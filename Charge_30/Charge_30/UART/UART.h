//
//  UART.h
//  FDTIScanner
//
//  Created by ydhuang on 15-7-16.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface UART : NSObject
{
@private
	int       uart_handle;
	NSString *uart_path;
	NSString *uart_nl;
    
	NSFileHandle         *uart_log;
}

@property (readonly) int                    uart_handle;
@property (readonly) NSString              *uart_path;
@property (copy)     NSString              *uart_nl;


-(id)initWithPath:(NSString *)path andBaudRate:(unsigned)baud_rate;
-(int)write:(NSString *)str;//写str字符串到 uart_handle所指中
-(int)writeLine:(NSString *)str;//将串口检测到的字符 剪切到uart_handle 所指文件中
-(NSString *)flush;//不断循环检测串口，直到检测的字符串不为空
-(NSString *)read;//串口读字符串
-(NSData *)readData;//串口读数据串
-(BOOL)close;//关闭uart处理

@end
