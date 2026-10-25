#!/usr/bin/env bash
#
# scripts/install_singbox.sh
#
# 一键安装并启动 sing-box（VLESS + REALITY，TCP 443）。
# 只应在一台全新的 Debian 12 / Ubuntu 22.04+ x86_64 VPS 上以 root 运行。
#
# 用法：
#   bash scripts/install_singbox.sh
#
# 可用环境变量：
#   SERVER_NAME   REALITY 握手目标（默认 www.microsoft.com）
#   UUID          指定 VLESS UUID（默认自动生成）
#   SHORT_ID      指定 Short ID（默认自动生成）
#
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "请以 root 运行： sudo bash $0" >&2
  exit 1
fi

SERVER_NAME="${SERVER_NAME:-www.microsoft.com}"
CONFIG="/etc/sing-box/config.json"

log() { printf '\033[1;32m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warning]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

if command -v systemctl >/dev/null 2>&1; then
  :
else
  die "需要 systemd（systemctl）。请使用 Debian 12 / Ubuntu 22.04+ 的标准云镜像。"
fi

log "1/7 更新软件源并安装基础依赖"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates openssl

log "2/7 检查环境"
. /etc/os-release
log "系统：${PRETTY_NAME:-unknown} / $(uname -m) / $(uname -r)"
[[ "$(uname -m)" == "x86_64" ]] || warn "当前架构是 $(uname -m)，本教程仅验证过 x86_64/amd64。"

log "3/7 添加 sing-box 官方 APT 仓库并安装"
mkdir -p /etc/apt/keyrings
curl -fsSL https://sing-box.app/gpg.key -o /etc/apt/keyrings/sagernet.asc
chmod a+r /etc/apt/keyrings/sagernet.asc
cat > /etc/apt/sources.list.d/sagernet.sources <<'EOF'
Types: deb
URIs: https://deb.sagernet.org/
Suites: *
Components: *
Enabled: yes
Signed-By: /etc/apt/keyrings/sagernet.asc
EOF
apt-get update
apt-get install -y sing-box
log "sing-box 版本：$(sing-box version | head -n 1)"

log "4/7 检查 443 端口占用"
if ss -lntp | grep -q ':443 '; then
  ss -lntp | grep ':443 '
  die "TCP 443 已被占用，请先停用占用程序（如 nginx/apache/caddy）后重试。"
fi
log "443 端口空闲"

log "5/7 验证 REALITY 握手目标：${SERVER_NAME}:443"
if ! timeout 12 openssl s_client -connect "${SERVER_NAME}:443" -servername "${SERVER_NAME}" -tls1_3 </dev/null 2>/dev/null | grep -q "BEGIN CERTIFICATE"; then
  die "无法与 ${SERVER_NAME}:443 完成 TLS 握手。请换一个在 VPS 所在地区可达、正常提供 TLS 的站点，并用 SERVER_NAME=... 重新运行。"
fi
log "握手目标可达"

log "6/7 生成凭据并写入配置"
UUID_VALUE="${UUID:-$(sing-box generate uuid)}"
PRIVATE_KEY="$(sing-box generate reality-keypair | awk '/PrivateKey/{print $2}')"
PUBLIC_KEY="$(sing-box generate reality-keypair | awk '/PublicKey/{print $2}')"
SHORT_ID_VALUE="${SHORT_ID:-$(sing-box generate rand --hex 4)}"

mkdir -p /etc/sing-box
cat > "${CONFIG}" <<EOF
{
  "log": {
    "level": "warn",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-reality",
      "listen": "0.0.0.0",
      "listen_port": 443,
      "users": [
        {
          "name": "self",
          "uuid": "${UUID_VALUE}",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "${SERVER_NAME}",
        "reality": {
          "enabled": true,
          "handshake": {
            "server": "${SERVER_NAME}",
            "server_port": 443
          },
          "private_key": "${PRIVATE_KEY}",
          "short_id": [
            "${SHORT_ID_VALUE}"
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "final": "direct"
  }
}
EOF

if id sing-box >/dev/null 2>&1; then
  chown root:sing-box "${CONFIG}"
else
  chown root:root "${CONFIG}"
fi
chmod 640 "${CONFIG}"

log "7/7 检查配置并启动服务"
sing-box check -c "${CONFIG}"
systemctl enable --now sing-box
sleep 1
systemctl --no-pager status sing-box --no-pager | head -n 5 || true

if ! ss -lntp | grep -q ':443 '; then
  die "sing-box 未监听 443，请执行 journalctl -u sing-box --output cat -e 查看日志。"
fi
log "sing-box 已监听 TCP 443"

VPS_IP="$(curl -fsS --max-time 10 https://api.ipify.org || hostname -I | awk '{print $1}')"

cat <<EOF

============================================================
  服务端安装完成
============================================================
VPS IP            : ${VPS_IP}
VLESS UUID        : ${UUID_VALUE}
REALITY Public Key: ${PUBLIC_KEY}
Short ID          : ${SHORT_ID_VALUE}
握手目标 servername: ${SERVER_NAME}
配置文件          : ${CONFIG}

—— 客户端（Clash Verge Rev / Mihomo）需要填入上面除 Private Key 外的三项 ——

重要提醒：
  1. Private Key 只存在服务器 ${CONFIG} 中，不要发给任何人；
  2. 云防火墙/安全组必须放行 TCP 443；
  3. 请把上面三项凭据保存到本地密码管理器；
  4. 怀疑泄露时执行凭据轮换（见文档「凭据轮换」一节）。
============================================================
EOF
