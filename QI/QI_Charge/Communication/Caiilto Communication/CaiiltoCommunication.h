//
//  CaiiltoCommunication.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by luocw on 22/06/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Communication_h
#import "UART.h"
@interface CaiiltoCommunication : NSObject
{
    UART    *port;
    NSLock  *theLock;
}
@property (readonly) int  portUartHandle;
+(instancetype)communicationWithCaiiltoAndPath:(NSString *)path;
-(NSString *)SendCaiiltoCmdAndGetOKReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix  LogPath:(NSString*)logPath;
@end
