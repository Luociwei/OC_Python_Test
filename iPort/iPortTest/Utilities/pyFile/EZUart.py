import serial
import re
import time
import json
import binascii
import ctypes

class StrToLst:
	"""docstring for StrToList"""
	MsgStrLst = list([''])
	LocalMsgStrLst = list()
	IsEnd = 1
	def __init__(self):
		MsgStrLst = list([''])
		LocalMsgStrLst = list()
		self.IsEnd = 1
	def ToLst(self,output):
		self.LocalMsgStrLst=output.split('\n')
		if  self.IsEnd != 0:					#last element not end
			#print 'Not End'
			self.MsgStrLst[-1] = self.MsgStrLst[-1] + self.LocalMsgStrLst[0]
			self.MsgStrLst = self.MsgStrLst + self.LocalMsgStrLst[1:]
		else:									#last element end
			#print 'End'
			self.MsgStrLst = self.MsgStrLst + self.LocalMsgStrLst
		# del empty element
		if self.MsgStrLst[-1] == '':
			del self.MsgStrLst[-1]
		# detect last element end or not
		if  output[-1] != '\n':
			self.IsEnd = 1
		else:
			self.IsEnd = 0


class UartChannel(serial.Serial):
	"""docstring fos UartChannel"""
	ConfigDict = dict()
	Uart = serial.Serial()
	def __init__(self):
		super(UartChannel, self).__init__()
		self.ConfigDict = dict({'BAUD': '115200', 'PATH': '/dev/cu.SLAB_USBtoUART'})
	def UartConfig(self, Str_UartCfg):
		# Get the Drv Path info
		Match = re.search(r'Path:(\s*)(?P<PATH>[^,]*)', Str_UartCfg)
		if Match:
			self.ConfigDict.update(Match.groupdict())
		# Get the Baud rate info
		Match = re.search(r'Baud:(\s*)(?P<BAUD>[0-9]*)', Str_UartCfg)
		if Match:
			self.ConfigDict.update(Match.groupdict())
		if self.ConfigDict:
			print self.ConfigDict
		self.baudrate = int(self.ConfigDict['BAUD'])
		self.port = self.ConfigDict['PATH']
		self.timeout = 0.1
		#print self
		self.open()
	def StartTest(self):
		self.write('debug key1')

class TestEngine:
	"""docstring for TestEngine"""
	tick0 = 0.0
	ticks = 0.0
	output = ''

	Gnd_PinnameDict =	\
			{	\
			'a02-a01': 'RX1+',	\
			'a03-a01': 'RX1-', 	\
			'a04-a01':'Vbus', 	\
			'a05-a01': 'CC',	\
			'a06-a01': 'D-',	\
			'a07-a01': 'D+',	\
			'a08-a01': 'SBU1',	\
			'a09-a01': 'Vbus',	\
			'a10-a01': 'TX2-',	\
			'a11-a01': 'TX2+',	\
			'b02-a01': 'RX2+',	\
			'b03-a01': 'RX2-',	\
			'b04-a01': 'Vbus',	\
			'b05-a01': 'Vcon',	\
			'b08-a01': 'SBU2',	\
			'b09-a01': 'Vbus',	\
			'b10-a01': 'TX1-',	\
			'b11-a01': 'TX1+'
			}
	Vbus_PinnameDict =	\
			{	\
			'a01-a04': 'GND',	\
			'a02-a04': 'RX1+',	\
			'a03-a04': 'RX1-', 	\
			'a05-a04': 'CC',	\
			'a06-a04': 'D-',	\
			'a07-a04': 'D+',	\
			'a08-a04': 'SBU1',	\
			'a10-a04': 'TX2-',	\
			'a11-a04': 'TX2+',	\
			'a12-a04': 'GND',	\
			'b01-a04': 'GND',	\
			'b02-a04': 'RX2+',	\
			'b03-a04': 'RX2-', 	\
			'b05-a04': 'VCON',	\
			'b08-a04': 'SBU2',	\
			'b10-a04': 'TX1-',	\
			'b11-a04': 'TX1+',	\
			'b12-a04': 'GND',	\
			}


	UartbufToLst = StrToLst()
	MsgDictLs = list()
	def __init__(self):
		tick0 = 0.0
		ticks = 0.0
		MsgDictLs = list([])
		UartbufToLst = StrToLst()
	def TestCyle(self,UartCh1):
		self.tick0 = time.time()
		UartCh1.StartTest()
		FlagDict = dict()
		while self.ticks - self.tick0 <= 20.0:
			output = UartCh1.read(300)
			self.ticks = time.time()
			if output:
				self.UartbufToLst.ToLst(output)
				try:
					FlagDict = json.loads(self.UartbufToLst.MsgStrLst[-1])
					if FlagDict['item'] == 'end':
						break
				except (ValueError,KeyError):
					pass
		self.MsgDictLst = list([json.loads(p) for p in self.UartbufToLst.MsgStrLst])

	def PrintResult(self,ticks0):
		print 'Test Time:',"%.2f" %(time.time()-ticks0) ,'s'
		print '\t\tTest Result\t\t'
		print '|group\t|item\t|value (mV)\t|type\t|result\t|'

		for p in self.MsgDictLst:
			try:
				print '|'+p['group'].encode('utf-8')+'\t|'+self.Gnd_PinnameDict[p['item']].encode('utf-8')+'\t|'+str(p['value'])+'\t\t|'+p['typ'].encode('utf-8')+'\t|'+p['result']+'\t|'
			except KeyError:
				pass
	def PrintDict(self):
		for p in self.UartbufToLst.MsgStrLst:
			print p
	def StoreCSV(self):
		FilePath = 'TestResult/'+time.ctime()+'.csv'
		f = open(FilePath, 'w')
		TableStr = 'Test Result\r\n'
		TableStr += 'Group, Item, Pinname, Type, Short limit, Open limit, Value (mV), Result\r\n'
		for p in self.MsgDictLst:
			if 'group' in p.keys():
				if p['group'] != 'message':
					TableStr += p['group'].encode('utf-8')+', '
					TableStr += p['item'].encode('utf-8')+', '
					TableStr += self.Gnd_PinnameDict[p['item']]+', '
					TableStr += p['typ'].encode('utf-8')+', '
					TableStr += str(p['lim']['short'])+', '
					TableStr += str(p['lim']['open'])+', '
					TableStr += str(p['value'])+', '
					TableStr += p['result'].encode('utf-8')+'\r\n'
		f.write(TableStr)
		f.close()

class SetCmd:
	"""docstring for SetCmd"""
	SetgrpCmd1 = ''
	SetgrpCmd2 = ''
	SetgrpCmd3 = ''

	SetitmSkipCmd = ''
	SetitmVdrpCmd = ''

	SetlimVdrpCmd1 = ''
	SetlimVdrpCmd2 = ''
	def __init__(self):
		self.SetgrpCmd1 = 'setgrp adj off'
		self.SetgrpCmd2 = 'setgrp vbus off'
		self.SetgrpCmd3 = 'setgrp gnd on'

		self.SetitmSkipCmd = 'setitm gnd skip a04,a05,a06,a07,a08,a09,b04,b05,b06,b07,b08,b09'
		self.SetitmVdrpCmd = 'setitm gnd vdrp a02,a03,a04,a05,a06,a07,a08,a09,a10,a11,b02,b03,b04,b05,b08,b09,b10,b11'

		
		self.SetlimVdrpCmd1 = 'setlim gnd vdrp 600 50 a02,a03,a04,a05,a06,a07,a08,a09,b02,b03,b04,b05,b08,b09'
		self.SetlimVdrpCmd2 = 'setlim gnd vdrp 2500 50 a10,a11,b10,b11'

	def CmdCRC(self):
		TotalStr = ''
		TotalStr += self.SetgrpCmd1
		TotalStr += self.SetgrpCmd2
		TotalStr += self.SetgrpCmd3
		TotalStr += self.SetitmSkipCmd
		TotalStr += self.SetitmVdrpCmd
		TotalStr += self.SetlimVdrpCmd1
		TotalStr += self.SetlimVdrpCmd2
		return ctypes.c_uint32(binascii.crc32(TotalStr)).value

	def CRCCheck(self,UartCh):
		CRC0 = self.CmdCRC()
		UartCh.write('getcheck')
		CRC1 = int(json.loads(UartCh.read(50))['Getchecksum'])
		if CRC0 == CRC1:
			return 0
		else:
			UartCh.write("setcheck %u" %CRC0)
			return 1

	def Config(self,UartCh):
		UartCh.write('getversion')
		time.sleep(0.1)
		VerDict = json.loads(UartCh.read(50))
		if VerDict['version'] != u'1.3_0329':
			print 'Version Error!'
		print 'iPort FW version:'+VerDict['version'].encode('utf-8')
		print 'Testing...'
		if self.CRCCheck(UartCh) == 1:
			time.sleep(0.3)
			UartCh.write(self.SetgrpCmd1)
			time.sleep(0.3)
			UartCh.write(self.SetgrpCmd2)
			time.sleep(0.3)
			UartCh.write(self.SetgrpCmd3)
			time.sleep(0.3)
			UartCh.write(self.SetitmSkipCmd)
			time.sleep(0.3)
			UartCh.write(self.SetitmVdrpCmd)
			time.sleep(0.3)
			UartCh.write(self.SetlimVdrpCmd1)
			time.sleep(0.3)
			UartCh.write(self.SetlimVdrpCmd2)
			time.sleep(0.3)
			UartCh.read(500)

	





		

