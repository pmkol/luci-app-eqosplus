#!/bin/bash

# backup feeds
shopt -s extglob
mkdir -p /tmp/bak/
mv */ /tmp/bak/

# download feeds
git clone https://github.com/openwrt/luci openwrt/luci -b openwrt-23.05 --depth 1
git clone https://github.com/openwrt/packages openwrt/packages -b openwrt-23.05 --depth 1
git clone https://github.com/immortalwrt/luci immortalwrt/luci -b master --depth 1
git clone https://github.com/immortalwrt/packages immortalwrt/packages -b master --depth 1
git clone https://github.com/immortalwrt/homeproxy immortalwrt/luci-app-homeproxy --depth 1
git clone https://github.com/sirpdboy/luci-app-ddns-go openwrt-ddns-go --depth 1
git clone https://github.com/QiuSimons/luci-app-daed openwrt-daed --depth 1
git clone https://github.com/sbwml/openwrt_pkgs --depth 1
git clone https://github.com/sbwml/openwrt_helloworld --depth 1
git clone https://github.com/sbwml/luci-app-alist openwrt-alist --depth 1
git clone https://github.com/sbwml/luci-app-airconnect openwrt-airconnect --depth 1
git clone https://github.com/sbwml/luci-app-mentohust openwrt-mentohust --depth 1
git clone https://github.com/sbwml/luci-app-mosdns openwrt-mosdns --depth 1
git clone https://github.com/sbwml/luci-app-qbittorrent openwrt-qbittorrent --depth 1
git clone https://github.com/sbwml/luci-theme-argon openwrt-argon --depth 1
git clone https://github.com/sbwml/packages_utils_containerd --depth 1
git clone https://github.com/sbwml/packages_utils_docker --depth 1
git clone https://github.com/sbwml/packages_utils_dockerd --depth 1
git clone https://github.com/sbwml/packages_utils_runc --depth 1
git clone https://github.com/sbwml/OpenAppFilter openwrt-oaf --depth 1
git clone https://github.com/sbwml/feeds_packages_libs_liburing --depth 1
git clone https://github.com/sbwml/feeds_packages_net_samba4 --depth 1
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic --depth 1
git clone https://github.com/hudra0/qosmate --depth 1
git clone https://github.com/pmkol/luci-app-qosmate --depth 1
git clone https://github.com/pmkol/openwrt-eqosplus --depth 1
git clone https://github.com/pmkol/openwrt-mihomo --depth 1
git clone https://github.com/pmkol/v2ray-geodata --depth 1
git clone https://github.com/pmkol/packages_net_miniupnpd miniupnpd --depth 1
git clone https://github.com/pmkol/luci-app-upnp --depth 1

rm -rf immortalwrt/luci-app-homeproxy/{LICENSE,README}
rm -rf openwrt-ddns-go/luci-app-ddns-go/README.md
rm -rf openwrt_pkgs/{fw_download_tool,lshw,luci-app-eqos,luci-app-ota,luci-app-zerotier,rtl_fm_streamer}
rm -rf openwrt_helloworld/{luci-app-homeproxy,luci-app-mihomo,mihomo,v2ray-geodata}
#rm -rf openwrt-alist/alist
rm -rf feeds_packages_libs_liburing/.git
rm -rf feeds_packages_net_samba4/.git
rm -rf packages_utils_containerd/.git
rm -rf packages_utils_docker/.git
rm -rf packages_utils_dockerd/.git
rm -rf packages_utils_runc/.git
rm -rf luci-app-unblockneteasemusic/.git
rm -rf qosmate/.git
rm -rf luci-app-qosmate/.git
rm -rf v2ray-geodata/.git
rm -rf packages_net_miniupnpd/.git
rm -rf luci-app-upnp/.git

# download patch
mv -f openwrt_helloworld/*.patch ./
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/docker/0001-dockerd-fix-bridge-network.patch > patch-dockerd-fix-bridge-network.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/docker/0002-docker-add-buildkit-experimental-support.patch patch-docker-add-buildkit-experimental-support.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch > patch-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/luci/applications/luci-app-frpc/001-luci-app-frpc-hide-token-openwrt-23.05.patch > patch-luci-app-frpc-hide-token.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/luci/applications/luci-app-frpc/002-luci-app-frpc-add-enable-flag-openwrt-23.05.patch > patch-luci-app-frpc-add-enable-flag.patch

# add pkgs
mv openwrt_pkgs/*/ ./
rm -rf openwrt_pkgs

# add helloworld
mv openwrt_helloworld/*/ ./
rm -rf openwrt_helloworld

# add luci-app-alist
mv openwrt-alist/*/ ./
rm -rf openwrt-alist

# add luci-app-airconnect/*/ ./
mv openwrt-airconnect/*/ ./
rm -rf openwrt-airconnect

# add luci-theme-argon
mv openwrt-argon/*/ ./
rm -rf openwrt-argon

# add luci-app-ddns-go
mv openwrt-ddns-go/*/ ./
rm -rf openwrt-ddns-go

#add luci-app-eqosplus
mv openwrt-eqosplus/*/ ./
rm -rf openwrt-eqosplus

# luci-app-frpc
mv openwrt/luci/applications/luci-app-frpc ./
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|' luci-app-frpc/Makefile
sed -i 's,frp 客户端,FRP 客户端,g' luci-app-frpc/po/zh_Hans/frpc.po
rm -rf luci-app-frpc/po/!(templates|zh_Hans)
patch -p1 -f -s patch-luci-app-frpc-hide-token.patch
patch -p1 -f -s patch-luci-app-frpc-add-enable-flag.patch
mv openwrt/packages/net/frp ./
sed -i 's|../../lang|$(TOPDIR)/feeds/packages/lang|' frp/Makefile
sed -i 's/procd_set_param stdout $stdout/procd_set_param stdout 0/g' frp/files/frpc.init
sed -i 's/procd_set_param stderr $stderr/procd_set_param stderr 0/g' frp/files/frpc.init
sed -i 's/stdout stderr //g' frp/files/frpc.init
sed -i '/stdout:bool/d;/stderr:bool/d' frp/files/frpc.init
sed -i '/stdout/d;/stderr/d' frp/files/frpc.config
sed -i 's/env conf_inc/env conf_inc enable/g' frp/files/frpc.init
sed -i "s/'conf_inc:list(string)'/& \\\\/" frp/files/frpc.init
sed -i "/conf_inc:list/a\\\t\t\'enable:bool:0\'" frp/files/frpc.init
sed -i '/procd_open_instance/i\\t\[ "$enable" -ne 1 \] \&\& return 1\n' frp/files/frpc.init

# luci-app-mentohust
mv openwrt-mentohust/*/ ./
rm -rf openwrt-mentohust

# luci-app-mihomo
mv openwrt-mihomo/*/ ./
rm -rf openwrt-mihomo

# luci-app-mosdns
mv openwrt-mosdns/*/ ./
rm -rf openwrt-mosdns

# luci-app-passwall
PASSWALL_VERSION=$(curl -s "https://api.github.com/repos/xiaorouji/openwrt-passwall/tags" | jq -r '.[0].name')
if [ "$(grep ^PKG_VERSION luci-app-passwall/Makefile | cut -d '=' -f 2 | tr -d ' ')" != "$PASSWALL_VERSION" ]; then
    rm -rf luci-app-passwall
    git clone https://github.com/xiaorouji/openwrt-passwall.git -b "$PASSWALL_VERSION" --depth 1
    patch -p1 -f -s -d openwrt-passwall < patch-luci-app-passwall.patch
    if [ $? -eq 0 ]; then
        rm -rf luci-app-passwall
        mv openwrt-passwall/luci-app-passwall ./
        rm -rf openwrt-passwall
    else
        rm -rf openwrt-passwall
    fi
fi

# luci-app-qbittorrent
mv openwrt-qbittorrent/*/ ./
rm -rf openwrt-qbittorrent

# luci-app-ttyd
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# smb
# enable multi-channel
sed -i '/workgroup/a \\n\t## enable multi-channel' feeds/packages/net/samba4/files/smb.conf.template
sed -i '/enable multi-channel/a \\tserver multi channel support = yes' feeds/packages/net/samba4/files/smb.conf.template
# default config
sed -i 's/#aio read size = 0/aio read size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#aio write size = 0/aio write size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#create mask/create mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#directory mask/directory mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' feeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/samba.config
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/smb.conf.template


# unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/网易云音乐解锁/g' luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# docker
sed -i 's|../../lang|$(TOPDIR)/feeds/packages/lang|' packages_utils_containerd/Makefile
sed -i 's|../../lang|$(TOPDIR)/feeds/packages/lang|' packages_utils_docker/Makefile
sed -i 's|../../lang|$(TOPDIR)/feeds/packages/lang|' packages_utils_dockerd/Makefile
sed -i 's|../../lang|$(TOPDIR)/feeds/packages/lang|' packages_utils_runc/Makefile

# nlbwmon
mv openwrt/packages/net/nlbwmon ./
sed -i 's/stderr 1/stderr 0/g' nlbwmon/files/nlbwmon.init
mv openwrt/luci/applications/luci-app-nlbwmon ./
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|' luci-app-nlbwmon/Makefile
sed -i 's/services/network/g' luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services/network/g' luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# haproxy
mv openwrt/packages/net/haproxy ./

rm -rf openwrt immortalwrt
