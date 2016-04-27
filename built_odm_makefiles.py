"""
--------------------------------------------------------------------
Title:
Build asus-prebuilt make files for ODM design
--------------------------------------------------------------------

1. Build Android Image(Main)

2. Demo Adding Product Packages List(After source)

3. Clear Output Folders for Asus ODM Apps(After source)

@author: george_liao@asus.com
"""

import os
import re
import sys
import time
import subprocess
import argparse

default_app_tpye = ['amax-prebuilt', '3rd_party', 'google']

def find_element_in_list(element, list_element):
    try:
        index_element = list_element.index(element)
        return index_element
    except ValueError:
        return -1

def shell(cmd, env=None):
    if sys.platform.startswith('linux'):
        p = subprocess.Popen(['/bin/bash', '-c', cmd], env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    else:
        p = subprocess.Popen(cmd, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    return p.returncode, stdout, stderr

def scan_check_project(root_path):
    default_filter_out = ['.git', '.gitignore', 'asus_odm.mk', 'Android.mk', 'vendorsetup.sh']
    for each_root_dir in os.listdir(root_path):
        if find_element_in_list(each_root_dir, default_filter_out) < 0 and os.path.isdir(root_path + '/' + each_root_dir):
            for each_app_type_dir in os.listdir(root_path + '/' + each_root_dir):
                if find_element_in_list(each_app_type_dir, default_app_tpye) > -1 and os.path.isdir(root_path + '/' + each_root_dir + '/' + each_app_type_dir):
                    if each_app_type_dir == 'google' and os.path.isdir(root_path + '/' + each_root_dir + '/' + each_app_type_dir + '/apps'):
                        each_app_type_dir = 'google/apps'
                    for each_app_dir in os.listdir(root_path + '/' + each_root_dir + '/' + each_app_type_dir):
                        if os.path.exists(root_path + '/' + each_root_dir + '/' + each_app_type_dir + '/' + each_app_dir + '/Android.mk'):
                            return each_root_dir
    return None

def scan_check_app_list(app_type_path):
    app_module_list = []
    app_module_list_err = []
    for each_app_list in os.listdir(app_type_path):
        if os.path.exists(app_type_path + '/' + each_app_list + '/Android.mk'):
            is_local_module = False
            ret_code, stdout, stderr = shell('find ' + app_type_path + '/' + each_app_list + ' -name "*.mk"')
            if ret_code != 0:
                    print stderr
                    sys.exit(1)

            for makefile_path in stdout.split('\n'):
                if os.path.exists(makefile_path):
                    makefile_file = open(makefile_path, 'r').read()
                    for line in makefile_file.split('\n'):
                        if line.split(':=')[0].strip() == 'LOCAL_MODULE':
                            local_module = re.sub(r'\s+', '', line.split(':=')[1].strip())
                            if local_module == each_app_list or each_app_list.startswith(local_module + '-'):
                                is_local_module = True
                                main_local_module = local_module
            if is_local_module:
                app_module_list.append(main_local_module)
            else:
                app_module_list_err.append(each_app_list)
    return app_module_list, app_module_list_err

def scan_customize_for_gms(gms_path, project):
    gms_path_list = []

    if os.path.exists(gms_path + '/Android.mk'):
        gms_path_list.append('vendor/asus-prebuilt/' + project + '/google/Android.mk')

    for dir in os.listdir(gms_path):
        if os.path.isdir(gms_path + '/' + dir) and dir != 'apps':
            ret_code, stdout, stderr = shell('find ' + gms_path + '/' + dir + ' -name "Android.mk"')
            if ret_code != 0:
                print stderr
                sys.exit(1)

            for each_path in stdout.split('\n'):
                if os.path.exists(each_path):
                        gms_path_list.append('vendor/asus-prebuilt/' + project + '/google/' + each_path.replace(gms_path + '/',''))

    return gms_path_list

def remove_files(app_path):
    ret_code, stdout, stderr = shell('rm -rf ' + app_path)
    if ret_code != 0:
        print stderr

def clear_app(root_path, product_device, app_name):
    clear_dir= ['/obj/APPS','/system']
    is_exist_app = False

    for i in xrange(len(clear_dir)):
        if i == 0:
            ret_code, stdout, stderr = shell('find ' + root_path + '/out/target/product/' + product_device + clear_dir[i] + ' -name "*'+ app_name +'*_intermediates"')
        else:
            ret_code, stdout, stderr = shell('find ' + root_path + '/out/target/product/' + product_device + clear_dir[i] + ' -name "*'+ app_name +'*"')

        if ret_code != 0:
            print stderr

        for app_path in stdout.split('\n'):
            if os.path.exists(app_path):
                is_exist_app = True
                remove_files(app_path)
    if is_exist_app:
        print 'Clear -',app_name

def clear_all_apps(local_build_path, root_path, product_device):
    odm_project_name = scan_check_project(local_build_path)
    if odm_project_name == None:
        print 'Not project for Asus ODM'
    else:
        for app_type in default_app_tpye:
            if app_type == 'google':
                app_type = 'google/apps'
            if os.path.exists(local_build_path+ '/' +odm_project_name + '/' + app_type):
                print '-- Clear', app_type , '---'
                app_module_list, app_module_list_err = scan_check_app_list(local_build_path+ '/' + odm_project_name + '/' + app_type)
                for app_name in app_module_list:
                    clear_app(root_path, product_device, app_name)

def run_all_asus_odm(root_path):
    odm_project_name = scan_check_project(root_path)
    if odm_project_name == None:
        print 'Not project for Asus ODM'
    else:
        print '## Project:', odm_project_name, '##'
        for app_type in default_app_tpye:
            if app_type == 'google':
                app_type_path = 'google/apps'
            else:
                app_type_path = app_type

            if os.path.exists(root_path+ '/' + odm_project_name + '/' + app_type_path):
                app_module_list, app_module_list_err = scan_check_app_list(root_path+ '/' + odm_project_name + '/' + app_type_path)
                print '-- App Type:', app_type , '--'
                for app_module in app_module_list:
                    print app_module
                if len(app_module_list_err) > 0:
                    print '** Makefile Error **'
                    for app_module in app_module_list_err:
                        print app_module
                    print '********************'

def main(args):
    root_path = args.root_path
    if os.path.exists(root_path):
        if args.check_project:
            odm_project_name = scan_check_project(root_path)
            print odm_project_name

        if not args.app_type is None:
            app_type = args.app_type
            if app_type == 'google':
                app_type = 'google/apps'
            app_module_list, app_module_list_err = scan_check_app_list(root_path + '/' + scan_check_project(root_path) + '/' + app_type)
            for app_module in app_module_list:
                print app_module

        if args.gms_path:
            gms_path_list = scan_customize_for_gms(root_path + '/' + scan_check_project(root_path) + '/google', scan_check_project(root_path))
            for each_gms_path in gms_path_list:
                print each_gms_path

        if args.gms_sku:
            if len(args.gms_list) < 10:
                print 'CN'
            else:
                print 'OPEN'

        if args.run_all:
            run_all_asus_odm(root_path)

        if args.clear_allapps:
            if args.product_device:
                clear_all_apps(root_path + '/vendor/asus-prebuilt', root_path, args.product_device)

        if args.clear_app:
            if args.product_device:
                clear_app(root_path, args.product_device, args.clear_app)

if __name__ == '__main__':
    arg_parse = argparse.ArgumentParser(prog='built_odm_makefiles.py',
                                        description='Build asus-prebuilt make files for ODM design')
    arg_parse.add_argument('--root-path',
                           help='Define root path for the current branch of this project',
                           required=True)
    arg_parse.add_argument('--check-project', action='store_true',
                           help='Check include ODM project in vendor/asus-prebuilt/')
    arg_parse.add_argument('--app-type',
                           help='Scan app list for adding product_packages')
    arg_parse.add_argument('--gms-path', action='store_true',
                           help='Scan all Android.mk path in google/ folder except google/apps/ folder')
    arg_parse.add_argument('--gms-sku', action='store_true',
                           help='Check gms sku, CN or OPEN')
    arg_parse.add_argument('--gms-list', nargs='*',
                           help='Current gms app list for ODM project')
    arg_parse.add_argument('--run-all', action='store_true',
                           help='Scan all ODM project and include app list')
    arg_parse.add_argument('--clear-allapps', action='store_true',
                           help='Clear all apps for asus-prebuilt')
    arg_parse.add_argument('--clear-app',
                        help='Clear the specific app for asus-prebuilt, Example: --clear-app ASUSBrowser')
    arg_parse.add_argument('--product-device',
                           help='Define PRODUCT_DEVICE in building system image')
    args = arg_parse.parse_args()

    main(args)