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

REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/bin/hw/vendor.samsung.hardware.biometrics.face@2.0-service"
REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/etc/init/vendor.samsung.hardware.biometrics.face@2.0-service.rc"

if ! grep -q "biometrics\.face@3\.0-service" "$WORK_DIR/configs/file_context-vendor"; then
    {
        echo "/vendor/bin/hw/vendor\.samsung\.hardware\.biometrics\.face@3\.0-service u:object_r:hal_face_default_exec:s0"
        echo "/vendor/etc/init/vendor\.samsung\.hardware\.biometrics\.face@3\.0-service\.rc u:object_r:vendor_configs_file:s0"
        echo "/vendor/lib/vendor\.samsung\.hardware\.biometrics\.face@3\.0\.so u:object_r:vendor_file:s0"
        echo "/vendor/lib64/vendor\.samsung\.hardware\.biometrics\.face@3\.0\.so u:object_r:vendor_file:s0"
    } >> "$WORK_DIR/configs/file_context-vendor"
fi
if ! grep -q "biometrics.face@3.0-service" "$WORK_DIR/configs/fs_config-vendor"; then
    {
        echo "vendor/bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service 0 2000 755 capabilities=0x0"
        echo "vendor/etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc 0 0 644 capabilities=0x0"
        echo "vendor/lib/vendor.samsung.hardware.biometrics.face@3.0.so 0 0 644 capabilities=0x0"
        echo "vendor/lib64/vendor.samsung.hardware.biometrics.face@3.0.so 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-vendor"
fi
