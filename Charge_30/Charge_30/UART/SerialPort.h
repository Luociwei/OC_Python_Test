//
//  SerialPort.h
//  Quick Test
//
//  Created by yecm on 2017/5/2.
//  Copyright © 2017年 Innorev. All rights reserved.
//

#ifndef SerialPort_h
#define SerialPort_h
#import <Foundation/Foundation.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <sys/termios.h>

@interface SerialPort : NSObject
{
    int             m_iRS232;
    struct termios  m_rsOriTerm;
    struct termios  m_rsNewTerm;
}

+ (NSMutableArray *)SearchSerialPorts;

@end
#endif /* SerialPort_h */
