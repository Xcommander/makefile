##################################
# Support asus-prebuilt function #
# 1. generate_asus_prebuilt_list #
# 2. clear_asus_apps_output      #
##################################

function generate_asus_prebuilt_list()
{
    local ROOT=$(gettop)
    local execture_func="false"

    help_msg_for_generate_asus_prebuilt_list="
** Command line error **
Try 'generate_asus_prebuilt_list -h' for more information
************************
"
    help_msg_detail_for_generate_asus_prebuilt_list="
           #### generate_asus_prebuilt_list ####
*******************************************************************************
usage: generate_asus_prebuilt_list [-h] [--run-all]

optional arguments:
  -h                    show this help message and exit
  --run-all             Scan all ODM project and include app list
*******************************************************************************
"
    if [ $# -eq 0 ]; then
        echo "${help_msg_for_generate_asus_prebuilt_list}"
        local execture_func="false"
    fi

    while test $# -gt 0; do
        case "$1" in
            -h)
              echo "${help_msg_detail_for_generate_asus_prebuilt_list}"
              local execture_func="false"
              break
              ;;
            --run-all)
              local execture_func="true"
              break
              ;;
            *)
              echo "${help_msg_for_generate_asus_prebuilt_list}"
              local execture_func="false"
              break
              ;;
        esac
    done

    if [ "$execture_func" == "true" ]; then
        local current_path="$ROOT/vendor/asus-prebuilt"
        python $ROOT/vendor/asus-prebuilt/built_odm_makefiles.py --root-path $current_path --run-all
    fi
}

function clear_asus_apps_output()
{
    local ROOT=$(gettop)
    local execture_func="true"
    local current_all="false"

    help_msg_for_clear_asus_apps_output="
** Command line error **
Try 'clear_asus_apps_output -h' for more information
************************
"
    help_msg_detail_for_clear_asus_apps_output="
                #### clear_asus_apps_output ####
***************************************************************************
usage: clear_asus_apps_output [-h] [--clear-allapps] [--clear-app CLEAR_APP]

optional arguments:
  -h                      show this help message and exit
  --clear-allapps         Clear all apps for asus-prebuilt
  --clear-app CLEAR_APP   Clear the specific app for asus-prebuilt
                          Example: --clear-app ASUSBrowser
***************************************************************************
"

    if [ $# -eq 0 ]; then
        echo "${help_msg_for_clear_asus_apps_output}"
        local execture_func="false"
    fi

    while test $# -gt 0; do
        case "$1" in
            -h)
              echo "${help_msg_detail_for_clear_asus_apps_output}"
              local execture_func="false"
              break
              ;;
            --clear-allapps)
              local current_all="true"
              break
              ;;
            --clear-app)
              local current_app=$2
              break
              ;;
            *)
              echo "${help_msg_for_clear_asus_apps_output}"
              local execture_func="false"
              break
              ;;
        esac
    done

    if [ "$execture_func" == "true" ]; then
        local current_root=$ROOT
        local current_device=$(get_build_var TARGET_DEVICE)

        if [ -z $current_app ]; then
            if [ "$current_all" == "true" ]; then
                python $ROOT/vendor/asus-prebuilt/built_odm_makefiles.py --root-path $current_root --product-device $current_device --clear-allapps
            fi
        else
            python $ROOT/vendor/asus-prebuilt/built_odm_makefiles.py --root-path $current_root --product-device $current_device --clear-app $current_app
        fi
    fi

    unset current_app

}

# Print help for asus-prebuilt tools
function asus_prebuilt_tools()
{
help_msg_for_asus_prebuilt="------
asus-prebuilt tool list:
- generate_asus_prebuilt_list
- clear_asus_apps_output
Try '-h' for more information
------"

echo "${help_msg_for_asus_prebuilt}"
}
