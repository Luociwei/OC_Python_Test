//
//  TestEngine.m
//  iPortTest
//
//  Created by Zaffer.yang on 3/14/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "TestEngine.h"


@implementation TestEngine
- (id)init:(int)identifier Config:(NSArray*)arr{
    if (self = [super init]) {
        
    }
    return self;
}
-(void)setGecfg_end_key:(NSString *)gecfg_end_key
{
    _gecfg_end_key =gecfg_end_key;
    _device.gecfg_end_key = gecfg_end_key;
}

- (bool)initDevices:(NSString*)portName
{
    _portName = portName;
    _device = [[SerialDevice alloc] initWithPortName:portName baudRate:B115200 config:PORT_CONFIG_8N1 timeout:2000 file:self.fileName];
    
    if ([_device openSerialPort]) {
        NSLog(@"%@ Open!",portName);
    }
    else
    {
        NSLog(@"%@ Can't open!",portName);
        return NO;
    }
    return YES;
}

-(NSString*)sendCommandAndReadResponse:(NSString*)command{
    return [_device sendCommandAndReadResponse:command];
}

-(NSString *)readFromDevice
{
    return [_device readFromDevice];
}
-(void)readExsiting
{
    [_device readExsiting];
}
- (void)resetSerialPorts
{
    
}
-(NSString*)ReadFromTestFile{
    NSString *fileContent=@"";
    NSError *error=nil;
    NSString *jsonTestPath = [[NSBundle mainBundle] pathForResource:@"SerialOutputTest" ofType:@"json"];
    fileContent = [NSString stringWithContentsOfFile:jsonTestPath encoding:NSUTF8StringEncoding error:&error];
    return fileContent;
}
-(NSString*)ReadFromTestFile2{
    NSString *fileContent=@"";
    NSError *error=nil;
    NSString *jsonTestPath = [[NSBundle mainBundle] pathForResource:@"SerialOutputTest2" ofType:@"json"];
    fileContent = [NSString stringWithContentsOfFile:jsonTestPath encoding:NSUTF8StringEncoding error:&error];
    return fileContent;
}
-(NSString*)ReadForCcpinTest{
    NSString *fileContent=@"";
    NSError *error=nil;
    NSString *jsonTestPath = [[NSBundle mainBundle] pathForResource:@"ccpintest" ofType:@"json"];
    fileContent = [NSString stringWithContentsOfFile:jsonTestPath encoding:NSUTF8StringEncoding error:&error];
    return fileContent;
}
-(NSString*)ReadForCcpinTest2{
    NSString *fileContent=@"";
    NSError *error=nil;
    NSString *jsonTestPath = [[NSBundle mainBundle] pathForResource:@"ccpintest2" ofType:@"json"];
    fileContent = [NSString stringWithContentsOfFile:jsonTestPath encoding:NSUTF8StringEncoding error:&error];
    return fileContent;
}
@end
