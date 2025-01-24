[ -f "$WORK_DIR/system/system/priv-app/AppLock/AppLock.apk" ] \
    && mv -f "$WORK_DIR/system/system/priv-app/AppLock/AppLock.apk" "$WORK_DIR/system/system/priv-app/AppLock/SAppLock.apk"
[ -d "$WORK_DIR/system/system/priv-app/AppLock" ] \
    && mv -f "$WORK_DIR/system/system/priv-app/AppLock" "$WORK_DIR/system/system/priv-app/SAppLock"

if ! grep -q "SAppLock" "$WORK_DIR/configs/file_context-system"; then
    {
        echo "/system/etc/permissions/privapp-permissions-com\.samsung\.android\.applock\.xml u:object_r:system_file:s0"
        echo "/system/priv-app/SAppLock u:object_r:system_file:s0"
        echo "/system/priv-app/SAppLock/SAppLock\.apk u:object_r:system_file:s0"
    } >> "$WORK_DIR/configs/file_context-system"
fi
if ! grep -q "SAppLock" "$WORK_DIR/configs/fs_config-system"; then
    {
        echo "system/etc/permissions/privapp-permissions-com.samsung.android.applock.xml 0 0 644 capabilities=0x0"
        echo "system/priv-app/SAppLock 0 0 755 capabilities=0x0"
        echo "system/priv-app/SAppLock/SAppLock.apk 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-system"
fi
