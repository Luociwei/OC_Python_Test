//
//  Communication.m
//  Quick Test
//
//  Created by yecm on 2017/5/2.
//  Copyright © 2017年 Innorev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communication.h"
#import "UART.h"
#import "TestCommandModel.h"
#import "CSVLog.h"
@implementation Communication

-(int)Open:(NSString *)path andBaudRate:(unsigned)baud_rate
{
    [theLock lock];
    NSLog(@"command path = %@", path);
    port = [[UART alloc] initWithPath:path andBaudRate:baud_rate];
   // port = [[UART alloc] initWith1250000AndPath:path];
    _portUartHandle = port.uart_handle;
    [theLock unlock];
    NSLog(@"port.uart_handle = %d\n",port.uart_handle);
    return port.uart_handle;
}


+(instancetype)communicationWithPath:(NSString *)path baudRate:(unsigned)baud_rate
{
    Communication *console = [[Communication alloc] init];
    [console Open:path andBaudRate:baud_rate];
    return console;
}


-(void)SendCmd:(NSString *)cmd
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"%@\n", cmd];
    [port flush];
    [port write:WriteCommond];
    [theLock unlock];
    //[CSVLog saveLog:cmd];
    usleep(1000);
}
-(NSString *)GetReply
{
    [theLock lock];
    [port flush];
    [NSThread sleepForTimeInterval:0.1];
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp= [NSString stringWithString:[port read]];
    NSDate *overTime = [NSDate date];
    BOOL isReadFinish = NO;
    while (!isReadFinish)
    {
        [rece appendString:recetmp];
        recetmp=[port read];
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSinceDate:overTime];
        if (time > 0.1)
        {
            break;
        }
        [NSThread sleepForTimeInterval:0.2];
    }
    
    [theLock unlock];
    
    return [NSString stringWithFormat:@"%@",rece];
}

-(NSString *)GetControlBoardReply:(NSArray *)responseSuffixs
{
    [theLock lock];
    [port flush];
    [NSThread sleepForTimeInterval:0.5];
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp= [NSString stringWithString:[port read]];
    NSDate *overTime = [NSDate date];
    BOOL isReadFinish = NO;
    while (!isReadFinish)
    {
        
        [rece appendString:recetmp];
        recetmp=[port read];

        NSDate *date = [NSDate date];
//        NSTimeInterval time = [date timeIntervalSinceDate:overTime];
//        if (time > 1)
//        {
//            break;
//        }

        for (NSString *responseSuffix in responseSuffixs) {
            if ([rece containsString:responseSuffix])
            {
                
                isReadFinish = YES;
              //  [CSVLog saveReceiveCommand:rece];
                break;
            }
        }
        
        [NSThread sleepForTimeInterval:0.2];
    }
    
    [theLock unlock];
    if (rece.length > 0) {
        NSLog(@"###########get control broad cammand :%@",rece);
    }
    
    return [NSString stringWithFormat:@"%@",rece];
}
//-(NSString *)SendCmdAndGetOKReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix model:(TestCommandModel *)model
//{
//    return model.response;
//}

-(NSString *)GetReply:(int)timeOut ResponseSuffix:(NSString *)responseSuffix LogPath:(NSString*)logPath
{
    
    [theLock lock];
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp= [port read];
    NSDate *overTime = [NSDate date];
    while (1)
    {
        if (recetmp.length>0) {
            [rece appendString:recetmp];
        }
        
        if ([[NSDate date] timeIntervalSinceDate:overTime] > timeOut)
        {
            [CSVLog saveLog:[NSString stringWithFormat:@"             %@",@"Time Out"] LogPath:logPath];
            break;
        }
        if ([rece containsString:responseSuffix])
        {
            break;
        }
        recetmp=[port read];
        [NSThread sleepForTimeInterval:0.2];
    }
    
    [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Get :  %@",rece] LogPath:logPath];
    [theLock unlock];
    
    return rece;
}

-(NSString *)SendCmdAndGetReply2:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix  LogPath:(NSString*)logPath
{
    [theLock lock];
    [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Send:  %@",cmd] LogPath:logPath];
    NSString* WriteCommond = [NSString stringWithFormat:@"%@\n", cmd];
    [port flush];
    [port write:WriteCommond];
    //[port dataWrite:WriteCommond];
    [NSThread sleepForTimeInterval:0.02];
    NSMutableString *rece=[[NSMutableString alloc]init];
    // NSString* recetmp= [port dataRead];
    NSString* recetmp= [port read];
    [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Get :  %@",recetmp] LogPath:logPath];
    return recetmp;
}

-(NSString *)SendCmdAndGetReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix  LogPath:(NSString*)logPath
{
    [theLock lock];
    [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Send:  %@",cmd] LogPath:logPath];
    NSString* WriteCommond = [NSString stringWithFormat:@"%@\n", cmd];
    [port flush];
    [port write:WriteCommond];
    //[port dataWrite:WriteCommond];
    [NSThread sleepForTimeInterval:0.3];
    NSMutableString *rece=[[NSMutableString alloc]init];
    // NSString* recetmp= [port dataRead];
    NSString* recetmp= [port read];
    NSDate *overTime = [NSDate date];
    while (1)
    {
        if (recetmp.length>0) {
            [rece appendString:recetmp];
        }
        
        if([responseSuffix isEqualToString:nil])
        {
            responseSuffix = @"";
        }
        
        if ([rece containsString:responseSuffix])
        {
            
            break;
        }
        if ([[NSDate date] timeIntervalSinceDate:overTime] > timeOut)
        {
            [CSVLog saveLog:[NSString stringWithFormat:@"             %@",@"Time Out"] LogPath:logPath];
            break;
        }
        if([cmd containsString:@"[tm-13]"])
        {
            break;
        }
        recetmp=[port read];
        [NSThread sleepForTimeInterval:0.2];
    }
    [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Get :  %@",rece] LogPath:logPath];
    
    [theLock unlock];
    
    return rece;
}

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
       waitForDelimiter:(const char *)delimiter foundDelimiter:(BOOL *)found
{
    return [port readToBuffer:recbuf length:len
             waitForDelimiter:delimiter foundDelimiter:found
                  withTimeout:10];
}
//

- (BOOL)readToString:(NSString **)str withDelimiter:(NSString *)delimiter
{
    return [port readToString:str withDelimiter:delimiter withTimeout:10000];
}

- (BOOL)writeString:(NSString *)str
{
    return [self writeCString:[str UTF8String]];
}

- (BOOL)writeCString:(const char *)str
{
    return [port writeBuffer:(const unsigned char *)str length:strlen(str)];
}

-(BOOL)writePassbit:(const unsigned char *)str length:(ssize_t)len
{
    return [port writeBuffer:(const unsigned char *)str length:len];
}


#pragma caliito
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

+(instancetype)communicationWithCaiiltoAndPath:(NSString *)path
{
    Communication *console = [[Communication alloc] init];
    [console openCaiiltoWithPath:path];
    return console;
}

@end
