# 自建个人节点指南：Debian + sing-box VLESS/REALITY + Clash Verge Rev + Windows DoH

> 从零搭建个人 VPS 代理节点：服务端 sing-box（VLESS + REALITY），Windows 客户端 Clash Verge Rev 只开系统代理，国内直连、国外走 VPS，系统 DNS 使用 AliDNS DoH 并禁止明文回退。

![Debian 12](https://img.shields.io/badge/Debian-12-A80030?logo=debian&logoColor=white)
![sing-box](https://img.shields.io/badge/sing--box-VLESS%20%2B%20REALITY-22314E)
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?logo=windows&logoColor=white)
![Clash Verge Rev](https://img.shields.io/badge/Clash%20Verge%20Rev-Mihomo-555555)
![License](https://img.shields.io/badge/License-MIT-green)

本仓库整理了一份**个人自建、最小组件、可维护**的 VPS 节点搭建流程，覆盖服务端部署、Windows 客户端分流、DoH 隐私配置、验证方法、安全维护与故障排查，并提供一键安装脚本。

<p>
  <a href="#quick-start">快速开始</a> ·
  <a href="#1-方案速览">方案速览</a> ·
  <a href="#2-仓库结构">仓库结构</a> ·
  <a href="#3-一键安装脚本">一键安装</a> ·
  <a href="#4-部署流程">部署流程</a> ·
  <a href="#6-验证分流">验证分流</a> ·
  <a href="#7-安全要求">安全须知</a> ·
  <a href="#8-常见问题">常见问题</a> ·
  <a href="#9-一页式检查清单">检查清单</a> ·
  <a href="#10-参与贡献">参与贡献</a> ·
  <a href="#11-参考资料官方">参考资料</a> ·
  <a href="#license">License</a>
</p>

**开源许可证**：本仓库以 [MIT License](LICENSE) 开源，欢迎自由使用、修改和分发（详见[参与贡献](#10-参与贡献)与 [License](#license)）。

## 项目速览

| 项目 | 说明 |
|---|---|
| 目标 | 个人设备日常浏览、查资料、访问代码仓库和学术网站 |
| 服务端 | Debian 12 / Ubuntu 22.04+ x86_64 VPS、sing-box、VLESS + REALITY + xtls-rprx-vision |
| 入口 | TCP 443，无需购买域名 |
| 客户端 | Windows 10/11 + Clash Verge Rev（Mihomo），仅系统代理、**不使用 TUN** |
| 分流 | 国内域名/IP 直连（DIRECT），其余走 VPS（PROXY） |
| DNS | Windows 系统 DNS 使用 AliDNS DoH（223.5.5.5 / 223.6.6.6），禁止明文回退 |
| 任务入口 | 一键脚本 `scripts/install_singbox.sh`；完整流程见 `docs/` 教程 |

> [!IMPORTANT]
> 本仓库不是“即插即用”的机场方案。你需要自己租用 VPS、自己保管 UUID / REALITY 密钥 / Short ID，并自行遵守所在地法律法规与 VPS 服务商条款。

> [!NOTE]
> 仓库所有示例均使用占位符（`YOUR_UUID`、`YOUR_VPS_IP` 等），不含真实 UUID、密钥、Short ID 或服务器 IP，可安全保存和分享。

## Quick Start

> [!WARNING]
> **务必先把服务器端启动成功，再配置客户端。**
> 客户端配置里的 UUID、Public Key、Short ID 都来自服务端安装脚本的输出；服务端没有跑起来之前，客户端配置没有任何意义，也无从校验。

以下是最短路径，详细原理和逐步手动操作见[完整教程](docs/自建个人节点_VLESS_REALITY_系统代理_DNS分流指南.md)。

> [!TIP]
> 第一次部署请先阅读[部署前提](#5-部署前提)和[安全要求](#7-安全要求)，并在云防火墙放行 TCP 443 后再测试连通性。

```bash
# ===== 第一步：服务端（必须先完成）=====
# 1. SSH 登录 VPS
ssh root@YOUR_VPS_IP

# 2. 一键安装并启动 sing-box（脚本会自动完成 7 步检查）
curl -fsSL https://raw.githubusercontent.com/e2432/Setting-Up-a-VPN-Node/main/scripts/install_singbox.sh | bash

# 3. 保存脚本最后输出的三项客户端凭据：
#    VLESS UUID / REALITY Public Key / Short ID
# 4. 在云控制台放行 TCP 443，并在本地验证：
#    Test-NetConnection YOUR_VPS_IP -Port 443   # Windows
```

```powershell
# ===== 第二步：客户端（服务端确认监听 443 后再做）=====
# 1. 把 docs/ 中的 clash-self.yaml 复制到 Windows，替换 4 个占位符
# 2. Clash Verge Rev 导入该配置：
#    模式 = 规则；系统代理 = 开；TUN = 关；DNS 覆写 = 关；PROXY 选 My-VPS
# 3. 验证代理链
curl.exe -x http://127.0.0.1:7897 https://api.ipify.org   # 应返回 YOUR_VPS_IP
```

> [!CAUTION]
> `curl | bash` 会直接以 root 执行远程脚本。介意的话请先 `curl -fsSL ... -o install_singbox.sh`，**读完脚本**再 `bash install_singbox.sh`。

## 1. 方案速览

```text
                              ┌── 中国大陆站点 ── DIRECT ── Internet
Windows 浏览器 / 应用
        │                     │
        └─ 系统代理 ── Clash/Mihomo
                              │
                              └── 其他站点 ── PROXY ── VLESS + REALITY
                                                     │
                                                     ▼
                                                你的海外 VPS
                                                     │
                                                     ▼
                                                  Internet

Windows 系统 DNS
        └── DNS over HTTPS (DoH) ──▶ AliDNS 223.5.5.5 / 223.6.6.6
```

最终日常状态：

```text
Clash Verge：
  模式          = 规则
  系统代理      = 开
  虚拟网卡/TUN  = 关
  DNS 覆写      = 关

Windows：
  IPv4 DNS      = 223.5.5.5, 223.6.6.6
  DoH           = 开
  明文回退      = 关
```

REALITY 的核心参数关系（**不要写反**）：

```text
服务器：UUID + REALITY Private Key + Short ID
客户端：UUID + REALITY Public  Key + Short ID
```

## 2. 仓库结构

| 目录 / 文件 | 职责 |
|---|---|
| `README.md` | 本页：方案概览、快速开始、检查清单与常见问题 |
| `LICENSE` | MIT 开源许可证 |
| `scripts/install_singbox.sh` | 服务端一键安装脚本：装 sing-box、生成凭据、写配置、校验并启动 |
| `docs/自建个人节点_VLESS_REALITY_系统代理_DNS分流指南.md` | 完整七部分教程（服务端 → 客户端 → DNS → 验证 → 安全维护 → 故障排查 → 检查清单） |

<details>
<summary><strong>展开完整目录树</strong></summary>

```text
Setting-Up-a-VPN-Node/
├── README.md
├── LICENSE
├── scripts/
│   └── install_singbox.sh
└── docs/
    └── 自建个人节点_VLESS_REALITY_系统代理_DNS分流指南.md
```

</details>

## 3. 一键安装脚本

`scripts/install_singbox.sh` 会在一台全新的 Debian/Ubuntu VPS 上按顺序执行：

```text
install_singbox.sh
  ├─ 1/7 apt 更新 + curl/ca-certificates/openssl
  ├─ 2/7 检查 systemd 与架构
  ├─ 3/7 添加 sing-box 官方 APT 源并安装
  ├─ 4/7 确认 TCP 443 未被占用
  ├─ 5/7 用 openssl 验证 REALITY 握手目标可达
  ├─ 6/7 生成 UUID / REALITY 密钥对 / Short ID 并写入 /etc/sing-box/config.json
  └─ 7/7 sing-box check -> systemctl enable --now sing-box -> 确认监听 443
```

可选环境变量：

| 变量 | 默认值 | 说明 |
|---|---|---|
| `SERVER_NAME` | `www.microsoft.com` | REALITY 握手目标，服务端与客户端必须一致 |
| `UUID` | 自动生成 | 指定 VLESS UUID |
| `SHORT_ID` | 自动生成 | 指定 Short ID |

```bash
# 自定义握手目标示例
curl -fsSL https://raw.githubusercontent.com/e2432/Setting-Up-a-VPN-Node/main/scripts/install_singbox.sh \
  | SERVER_NAME=www.apple.com bash
```

脚本结束时会打印客户端需要的三项凭据，**请立即保存**：

```text
VLESS UUID         -> clash-self.yaml 的 uuid
REALITY Public Key -> clash-self.yaml 的 reality-opts.public-key
Short ID           -> clash-self.yaml 的 reality-opts.short-id
```

> [!WARNING]
> 脚本**不会**替你开放云防火墙。装完后必须在云控制台放行 TCP 443，否则 `Test-NetConnection` 会一直失败。

## 4. 部署流程

### 4.1 服务端（必须先启动）

1. 准备一台 Debian 12 / Ubuntu 22.04+ x86_64 VPS，独立公网 IPv4。
2. 云防火墙至少放行 `TCP 22`（SSH，建议限制来源 IP）和 `TCP 443`。
3. SSH 登录后运行一键脚本（见 Quick Start）。
4. 确认服务状态：

```bash
systemctl status sing-box --no-pager
ss -lntp | grep ':443 '
sing-box check -c /etc/sing-box/config.json
```

5. 保存输出的 UUID / Public Key / Short ID。

### 4.2 客户端（服务端成功后再配置）

1. 复制 `docs/` 教程中的 `clash-self.yaml` 到 Windows。
2. 替换 4 个占位符：`YOUR_VPS_IP`、`YOUR_UUID`、`YOUR_REALITY_PUBLIC_KEY`、`YOUR_SHORT_ID`。
3. Clash Verge Rev 导入配置：模式 = 规则、系统代理 = 开、TUN = 关、DNS 覆写 = 关。
4. PROXY 组选择 `My-VPS`。

### 4.3 Windows DNS（可选但推荐）

管理员 PowerShell 执行教程第三部分：添加 AliDNS DoH、`AutoUpgrade=True`、`AllowFallbackToUdp=False`，把 WLAN 的 IPv4 DNS 切到 `223.5.5.5 / 223.6.6.6`。

## 5. 部署前提

### 5.1 服务端要求

1. Debian 12 或较新的 Ubuntu，x86_64/amd64。
2. 独立公网 IPv4，可用 SSH 密钥登录。
3. 云防火墙/安全组可开放 TCP 443。
4. TCP 443 未被 nginx/apache/caddy 等占用（脚本会检查）。
5. REALITY 握手目标（默认 `www.microsoft.com`）在 VPS 所在地区可达。

### 5.2 客户端要求

- Windows 10/11，Clash Verge Rev（或其它 Mihomo 内核客户端）。
- 浏览器和常用桌面软件遵守 Windows 系统代理（本方案不使用 TUN）。

## 6. 验证分流

在 Clash Verge「连接」页面观察，浏览器依次访问：

```text
https://www.baidu.com     -> DIRECT
https://www.google.com    -> PROXY / My-VPS
https://www.youtube.com   -> PROXY / My-VPS
```

命令行验证代理链：

```powershell
curl.exe -x http://127.0.0.1:7897 https://api.ipify.org   # 应返回 VPS IP
```

这比单纯看“网站能不能打开”更能确认分流规则真正命中。

## 7. 安全要求

> [!CAUTION]
> 自建节点会把你的全部代理流量交给自己租用的 VPS。凭据泄露 = 任何人都能用你的节点。请把 UUID、REALITY Private Key、Short ID 视同密码保管。

1. **Private Key 只留在服务器** `/etc/sing-box/config.json`，客户端只需要 Public Key。
2. SSH 只用密钥登录、禁止密码登录，TCP 22 尽量限制来源 IP。
3. 不要使用宝塔面板、机场面板、来源不明的一键脚本或 Web 管理后台；核心组件只有 Linux + SSH + sing-box。
4. 修改 SSH 配置前保留一个已登录终端，先在第二个终端测试，避免把自己锁在外面。
5. 怀疑 UUID/Short ID/配置泄露时立即轮换：重新生成三项凭据 → 更新服务端 → `sing-box check` → 重启 → 同步客户端。
6. `Private Key`、`.pem`、`id_ed25519` 等私钥文件不要发送给任何人。

### 隐私边界

```text
自建代理 ≠ 匿名
自建代理 ≠ Tor
自建代理 = 把中转服务器的控制权拿回自己手里
```

- 本地网络/运营商能看到：你与 VPS IP 的连接、时间与流量大小等元数据；
- VPS 云厂商可能看到：连接元数据、目的 IP；
- 最终网站仍可能知道：VPS 出口 IP、账号、Cookie、浏览器指纹。

## 8. 常见问题

### 一键脚本提示 “TCP 443 已被占用”

说明 VPS 上已有 nginx/apache/caddy 等监听 443。停用该程序或换用其它入口端口后再运行脚本（换端口需同步修改客户端 `port`）。

### 一键脚本提示 “无法与 xxx:443 完成 TLS 握手”

REALITY 握手目标在 VPS 所在地区不可达。换一个稳定、正常提供 TLS 的站点：

```bash
curl -fsSL .../install_singbox.sh | SERVER_NAME=www.apple.com bash
```

并同步修改客户端 `servername`。

### 服务端 `ss` 显示 443 在监听，但 Windows 连不上

先检查云平台安全组/防火墙、Lighthouse/CVM 防火墙、Linux 自身 nftables/iptables/ufw：

```powershell
Test-NetConnection YOUR_VPS_IP -Port 443   # 目标 TcpTestSucceeded : True
```

### `Permission denied (publickey)`

SSH 身份认证失败。用 `ssh -i "C:\path\key.pem" root@YOUR_VPS_IP` 指定密钥，而不是裸的 `ssh root@...`。

### 显式代理正常，但不开 `-x` 的 curl 不通

`curl.exe -x http://127.0.0.1:7897 ...` 正常而 `curl.exe https://...` 不正常，不一定是节点坏了。系统代理只接管**遵守 Windows 代理设置的软件**，这是系统代理与 TUN 最重要的差别。

### TUN 报 `The device is not ready for use`

这是 Windows 虚拟网卡/Wintun 路径问题，不代表 VPS / VLESS / REALITY 坏了。日常以浏览器为主时直接用「系统代理 = 开、TUN = 关」即可。

### DoH 已开但国外域名解析异常

DoH 只保证“到解析器的传输加密”，不保证解析结果适合国外站点。可为该程序显式配代理、换其它可信 DoH，或恢复 DHCP DNS：

```powershell
Set-DnsClientServerAddress -InterfaceAlias "WLAN" -ResetServerAddresses
```

## 9. 一页式检查清单

<details>
<summary><strong>展开检查清单</strong></summary>

**服务器**

```text
[ ] SSH 密钥登录成功
[ ] sing-box 已安装
[ ] sing-box check 通过
[ ] systemctl 显示 active (running)
[ ] 0.0.0.0:443 正在监听
[ ] 云防火墙 TCP 443 已放行
[ ] Reality Private Key 只存在于服务器
```

**Windows**

```text
[ ] clash-self.yaml 已导入
[ ] PROXY 组选择 My-VPS
[ ] 模式 = 规则
[ ] 系统代理 = 开
[ ] TUN = 关
[ ] DNS 覆写 = 关
[ ] curl -x 127.0.0.1:7897 返回 VPS IP
```

**DNS**

```text
[ ] WLAN IPv4 DNS = 223.5.5.5 / 223.6.6.6
[ ] AutoUpgrade = True
[ ] AllowFallbackToUdp = False
[ ] Resolve-DnsName 国内域名正常
```

**分流**

```text
[ ] 百度等国内站点显示 DIRECT
[ ] Google/YouTube 等显示 PROXY / My-VPS
```

</details>

## 10. 参与贡献

本仓库以 [MIT License](LICENSE) 开源，欢迎 Issue 和 Pull Request。

**再分发时请保留**：

1. [LICENSE](LICENSE) 文件与版权声明；
2. [docs/](docs/) 完整教程中的[隐私边界](#隐私边界)与[安全要求](#7-安全要求)章节 —— 自建代理不等于匿名，删掉这些说明容易让读者产生误解；
3. `scripts/install_singbox.sh` 中的凭据安全提醒（Private Key 只留服务器等）。

**欢迎的改进方向**：

| 需求 | 优先检查 |
|---|---|
| 换 Linux 发行版 / 非 x86_64 架构 | `scripts/install_singbox.sh` 第 2、3 步 |
| 换代理协议（Hysteria2 / TUIC 等） | `docs/` 教程第 9 节服务端配置 + 第 12 节客户端配置 |
| 换 REALITY 握手目标 | 一键脚本 `SERVER_NAME` 变量 + 客户端 `servername` |
| 换 DoH 提供商 | `docs/` 教程第 17、18 节 |
| 加入 TUN 模式说明 | `docs/` 教程第 14 节（当前刻意不用 TUN） |
| 新增故障排查条目 | `docs/` 教程第六部分 + 本页第 8 节 |

**提交前请自查**：

1. 所有示例仍然只使用占位符，不含真实 UUID、密钥、Short ID、服务器 IP；
2. `bash -n scripts/install_singbox.sh` 无语法错误；
3. 服务端与客户端字段对应关系（UUID / Public Key / Short ID）没有写反。

## 11. 参考资料（官方）

- sing-box 包管理器 / APT 安装：<https://sing-box.sagernet.org/installation/package-manager/>
- sing-box VLESS 入站：<https://sing-box.sagernet.org/configuration/inbound/vless/>
- sing-box TLS / REALITY：<https://sing-box.sagernet.org/configuration/shared/tls/>
- Mihomo 路由规则：<https://wiki.metacubex.one/en/config/rules/>
- Mihomo TLS / REALITY 客户端字段：<https://wiki.metacubex.one/en/config/proxies/tls/>
- 阿里公共 DNS：<https://alidns.com/>
- Microsoft Add-DnsClientDohServerAddress：<https://learn.microsoft.com/powershell/module/dnsclient/add-dnsclientdohserveraddress>

## License

本仓库以 [MIT License](LICENSE) 开源。

```text
MIT License

Copyright (c) 2026 e2432
```

你可以自由使用、复制、修改、合并、发布、分发、再许可和销售本软件的副本，只需保留版权声明和许可声明。软件按“原样”提供，不附带任何明示或默示担保。

> [!NOTE]
> MIT 只覆盖本仓库的文档与脚本本身，不覆盖你部署后产生的任何服务、凭据或流量。运行本方案产生的法律责任和合规义务由使用者自行承担；请遵守所在地法律法规以及 VPS 服务商的使用条款。

第三方项目（sing-box、Mihomo / Clash Verge Rev、AliDNS 等）各自遵循其上游许可证，与本仓库无关。

---

<p align="right">
  <a href="#自建个人节点指南debian--sing-box-vlessreality--clash-verge-rev--windows-doh">返回顶部 ↑</a>
</p>
