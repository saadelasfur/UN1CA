# [
REMOVE_FROM_WORK_DIR()
{
    local FILE_PATH="$1"

    if [ -e "$FILE_PATH" ]; then
        local FILE
        local PARTITION
        FILE="$(echo -n "$FILE_PATH" | sed "s.$WORK_DIR/..")"
        PARTITION="$(echo -n "$FILE" | cut -d "/" -f 1)"

        echo "Debloating /$FILE"
        rm -rf "$FILE_PATH"

        [[ "$PARTITION" == "system" ]] && FILE="$(echo "$FILE" | sed 's.^system/system/.system/.')"
        FILE="$(echo -n "$FILE" | sed 's/\//\\\//g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/fs_config-$PARTITION"

        FILE="$(echo -n "$FILE" | sed 's/\./\\\\\./g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/file_context-$PARTITION"
    fi
}
# ]

REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/bin/dualdard"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/init/dualdard.rc"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.hdmapp.xml"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/android.hardware.weaver@1.0.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/hidl_comm_ddar_client.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/hidl_comm_snap_client.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libdualdar.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libepm.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libhermes_cred.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libkeyutils.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libknox_filemanager.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libpersona.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/vendor.samsung.hardware.tlc.ddar@1.0.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/vendor.samsung.hardware.tlc.snap@1.0.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib64/hidl_comm_ddar_client.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib64/hidl_comm_snap_client.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib64/libdualdar.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib64/vendor.samsung.hardware.tlc.ddar@1.0.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib64/vendor.samsung.hardware.tlc.snap@1.0.so"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/HdmApk"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/KnoxAIFrameworkApp"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/KnoxGuard"
