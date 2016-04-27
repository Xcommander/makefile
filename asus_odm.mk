#
# Title: Include ASUS apps for ODM
#

# Default support folder type $(ASUS_ODM_APP_TYPE) in vendor/asus-prebuilt/$(ASUS_ODM_PROJECT_NAME)/
ASUS_ODM_APP_TYPE := amax-prebuilt 3rd_party google
MAKE_MESSAGE_LOGS :=

define generate_product_packages
$(strip \
    $(eval odm_product_packages := )
    $(eval $(if $(wildcard vendor/asus-prebuilt/$(1)/$(2)), \
                odm_product_packages := $(shell python vendor/asus-prebuilt/built_odm_makefiles.py --root-path vendor/asus-prebuilt --app-type $(2)), \
                MAKE_MESSAGE_LOGS += Path - vendor/asus_prebuilt/$(1)/$(2) do not exist;))
    $(odm_product_packages)
)
endef

ifneq ($(wildcard vendor/asus-prebuilt/built_odm_makefiles.py),)

ASUS_ODM_PROJECT_NAME := $(shell python vendor/asus-prebuilt/built_odm_makefiles.py --root-path vendor/asus-prebuilt --check-project)

ifeq ($(filter None, $(ASUS_ODM_PROJECT_NAME)),)
$(foreach var,$(ASUS_ODM_APP_TYPE), \
    $(eval PRODUCT_PACKAGES_$(var) := $(call generate_product_packages,$(ASUS_ODM_PROJECT_NAME),$(var))) \
    $(eval PRODUCT_PACKAGES += $(PRODUCT_PACKAGES_$(var))))
ASUS_ODM_CN_PROJECT := $(shell python vendor/asus-prebuilt/built_odm_makefiles.py --root-path vendor/asus-prebuilt --gms-sku --gms-list $(PRODUCT_PACKAGES_google))
$(call inherit-product-if-exists, vendor/asus-prebuilt/$(ASUS_ODM_PROJECT_NAME)/google/products/gms_odm.mk)
else
MAKE_MESSAGE_LOGS := Failed -- Do not support ASUS ODM project
endif

else
MAKE_MESSAGE_LOGS := Missing vendor/asus_prebuilt/built_odm_makefiles.py path
endif

