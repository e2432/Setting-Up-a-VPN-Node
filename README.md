# 鑷缓涓汉鑺傜偣鎸囧崡锛欴ebian + sing-box VLESS/REALITY + Clash Verge Rev + Windows DoH

> 浠庨浂鎼缓涓汉 VPS 浠ｇ悊鑺傜偣锛氭湇鍔＄ sing-box锛圴LESS + REALITY锛夛紝Windows 瀹㈡埛绔?Clash Verge Rev 鍙紑绯荤粺浠ｇ悊锛屽浗鍐呯洿杩炪€佸浗澶栬蛋 VPS锛岀郴缁?DNS 浣跨敤 AliDNS DoH 骞剁姝㈡槑鏂囧洖閫€銆?
![Debian 12](https://img.shields.io/badge/Debian-12-A80030?logo=debian&logoColor=white)
![sing-box](https://img.shields.io/badge/sing--box-VLESS%20%2B%20REALITY-22314E)
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?logo=windows&logoColor=white)
![Clash Verge Rev](https://img.shields.io/badge/Clash%20Verge%20Rev-Mihomo-555555)
![License](https://img.shields.io/badge/License-MIT-green)

鏈粨搴撴暣鐞嗕簡涓€浠?*涓汉鑷缓銆佹渶灏忕粍浠躲€佸彲缁存姢**鐨?VPS 鑺傜偣鎼缓娴佺▼锛岃鐩栨湇鍔＄閮ㄧ讲銆乄indows 瀹㈡埛绔垎娴併€丏oH 闅愮閰嶇疆銆侀獙璇佹柟娉曘€佸畨鍏ㄧ淮鎶や笌鏁呴殰鎺掓煡锛屽苟鎻愪緵涓€閿畨瑁呰剼鏈€?
<p>
  <a href="#quick-start">蹇€熷紑濮?/a> 路
  <a href="#1-鏂规閫熻">鏂规閫熻</a> 路
  <a href="#2-浠撳簱缁撴瀯">浠撳簱缁撴瀯</a> 路
  <a href="#3-涓€閿畨瑁呰剼鏈?>涓€閿畨瑁?/a> 路
  <a href="#4-閮ㄧ讲娴佺▼">閮ㄧ讲娴佺▼</a> 路
  <a href="#6-楠岃瘉鍒嗘祦">楠岃瘉鍒嗘祦</a> 路
  <a href="#7-瀹夊叏瑕佹眰">瀹夊叏椤荤煡</a> 路
  <a href="#8-甯歌闂">甯歌闂</a> 路
  <a href="#9-涓€椤靛紡妫€鏌ユ竻鍗?>妫€鏌ユ竻鍗?/a> 路
  <a href="#10-鍙備笌璐＄尞">鍙備笌璐＄尞</a> 路
  <a href="#11-参考资料官方">参考资料</a> ·
  <a href="#license">License</a>
</p>

**寮€婧愯鍙瘉**锛氭湰浠撳簱浠?[MIT License](LICENSE) 寮€婧愶紝娆㈣繋鑷敱浣跨敤銆佷慨鏀瑰拰鍒嗗彂锛堣瑙乕鍙備笌璐＄尞](#10-鍙備笌璐＄尞)涓?[License](#license)锛夈€?
## 椤圭洰閫熻

| 椤圭洰 | 璇存槑 |
|---|---|
| 鐩爣 | 涓汉璁惧鏃ュ父娴忚銆佹煡璧勬枡銆佽闂唬鐮佷粨搴撳拰瀛︽湳缃戠珯 |
| 鏈嶅姟绔?| Debian 12 / Ubuntu 22.04+ x86_64 VPS銆乻ing-box銆乂LESS + REALITY + xtls-rprx-vision |
| 鍏ュ彛 | TCP 443锛屾棤闇€璐拱鍩熷悕 |
| 瀹㈡埛绔?| Windows 10/11 + Clash Verge Rev锛圡ihomo锛夛紝浠呯郴缁熶唬鐞嗐€?*涓嶄娇鐢?TUN** |
| 鍒嗘祦 | 鍥藉唴鍩熷悕/IP 鐩磋繛锛圖IRECT锛夛紝鍏朵綑璧?VPS锛圥ROXY锛?|
| DNS | Windows 绯荤粺 DNS 浣跨敤 AliDNS DoH锛?23.5.5.5 / 223.6.6.6锛夛紝绂佹鏄庢枃鍥為€€ |
| 浠诲姟鍏ュ彛 | 涓€閿剼鏈?`scripts/install_singbox.sh`锛涘畬鏁存祦绋嬭 `docs/` 鏁欑▼ |

> [!IMPORTANT]
> 鏈粨搴撲笉鏄?鍗虫彃鍗崇敤"鐨勬満鍦烘柟妗堛€備綘闇€瑕佽嚜宸辩鐢?VPS銆佽嚜宸变繚绠?UUID / REALITY 瀵嗛挜 / Short ID锛屽苟鑷閬靛畧鎵€鍦ㄥ湴娉曞緥娉曡涓?VPS 鏈嶅姟鍟嗘潯娆俱€?
> [!NOTE]
> 浠撳簱鎵€鏈夌ず渚嬪潎浣跨敤鍗犱綅绗︼紙`YOUR_UUID`銆乣YOUR_VPS_IP` 绛夛級锛屼笉鍚湡瀹?UUID銆佸瘑閽ャ€丼hort ID 鎴栨湇鍔″櫒 IP锛屽彲瀹夊叏淇濆瓨鍜屽垎浜€?
## Quick Start

> [!WARNING]
> **鍔″繀鍏堟妸鏈嶅姟鍣ㄧ鍚姩鎴愬姛锛屽啀閰嶇疆瀹㈡埛绔€?*
> 瀹㈡埛绔厤缃噷鐨?UUID銆丳ublic Key銆丼hort ID 閮芥潵鑷湇鍔＄瀹夎鑴氭湰鐨勮緭鍑猴紱鏈嶅姟绔病鏈夎窇璧锋潵涔嬪墠锛屽鎴风閰嶇疆娌℃湁浠讳綍鎰忎箟锛屼篃鏃犱粠鏍￠獙銆?
浠ヤ笅鏄渶鐭矾寰勶紝璇︾粏鍘熺悊鍜岄€愭鎵嬪姩鎿嶄綔瑙乕瀹屾暣鏁欑▼](docs/鑷缓涓汉鑺傜偣_VLESS_REALITY_绯荤粺浠ｇ悊_DNS鍒嗘祦鎸囧崡.md)銆?
> [!TIP]
> 绗竴娆￠儴缃茶鍏堥槄璇籟閮ㄧ讲鍓嶆彁](#5-閮ㄧ讲鍓嶆彁)鍜孾瀹夊叏瑕佹眰](#7-瀹夊叏瑕佹眰)锛屽苟鍦ㄤ簯闃茬伀澧欐斁琛?TCP 443 鍚庡啀娴嬭瘯杩為€氭€с€?
```bash
# ===== 绗竴姝ワ細鏈嶅姟绔紙蹇呴』鍏堝畬鎴愶級=====
# 1. SSH 鐧诲綍 VPS
ssh root@YOUR_VPS_IP

# 2. 涓€閿畨瑁呭苟鍚姩 sing-box锛堣剼鏈細鑷姩瀹屾垚 7 姝ユ鏌ワ級
curl -fsSL https://raw.githubusercontent.com/e2432/Setting-Up-a-VPN-Node/main/scripts/install_singbox.sh | bash

# 3. 淇濆瓨鑴氭湰鏈€鍚庤緭鍑虹殑涓夐」瀹㈡埛绔嚟鎹細
#    VLESS UUID / REALITY Public Key / Short ID
# 4. 鍦ㄤ簯鎺у埗鍙版斁琛?TCP 443锛屽苟鍦ㄦ湰鍦伴獙璇侊細
#    Test-NetConnection YOUR_VPS_IP -Port 443   # Windows
```

```powershell
# ===== 绗簩姝ワ細瀹㈡埛绔紙鏈嶅姟绔‘璁ょ洃鍚?443 鍚庡啀鍋氾級=====
# 1. 鎶?docs/ 涓殑 clash-self.yaml 澶嶅埗鍒?Windows锛屾浛鎹?4 涓崰浣嶇
# 2. Clash Verge Rev 瀵煎叆璇ラ厤缃細
#    妯″紡 = 瑙勫垯锛涚郴缁熶唬鐞?= 寮€锛汿UN = 鍏筹紱DNS 瑕嗗啓 = 鍏筹紱PROXY 閫?My-VPS
# 3. 楠岃瘉浠ｇ悊閾?curl.exe -x http://127.0.0.1:7897 https://api.ipify.org   # 搴旇繑鍥?YOUR_VPS_IP
```

> [!CAUTION]
> `curl | bash` 浼氱洿鎺ヤ互 root 鎵ц杩滅▼鑴氭湰銆備粙鎰忕殑璇濊鍏?`curl -fsSL ... -o install_singbox.sh`锛?*璇诲畬鑴氭湰**鍐?`bash install_singbox.sh`銆?
## 1. 鏂规閫熻

```text
                              鈹屸攢鈹€ 涓浗澶ч檰绔欑偣 鈹€鈹€ DIRECT 鈹€鈹€ Internet
Windows 娴忚鍣?/ 搴旂敤
        鈹?                    鈹?        鈹斺攢 绯荤粺浠ｇ悊 鈹€鈹€ Clash/Mihomo
                              鈹?                              鈹斺攢鈹€ 鍏朵粬绔欑偣 鈹€鈹€ PROXY 鈹€鈹€ VLESS + REALITY
                                                     鈹?                                                     鈻?                                                浣犵殑娴峰 VPS
                                                     鈹?                                                     鈻?                                                  Internet

Windows 绯荤粺 DNS
        鈹斺攢鈹€ DNS over HTTPS (DoH) 鈹€鈹€鈻?AliDNS 223.5.5.5 / 223.6.6.6
```

鏈€缁堟棩甯哥姸鎬侊細

```text
Clash Verge锛?  妯″紡          = 瑙勫垯
  绯荤粺浠ｇ悊      = 寮€
  铏氭嫙缃戝崱/TUN  = 鍏?  DNS 瑕嗗啓      = 鍏?
Windows锛?  IPv4 DNS      = 223.5.5.5, 223.6.6.6
  DoH           = 寮€
  鏄庢枃鍥為€€      = 鍏?```

REALITY 鐨勬牳蹇冨弬鏁板叧绯伙紙**涓嶈鍐欏弽**锛夛細

```text
鏈嶅姟鍣細UUID + REALITY Private Key + Short ID
瀹㈡埛绔細UUID + REALITY Public  Key + Short ID
```

## 2. 浠撳簱缁撴瀯

| 鐩綍 / 鏂囦欢 | 鑱岃矗 |
|---|---|
| `README.md` | 鏈〉锛氭柟妗堟瑙堛€佸揩閫熷紑濮嬨€佹鏌ユ竻鍗曚笌甯歌闂 |
| `scripts/install_singbox.sh` | 鏈嶅姟绔竴閿畨瑁呰剼鏈細瑁?sing-box銆佺敓鎴愬嚟鎹€佸啓閰嶇疆銆佹牎楠屽苟鍚姩 |
| `docs/鑷缓涓汉鑺傜偣_VLESS_REALITY_绯荤粺浠ｇ悊_DNS鍒嗘祦鎸囧崡.md` | 瀹屾暣涓冮儴鍒嗘暀绋嬶紙鏈嶅姟绔?鈫?瀹㈡埛绔?鈫?DNS 鈫?楠岃瘉 鈫?瀹夊叏缁存姢 鈫?鏁呴殰鎺掓煡 鈫?妫€鏌ユ竻鍗曪級 |

<details>
<summary><strong>灞曞紑瀹屾暣鐩綍鏍?/strong></summary>

```text
Setting-Up-a-VPN-Node/
鈹溾攢鈹€ README.md
鈹溾攢鈹€ scripts/
鈹?  鈹斺攢鈹€ install_singbox.sh
鈹斺攢鈹€ docs/
    鈹斺攢鈹€ 鑷缓涓汉鑺傜偣_VLESS_REALITY_绯荤粺浠ｇ悊_DNS鍒嗘祦鎸囧崡.md
```

</details>

## 3. 涓€閿畨瑁呰剼鏈?
`scripts/install_singbox.sh` 浼氬湪涓€鍙板叏鏂扮殑 Debian/Ubuntu VPS 涓婃寜椤哄簭鎵ц锛?
```text
install_singbox.sh
  鈹溾攢 1/7 apt 鏇存柊 + curl/ca-certificates/openssl
  鈹溾攢 2/7 妫€鏌?systemd 涓庢灦鏋?  鈹溾攢 3/7 娣诲姞 sing-box 瀹樻柟 APT 婧愬苟瀹夎
  鈹溾攢 4/7 纭 TCP 443 鏈鍗犵敤
  鈹溾攢 5/7 鐢?openssl 楠岃瘉 REALITY 鎻℃墜鐩爣鍙揪
  鈹溾攢 6/7 鐢熸垚 UUID / REALITY 瀵嗛挜瀵?/ Short ID 骞跺啓鍏?/etc/sing-box/config.json
  鈹斺攢 7/7 sing-box check -> systemctl enable --now sing-box -> 纭鐩戝惉 443
```

鍙€夌幆澧冨彉閲忥細

| 鍙橀噺 | 榛樿鍊?| 璇存槑 |
|---|---|---|
| `SERVER_NAME` | `www.microsoft.com` | REALITY 鎻℃墜鐩爣锛屾湇鍔＄涓庡鎴风蹇呴』涓€鑷?|
| `UUID` | 鑷姩鐢熸垚 | 鎸囧畾 VLESS UUID |
| `SHORT_ID` | 鑷姩鐢熸垚 | 鎸囧畾 Short ID |

```bash
# 鑷畾涔夋彙鎵嬬洰鏍囩ず渚?curl -fsSL https://raw.githubusercontent.com/e2432/Setting-Up-a-VPN-Node/main/scripts/install_singbox.sh \
  | SERVER_NAME=www.apple.com bash
```

鑴氭湰缁撴潫鏃朵細鎵撳嵃瀹㈡埛绔渶瑕佺殑涓夐」鍑嵁锛?*璇风珛鍗充繚瀛?*锛?
```text
VLESS UUID         -> clash-self.yaml 鐨?uuid
REALITY Public Key -> clash-self.yaml 鐨?reality-opts.public-key
Short ID           -> clash-self.yaml 鐨?reality-opts.short-id
```

> [!WARNING]
> 鑴氭湰**涓嶄細**鏇夸綘寮€鏀句簯闃茬伀澧欍€傝瀹屽悗蹇呴』鍦ㄤ簯鎺у埗鍙版斁琛?TCP 443锛屽惁鍒?`Test-NetConnection` 浼氫竴鐩村け璐ャ€?
## 4. 閮ㄧ讲娴佺▼

### 4.1 鏈嶅姟绔紙蹇呴』鍏堝惎鍔級

1. 鍑嗗涓€鍙?Debian 12 / Ubuntu 22.04+ x86_64 VPS锛岀嫭绔嬪叕缃?IPv4銆?2. 浜戦槻鐏鑷冲皯鏀捐 `TCP 22`锛圫SH锛屽缓璁檺鍒舵潵婧?IP锛夊拰 `TCP 443`銆?3. SSH 鐧诲綍鍚庤繍琛屼竴閿剼鏈紙瑙?Quick Start锛夈€?4. 纭鏈嶅姟鐘舵€侊細

```bash
systemctl status sing-box --no-pager
ss -lntp | grep ':443 '
sing-box check -c /etc/sing-box/config.json
```

5. 淇濆瓨杈撳嚭鐨?UUID / Public Key / Short ID銆?
### 4.2 瀹㈡埛绔紙鏈嶅姟绔垚鍔熷悗鍐嶉厤缃級

1. 澶嶅埗 `docs/` 鏁欑▼涓殑 `clash-self.yaml` 鍒?Windows銆?2. 鏇挎崲 4 涓崰浣嶇锛歚YOUR_VPS_IP`銆乣YOUR_UUID`銆乣YOUR_REALITY_PUBLIC_KEY`銆乣YOUR_SHORT_ID`銆?3. Clash Verge Rev 瀵煎叆閰嶇疆锛氭ā寮?= 瑙勫垯銆佺郴缁熶唬鐞?= 寮€銆乀UN = 鍏炽€丏NS 瑕嗗啓 = 鍏炽€?4. PROXY 缁勯€夋嫨 `My-VPS`銆?
### 4.3 Windows DNS锛堝彲閫変絾鎺ㄨ崘锛?
绠＄悊鍛?PowerShell 鎵ц鏁欑▼绗笁閮ㄥ垎锛氭坊鍔?AliDNS DoH銆乣AutoUpgrade=True`銆乣AllowFallbackToUdp=False`锛屾妸 WLAN 鐨?IPv4 DNS 鍒囧埌 `223.5.5.5 / 223.6.6.6`銆?
## 5. 閮ㄧ讲鍓嶆彁

### 5.1 鏈嶅姟绔姹?
1. Debian 12 鎴栬緝鏂扮殑 Ubuntu锛寈86_64/amd64銆?2. 鐙珛鍏綉 IPv4锛屽彲鐢?SSH 瀵嗛挜鐧诲綍銆?3. 浜戦槻鐏/瀹夊叏缁勫彲寮€鏀?TCP 443銆?4. TCP 443 鏈 nginx/apache/caddy 绛夊崰鐢紙鑴氭湰浼氭鏌ワ級銆?5. REALITY 鎻℃墜鐩爣锛堥粯璁?`www.microsoft.com`锛夊湪 VPS 鎵€鍦ㄥ湴鍖哄彲杈俱€?
### 5.2 瀹㈡埛绔姹?
- Windows 10/11锛孋lash Verge Rev锛堟垨鍏跺畠 Mihomo 鍐呮牳瀹㈡埛绔級銆?- 娴忚鍣ㄥ拰甯哥敤妗岄潰杞欢閬靛畧 Windows 绯荤粺浠ｇ悊锛堟湰鏂规涓嶄娇鐢?TUN锛夈€?
## 6. 楠岃瘉鍒嗘祦

鍦?Clash Verge銆岃繛鎺ャ€嶉〉闈㈣瀵燂紝娴忚鍣ㄤ緷娆¤闂細

```text
https://www.baidu.com     -> DIRECT
https://www.google.com    -> PROXY / My-VPS
https://www.youtube.com   -> PROXY / My-VPS
```

鍛戒护琛岄獙璇佷唬鐞嗛摼锛?
```powershell
curl.exe -x http://127.0.0.1:7897 https://api.ipify.org   # 搴旇繑鍥?VPS IP
```

杩欐瘮鍗曠函鐪?缃戠珯鑳戒笉鑳芥墦寮€"鏇磋兘纭鍒嗘祦瑙勫垯鐪熸鍛戒腑銆?
## 7. 瀹夊叏瑕佹眰

> [!CAUTION]
> 鑷缓鑺傜偣浼氭妸浣犵殑鍏ㄩ儴浠ｇ悊娴侀噺浜ょ粰鑷繁绉熺敤鐨?VPS銆傚嚟鎹硠闇?= 浠讳綍浜洪兘鑳界敤浣犵殑鑺傜偣銆傝鎶?UUID銆丷EALITY Private Key銆丼hort ID 瑙嗗悓瀵嗙爜淇濈銆?
1. **Private Key 鍙暀鍦ㄦ湇鍔″櫒** `/etc/sing-box/config.json`锛屽鎴风鍙渶瑕?Public Key銆?2. SSH 鍙敤瀵嗛挜鐧诲綍銆佺姝㈠瘑鐮佺櫥褰曪紝TCP 22 灏介噺闄愬埗鏉ユ簮 IP銆?3. 涓嶈浣跨敤瀹濆闈㈡澘銆佹満鍦洪潰鏉裤€佹潵婧愪笉鏄庣殑涓€閿剼鏈垨 Web 绠＄悊鍚庡彴锛涙牳蹇冪粍浠跺彧鏈?Linux + SSH + sing-box銆?4. 淇敼 SSH 閰嶇疆鍓嶄繚鐣欎竴涓凡鐧诲綍缁堢锛屽厛鍦ㄧ浜屼釜缁堢娴嬭瘯锛岄伩鍏嶆妸鑷繁閿佸湪澶栭潰銆?5. 鎬€鐤?UUID/Short ID/閰嶇疆娉勯湶鏃剁珛鍗宠疆鎹細閲嶆柊鐢熸垚涓夐」鍑嵁 鈫?鏇存柊鏈嶅姟绔?鈫?`sing-box check` 鈫?閲嶅惎 鈫?鍚屾瀹㈡埛绔€?6. `Private Key`銆乣.pem`銆乣id_ed25519` 绛夌閽ユ枃浠朵笉瑕佸彂閫佺粰浠讳綍浜恒€?
### 闅愮杈圭晫

```text
鑷缓浠ｇ悊 鈮?鍖垮悕
鑷缓浠ｇ悊 鈮?Tor
鑷缓浠ｇ悊 = 鎶婁腑杞湇鍔″櫒鐨勬帶鍒舵潈鎷垮洖鑷繁鎵嬮噷
```

- 鏈湴缃戠粶/杩愯惀鍟嗚兘鐪嬪埌锛氫綘涓?VPS IP 鐨勮繛鎺ャ€佹椂闂翠笌娴侀噺澶у皬绛夊厓鏁版嵁锛?- VPS 浜戝巶鍟嗗彲鑳界湅鍒帮細杩炴帴鍏冩暟鎹€佺洰鐨?IP锛?- 鏈€缁堢綉绔欎粛鍙兘鐭ラ亾锛歏PS 鍑哄彛 IP銆佽处鍙枫€丆ookie銆佹祻瑙堝櫒鎸囩汗銆?
## 8. 甯歌闂

### 涓€閿剼鏈彁绀?"TCP 443 宸茶鍗犵敤"

璇存槑 VPS 涓婂凡鏈?nginx/apache/caddy 绛夌洃鍚?443銆傚仠鐢ㄨ绋嬪簭鎴栨崲鐢ㄥ叾瀹冨叆鍙ｇ鍙ｅ悗鍐嶈繍琛岃剼鏈紙鎹㈢鍙ｉ渶鍚屾淇敼瀹㈡埛绔?`port`锛夈€?
### 涓€閿剼鏈彁绀?"鏃犳硶涓?xxx:443 瀹屾垚 TLS 鎻℃墜"

REALITY 鎻℃墜鐩爣鍦?VPS 鎵€鍦ㄥ湴鍖轰笉鍙揪銆傛崲涓€涓ǔ瀹氥€佹甯告彁渚?TLS 鐨勭珯鐐癸細

```bash
curl -fsSL .../install_singbox.sh | SERVER_NAME=www.apple.com bash
```

骞跺悓姝ヤ慨鏀瑰鎴风 `servername`銆?
### 鏈嶅姟绔?`ss` 鏄剧ず 443 鍦ㄧ洃鍚紝浣?Windows 杩炰笉涓?
鍏堟鏌ヤ簯骞冲彴瀹夊叏缁?闃茬伀澧欍€丩ighthouse/CVM 闃茬伀澧欍€丩inux 鑷韩 nftables/iptables/ufw锛?
```powershell
Test-NetConnection YOUR_VPS_IP -Port 443   # 鐩爣 TcpTestSucceeded : True
```

### `Permission denied (publickey)`

SSH 韬唤璁よ瘉澶辫触銆傜敤 `ssh -i "C:\path\key.pem" root@YOUR_VPS_IP` 鎸囧畾瀵嗛挜锛岃€屼笉鏄８鐨?`ssh root@...`銆?
### 鏄惧紡浠ｇ悊姝ｅ父锛屼絾涓嶅紑 `-x` 鐨?curl 涓嶉€?
`curl.exe -x http://127.0.0.1:7897 ...` 姝ｅ父鑰?`curl.exe https://...` 涓嶆甯革紝涓嶄竴瀹氭槸鑺傜偣鍧忎簡銆傜郴缁熶唬鐞嗗彧鎺ョ**閬靛畧 Windows 浠ｇ悊璁剧疆鐨勮蒋浠?*锛岃繖鏄郴缁熶唬鐞嗕笌 TUN 鏈€閲嶈鐨勫樊鍒€?
### TUN 鎶?`The device is not ready for use`

杩欐槸 Windows 铏氭嫙缃戝崱/Wintun 璺緞闂锛屼笉浠ｈ〃 VPS / VLESS / REALITY 鍧忎簡銆傛棩甯镐互娴忚鍣ㄤ负涓绘椂鐩存帴鐢ㄣ€岀郴缁熶唬鐞?= 寮€銆乀UN = 鍏炽€嶅嵆鍙€?
### DoH 宸插紑浣嗗浗澶栧煙鍚嶈В鏋愬紓甯?
DoH 鍙繚璇?鍒拌В鏋愬櫒鐨勪紶杈撳姞瀵?锛屼笉淇濊瘉瑙ｆ瀽缁撴灉閫傚悎鍥藉绔欑偣銆傚彲涓鸿绋嬪簭鏄惧紡閰嶄唬鐞嗐€佹崲鍏跺畠鍙俊 DoH锛屾垨鎭㈠ DHCP DNS锛?
```powershell
Set-DnsClientServerAddress -InterfaceAlias "WLAN" -ResetServerAddresses
```

## 9. 涓€椤靛紡妫€鏌ユ竻鍗?
<details>
<summary><strong>灞曞紑妫€鏌ユ竻鍗?/strong></summary>

**鏈嶅姟鍣?*

```text
[ ] SSH 瀵嗛挜鐧诲綍鎴愬姛
[ ] sing-box 宸插畨瑁?[ ] sing-box check 閫氳繃
[ ] systemctl 鏄剧ず active (running)
[ ] 0.0.0.0:443 姝ｅ湪鐩戝惉
[ ] 浜戦槻鐏 TCP 443 宸叉斁琛?[ ] Reality Private Key 鍙瓨鍦ㄤ簬鏈嶅姟鍣?```

**Windows**

```text
[ ] clash-self.yaml 宸插鍏?[ ] PROXY 缁勯€夋嫨 My-VPS
[ ] 妯″紡 = 瑙勫垯
[ ] 绯荤粺浠ｇ悊 = 寮€
[ ] TUN = 鍏?[ ] DNS 瑕嗗啓 = 鍏?[ ] curl -x 127.0.0.1:7897 杩斿洖 VPS IP
```

**DNS**

```text
[ ] WLAN IPv4 DNS = 223.5.5.5 / 223.6.6.6
[ ] AutoUpgrade = True
[ ] AllowFallbackToUdp = False
[ ] Resolve-DnsName 鍥藉唴鍩熷悕姝ｅ父
```

**鍒嗘祦**

```text
[ ] 鐧惧害绛夊浗鍐呯珯鐐规樉绀?DIRECT
[ ] Google/YouTube 绛夋樉绀?PROXY / My-VPS
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