LOCAL_PATH := $(call my-dir)

###############################################################################
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libcameraap
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_TAGS := optional

ifeq ($(TARGET_ARCH),arm64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/arm/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else ifeq ($(TARGET_ARCH),x86_64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/x86/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := libso/$(TARGET_ARCH)/$(LOCAL_MODULE).so
endif

include $(BUILD_PREBUILT)
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libarcsoft_panorama_burstcapture
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_TAGS := optional

ifeq ($(TARGET_ARCH),arm64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/arm/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else ifeq ($(TARGET_ARCH),x86_64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/x86/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := libso/$(TARGET_ARCH)/$(LOCAL_MODULE).so
endif

include $(BUILD_PREBUILT)
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libcamera_pano
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_TAGS := optional

ifeq ($(TARGET_ARCH),arm64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/arm/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else ifeq ($(TARGET_ARCH),x86_64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/x86/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := libso/$(TARGET_ARCH)/$(LOCAL_MODULE).so
endif

include $(BUILD_PREBUILT)
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libjpeggifcodec
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_TAGS := optional

ifeq ($(TARGET_ARCH),arm64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/arm/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else ifeq ($(TARGET_ARCH),x86_64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/x86/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := libso/$(TARGET_ARCH)/$(LOCAL_MODULE).so
endif

include $(BUILD_PREBUILT)
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libarcsoft_beautyshot
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_TAGS := optional

ifneq ($(filter $(TARGET_PROJECT), Z380M),)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := beautyshot/arm/3.1.0.1239/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else ifeq ($(TARGET_ARCH),arm64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/arm/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else ifeq ($(TARGET_ARCH),x86_64)
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib
LOCAL_SRC_FILES := libso/x86/$(LOCAL_MODULE).so
LOCAL_32_BIT_ONLY := true
else
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_SRC_FILES := libso/$(TARGET_ARCH)/$(LOCAL_MODULE).so
endif

include $(BUILD_PREBUILT)
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := bspcapability
LOCAL_MODULE_PATH := $(TARGET_OUT_JAVA_LIBRARIES)
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_TAGS := optional

ifneq ($(filter $(TARGET_PROJECT), FE375CL),)
LOCAL_SRC_FILES := bspcapability/1_1/$(LOCAL_MODULE).jar
else ifneq ($(filter $(TARGET_PROJECT), PF500KL),)
LOCAL_SRC_FILES := bspcapability/1_1_1/$(LOCAL_MODULE).jar
else ifneq ($(filter $(TARGET_PROJECT), ZE550ML ZE551ML),)
LOCAL_SRC_FILES := bspcapability/1_5_2/$(LOCAL_MODULE).jar
else ifneq ($(filter $(TARGET_PROJECT), ZE500KL ZE500KG ZE550KL ZE550KG ZE551KL ZD551KL ZE600KL ZE601KL ZC550KL ZB551KL ZE500KL_32 ZE550KL_32),)
LOCAL_SRC_FILES := bspcapability/1_5_3/$(LOCAL_MODULE).jar
else ifneq ($(filter $(TARGET_PROJECT), ZX550ML ZX551ML),)
LOCAL_SRC_FILES := bspcapability/1_5_5/$(LOCAL_MODULE).jar
else
LOCAL_SRC_FILES := bspcapability/1_5/$(LOCAL_MODULE).jar
endif

ifneq ($(filter $(TARGET_ARCH), x86_64 arm64),)
LOCAL_32_BIT_ONLY := true
endif
include $(BUILD_PREBUILT)
###############################################################################
include $(CLEAR_VARS)
LOCAL_MODULE := bspcapability.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
# Copies bspcapability.xml to /system/etc/
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)
LOCAL_SRC_FILES := bspcapability.xml
ifneq ($(filter $(TARGET_ARCH), x86_64 arm64),)
LOCAL_32_BIT_ONLY := true
endif
include $(BUILD_PREBUILT)
###############################################################################
# config file
$(shell mkdir -p $(TARGET_OUT)/vendor/etc)
$(shell cp -a $(LOCAL_PATH)/config/style.cng $(TARGET_OUT)/vendor/etc)
###############################################################################
# libmpbase so lib for Z380KL, PF500KL, Z370KL, ZB551KL
# lifeifei@wind-mobi.com 20160415 add full_E280L
#ifneq ($(filter $(TARGET_PROJECT), Z380KL PF500KL Z370KL ZB551KL),)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/arm/libmpbase.so $(TARGET_OUT)/lib)
#endif
###############################################################################
# libasuscameraext_jni so lib for ZX550ML, different so for different SDK

ifneq ($(and $(filter $(TARGET_PROJECT), ZX550ML),$(filter $(PLATFORM_SDK_VERSION), 23)),)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/x86/asuscameraextension_M/libasuscameraext_jni.so $(TARGET_OUT)/lib)
else ifneq ($(and $(filter $(TARGET_PROJECT), ZX550ML),$(filter $(PLATFORM_SDK_VERSION), 22 21)),)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/x86/asuscameraextension_L/libasuscameraext_jni.so $(TARGET_OUT)/lib)
endif
###############################################################################
# for ZE500KL_32 ZE550KL_32 de-feature libmorpho_panorama_gp

ifneq ($(filter $(TARGET_PROJECT), ZE500KL_32 ZE550KL_32),)
# do nothing
else ifeq ($(TARGET_ARCH),arm64)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/arm/libmorpho_panorama_gp.so $(TARGET_OUT)/lib)
else ifeq ($(TARGET_ARCH),x86_64)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/x86/libmorpho_panorama_gp.so $(TARGET_OUT)/lib)
else
$(shell mkdir -p $(TARGET_OUT_SHARED_LIBRARIES))
$(shell cp -a $(LOCAL_PATH)/libso/$(TARGET_ARCH)/libmorpho_panorama_gp.so $(TARGET_OUT_SHARED_LIBRARIES))

endif
###############################################################################
# for ZE500KL_32 ZE550KL_32 de-feature libsphere3

ifneq ($(filter $(TARGET_PROJECT), ZE500KL_32 ZE550KL_32),)
# do nothing
else ifeq ($(TARGET_ARCH),arm64)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/arm/libsphere3.so $(TARGET_OUT)/lib)
else ifeq ($(TARGET_ARCH),x86_64)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/x86/libsphere3.so $(TARGET_OUT)/lib)
else
$(shell mkdir -p $(TARGET_OUT_SHARED_LIBRARIES))
$(shell cp -a $(LOCAL_PATH)/libso/$(TARGET_ARCH)/libsphere3.so $(TARGET_OUT_SHARED_LIBRARIES))

endif
###############################################################################
# for ZE500KL_32 ZE550KL_32 de-feature libcamera_defocus

ifneq ($(filter $(TARGET_PROJECT), ZE500KL_32 ZE550KL_32),)
# do nothing
else ifeq ($(TARGET_ARCH),arm64)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/arm/libcamera_defocus.so $(TARGET_OUT)/lib)
else ifeq ($(TARGET_ARCH),x86_64)
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -a $(LOCAL_PATH)/libso/x86/libcamera_defocus.so $(TARGET_OUT)/lib)
else
$(shell mkdir -p $(TARGET_OUT_SHARED_LIBRARIES))
$(shell cp -a $(LOCAL_PATH)/libso/$(TARGET_ARCH)/libcamera_defocus.so $(TARGET_OUT_SHARED_LIBRARIES))

endif
###############################################################################
