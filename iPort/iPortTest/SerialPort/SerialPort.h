//
//  SerialPort.h
//  FactoryCocoa
//
//  Created by Allen Cheung on 6/14/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <termios.h>
#include "buffer.h"
#import "LogFile.h"

typedef enum
{
	PORT_CONFIG_8N1 = 0x81,
	PORT_CONFIG_8E1 = 0xA1,
	PORT_CONFIG_8O1 = 0x91,
	PORT_CONFIG_7E1 = 0x61,
    PORT_CONFIG_7E2 = 0x62
	
} PORT_CONFIG;

@interface SerialPort : NSObject
{
    char *_portName;
    speed_t _baudRate;
    PORT_CONFIG _config;
    int _timeout;
    int _fd;
    struct termios *_originalAttr;
    BOOL _isOpen;
    struct buffer _buffer;
}
@property (nonatomic) NSString *fileName;
@property (readonly) char *portName;
@property (readonly) BOOL isOpen;
@property (readonly) PORT_CONFIG config;


- (id)initWithPort:(NSString *)port
          baudRate:(speed_t)baud
            config:(PORT_CONFIG)config
           timeout:(int)ms fileName:(NSString *)fileName;

- (BOOL)open;

- (BOOL)close;

- (BOOL)writeBuffer:(const unsigned char *)buf length:(ssize_t)len;

- (BOOL)writeCString:(const char *)str;

- (BOOL)writeString:(NSString *)str;

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
       waitForDelimiter:(const char *)delimiter foundDelimiter:(BOOL *)found
            withTimeout:(int)ms;

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
       waitForDelimiter:(const char *)delimiter foundDelimiter:(BOOL *)found;

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len withTimeout:(int)ms;

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len;

- (ssize_t)readOneByte:(unsigned char *)byte;

- (BOOL)readToString:(NSString **)str withDelimiter:(NSString *)delimiter withTimeout:(int)ms;

- (BOOL)readToString:(NSString **)str withDelimiter:(NSString *)delimiter;

- (BOOL)readExistingToString:(NSString **)str;

+ (BOOL)serialPortList:(NSArray **)list;

+ (NSArray *)serialPortList;
@end
