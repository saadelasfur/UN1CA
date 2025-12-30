SCRIPT_FILE="$TMP_DIR/META-INF/com/google/android/updater-script"

sed -i "/# --- End patching dynamic partitions ---/q" "$SCRIPT_FILE"

{
    echo ''
    echo 'ui_print("Full Patching dtbo.img img...");'
    echo 'getprop("ro.boot.em.model") == "SM-G990B" &&'
    echo '  package_extract_file("dtbo.img", "/dev/block/bootdevice/by-name/dtbo") ||'
    echo '  package_extract_file("dtbo_r9q2.img", "/dev/block/bootdevice/by-name/dtbo");'
    echo ''
    echo 'ui_print("Full Patching vendor_boot.img img...");'
    echo 'getprop("ro.boot.em.model") == "SM-G990B" &&'
    echo '  package_extract_file("vendor_boot.img", "/dev/block/bootdevice/by-name/vendor_boot") ||'
    echo '  package_extract_file("vendor_boot_r9q2.img", "/dev/block/bootdevice/by-name/vendor_boot");'
    echo ''
    echo 'ui_print("Installing boot image...");'
    echo 'getprop("ro.boot.em.model") == "SM-G990B" &&'
    echo '  package_extract_file("boot.img", "/dev/block/bootdevice/by-name/boot") ||'
    echo '  package_extract_file("boot_r9q2.img", "/dev/block/bootdevice/by-name/boot");'
    echo ''
    echo 'set_progress(1.000000);'
    echo 'ui_print("****************************************");'
    echo 'ui_print(" ");'
} >> "$SCRIPT_FILE"

unset SCRIPT_FILE
