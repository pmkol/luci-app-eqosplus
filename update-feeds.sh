#!/bin/bash

# backup feeds
mkdir -p /tmp/bak/
mv */ /tmp/bak/

# download feeds
git clone https://github.com/openwrt/luci openwrt/luci -b openwrt-23.05 --depth 1
git clone https://github.com/openwrt/packages openwrt/packages -b master --depth 1
git clone https://github.com/immortalwrt/luci immortalwrt/luci -b openwrt-23.05 --depth 1
git clone https://github.com/immortalwrt/packages immortalwrt/packages -b openwrt-23.05 --depth 1
git clone https://github.com/immortalwrt/homeproxy immortalwrt/luci-app-homeproxy --depth 1
git clone https://github.com/sirpdboy/luci-app-ddns-go openwrt-ddns-go --depth 1
git clone https://github.com/sbwml/openwrt_pkgs --depth 1
git clone https://github.com/sbwml/openwrt_helloworld --depth 1
git clone https://github.com/sbwml/luci-app-alist openwrt-alist --depth 1
git clone https://github.com/sbwml/luci-app-airconnect openwrt-airconnect --depth 1
git clone https://github.com/sbwml/luci-app-mentohust openwrt-mentohust --depth 1
git clone https://github.com/sbwml/luci-app-mosdns openwrt-mosdns --depth 1
git clone https://github.com/sbwml/luci-app-qbittorrent openwrt-qbittorrent --depth 1
git clone https://github.com/sbwml/packages_utils_containerd --depth 1
git clone https://github.com/sbwml/packages_utils_docker --depth 1
git clone https://github.com/sbwml/packages_utils_dockerd --depth 1
git clone https://github.com/sbwml/packages_utils_runc --depth 1
#git clone https://github.com/pmkol/openwrt-eqosplus --depth 1
git clone https://github.com/pmkol/openwrt-mihomo --depth 1

rm -rf immortalwrt/luci-app-homeproxy/{LICENSE,README}
rm -rf openwrt-ddns-go/luci-app-ddns-go/README.md
rm -rf openwrt_pkgs/fw_download_tool
rm -rf openwrt_pkgs/lshw
rm -rf openwrt_pkgs/luci-app-eqos wget patch
rm -rf openwrt_pkgs/luci-app-ota
rm -rf openwrt_pkgs/luci-app-zerotier wget patch
rm -rf openwrt_pkgs/rtl_fm_streamer
rm -rf openwrt_helloworld/

# download patch
mv -f openwrt_helloworld/*.patch ./
curl https://raw.githubusercontent.com/pmkol/openwrt-plus/refs/heads/master/openwrt/patch/docker/0001-dockerd-fix-bridge-network.patch > patch_docker_1.patch
curl https://raw.githubusercontent.com/pmkol/openwrt-plus/refs/heads/master/openwrt/patch/docker/0002-docker-add-buildkit-experimental-support.patch patch_docker_2.patch
curl https://github.com/pmkol/openwrt-plus/raw/refs/heads/master/openwrt/patch/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch > patch_docker_3.patch


# luci-app-alist
mv openwrt-alist/*/ ./
rm -rf openwrt-alist

# luci-app-airconnect/*/ ./
mv openwrt-airconnect
rm -rf openwrt-airconnect

# luci-app-ddns-go
mv openwrt-ddns-go/*/ ./
rm -rf openwrt-ddns-go

# luci-app-eqos
#patch -p1 -f -s -d immortalwrt/luci/applications < patch-luci-app-eqos.patch
#if [ $? -eq 0 ]; then
#    rm -rf luci-app-eqos
#    mv immortalwrt/luci/applications/luci-app-eqos luci-app-eqos
#else
#    mv /tmp/bak/luci-app-eqos luci-app-eqos
#fi

# luci-app-eqosplus
#mv openwrt-eqosplus/*/ ./

# luci-app-frpc
mv openwrt/luci/applications/luci-app-frpc ./

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

# luci-app-zerotier

mv immortalwrt/luci/applications/luci-app-zerotier luci-app-zerotier

# haproxy
mv openwrt/packages/net/haproxy ./


rm -rf openwrt immortalwrt
