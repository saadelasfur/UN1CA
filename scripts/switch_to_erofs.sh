#!/bin/bash
#
# Copyright (C) 2025 saadelasfur
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

set -eu

if [ "$#" == 0 ]; then
    exit 1
fi

PACK_IMAGE()
{
    local IMAGE_FILE="$1"
    local IMAGE_TYPE="$2"

    if [ ! -f "$IMAGE_FILE" ]; then
        echo "File not found: $IMAGE_FILE"
        exit 1
    else
        echo "Switching image to erofs"
        mkdir -p "$TMP_DIR/tmp"
        mv "$IMAGE_FILE" "$TMP_DIR/tmp/"
        cd "$TMP_DIR/tmp"

        if [ "$IMAGE_TYPE" == "vendor_boot" ]; then
            magiskboot unpack -h vendor_boot.img
            mkdir ramdisk
            cd ramdisk
            cpio -idv < ../ramdisk.cpio
            cp -a --preserve=all "$SRC_DIR/target/$TARGET_CODENAME/patches/erofs/vendor/etc/fstab.qcom" "$TMP_DIR/tmp/ramdisk/first_stage_ramdisk/fstab.qcom"
            find . | cpio -o -H newc > ../ramdisk_new.cpio
            cd ..
            rm ramdisk.cpio
            mv ramdisk_new.cpio ramdisk.cpio
            magiskboot repack vendor_boot.img vendor_boot_new.img
            mv "$TMP_DIR/tmp/vendor_boot_new.img" "$WORK_DIR/kernel/vendor_boot.img"
        else
            magiskboot unpack -h boot.img
            mkdir ramdisk
            cd ramdisk
            cpio -idv < ../ramdisk.cpio
            cp -a --preserve=all "$SRC_DIR/target/$TARGET_CODENAME/patches/patches/erofs/vendor/etc/fstab.qcom" "$TMP_DIR/tmp/ramdisk/fstab.qcom"
            find . | cpio -o -H newc > ../ramdisk_new.cpio
            cd ..
            rm ramdisk.cpio
            mv ramdisk_new.cpio ramdisk.cpio
            magiskboot repack boot.img boot_new.img
            mv "$TMP_DIR/tmp/boot_new.img" "$WORK_DIR/kernel/boot.img"
        fi

        cd "$SRC_DIR"
        rm -rf "$TMP_DIR/tmp"
    fi
}

while [ "$#" != 0 ]; do
    if [ "$TARGET_HAS_VENDOR_BOOT" == "true" ]; then
        PACK_IMAGE "$1" "vendor_boot"
    else
        PACK_IMAGE "$1" "boot"
    fi

    shift
done
