### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# Global properties
properties() { '
kernel.string=OVERCLOCK GPU 1.4GHz. By Raffxzr
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=X6853
device.name2=Infinix-X6853
device.name3=X678B
device.name4=Infinix-X678B
device.name5=
device.name6=garnet
device.name7=X6850
device.name8=Infinix-X6850
device.name9=X6882
device.name10=Infinix-X6882
device.name11=X6837
device.name12=Infinix-X6837
device.name13=S666LN
device.name14=itel-S666LN
device.name15=X6880
device.name16=Infinix-X6880
device.name17=X6881
device.name18=Infinix-X6881
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install

## Boot shell variables
block=boot
is_slot_device=1
ramdisk_compression=auto
patch_vbmeta_flag=auto

# Import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

##split_boot # disabled: vendor_dlkm/dtb only

########## FLASH VENDOR_DLKM START ##########

KEYCODE_UP=42
KEYCODE_DOWN=41

# Functions
extract_erofs() {
    local img_file=$1
    local out_dir=$2
    "${bin}"/extract.erofs -i "$img_file" -x -T8 -o "$out_dir" &> /dev/null
    return $?
}

mkfs_erofs() {
    local work_dir=$1
    local out_file=$2
    local partition_name=$(basename "$work_dir")

    "${bin}"/mkfs.erofs \
        --mount-point /"${partition_name}" \
        --fs-config-file "${work_dir}"/../config/"${partition_name}"_fs_config \
        --file-contexts  "${work_dir}"/../config/"${partition_name}"_file_contexts \
        "$out_file" "$work_dir"
}

is_mounted() { mount | grep -q " $1 "; }

sha1() { "${bin}"/magiskboot sha1 "$1"; }

get_keycheck_result() {
    # Default behavior:
    # - press Vol+: return true (0)
    # - press Vol-: return false (1)
    # The first execution responds to the button press event,
    # the second execution responds to the button release event.

    "${bin}"/keycheck; "${bin}"/keycheck
    local r_keycode=$?
    case $r_keycode in
        "$KEYCODE_UP") return 0;;
        "$KEYCODE_DOWN") return 1;;
        *) abort "! Unknown keycode: $r_keycode"
    esac
}

keycode_select() {
    local prompt_text=$1
    local r_keycode

    ui_print "# $prompt_text"
    ui_print "# Vol+ = Yes, Vol- = No."
    ui_print "# Please press the key..."
    get_keycheck_result
    r_keycode=$?
    ui_print "#"
    ui_print "- You chose $(if [ "$r_keycode" -eq "0" ]; then echo "Yes"; else echo "No"; fi)."
    ui_print " "
    return $r_keycode
}




ui_print " "
if [ -f /vendor_dlkm/lib/modules/vertmp ]; then
    ui_print "- GPU driver is already installed, no need to patch /vendor_dlkm partition."
else
keycode_select "Patched GPU drivers can cause bootloops in old firmware, if you encounter such issues, revert to stock and do not use patched gpu drivers. Install GPU driver?" && {
 
 
 
    # Check vendor_dlkm partition status
  #  [ -d /vendor_dlkm ] || mkdir /vendor_dlkm
   # is_mounted /vendor_dlkm || \
      #  mount /vendor_dlkm -o ro || mount /dev/block/mapper/vendor_dlkm"${slot}" /vendor_dlkm -o ro || \
          #  abort "! Failed to mount /vendor_dlkm"

  #  umount /vendor_dlkm

    # Fix unable to mount image as read-write in recovery
  #  $BOOTMODE || setenforce 0
ui_print "- PLEASE SELECT THIS OR YOU DEVICE WILL BOOTLOOP..."
ui_print ""
ui_print ""
sleep 2

keycode_select "!!!!!!!!!!!!!!! ARE YOU USING AOSP RECOVERY / CUSTOM ROM VENDOR_BOOT ?????????????????????????????????????" && {

abort " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!HEY HEY HEY YOU CANNOT FLASH IF YOU ARE USING AOSP RECOVERY, PLEASE CHANGE TO ORANGEFOX IF YOU DONT WANT YOUR DEVICE BOOTLOOP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}


    # Dump vendor_dlkm partition image
    dd if=/dev/block/mapper/vendor_dlkm"${slot}" of="${home}"/vendor_dlkm.img
    keycode_select "Backup the current boot and vendor_dlkm?" && {
        # Backup kernel and vendor_dlkm image
        ui_print "- Backing up boot and vendor_dlkm partition..."

        build_prop=/system/build.prop
        [ -d /system_root/system ] && build_prop=/system_root/$build_prop
        backup_package=/sdcard/Restore-boot-vendordlkm-$(file_getprop $build_prop ro.build.version.incremental)-$(date +"%Y%m%d-%H%M%S").zip

        "${bin}"/7za a -tzip -bd "$backup_package" \
            "${home}"/META-INF "${bin}" "${home}"/LICENSE "${home}"/_restore_anykernel.sh \
            "${home}"/boot.img "${home}"/vendor_dlkm.img 
        # "${bin}"/7za rn -bd "$backup_package" kernel Image
        "${bin}"/7za rn -bd "$backup_package" _restore_anykernel.sh anykernel.sh
        sync

        ui_print " "
        ui_print "- The current boot and vendor_dlkm have been backed up to:"
        ui_print "  $backup_package"
        ui_print "- If you encounter an unexpected situation,"
        ui_print "  or want to restore the stock boot and vendor_dlkm,"
        ui_print "  please flash it in TWRP or some supported apps."
        ui_print " "
        touch "${home}"/do_backup_flag
        unset build_prop backup_package
    }

    ui_print "- Unpacking /vendor_dlkm partition..."
    extract_vendor_dlkm_dir=${home}/_extract_vendor_dlkm
    mkdir -p "$extract_vendor_dlkm_dir"
    sync

    vendor_dlkm_is_ext4=0
    vendor_dlkm_is_erofs=0

    ui_print "- Checking /vendor_dlkm filesystem..."

    if mount "${home}"/vendor_dlkm.img "$extract_vendor_dlkm_dir" -o ro -t ext4; then
        vendor_dlkm_is_ext4=1
        ui_print "- /vendor_dlkm partition is ext4."
 
 
      abort "! ABORT ! ABORT ! ABORT ! ABORT ! NOT SUPPORTING VENDOR_DLKM EXT4 CONTACT DEVELOPER ! ABORT ! ABORT ! ABORT ! ABORT !"
      
        vendor_dlkm_free_space=$(df -k | grep -E "[[:space:]]$extract_vendor_dlkm_dir\$" | awk '{print $4}')
        ui_print "- /vendor_dlkm partition free space: $vendor_dlkm_free_space"
        umount "$extract_vendor_dlkm_dir"

        [ "$vendor_dlkm_free_space" -gt 10240 ] || {
            ui_print "- /vendor_dlkm partition does not have enough free space!"
            ui_print "- Trying to resize..."

            "${bin}"/e2fsck -f -y "${home}"/vendor_dlkm.img
            vendor_dlkm_current_size_mb=$(du -bm "${home}"/vendor_dlkm.img | awk '{print $1}')
            vendor_dlkm_target_size_mb=$((vendor_dlkm_current_size_mb + 10))
            "${bin}"/resize2fs "${home}"/vendor_dlkm.img "${vendor_dlkm_target_size_mb}M" ||                 abort "! Failed to resize vendor_dlkm image!"
            ui_print "- Resized vendor_dlkm.img size: ${vendor_dlkm_target_size_mb}M."
            "${bin}"/e2fsck -f -y "${home}"/vendor_dlkm.img

            unset vendor_dlkm_current_size_mb vendor_dlkm_target_size_mb
        }

        ui_print "- Trying to mount vendor_dlkm image as read-write..."
        mount "${home}"/vendor_dlkm.img "$extract_vendor_dlkm_dir" -o rw -t ext4 ||             abort "! Failed to mount vendor_dlkm.img as read-write!"

        extract_vendor_dlkm_modules_dir=${extract_vendor_dlkm_dir}/lib/modules

        ui_print "- Updating /vendor_dlkm image..."
        cp "${home}"/_vendor_dlkm_modules/* "${extract_vendor_dlkm_modules_dir}"/
        sync

        set_perm 0 0 0644 "${extract_vendor_dlkm_modules_dir}"/*
        chcon u:object_r:vendor_file:s0 "${extract_vendor_dlkm_modules_dir}"/* 2>/dev/null || true
        umount "$extract_vendor_dlkm_dir"

    else
        ui_print "- /vendor_dlkm partition is not ext4, trying EROFS..."

        rm -rf "$extract_vendor_dlkm_dir"
        mkdir -p "$extract_vendor_dlkm_dir"

        extract_erofs "${home}"/vendor_dlkm.img "$extract_vendor_dlkm_dir"



        vendor_dlkm_is_erofs=1
        extract_vendor_dlkm_modules_dir=${extract_vendor_dlkm_dir}/vendor_dlkm/lib/modules
        
        [ -d "$extract_vendor_dlkm_modules_dir" ] ||             abort "! Cannot find /vendor_dlkm/lib/modules after EROFS extract!"

        ui_print "- Updating extracted /vendor_dlkm tree..."
        cp "${home}"/_vendor_dlkm_modules/* ${extract_vendor_dlkm_dir}/vendor_dlkm/lib/modules
        ls
        cp "${home}"/vertmp "${extract_vendor_dlkm_modules_dir}"/vertmp
        sync

        set_perm 0 0 0644 "${extract_vendor_dlkm_modules_dir}"/*
        chcon u:object_r:vendor_file:s0 "${extract_vendor_dlkm_modules_dir}"/* 2>/dev/null || true

        ui_print "- Repacking /vendor_dlkm as EROFS..."
        rm -f "${home}"/vendor_dlkm_new.img
        mkfs_erofs "${extract_vendor_dlkm_dir}/vendor_dlkm" "${home}"/vendor_dlkm_new.img ||             abort "! Failed to repack vendor_dlkm EROFS image!"

        mv -f "${home}"/vendor_dlkm_new.img "${home}"/vendor_dlkm.img
        sync
    fi

unset vendor_dlkm_is_ext4 vendor_dlkm_free_space extract_vendor_dlkm_dir extract_vendor_dlkm_modules_dir

unset do_backup_flag
}
fi

flash_generic vendor_dlkm

########## FLASH VENDOR_DLKM END ##########
########## FLASH VENDOR_BOOT DTB START ##########

ui_print "- Patching vendor_boot dtb..."

dd if=/dev/block/by-name/vendor_boot"${slot}" of="${home}"/vendor_boot.img || abort "! dump vendor_boot failed"

cd "${home}" || abort "! cd home failed"

rm -rf "${home}"/vendor_boot_work
mkdir -p "${home}"/vendor_boot_work
cp -f "${home}"/vendor_boot.img "${home}"/vendor_boot_work/vendor_boot.img

cd "${home}"/vendor_boot_work || abort "! cd vendor_boot_work failed"

"${bin}"/magiskboot unpack vendor_boot.img || abort "! unpack vendor_boot failed"

[ -f dtb ] || abort "! vendor_boot dtb not found after unpack"

ui_print "- Searching FDT magic..."

FDT_OFF=0

# cek magic awal
MAGIC=$(dd if=dtb bs=4 count=1 2>/dev/null | xxd -p)

if [ "$MAGIC" = "d00dfeed" ]; then
    FDT_OFF=0
else
    MAGIC64=$(dd if=dtb bs=1 skip=64 count=4 2>/dev/null | xxd -p)

    if [ "$MAGIC64" = "d00dfeed" ]; then
        FDT_OFF=64
    else
        abort "! FDT magic not found"
    fi
fi

ui_print "- FDT offset: $FDT_OFF"



ui_print "- FDT offset: $FDT_OFF"

if [ "$FDT_OFF" -gt 0 ]; then
    ui_print "- Vendor DTB header detected, stripping header..."
    dd if=dtb of=dtb_raw.dtb bs=1 skip="$FDT_OFF" 2>/dev/null || abort "! strip dtb header failed"
else
    cp -f dtb dtb_raw.dtb || abort "! copy dtb failed"
fi

ui_print "- Decompiling DTB..."

"${bin}"/dtc -I dtb -O dts -o dtb.dts dtb_raw.dtb || abort "! dtc decompile failed"

ui_print "- Patching GPU OPP..."

sed -i 's/opp-hz *= *<0x0 *0x4190ab00 *>;/opp-hz = <0x0 0x53724e00>;/' dtb.dts
sed -i 's/opp-microvolt *= *<0xdbba0 *>;/opp-microvolt = <0xdbba0>;/' dtb.dts

ui_print "- Recompiling DTB..."

"${bin}"/dtc -I dts -O dtb -o dtb dtb.dts || abort "! dtc compile failed"

ui_print "- Repacking vendor_boot..."

"${bin}"/magiskboot repack vendor_boot.img || abort "! repack vendor_boot failed"

[ -f new-boot.img ] || abort "! new-boot.img not found"

ui_print "- Flashing vendor_boot..."

dd if=new-boot.img of=/dev/block/by-name/vendor_boot"${slot}" || abort "! flash vendor_boot failed"

cd "${home}"
sync

ui_print "PATCHED.... MAKE SURE YOUR VBMETA HAS BEEN DISABLED OR YOU DEVICE WILL BOOTLOOP"

########## FLASH VENDOR_BOOT DTB END ##########

#flash_boot # disabled: no boot/Image flashing

## End boot install

