#############################
# App Name:AsusCamera
# Support ndk:None
#############################

LOCAL_PATH := $(my-dir)

############################
# app(AsusCamera.apk)
include $(CLEAR_VARS)

LOCAL_MODULE := AsusCamera
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(LOCAL_MODULE).apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED

# priv-app
LOCAL_PRIVILEGED_MODULE := true

# override package
LOCAL_OVERRIDES_PACKAGES := Camera2 Camera

# ODEX
LOCAL_DEX_PREOPT := $(call local_odex_status, $(LOCAL_MODULE))

# other modules(Ex:etc) from extension.mk
LOCAL_REQUIRED_MODULES := \
    libcamera_pano \
    libcameraap \
    libjpeggifcodec \
    libarcsoft_panorama_burstcapture \
    libarcsoft_beautyshot \
    bspcapability \
    bspcapability.xml 

include $(BUILD_PREBUILT)
############################

# include extension.mk
ifneq ($(wildcard $(LOCAL_PATH)/extension.mk), )
include $(LOCAL_PATH)/extension.mk
endif
