#add by xulinchao@wind-mobi.com 2016.03.18 start
ifeq ($(strip $(WIND_DEF_ASUS_APKS)), yes)
ASUS_PREBUILT_DEBUG := false
LOCAL_PATH:= $(call my-dir)

$(info **** BEGIN asus-prebuilt ****)

### BEGIN: Pre-optimization of the definition ###
define local_odex_status
$(strip \
    $(eval app_odex_status := )
    $(eval $(if $(filter $(APP_ODEX_IS_TRUE),$(1)), \
        app_odex_status := true))
    $(eval $(if $(filter $(APP_ODEX_IS_FALSE),$(1)), \
        app_odex_status := false))
    $(app_odex_status)
    $(eval $(if $(filter true,$(ASUS_PREBUILT_DEBUG)), \
        $(info $(1) used odex is $(app_odex_status))))
)
endef
### END: Pre-optimization of the definition ###

### BEGIN: Get the suitable CPU-ABI ###
define check_cpu_abi_path
$(strip \
    $(eval $(if $(filter false,$(3)), \
        $(if $(wildcard $(1)/libs/$(2)), \
            check_path := $(2), \
            check_path := false), \
            check_path := $(3)))
    $(check_path)
)
endef

define cpu_abi_arm_to_x86
$(strip \
    $(eval arm_abi_path := $(call check_cpu_abi_path,$(1),armeabi-v7a,false))
    $(eval arm_abi_path := $(call check_cpu_abi_path,$(1),armeabi,$(arm_abi_path)))
    $(eval $(if $(filter false,$(arm_abi_path)), \
        $(error error - $(2) : Native-libs do not support armeabi/arrmeabi-v7a abi)))
    $(arm_abi_path)
)
endef

define local_cpu_abi
$(strip \
    $(eval abi_path := false)
    $(eval $(if $(filter none,$(3)), \
        abi_path := $(call cpu_abi_arm_to_x86,$(1),$(2))))
    $(eval $(if $(TARGET_CPU_ABI), \
        abi_path := $(call check_cpu_abi_path,$(1),$(TARGET_CPU_ABI),$(abi_path))))
    $(eval $(if $(TARGET_CPU_ABI2), \
        abi_path := $(call check_cpu_abi_path,$(1),$(TARGET_CPU_ABI2),$(abi_path))))
    $(eval $(if $(TARGET_2ND_CPU_ABI), \
        abi_path := $(call check_cpu_abi_path,$(1),$(TARGET_2ND_CPU_ABI),$(abi_path))))
    $(eval $(if $(TARGET_2ND_CPU_ABI2), \
        abi_path := $(call check_cpu_abi_path,$(1),$(TARGET_2ND_CPU_ABI2),$(abi_path))))
    $(eval $(if $(filter false,$(abi_path)), \
        $(error error - $(2) : Native-libs do not support CPU ABI for $(TARGET_PROJECT))))
    $(abi_path)
    $(eval $(if $(filter true,$(ASUS_PREBUILT_DEBUG)), \
        $(info $(2) used cpu abi is $(abi_path))))
)
endef
### END: Get the suitable CPU-ABI ###

ifeq ($(filter Missing Failed, $(MAKE_MESSAGE_LOGS)),)

### BEGIN: Include ASUS ODM MakeFiles ###
ifeq ($(filter None, $(ASUS_ODM_PROJECT_NAME)),)
$(info Project Name for Asus ODM - $(ASUS_ODM_PROJECT_NAME))
ifneq ($(ASUS_ODM_APP_TYPE),)

$(info -- Add product-packages --)
$(foreach var,$(ASUS_ODM_APP_TYPE), \
    $(eval $(info $(var) = $(PRODUCT_PACKAGES_$(var)))))

$(info -- Include Android.mk path for each ASUS ODM app --)
INCLUDE_ASUS_ODM_MAKEFILES :=
$(foreach var,$(ASUS_ODM_APP_TYPE), \
    $(eval $(if $(filter google,$(var)), \
        INCLUDE_ASUS_ODM_MAKEFILES += $(call all-makefiles-under,$(LOCAL_PATH)/$(ASUS_ODM_PROJECT_NAME)/$(var)/apps), \
        INCLUDE_ASUS_ODM_MAKEFILES += $(call all-makefiles-under,$(LOCAL_PATH)/$(ASUS_ODM_PROJECT_NAME)/$(var)))))
INCLUDE_ASUS_ODM_MAKEFILES += $(shell python vendor/asus-prebuilt/built_odm_makefiles.py --root-path vendor/asus-prebuilt --gms-path)
$(info Path List - $(INCLUDE_ASUS_ODM_MAKEFILES))
include $(INCLUDE_ASUS_ODM_MAKEFILES)

else
$(info The ASUS_ODM_APP_TYPE value - Not Exist)
endif
else
$(info Project Name for Asus ODM - Not Exist)
endif
### END: Include ASUS ODM Makefiles ###

else
$(info Asus prebuilt make files logs - $(MAKE_MESSAGE_LOGS))
endif

$(info **** END asus-prebuilt ****)
endif
#add by xulinchao@wind-mobi.com 2016.03.18 end
