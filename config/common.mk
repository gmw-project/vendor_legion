PRODUCT_BRAND ?= LegionOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true

# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Clean cache
PRODUCT_COPY_FILES += \
    vendor/legion/prebuilt/common/bin/clean_cache.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/clean_cache.sh

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/legion/prebuilt/common/bin/backuptool.sh:$(TARGET_COPY_OUT_SYSTEM)/install/bin/backuptool.sh \
    vendor/legion/prebuilt/common/bin/backuptool.functions:$(TARGET_COPY_OUT_SYSTEM)/install/bin/backuptool.functions \
    vendor/legion/prebuilt/common/bin/50-legion.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-legion.sh

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/legion/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/legion/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/legion/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Mount system
PRODUCT_COPY_FILES += \
    vendor/legion/prebuilt/common/bin/system-mount.sh:install/bin/system-mount.sh

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/legion/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Flipendo
PRODUCT_COPY_FILES += \
    vendor/legion/config/permissions/pixel_experience_2020.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2020.xml

# Legion-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/legion/config/permissions/legion-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/legion-sysconfig.xml

# Copy all Legion-specific init rc files
$(foreach f,$(wildcard vendor/legion/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/legion/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/legion/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Include AOSP audio files
include vendor/legion/config/aosp_audio.mk

# Include Legion audio files
include vendor/legion/config/legion_audio.mk

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# AOSP packages
PRODUCT_PACKAGES += \
    Terminal

# GcamGoPrebuilt
PRODUCT_PACKAGES += \
    GCamGOPrebuilt

# Themes
PRODUCT_PACKAGES += \
    ThemePicker \
    OmniStyle \
    OmniJaws

# Updater
ifeq ($(LEGION_BUILD_TYPE), OFFICIAL)

PRODUCT_GENERIC_PROPERTIES += \
    ro.legion.ziptype=$(LEGION_BUILD_ZIP_TYPE) \
    sys.ota.disable_uncrypt=1

PRODUCT_PACKAGES += \
    Updater
endif

# StitchImage
PRODUCT_PACKAGES += \
    StitchImage \
    StitchImageService \

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet

# Extra tools in Legion
PRODUCT_PACKAGES += \
    7z \
    bash \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Offline charger
PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(TARGET_USES_AOSP_CHARGER),true)
PRODUCT_PACKAGES += \
    product_charger_res_images
endif

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Enable WiFi Display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.nohdcp=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

# Disable Java debug info
USE_DEX2OAT_DEBUG := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/legion/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/legion/overlay/common

#Uncatogerised
-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/legion/config/partner_gms.mk

# Versioning
-include vendor/legion/config/version.mk

# Include Potato volume panels
include packages/apps/Plugins/plugins.mk

# Bootanimation
-include vendor/legion/bootanimation/bootanimation.mk

# IORap app launch prefetching using Perfetto traces and madvise
PRODUCT_PRODUCT_PROPERTIES += \
    iorapd.perfetto.enable=true \
    iorapd.readahead.enable=true \
    ro.iorapd.enable=true

# Gapps/faceunlock
$(call inherit-product-if-exists, vendor/legion/config/faceunlock.mk)
ifeq ($(WITH_GAPPS), true)
-include vendor/google/gms/gms-vendor.mk
endif

# Disable blurs
PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.supports_background_blur=1 \
    persist.sys.sf.disable_blurs=1 \
    ro.sf.blurs_are_expensive=1

# Include Vendor Parts
-include vendor/LegionParts/parts.mk

# Inherit art options
include vendor/legion/config/art.mk
