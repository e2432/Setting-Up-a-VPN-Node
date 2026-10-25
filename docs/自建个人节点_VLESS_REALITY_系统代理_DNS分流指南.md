# 自建个人代理节点指南
## Debian + sing-box VLESS/REALITY + Clash Verge Rev + Windows DoH

> 适用场景：个人设备日常浏览、查资料、访问代码仓库和学术网站。  
> 本文采用我们实际验证过的最终方案：**不依赖 TUN/虚拟网卡，Clash Verge 只开启“系统代理”；国内流量直连，其他流量走自建 VPS；Windows 系统 DNS 使用 AliDNS DoH 并禁止明文回退。**
>
> 本文示例全部使用占位符，不包含真实 UUID、密钥、Short ID 或服务器 IP，可安全作为模板保存和分享。

---

## 1. 这套方案最终长什么样

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
        │
        └── DNS over HTTPS (DoH)
                    │
                    ▼
              AliDNS 223.5.5.5 / 223.6.6.6
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

---

## 2. “自建节点”到底是什么

传统第三方代理通常是：

```text
你的电脑 → 第三方节点商的服务器 → 目标网站
```

自建以后变成：

```text
你的电脑 → 你自己租用并控制的 VPS → 目标网站
```

客户端 Clash Verge 并不是“节点商”。它只是本机流量入口和规则引擎。真正承担中转的是服务器上的 sing-box。

本文服务端使用：

- **VLESS**：客户端和服务器之间的代理协议；
- **REALITY**：在 TLS 握手层提供认证和连接特征处理；
- **xtls-rprx-vision**：VLESS 可使用的 flow；
- **TCP 443**：公网入口；
- **sing-box**：服务器端程序；
- **Mihomo / Clash Verge Rev**：Windows 客户端。

REALITY 的核心参数关系：

```text
服务器：
  UUID
  REALITY Private Key
  Short ID

客户端：
  UUID
  REALITY Public Key
  Short ID
```

Private Key 只应该留在服务器。客户端只需要对应的 Public Key。

---

## 3. 隐私边界：它解决什么，不解决什么

自建节点最直接解决的是：

> 不再把完整代理流量交给陌生的“机场/节点提供商”。

但它**不等于匿名网络**。

### 本地网络/运营商通常能看到

- 你的设备正在与某个 VPS IP 建立连接；
- 连接时间、流量大小等元数据；
- 本方案的系统 DNS 使用 DoH 后，本地网络一般不会再直接看到明文 DNS 查询内容，但能看到你连接到 DoH 服务端。

### VPS 云厂商可能看到

- 服务器的网络连接元数据；
- 目的 IP；
- 某些场景下可能推断域名。

### 最终网站仍然可能知道

- VPS 出口 IP；
- 登录账号；
- Cookie；
- 浏览器指纹；
- 你主动提交的信息。

HTTPS 网站的网页正文、密码和请求内容通常仍由 HTTPS 保护。

所以：

```text
自建代理 ≠ 匿名
自建代理 ≠ Tor
自建代理 = 把中转服务器的控制权拿回自己手里
```

---

# 第一部分：搭建服务器节点

## 4. 准备 VPS

推荐条件：

- Debian 12 或较新的 Ubuntu；
- x86_64/amd64；
- 独立公网 IPv4；
- 可以使用 SSH 密钥登录；
- 云防火墙/安全组可开放 TCP 443；
- 个人使用通常不需要很高配置。

本文不需要购买域名。

云防火墙至少需要：

```text
TCP 22    SSH
TCP 443   VLESS + REALITY
```

SSH 后续最好限制来源 IP；443 则需要允许你的客户端访问。

---

## 5. SSH 登录

Windows PowerShell 示例：

```powershell
ssh -i "C:\path\to\your-key.pem" root@YOUR_VPS_IP
```

第一次连接会询问主机指纹，确认服务器确实是你刚创建的 VPS 后再接受。

**不要把 `.pem` 私钥内容发送给任何人。**

登录后建议先查看：

```bash
cat /etc/os-release
uname -m
uname -r
ss -lntup
```

---

## 6. 安装 sing-box

Debian/Ubuntu 推荐使用 sing-box 官方 APT 仓库：

```bash
apt-get update
apt-get install -y curl ca-certificates

mkdir -p /etc/apt/keyrings

curl -fsSL https://sing-box.app/gpg.key   -o /etc/apt/keyrings/sagernet.asc

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
```

检查：

```bash
sing-box version
which sing-box
```

确认 443 没有被其他程序占用：

```bash
ss -lntp | grep ':443 ' || echo "443 port is free"
```

---

## 7. 测试 REALITY 握手目标

本文示例使用：

```text
www.microsoft.com:443
```

先从 VPS 测试它是否可达以及是否能正常协商 TLS：

```bash
apt-get install -y openssl

timeout 12 openssl s_client   -connect www.microsoft.com:443   -servername www.microsoft.com   -tls1_3 </dev/null
```

如果目标站在 VPS 所在地区不可达，就换一个稳定、正常提供 TLS 服务的站点，并同步修改服务端和客户端的 `server_name` / `servername`。

---

## 8. 生成 UUID、REALITY 密钥和 Short ID

分别执行：

```bash
sing-box generate uuid
```

记录输出为：

```text
YOUR_UUID
```

然后：

```bash
sing-box generate reality-keypair
```

会得到一对密钥：

```text
PrivateKey: ...
PublicKey: ...
```

记录为：

```text
YOUR_REALITY_PRIVATE_KEY
YOUR_REALITY_PUBLIC_KEY
```

再生成 Short ID：

```bash
sing-box generate rand --hex 4
```

记录为：

```text
YOUR_SHORT_ID
```

安全规则：

```text
Private Key       只留服务器
UUID              不公开
Short ID          不公开
Public Key        本身不是私钥，但客户端配置整体仍应视作凭据
```

如果 UUID/Short ID/完整客户端配置被发到公开聊天、论坛或截图中，建议重新生成并轮换。

---

## 9. 写服务器配置

配置文件：

```text
/etc/sing-box/config.json
```

示例：

```json
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
          "uuid": "YOUR_UUID",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "www.microsoft.com",
        "reality": {
          "enabled": true,
          "handshake": {
            "server": "www.microsoft.com",
            "server_port": 443
          },
          "private_key": "YOUR_REALITY_PRIVATE_KEY",
          "short_id": [
            "YOUR_SHORT_ID"
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
```

把四个占位符替换为自己的值：

```text
YOUR_UUID
YOUR_REALITY_PRIVATE_KEY
YOUR_SHORT_ID
www.microsoft.com（如果你选择了别的握手目标，也要同步替换）
```

设置权限：

```bash
chown root:sing-box /etc/sing-box/config.json
chmod 640 /etc/sing-box/config.json
```

---

## 10. 配置检查和启动

**永远先检查，再重启。**

```bash
sing-box check -c /etc/sing-box/config.json
```

没有报错再执行：

```bash
systemctl enable --now sing-box
```

查看状态：

```bash
systemctl status sing-box --no-pager
```

确认监听 TCP 443：

```bash
ss -lntp | grep ':443 '
```

预期看到类似：

```text
0.0.0.0:443
```

查看实时日志：

```bash
journalctl -u sing-box --output cat -f
```

---

## 11. 云厂商防火墙开放 443

如果服务器本地已经监听：

```text
0.0.0.0:443
```

但 Windows 仍然连不上，检查云平台安全组/防火墙。

允许：

```text
协议：TCP
端口：443
来源：0.0.0.0/0
动作：允许
```

Windows 测试：

```powershell
Test-NetConnection YOUR_VPS_IP -Port 443
```

目标：

```text
TcpTestSucceeded : True
```

---

# 第二部分：配置 Windows 客户端

## 12. Clash Verge Rev / Mihomo 客户端配置

本文最终方案**不使用 TUN**，所以客户端配置非常简单。

将下面内容保存为：

```text
clash-self.yaml
```

```yaml
mixed-port: 7897
allow-lan: false
mode: rule
log-level: warning
ipv6: false

proxies:
  - name: "My-VPS"
    type: vless
    server: "YOUR_VPS_IP"
    port: 443
    uuid: "YOUR_UUID"
    network: tcp
    udp: true
    tls: true
    servername: "www.microsoft.com"
    client-fingerprint: chrome
    flow: xtls-rprx-vision
    reality-opts:
      public-key: "YOUR_REALITY_PUBLIC_KEY"
      short-id: "YOUR_SHORT_ID"
    encryption: ""

proxy-groups:
  - name: "PROXY"
    type: select
    proxies:
      - "My-VPS"

rules:
  - IP-CIDR,127.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,10.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,172.16.0.0/12,DIRECT,no-resolve
  - IP-CIDR,192.168.0.0/16,DIRECT,no-resolve
  - IP-CIDR,169.254.0.0/16,DIRECT,no-resolve
  - GEOSITE,CN,DIRECT
  - GEOIP,CN,DIRECT,no-resolve
  - MATCH,PROXY
```

需要替换：

```text
YOUR_VPS_IP
YOUR_UUID
YOUR_REALITY_PUBLIC_KEY
YOUR_SHORT_ID
```

这些值必须与服务器端对应。

注意：

```text
客户端使用 Public Key
服务器使用 Private Key
```

不要写反。

---

## 13. 分流规则原理

关键规则：

```yaml
  - GEOSITE,CN,DIRECT
  - GEOIP,CN,DIRECT,no-resolve
  - MATCH,PROXY
```

Mihomo 规则从上到下匹配。

因此：

```text
中国域名           → DIRECT
中国 IP            → DIRECT
剩下所有目标       → PROXY
```

前面的私网规则：

```yaml
  - IP-CIDR,127.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,10.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,172.16.0.0/12,DIRECT,no-resolve
  - IP-CIDR,192.168.0.0/16,DIRECT,no-resolve
  - IP-CIDR,169.254.0.0/16,DIRECT,no-resolve
```

用于避免本机、路由器、局域网设备被错误送往 VPS。

---

## 14. Clash Verge 日常设置

加载 `clash-self.yaml` 后：

```text
模式：规则
PROXY：选择 My-VPS

系统代理：开启
虚拟网卡模式 / TUN：关闭
DNS 覆写：关闭
```

为什么不强求 TUN：

- 浏览器和大量桌面软件本身就遵守 Windows 系统代理；
- 不需要安装/维护 Wintun 虚拟网卡；
- Windows 兼容性更简单；
- 对“浏览器查资料”这一用途已经足够。

TUN 的额外价值主要是：

- 接管不遵守系统代理的软件；
- 更全面地接管 UDP；
- 更容易做全系统 DNS 劫持。

如果你的核心需求只是 Chrome/Edge/Firefox 浏览资料，没有必要为了 TUN 增加故障面。

---

## 15. 测试 VPS 代理链

明确指定 Clash 本地 HTTP/Mixed 端口：

```powershell
curl.exe -x http://127.0.0.1:7897 https://api.ipify.org
```

成功时应返回：

```text
YOUR_VPS_IP
```

这证明：

```text
Windows
  → 127.0.0.1:7897
  → Clash/Mihomo
  → VLESS + REALITY
  → VPS
  → Internet
```

---

# 第三部分：Windows DNS 隐私

## 16. 为什么把 DNS 单独交给 Windows

本方案不使用 TUN，也不让 Clash 监听一个额外的本地 DNS 端口。

职责拆开：

```text
Clash：
  负责“这个连接走 DIRECT 还是 PROXY”

Windows：
  负责系统 DNS，并使用 DoH 加密
```

优点是组件更少、故障面更小。

但要理解：

> DoH 保护的是“你到 DNS 解析器之间的传输”，不是让 DNS 解析器不知道你查了什么。

AliDNS 仍然是你的 DNS 信任方。

---

## 17. 添加 AliDNS DoH

AliDNS IPv4：

```text
223.5.5.5
223.6.6.6
```

DoH 模板：

```text
https://dns.alidns.com/dns-query
```

使用**管理员 PowerShell**：

```powershell
Add-DnsClientDohServerAddress `
  -ServerAddress "223.5.5.5" `
  -DohTemplate "https://dns.alidns.com/dns-query" `
  -AutoUpgrade $true `
  -AllowFallbackToUdp $false

Add-DnsClientDohServerAddress `
  -ServerAddress "223.6.6.6" `
  -DohTemplate "https://dns.alidns.com/dns-query" `
  -AutoUpgrade $true `
  -AllowFallbackToUdp $false
```

关键参数：

```text
AutoUpgrade=True
```

表示发给这些服务器的解析自动升级为 DoH。

```text
AllowFallbackToUdp=False
```

表示 DoH 失败时不允许回退成普通未加密 UDP DNS。

---

## 18. 把 WLAN 真正切到 AliDNS

管理员 PowerShell：

```powershell
Set-DnsClientServerAddress `
  -InterfaceAlias "WLAN" `
  -ServerAddresses ("223.5.5.5","223.6.6.6")
```

刷新缓存：

```powershell
ipconfig /flushdns
```

检查：

```powershell
Get-DnsClientServerAddress `
  -InterfaceAlias "WLAN" `
  -AddressFamily IPv4
```

目标：

```text
223.5.5.5
223.6.6.6
```

检查 DoH：

```powershell
Get-DnsClientDohServerAddress `
  -ServerAddress "223.5.5.5","223.6.6.6" |
Format-Table ServerAddress,DohTemplate,AutoUpgrade,AllowFallbackToUdp
```

理想状态：

```text
AutoUpgrade         True
AllowFallbackToUdp  False
```

---

## 19. DNS 测试

测试国内：

```powershell
Resolve-DnsName www.baidu.com -Type A
```

测试国外：

```powershell
Resolve-DnsName www.google.com -Type A
```

注意：

- DoH 已开启并不保证每个解析器对每个国外域名都会给出你期望的答案；
- 在某些网络环境里，AliDNS 对部分国外域名可能出现异常/不理想结果；
- **不要仅靠 Google 的系统 DNS 解析结果判断代理节点是否工作。**

代理是否工作，优先测试：

```powershell
curl.exe -x http://127.0.0.1:7897 https://api.ipify.org
```

以及 Clash Verge 的“连接/日志”页面。

---

# 第四部分：验证国内直连、国外走 VPS

## 20. 最直观的验证方法

在 Clash Verge 中打开“连接”页面。

浏览器依次访问：

```text
https://www.baidu.com
https://www.google.com
https://www.youtube.com
```

期望看到：

```text
baidu.com    → DIRECT
google.com   → PROXY / My-VPS
youtube.com  → PROXY / My-VPS
```

这比单纯看“网站能不能打开”更能确认分流规则是否真正命中。

---

# 第五部分：服务器安全与长期维护

## 21. SSH 安全

建议：

- 只使用 SSH 密钥；
- 禁止密码登录；
- 如果条件允许，把 TCP 22 的云防火墙来源限制为自己的管理 IP；
- 修改 SSH 配置前保留一个已登录的终端，先在第二个终端测试新配置，避免把自己锁在服务器外。

不要把：

```text
.pem
id_ed25519
id_rsa
```

等私钥文件发送给任何人。

---

## 22. 减少不必要的软件

个人节点一般不需要：

- 宝塔面板；
- 机场面板；
- 来源不明的一键脚本；
- Web 管理后台。

服务器越简单，维护面和攻击面通常越小。

本文需要的核心组件只有：

```text
Linux
SSH
sing-box
```

---

## 23. 日志与故障排查

检查服务：

```bash
systemctl status sing-box --no-pager
```

检查配置：

```bash
sing-box check -c /etc/sing-box/config.json
```

检查端口：

```bash
ss -lntp | grep ':443 '
```

查看最近日志：

```bash
journalctl -u sing-box --output cat -e
```

实时看日志：

```bash
journalctl -u sing-box --output cat -f
```

---

## 24. 凭据轮换

任何时候怀疑 UUID/Short ID/配置被泄露，可以重新生成：

```bash
sing-box generate uuid
sing-box generate reality-keypair
sing-box generate rand --hex 4
```

然后：

1. 更新服务端 UUID；
2. 更新 Reality Private Key；
3. 更新 Short ID；
4. `sing-box check`；
5. 重启 sing-box；
6. 更新客户端 UUID、Public Key、Short ID；
7. 重新加载 Clash 配置。

旧凭据立即失效。

---

## 25. 系统更新

定期：

```bash
apt-get update
apt-get upgrade
```

sing-box 升级后，在重启前先：

```bash
sing-box check -c /etc/sing-box/config.json
```

尤其跨大版本升级时，先看官方迁移说明，不要假设所有旧配置永远兼容。

---

# 第六部分：常见故障

## 26. `Permission denied (publickey)`

含义：

```text
服务器能访问，但 SSH 身份认证失败
```

通常需要：

```powershell
ssh -i "C:\path\key.pem" root@YOUR_VPS_IP
```

而不是单纯：

```powershell
ssh root@YOUR_VPS_IP
```

---

## 27. 服务器监听 443，但公网连接失败

服务器：

```bash
ss -lntp | grep ':443 '
```

有输出，但 Windows：

```powershell
Test-NetConnection YOUR_VPS_IP -Port 443
```

显示 `False`，首先检查：

- 云平台安全组；
- Lighthouse/CVM 防火墙；
- Linux 自身 nftables/iptables/ufw。

---

## 28. 显式代理正常，但不开 `-x` 的 curl 不通

如果：

```powershell
curl.exe -x http://127.0.0.1:7897 https://api.ipify.org
```

正常，而：

```powershell
curl.exe https://api.ipify.org
```

不正常，不一定意味着节点坏了。

系统代理只会自动接管**遵守 Windows 代理设置的软件**。

这是系统代理与 TUN 最重要的差别之一。

---

## 29. TUN 报 `The device is not ready for use`

这属于 Windows 虚拟网卡/Wintun 路径问题，不代表：

- VPS 坏了；
- VLESS 坏了；
- REALITY 坏了。

如果显式 HTTP 代理已经工作，而日常主要是浏览器，可以直接使用本文最终方案：

```text
系统代理 = 开
TUN      = 关
```

没有必要把 TUN 当成必须项。

---

## 30. Windows DNS 已经是 DoH，但国外域名解析结果异常

先确认：

```powershell
Get-DnsClientDohServerAddress `
  -ServerAddress "223.5.5.5","223.6.6.6"
```

如果：

```text
AutoUpgrade=True
AllowFallbackToUdp=False
```

说明“加密传输”和“禁止明文回退”配置已经成立。

解析结果是否适合国外站点，是另一件事。

如果某个不经过 Clash 的程序因此受到影响，可以：

- 为该程序显式配置代理；
- 改用其他可信 DoH；
- 或恢复 DHCP DNS。

恢复 WLAN 自动 DNS：

```powershell
Set-DnsClientServerAddress `
  -InterfaceAlias "WLAN" `
  -ResetServerAddresses
```

---

# 第七部分：一页式检查清单

## 31. 服务器

```text
[ ] SSH 密钥登录成功
[ ] sing-box 已安装
[ ] sing-box check 通过
[ ] systemctl 显示 active (running)
[ ] 0.0.0.0:443 正在监听
[ ] 云防火墙 TCP 443 已放行
[ ] Reality Private Key 只存在于服务器
```

## 32. Windows

```text
[ ] clash-self.yaml 已导入
[ ] PROXY 组选择 My-VPS
[ ] 模式 = 规则
[ ] 系统代理 = 开
[ ] TUN = 关
[ ] DNS 覆写 = 关
[ ] curl -x 127.0.0.1:7897 返回 VPS IP
```

## 33. DNS

```text
[ ] WLAN IPv4 DNS = 223.5.5.5 / 223.6.6.6
[ ] AutoUpgrade = True
[ ] AllowFallbackToUdp = False
[ ] Resolve-DnsName 国内域名正常
```

## 34. 分流

```text
[ ] 百度等国内站点显示 DIRECT
[ ] Google/YouTube 等显示 PROXY / My-VPS
```

---

# 参考资料（官方）

- sing-box 包管理器 / APT 安装  
  https://sing-box.sagernet.org/installation/package-manager/

- sing-box VLESS 入站  
  https://sing-box.sagernet.org/configuration/inbound/vless/

- sing-box TLS / REALITY  
  https://sing-box.sagernet.org/configuration/shared/tls/

- Mihomo 路由规则  
  https://wiki.metacubex.one/en/config/rules/

- Mihomo TLS / REALITY 客户端字段  
  https://wiki.metacubex.one/en/config/proxies/tls/

- 阿里公共 DNS  
  https://alidns.com/

- Microsoft：Add-DnsClientDohServerAddress  
  https://learn.microsoft.com/powershell/module/dnsclient/add-dnsclientdohserveraddress

- Microsoft：Set-DnsClientDohServerAddress  
  https://learn.microsoft.com/powershell/module/dnsclient/set-dnsclientdohserveraddress

---

## 最后说明

本文是一份**个人自建、最小组件、可维护**的配置思路，而不是匿名方案。

长期使用时最重要的三件事：

1. **自己掌握服务器和凭据；**
2. **减少不必要的第三方脚本和管理面板；**
3. **理解信任边界，而不是把“自建代理”误认为“绝对匿名”。**

请遵守所在地法律法规以及 VPS 服务商的使用条款。