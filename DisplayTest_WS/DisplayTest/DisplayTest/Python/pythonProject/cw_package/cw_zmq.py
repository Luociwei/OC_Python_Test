#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time  : 2021/12/11 1:44 PM
# @Author: Ci-wei
# @File  : zmq_socket.py

import json
import cw_common as common

try:
    import zmq
except Exception as e:
    print('import zmq error:', e)


def is_contain_all_in_string(string, keyword_arr):
    result = True
    for keyword in keyword_arr:
        if keyword.lower() not in string.lower():
            result = False
            break
    return result


# import
class ZmqMsg:
    def __init__(self, msg_dict):
        self.name = ''
        self.event = ''
        self.params = []

        if len(msg_dict):
            # is_json_str = is_contain_all_in_string(msg, ['[', ']']) or is_contain_all_in_string(msg, ['{', '}'])
            # if not is_json_str:
            #     print ('is not a dict string')
            #     return
            # msg_dict = json.loads(msg)
            if msg_dict:
                self.name = msg_dict['name']
                self.event = msg_dict['event']
                self.params = msg_dict['params']


class ZmqClient(object):
    def __init__(self, url):
        try:
            context = zmq.Context()
            socket = context.socket(zmq.REP)
            socket.setsockopt(zmq.LINGER, 0)
            # "tcp://127.0.0.1:3100"
            self.url = url
            socket.bind(url)
            self.socket = socket
            print('zmq connect successful.url:{0}'.format(url))
        except Exception as err:
            print('zmq connect fail.url:{0}'.format(url))
            print(err)

    def send(self, cmd):

        if len(cmd) == 0:
            error_mes = 'Error:the cmd inputted is null!!!'
            print (error_mes)
            return False

        b_result = type(cmd) == type('') or type(cmd) == type([]) or type(cmd) == type({})
        if not b_result:
            print ('the cmd inputted must be string or list or dict!!!')
            return False

        send_cmd = cmd
        b_result = True
        try:
            if type(cmd) == type([]) or type(cmd) == type({}):
                send_cmd = json.dumps(cmd)
            # self.socket.send(send_cmd.encode('ascii'))
            if common.get_version() < 3:
                self.socket.send(send_cmd)
            else:
                self.socket.send(send_cmd.encode('ascii'))
        except Exception as error:
            print (error)
        else:
            b_result = False
        finally:
            return b_result

    def recv(self):
        ret = self.socket.recv()
        recv = ret
        if common.get_version() >= 3:
            recv = ret.decode('utf-8')

        is_json_str = is_contain_all_in_string(recv, ['[', ']']) or is_contain_all_in_string(recv, ['{', '}'])
        if is_json_str:  # is not a json string
            try:
                json_recv = json.loads(recv)
                if type(json_recv) == type([]) or type(json_recv) == type({}):
                    recv = json_recv
            except Exception as result:
                print(result)

        return recv


if __name__ == '__main__':
    b = common.get_version() < 3
    print (b)
    zmq_client = ZmqClient("tcp://127.0.0.1:3200")
    zmq_client.send('sss')
    result1 = zmq_client.recv()

    zmq_client.send('sss')
    result2 = zmq_client.recv()
    print ('sss')

