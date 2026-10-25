# 自建个人节点指南：Debian + sing-box VLESS/REALITY + Clash Verge Rev + Windows DoH

> 适用场景：个人设备日常浏览、查资料、访问代码仓库和学术网站。
> 本方案**不依赖 TUN/虚拟网卡**，Clash Verge 只开启「系统代理」；国内流量直连，其他流量走自建 VPS；Windows 系统 DNS 使用 AliDNS DoH 并禁止明文回退。
>
> 本仓库所有示例均使用占位符（`YOUR_UUID`、`YOUR_VPS_IP` 等），不含真实 UUID、密钥、Short ID 或服务器 IP，可安全保存和分享。

## 技术栈

| 组件 | 说明 |
| --- | --- |
| VLESS | 客户端与服务器之间的代理协议 |
| REALITY | 在 TLS 握手层提供认证与连接特征处理 |
| xtls-rprx-vision | VLESS 使用的 flow |
| TCP 443 | 公网入口，无需购买域名 |
| sing-box | 服务器端程序 |
| Mihomo / Clash Verge Rev | Windows 客户端 |
| AliDNS DoH | Windows 系统 DNS 加密 |

## 快速导航

| 部分 | 内容 |
| --- | --- |
| 第一部分 | 搭建服务器节点（VPS、sing-box、REALITY、防火墙） |
| 第二部分 | 配置 Windows 客户端（Clash Verge Rev / Mihomo、分流规则） |
| 第三部分 | Windows DNS 隐私（AliDNS DoH、禁止明文回退） |
| 第四部分 | 验证国内直连、国外走 VPS |
| 第五部分 | 服务器安全与长期维护 |
| 第六部分 | 常见故障排查 |
| 第七部分 | 一页式检查清单 |

完整教程请见 **[docs/自建个人节点_VLESS_REALITY_系统代理_DNS分流指南.md](docs/自建个人节点_VLESS_REALITY_系统代理_DNS分流指南.md)**。

## 隐私边界

```text
自建代理 ≠ 匿名
自建代理 ≠ Tor
自建代理 = 把中转服务器的控制权拿回自己手里
```

- 本地网络/运营商能看到：你与 VPS IP 的连接、连接时间与流量大小等元数据；
- VPS 云厂商可能看到：网络连接元数据、目的 IP；
- 最终网站仍可能知道：VPS 出口 IP、账号、Cookie、浏览器指纹。

## 免责声明

本仓库是一份**个人自建、最小组件、可维护**的配置思路，而不是匿名方案。
请遵守所在地法律法规以及 VPS 服务商的使用条款。
