//
//  SerialDevice.h
//  iPortTest
//
//  Created by Zaffer.yang on 3/14/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerialPort.h"

@interface SerialDevice : NSObject
@property (nonatomic, retain) NSString *portName;
@property (nonatomic, retain) SerialPort *serialPort;

@property (nonatomic, retain) NSString *gecfg_end_key;

- (id)initWithPortName:(NSString *)port baudRate:(speed_t)baud config:(PORT_CONFIG)config timeout:(int)ms file:(NSString *)fileName;

- (BOOL)openSerialPort;

- (BOOL)closeSerialPort;

-(NSString*)sendCommandAndReadResponse:(NSString*)command;

-(NSString *) readFromDevice;
-(void)readExsiting;
@end
