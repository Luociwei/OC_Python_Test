#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time  : 2021/12/15 4:18 PM
# @Author: Ci-wei
# @File  : cw_common.py
import os
import re
import platform
import time

def delete_last_path_component(path, level):

    split_arr = path.split(r'/')
    count = len(split_arr)
    file_path = ''
    for index in range(count-level):
        file_path = file_path + split_arr[index] + '/'
    return file_path

def get_desk_p():
    return os.path.join(os.path.expanduser('~'), 'Desktop')

def remove_file(file_path):
    if os.path.exists(file_path):
        os.remove(file_path)


def save_log(log_str, file_path):

    if type(log_str) != type(''):
        print('the log is not a string!!!!')
        return

    if len(log_str) == 0:
        return

    # if not os.path.exists(file_path):
    #     dir = delete_last_path_component(file_path, 1)
    #     os.mkdir(dir)
    f = open(file_path, 'a')
    try:
        f.write(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time())) + ' ' + log_str+'\n')
    except Exception as result:
        print (result)
    finally:

        f.close()

    # with open(file_path, 'w') as f:
    #     f.write(log_str)
        # f.write(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time())) + ' ' + log_str)


def regular(content, pattern):

    re_pattern = re.compile(pattern)
    results = re_pattern.findall(content)
    return results


def is_contain_all_in_string(string, keyword_arr):
    result = True
    for keyword in keyword_arr:
        if keyword.lower() not in string.lower():
            result = False
            break
    return result


def is_contain_in_string(string, keyword_arr):
    result = False
    for keyword in keyword_arr:
        if keyword.lower() in string.lower():
            result = True
            break
    return result


def filter_list(arr, keyword_arr):
    new_arr = []
    for path in arr:
        for keyword in keyword_arr:
            if keyword.lower() in path.lower():
                new_arr.append(path)
                break
    return new_arr


def get_file_path_list(dir_path, is_deep_find):
    file_arr = []
    for root, dirs, files in os.walk(dir_path):
        for file in files:
            if is_deep_find:
                file_arr.append(os.path.join(root, file))
            else:
                if root == dir_path:
                    file_arr.append(os.path.join(root, file))

    return file_arr


def get_version():
    version = platform.python_version()
    print("platform.python_version():", platform.python_version())
    split_arr = version.split(r'.')
    return int(split_arr[0])


if __name__ == '__main__':
    test_log_file = get_desk_p() + '/demo/test_log.txt'
    start_time = time.time()
    i = 0
    while 1:
        i= i + 1
        current_time = time.time()
        if current_time - start_time >=10 :
            break

        f= open(test_log_file,'a')

        f.write('\n'+str(i))

        f.close()
        # f.write(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time())) + ' ' + log_str)

    # test_log_file = '/tmp/demo/test_log.txt'
    # remove_file(test_log_file)
    # save_log('ssss', test_log_file)
    # new_path = delete_last_path_component(test_path, 2)
    # print(new_path)
