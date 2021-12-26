//
//  TestEngine.h
//  iPortTest
//
//  Created by Zaffer.yang on 3/14/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerialDevice.h"
#import "QuickPudding.h"



@interface TestEngine : NSObject{
//    SerialDevice *device;
}
- (bool)initDevices:(NSString*)portName;
-(NSString*)sendCommandAndReadResponse:(NSString*)command;
-(NSString*)readFromDevice;
-(void)readExsiting;
-(NSString*)ReadFromTestFile;
-(NSString*)ReadFromTestFile2;
-(NSString*)ReadForCcpinTest;
-(NSString*)ReadForCcpinTest2;
//- (void)resetSerialPorts;
@property (readonly,nonatomic)SerialDevice *device;
@property (strong,nonatomic)NSString *gecfg_end_key;
@property (readonly,nonatomic)NSString *portName;
@property (nonatomic)NSString *fileName;

@end
