//
//  SerialDevice.m
//  iPortTest
//
//  Created by Zaffer.yang on 3/14/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "SerialDevice.h"
#import "PlistUtilities.h"
#import "MyEexception.h"

#define STARTSINGAL   @"{\"group\": \"message\", \"item\": \"start\"}"
#define ENDSINGAL     @"{\"group\": \"message\",\"item\": \"end\"}\r\n"

@implementation SerialDevice
- (id)initWithPortName:(NSString *)port baudRate:(speed_t)baud config:(PORT_CONFIG)config timeout:(int)ms file:(NSString *)fileName
{
    if (self = [super init])
    {
        _portName = port;
        _serialPort = [[SerialPort alloc] initWithPort:port baudRate:baud config:config timeout:ms fileName:fileName];
        
    }
    
    return self;
}

- (BOOL)openSerialPort
{
    return [_serialPort open];
}

- (BOOL)closeSerialPort
{
    return [_serialPort close];
}

//-(NSString*)ReadFromTestFile2{
//    NSString *fileContent=@"";
//    NSError *error=nil;
//    NSString *jsonTestPath = [[NSBundle mainBundle] pathForResource:@"SerialOutputTest2" ofType:@"json"];
//    fileContent = [NSString stringWithContentsOfFile:jsonTestPath encoding:NSUTF8StringEncoding error:&error];
//    return fileContent;
//}
//
//-(NSString*)ReadFromTestFile{
//    NSString *fileContent=@"";
//    NSError *error=nil;
//    NSString *jsonTestPath = [[NSBundle mainBundle] pathForResource:@"SerialOutputTest" ofType:@"json"];
//    fileContent = [NSString stringWithContentsOfFile:jsonTestPath encoding:NSUTF8StringEncoding error:&error];
//    return fileContent;
//}

-(NSString *)gecfg_end_key
{
    if (!_gecfg_end_key.length) {
        _gecfg_end_key = @"\r\n";
    }
    return _gecfg_end_key;
}


-(NSString*)sendCommandAndReadResponse:(NSString*)command{
    
    NSString* finalCmdResponse = nil;
    if([_serialPort writeString:command]){
#ifdef DEBUG
        NSLog(@"Sent: %@",command);
#endif
        // Send the command and receive the response
        if ([command isEqualToString:@"debug key1"] ||[command isEqualToString:@"ccpintest"] || [command isEqualToString:@"vbustest"]) {
            [_serialPort readToString:&finalCmdResponse withDelimiter:ENDSINGAL withTimeout:[self get_debugkey1_time_out]];
            if ([finalCmdResponse containsString:STARTSINGAL]&&[finalCmdResponse containsString:ENDSINGAL]) {
                NSRange range2 = [finalCmdResponse rangeOfString:STARTSINGAL];
                NSString *mutOutPut = [finalCmdResponse substringFromIndex:range2.location+range2.length +1];
                if ([mutOutPut containsString:STARTSINGAL]) {
                    NSRange range3 = [mutOutPut rangeOfString:STARTSINGAL];
                    finalCmdResponse = [mutOutPut substringFromIndex:range3.location];
                    
                }
                
            }else
            {
                finalCmdResponse = nil;
            }
            
        }
        else{
            if ([command containsString:@"getcfg grp"]) {
                [_serialPort readToString:&finalCmdResponse withDelimiter:self.gecfg_end_key withTimeout:2000];
                if (![finalCmdResponse containsString:self.gecfg_end_key]) {
                    finalCmdResponse = nil;
                }
            }
    
            else if ([command containsString:@"check"]) {
                [_serialPort readToString:&finalCmdResponse withDelimiter:@"}\r\n" withTimeout:1000];
                if (![finalCmdResponse containsString:@"}\r\n"]) {
                    finalCmdResponse = nil;
                }
            }
          
            else{
                [_serialPort readToString:&finalCmdResponse withDelimiter:@"}\r\n" withTimeout:1000];
                if (![finalCmdResponse containsString:@"}\r\n"]) {
                    finalCmdResponse = nil;
                }
            }
            
        }
    }else{

        [NSThread sleepForTimeInterval:3];
    }
    for (int k = 0; k < 1; k++) {
        if ([finalCmdResponse length] == 0 || finalCmdResponse == nil) {
            [_serialPort close];
            [_serialPort open];

            [NSThread sleepForTimeInterval:1.5];
            if([_serialPort writeString:command]){
                [NSThread sleepForTimeInterval:0.5];
                if ([command isEqualToString:@"debug key1"]) {
                    [_serialPort readToString:&finalCmdResponse withDelimiter:ENDSINGAL withTimeout:[self get_debugkey1_time_out]];
                    
                    if ([finalCmdResponse containsString:STARTSINGAL]&&[finalCmdResponse containsString:ENDSINGAL]) {
                        NSRange range2 = [finalCmdResponse rangeOfString:STARTSINGAL];
                        NSString *mutOutPut = [finalCmdResponse substringFromIndex:range2.location+range2.length +1];
                        if ([mutOutPut containsString:STARTSINGAL]) {
                            NSRange range3 = [mutOutPut rangeOfString:STARTSINGAL];
                            finalCmdResponse = [mutOutPut substringFromIndex:range3.location];
                            
                        }
                        
                    }else
                    {
                        finalCmdResponse = nil;
                    }
                    
                    
                    NSString *string = nil;
                    [_serialPort readToString:&string withDelimiter:ENDSINGAL withTimeout:1];
                }
                else{
                    if (k==0) {
                        
                        
                        if ([command containsString:@"getcfg grp"]) {
                            [_serialPort readToString:&finalCmdResponse withDelimiter:self.gecfg_end_key withTimeout:1000];
                            if (![finalCmdResponse containsString:self.gecfg_end_key]) {
                                finalCmdResponse = nil;
                            }
                        }
            
                        else if ([command containsString:@"check"]) {
                            [_serialPort readToString:&finalCmdResponse withDelimiter:@"}\r\n" withTimeout:1000];
                            if (![finalCmdResponse containsString:@"}\r\n"]) {
                                finalCmdResponse = nil;
                            }
                        }
                        else{
                            [_serialPort readToString:&finalCmdResponse withDelimiter:@"}\r\n" withTimeout:1500];
                        }
                        
                    }
                    else if (k==1){
                        [_serialPort close];
                        
                        [_serialPort readToString:&finalCmdResponse withDelimiter:@"}\r\n" withTimeout:2000];
                        
                        sleep(1);
                    }
                }
            }
        }
        else{
            break;
        }
    }
    
#ifdef DEBUG
    NSLog(@"\n=========================>\nReceived: %@\n<=======================\n",finalCmdResponse);
#endif
    
    if ((![finalCmdResponse containsString:@"\r\n"])||(![finalCmdResponse containsString:@"}"])) {
        NSLog(@"111");
    }
    
    return finalCmdResponse;
}

-(NSString *) readFromDevice{
    NSString *strFromDevice=@"";
    [_serialPort readToString:&strFromDevice withDelimiter:@"" withTimeout:3000];
    return strFromDevice;
}
-(void)readExsiting{
    NSString *strExsiting = @"";
    [_serialPort readExistingToString:&strExsiting];
}

-(int)get_debugkey1_time_out
{
    NSDictionary *configDic  = [PlistUtilities loadFile:@"setting"];
    int time_out = [[configDic objectForKey:@"debugkey1_timeout"] intValue];
    return time_out;
}

@end
