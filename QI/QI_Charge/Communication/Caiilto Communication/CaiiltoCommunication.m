//
//  CaiiltoCommunication.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by luocw on 22/06/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import "CaiiltoCommunication.h"
#import "CSVLog.h"

@implementation CaiiltoCommunication

+(instancetype)communicationWithCaiiltoAndPath:(NSString *)path
{
    CaiiltoCommunication *console = [[CaiiltoCommunication alloc] init];
    [console openCaiiltoWithPath:path];
    return console;
}
-(int)openCaiiltoWithPath:(NSString *)path
{
    [theLock lock];
    NSLog(@"command path = %@", path);
    port = [[UART alloc] initWith1250000AndPath:path];
    _portUartHandle = port.uart_handle;
    [theLock unlock];
    NSLog(@"port.uart_handle = %d\n",port.uart_handle);
    return port.uart_handle;
}

-(NSString *)SendCaiiltoCmdAndGetOKReply:(NSString *)cmd TimeOut:(int)times ResponseSuffix:(NSString *)responseSuffix LogPath:(NSString*)logPath
{
    [CSVLog saveLog:[NSString stringWithFormat:@"  Callisto Send:  %@",cmd] LogPath:logPath];
    [theLock lock];
    //[port flush];
    NSString* WriteCommond = [NSString stringWithFormat:@"%@\n", cmd];
    [port dataWrite:WriteCommond];
    [NSThread sleepForTimeInterval:0.2];
    
    NSString *recetmp= [port dataRead];
    NSMutableString *rece=[[NSMutableString alloc]initWithString:recetmp];
    NSDate *overTime = [NSDate date];
    if([cmd containsString:@"inband ping_pong 1 127772 126984 5 10 15 100"])
    {
        while (1)
        {
            [rece appendString:recetmp];
            int time = [[NSDate date] timeIntervalSinceDate:overTime];
            if ([[NSDate date] timeIntervalSinceDate:overTime] > 120)
            {
                break;
            }
            if ([rece containsString:@"repeat count 1:"])
            {
                NSRange range_from = [rece rangeOfString:@"repeat count 1: sent crc 0x4d, read crc 0x4d,"];
                NSString * string_from = [rece substringWithRange:NSMakeRange(range_from.location+range_from.length, rece.length-range_from.location-range_from.length)];
                if([string_from containsString:@"\n"])
                {
                    break;
                }
            }
            if([recetmp containsString:@"repeat count 1"]&&[recetmp containsString:@"repeat count 2"]&&![recetmp containsString:@"pass"])
            {
                break;
            }
            @try
            {
                recetmp=[port dataRead];
            }
            @catch(NSException *exce)
            {
                NSLog(@"########recetmp fail");
            }
            [NSThread sleepForTimeInterval:0.2];
        }
    }
    [CSVLog saveLog:[NSString stringWithFormat:@"  Callisto Get :  %@\n",rece] LogPath:logPath];
    [theLock unlock];

    //    NSString* rece2 = [rece stringByReplacingOccurrencesOfString:@"\r\n" withString:@"-"];
    //    NSString * str1=[NSString stringWithFormat:@"Command %@ OK   , Reply is: %s  ", cmd, [rece2 UTF8String]];
    //    str1 = [str1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //    NSLog(@"%@",str1);
     //NSLog(@"lcw-rece--%@",rece);
    NSLog([NSString stringWithFormat:@"###############get reply:  %@\n", rece]);
    return rece;
}
@end
