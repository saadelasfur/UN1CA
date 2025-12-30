LOG_STEP_IN "- Adding /vendor/firmware/wlan/qca_cld/wlan_mac.bin"
EVAL "ln -sf \"/mnt/vendor/persist/wlan_mac.bin\" \"$WORK_DIR/vendor/firmware/wlan/qca_cld/wlan_mac.bin\""
SET_METADATA "vendor" "firmware/wlan/qca_cld/wlan_mac.bin" 0 0 644 "u:object_r:vendor_firmware_file:s0"
LOG_STEP_OUT

LOG "- Patching /vendor/etc/selinux/vendor_sepolicy.cil"
ENTRIES="
factory_ssc_exec
hal_wifi_default_exec
hal_wifi_hostapd_default_exec
hal_wifi_supplicant_default_exec
macloader_exec
mfgloader_exec
vendor_configs_file
vendor_file
vendor_firmware_file
vendor_hostapd_exec
"
for e in $ENTRIES; do
    if ! grep -q "${e} (file (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
        echo "(allow init_30_0 ${e} (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    fi
done

unset ENTRIES
