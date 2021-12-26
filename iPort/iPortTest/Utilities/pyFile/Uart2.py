# coding= utf-8

import time
import serial
import re
import json
import os
import sys
from EZUart import *


if __name__ == '__main__':
	#Object defination

	#ConfigCmd = SetCmd()
	Test1 = TestEngine()
	UartCh1 = UartChannel()
	#os.system('clear')

	#Sys config
	#print time.ctime()
	#print 'Eziport Version: V1.0_0327_1325'

	#Str_UartCfg = raw_input('Input Serial port config>')
	Str_UartCfg = sys.argv[1]
	ticks0 = time.time()
	#print 'Setting...'

	UartCh1.UartConfig(Str_UartCfg)
	
	#ConfigCmd.Config(UartCh1)
	
	#Testing
	Test1.TestCyle(UartCh1)

	#Show result
	Test1.PrintDict()




		
