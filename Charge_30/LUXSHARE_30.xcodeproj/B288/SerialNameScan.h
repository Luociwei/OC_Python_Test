//
//  SerialNameScan.h
//  FDTIScanner
//
//  Created by chenzw on 15-6-26.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#ifndef _SERIALNAMESCAN_H_
#define _SERIALNAMESCAN_H_

#import <Cocoa/Cocoa.h>

#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <strings.h>
#include <sys/signal.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#import <Foundation/Foundation.h>

@interface SerialNameScan : NSObject

-(void) scanPortName:(NSString *) shortName needName:(NSMutableArray*) m_PortNameArray;//扫描端口,并存储到数组中


@end

#endif