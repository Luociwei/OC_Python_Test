//
//  Communication.h
//  Quick Test
//
//  Created by yecm on 2017/5/2.
//  Copyright © 2017年 Innorev. All rights reserved.
//

#ifndef Communication_h
#define Communication_h
#import "UART.h"
@class TestCommandModel;

@interface Communication: NSObject
{
    UART    *port;
    NSLock  *theLock;
}

@property (readonly) int  portUartHandle;
-(int)Open:(NSString *)path andBaudRate:(unsigned)baud_rate;

-(NSString *)SendCmdAndGetReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix  LogPath:(NSString*)logPath;

-(NSString *)SendCmdAndGetReply2:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix  LogPath:(NSString*)logPath;

-(NSString *)GetReply:(int)timeOut ResponseSuffix:(NSString *)responseSuffix LogPath:(NSString*)logPath;

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
       waitForDelimiter:(const char *)delimiter foundDelimiter:(BOOL *)found;


- (BOOL)readToString:(NSString **)str withDelimiter:(NSString *)delimiter;

- (BOOL)writeString:(NSString *)str;

- (BOOL)writeCString:(const char *)str;

- (BOOL)writePassbit:(const unsigned char *)str length:(ssize_t)len;

//add by 罗词威
+(instancetype)communicationWithPath:(NSString *)path baudRate:(unsigned)baud_rate;
-(NSString *)GetControlBoardReply:(NSArray *)responseSuffixs;
-(NSString *)GetReply;
-(void)SendCmd:(NSString *)cmd;

+(instancetype)communicationWithCaiiltoAndPath:(NSString *)path;
//-(NSString *)SendCmdAndGetOKReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix model:(TestCommandModel *)model;
@end

#endif /* Communication_h */
