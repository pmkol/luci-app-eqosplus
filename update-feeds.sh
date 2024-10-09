#!/bin/bash

# backup feeds
shopt -s extglob
mkdir -p /tmp/bak/
mv */ /tmp/bak/

# download feeds
git clone https://github.com/openwrt/luci openwrt/luci -b openwrt-23.05 --depth 1
git clone https://github.com/openwrt/packages openwrt/packages -b master --depth 1
git clone https://github.com/immortalwrt/luci immortalwrt/luci -b openwrt-23.05 --depth 1
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
git clone https://github.com/pmkol/openwrt-eqosplus --depth 1
git clone https://github.com/pmkol/openwrt-mihomo --depth 1
git clone https://github.com/pmkol/v2ray-geodata -b lite --depth 1

rm -rf immortalwrt/luci-app-homeproxy/{LICENSE,README}
rm -rf openwrt-ddns-go/luci-app-ddns-go/README.md
rm -rf openwrt_pkgs/{fw_download_tool,lshw,luci-app-eqos,luci-app-ota,luci-app-zerotier,rtl_fm_streamer}
rm -rf openwrt_helloworld/{luci-app-homeproxy,luci-app-mihomo,mihomo,v2ray-geodata}
rm -rf openwrt-alist/alist

# download patch
mv -f openwrt_helloworld/*.patch ./
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/docker/0001-dockerd-fix-bridge-network.patch > patch-dockerd-fix-bridge-network.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/docker/0002-docker-add-buildkit-experimental-support.patch patch-docker-add-buildkit-experimental-support.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch > patch-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/miniupnpd/01-set-presentation_url.patch > patch-miniupnpd-set-presentation_url.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/miniupnpd/02-force_forwarding.patch > patch-miniupnpd-force_forwarding.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/miniupnpd/04-enable-force_forwarding-by-default.patch > patch-miniupnpd-enable-force_forwarding-by-default.patch 
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/luci/applications/luci-app-frpc/001-luci-app-frpc-hide-token-openwrt-23.05.patch > patch-luci-app-frpc-hide-token.patch
curl -s https://raw.githubusercontent.com/pmkol/openwrt-plus/master/openwrt/patch/luci/applications/luci-app-frpc/002-luci-app-frpc-add-enable-flag-openwrt-23.05.patch > patch-luci-app-frpc-add-enable-flag.patch

# add pkgs
mv openwrt_pkgs/*/ ./

# add helloworld
mv openwrt_helloworld/*/ ./

# add luci-app-alist
mv openwrt-alist/*/ ./
rm -rf openwrt-alist

# add luci-app-ddns-go
mv openwrt-ddns-go/*/ ./
rm -rf openwrt-ddns-go

# add luci-app-eqos
mv immortalwrt/luci/applications/luci-app-eqos ./
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|' luci-app-eqos/Makefile
#luci_eqos_commit_date=$(curl -s "https://api.github.com/repos/immortalwrt/luci/commits?path=applications/luci-app-eqos&sha=openwrt-23.05" | jq -r '.[0].commit.committer.date' | cut -d'T' -f1 | tr -d '-')
#luci_eqos_po_commit_date=$(curl -s "https://api.github.com/repos/immortalwrt/luci/commits?path=applications/luci-app-eqos/po&sha=openwrt-23.05" | jq -r '.[0].commit.committer.date' | cut -d'T' -f1 | tr -d '-')
sed -i 's/services/network/g' luci-app-eqos/root/usr/share/luci/menu.d/luci-app-eqos.json
sed -i '3 a\\t\t"order": 80,' luci-app-eqos/root/usr/share/luci/menu.d/luci-app-eqos.json

# luci-app-eqosplus
#mv openwrt-eqosplus/*/ ./
#rm -rf openwrt-eqosplus

# luci-app-frpc
mv openwrt/luci/applications/luci-app-frpc ./
sed -i 's|../../luci.mk|$(TOPDIR)/feeds/luci/luci.mk|' luci-app-frpc/Makefile
#luci_frpc_commit_date=$(curl -s "https://api.github.com/repos/immortalwrt/luci/commits?path=applications/luci-app-frpc&sha=openwrt-23.05" | jq -r '.[0].commit.committer.date' | cut -d'T' -f1 | tr -d '-')
#sed -i "/PKG_MAINTAINER/i\PKG_PO_VERSION:=$luci_frpc_commit_date" luci-app-frpc/Makefile
#sed -i "/PKG_MAINTAINER/i\PKG_VERSION:=$luci_frpc_commit_date" luci-app-frpc/Makefile
sed -i 's,frp 客户端,FRP 客户端,g' luci-app-frpc/po/zh_Hans/frpc.po
rm -rf luci-app-frpc/po/!(templates|zh_Hans)
patch -p1 -f -s patch-luci-app-frpc-hide-token.patch
patch -p1 -f -s patch-luci-app-frpc-add-enable-flag.patch

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

rm -rf openwrt immortalwrt
