# Flasher Overclock GPU 1.4GHz — MT6789

Flasher AnyKernel3 sederhana untuk menaikkan clock maksimum GPU MediaTek
**MT6789 (Helio G99)** dari **1.1 GHz → 1.4 GHz** dengan mem-patch
`vendor_dlkm` (driver GPU) dan DTB OPP di `vendor_boot`.

> **Kredit overclock:** [Sultan Hassan Nurdin](https://t.me/sultanhassannurdin)
> **Installer / repack:** [Raffxzr](https://github.com/Raffxzr)

---

## 🇮🇩 Indonesia

### Fitur
- GPU max clock **1.4 GHz** (stock 1.1 GHz).
- Patch module `mtk_gpufreq_mt6789.ko` di partisi `vendor_dlkm`.
- Patch OPP GPU di DTB `vendor_boot`.
- Opsi backup otomatis `boot` + `vendor_dlkm` sebelum flashing.
- Membuat zip restore di `/sdcard` untuk kembali ke stock.

### Perangkat yang didukung
`X6853` / `X678B` / `X6850` / `X6882` / `X6837` / `S666LN` / `X6880` / `X6881`
(Infinix / itel, MT6789).

### Syarat
- Bootloader unlocked.
- Recovery custom: **OrangeFox direkomendasikan**. **Jangan** pakai AOSP
  recovery atau custom ROM dengan `vendor_boot` sendiri — bisa bootloop.
- VBMeta harus sudah di-disable (mis. flash `vbmeta-disable-verification`),
  kalau tidak perangkat akan bootloop.
- Partisi `vendor_dlkm` harus **EROFS**. Script ini tidak mendukung ext4.

### Cara flash
1. Unduh zip dari halaman **Releases** (`OC 1.4GHz+.zip`).
2. Masuk ke OrangeFox Recovery.
3. Flash zip tersebut.
4. Jawab prompt dengan tombol volume:
   - **Install GPU driver?** → **Vol+ (Yes)**
   - **Are you using AOSP recovery / custom ROM vendor_boot?** → **Vol- (No)**
   - **Backup boot dan vendor_dlkm?** → **Vol+ (Yes)** *(sangat disarankan)*
5. Reboot system.

### Restore ke stock
Saat instalasi, script membuat file
`/sdcard/Restore-boot-vendordlkm-<build>-<tanggal>.zip`.
Flash file itu lewat recovery untuk mengembalikan `boot` dan `vendor_dlkm`
ke kondisi awal.

Jika backup tidak dibuat, restore dengan flash ulang firmware stock
(`boot` + `vendor_dlkm` + `vendor_boot`).

### Peringatan
Overclock meningkatkan panas, konsumsi baterai, dan risiko tidak stabil.
Driver GPU yang di-patch bisa menyebabkan **bootloop pada firmware lama**.
Gunakan dengan risiko sendiri.

---

## 🇬🇧 English

### Features
- GPU max clock **1.4 GHz** (stock 1.1 GHz).
- Patches the `mtk_gpufreq_mt6789.ko` module inside the `vendor_dlkm` partition.
- Patches the GPU OPP table in the `vendor_boot` DTB.
- Optional automatic `boot` + `vendor_dlkm` backup before flashing.
- Generates a restore zip on `/sdcard` to return to stock.

### Supported devices
`X6853` / `X678B` / `X6850` / `X6882` / `X6837` / `S666LN` / `X6880` / `X6881`
(Infinix / itel, MT6789).

### Requirements
- Unlocked bootloader.
- Custom recovery: **OrangeFox recommended**. **Do not** use AOSP recovery or
  a custom ROM with its own `vendor_boot` — it may bootloop.
- VBMeta must be disabled (e.g. flash `vbmeta-disable-verification`),
  otherwise the device will bootloop.
- The `vendor_dlkm` partition must be **EROFS**. This script does not support ext4.

### How to flash
1. Download the zip from the **Releases** page (`OC 1.4GHz+.zip`).
2. Boot into OrangeFox Recovery.
3. Flash the zip.
4. Answer the prompts with the volume keys:
   - **Install GPU driver?** → **Vol+ (Yes)**
   - **Are you using AOSP recovery / custom ROM vendor_boot?** → **Vol- (No)**
   - **Backup boot and vendor_dlkm?** → **Vol+ (Yes)** *(highly recommended)*
5. Reboot to system.

### Restore to stock
During installation the script creates
`/sdcard/Restore-boot-vendordlkm-<build>-<date>.zip`.
Flash that file in recovery to restore `boot` and `vendor_dlkm` to their
original state.

If no backup was made, restore by reflashing the stock firmware
(`boot` + `vendor_dlkm` + `vendor_boot`).

### Warning
Overclocking increases heat, battery drain, and instability. Patched GPU
drivers can cause a **bootloop on older firmware**. Use at your own risk.

---

## Credits
- AnyKernel3 by [osm0sis](https://github.com/osm0sis/AnyKernel3)
- GPU overclock by [Sultan Hassan Nurdin](https://t.me/sultanhassannurdin)
- Flasher packaging by [Raffxzr](https://github.com/Raffxzr)
