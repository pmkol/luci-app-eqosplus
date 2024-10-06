#!/bin/bash
#
arch=$1
echo "matrix.arch=$arch"
[[ "$arch" != "x86_64" && "$arch" != "aarch64_generic" ]] && echo "Unsupported architecture: $arch. Exiting..." && exit 1

curl -s https://downloads.openwrt.org/releases/packages-23.05/$arch/packages/Packages | grep '^Package:' | awk '{print $2}' | sort > openwrt-packages
curl -s https://downloads.immortalwrt.org/releases/packages-23.05/$arch/packages/Packages | grep '^Package:' | awk '{print $2}' | sort > immortalwrt-packages
grep -Fxf openwrt-packages immortalwrt-packages > remove-packages
curl -s https://downloads.openwrt.org/releases/packages-23.05/$arch/luci/Packages | grep '^Package:' | awk '{print $2}' | sort > openwrt-packages
curl -s https://downloads.immortalwrt.org/releases/packages-23.05/$arch/luci/Packages | grep '^Package:' | awk '{print $2}' | sort > immortalwrt-packages
grep -Fxf openwrt-packages immortalwrt-packages >> remove-packages

git clone https://github.com/immortalwrt/packages immortalwrt/packages --depth 1
git clone https://github.com/immortalwrt/luci immortalwrt/luci --depth 1

while read -r pkg_name; do
  find immortalwrt -mindepth 3 -maxdepth 3 -type d -name "$pkg_name" | while read -r pkg_dir; do
    remove_dir=$(realpath "$pkg_dir")
    echo "remove $pkg_dir"
    rm -rf "$remove_dir"
  done
done < remove-packages
