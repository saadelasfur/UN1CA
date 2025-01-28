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
        sed -i "/$FILE/d" "$WORK_DIR/configs/fs_config-$PARTITION"

        FILE="$(echo -n "$FILE" | sed 's/\./\\\\\./g')"
        sed -i "/$FILE/d" "$WORK_DIR/configs/file_context-$PARTITION"
    fi
}
# ]

REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/SmartManager_v6_DeviceSecurity"
REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml"

if ! grep -q "system/app/SmartManager_v6_DeviceSecurity" "$WORK_DIR/configs/file_context-system"; then
    {
        echo "/system/etc/permissions/signature-permissions-com\.samsung\.android\.lool.xml u:object_r:system_file:s0"
        echo "/system/app/SmartManager_v6_DeviceSecurity u:object_r:system_file:s0"
        echo "/system/app/SmartManager_v6_DeviceSecurity/SmartManager_v6_DeviceSecurity\.apk u:object_r:system_file:s0"
    } >> "$WORK_DIR/configs/file_context-system"
fi
if ! grep -q "system/app/SmartManager_v6_DeviceSecurity" "$WORK_DIR/configs/fs_config-system"; then
    {
        echo "system/etc/permissions/signature-permissions-com.samsung.android.lool.xml 0 0 644 capabilities=0x0"
        echo "system/app/SmartManager_v6_DeviceSecurity 0 0 755 capabilities=0x0"
        echo "system/app/SmartManager_v6_DeviceSecurity/SmartManager_v6_DeviceSecurity.apk 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-system"
fi
