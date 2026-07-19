#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/10.0.1.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
sed -i 's/LEDE/OneCloud/g' package/base-files/files/bin/config_generate

# 替换终端为bash
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# 修改默认用户名和密码
PASSWD_HASH=$(openssl passwd -6 -salt "onecloud" "liqwerty")
cat >> .config <<EOF
CONFIG_TARGET_ROOTFS_PASSWD_REPLACE=y
CONFIG_TARGET_ROOTFS_PASSWD_USERNAME="lis"
CONFIG_TARGET_ROOTFS_PASSWD_HASH="$PASSWD_HASH"
EOF

# 删除不兼容的S905D补丁 - 修复编译失败问题
[ -f target/linux/amlogic/patches-6.6/001-dts-s905d-fix-high-load.patch ] && \
rm -f target/linux/amlogic/patches-6.6/001-dts-s905d-fix-high-load.patch
