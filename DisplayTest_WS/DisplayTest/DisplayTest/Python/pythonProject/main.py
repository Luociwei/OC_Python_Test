# This is a sample Python script.
import json
import os
import time

from cw_package import cw_redis
from cw_package import cw_zmq
from cw_package import cw_common as common
from atlaslog_package import atlas_log

is_debug = 0
if is_debug:
    test_str = {
        'name': 'ScriptListVC',
        'event': 'ScriptClick',
        'params': ["/Users/ciweiluo/Desktop/profile/Project_C/ProjectC_Script_2.json"]
    }

redis_client = cw_redis.RedisClient()

zmqClient = cw_zmq.ZmqClient("tcp://127.0.0.1:3100")

test_log_file = common.get_desk_p() + '/demo/test_log.txt'


# def savelog(log_content):
#     common.save_log(test_log_file, log_content)

# can't write the log to file in run() function.
def run():
    while True:
        redis_client.flushdb()
        time.sleep(0.1)
        try:
            print("wait for zmq client ...")

            if is_debug:
                zmq_recv_msg = test_str
            else:
                zmq_recv_msg = zmqClient.recv()

            # savelog("wait for zmq client ...")
            print('zmq_recv_msg:{0}', zmq_recv_msg)
            
            msg_name = zmq_recv_msg['name']
            msg_event = zmq_recv_msg['event']
            msg_path_arr = zmq_recv_msg['params']

            if len(msg_path_arr):
                msg_path = msg_path_arr[0]

            else:
                zmqClient.send_warning('Not found the file path,pls check.')
                continue

            zmq_send_msg = ''
            if msg_name == 'ScriptListVC':
                if msg_event == 'ScriptClick':
                    print("ScriptClick msg_mode_path:", msg_path)
                    print("msg_path type:", type(msg_path))

                    if len(msg_path) == 0 or not os.path.exists(msg_path):

                        zmqClient.send_warning('Not found the file path,pls check.')
                        continue
                    loop_count = 5
                    for index in range(loop_count):

                        redis_client.set_loading_data('test...', str((index+1)*1.0/loop_count))
                        if index == loop_count-1:
                            time.sleep(0.3)
                        else:
                            time.sleep(0.6)
                        print ('index..', index)

                    zmq_send_msg = msg_path

                else:
                    pass

            elif msg_name == 'Others':
                pass
            else:
                pass

            zmqClient.send(zmq_send_msg)
            if is_debug:
                break

        except Exception as error:
            print('error:', error)
            continue


if __name__ == '__main__':
    # common.remove_file(test_log_file)

    run()
    # # zmq_client = ZmqClient("tcp://127.0.0.1:3200")
    # zmqClient.send('sss')
    # result1 = zmqClient.recv()
    #
    # zmqClient.send('sss')
    # result2 = zmqClient.recv()

    # print ('sss')