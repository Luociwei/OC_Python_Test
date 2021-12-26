//
//  BoardController.h
//  Electricity Recorder
//
//  Created by ydhuang on 15-9-2.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UART.h"


@interface BoardController : NSObject
{
    NSMutableArray* m_PortNameArray;
    UART        *port;
    NSLock      *theLock;
}
-(NSString *)GetDutChargingStatus:(NSInteger)index;
-(id)Open:(NSString *)path andBaudRate:(unsigned)baud_rate;
-(BOOL)Close;
-(NSString *)ReadDI:(NSInteger)index;//给控制板 index 发送读充电电流命令

-(NSString *)GetDutSerialName:(NSInteger)index;
-(NSString *)GetDutBATMAN_DirectDUT;
-(NSString *)GetDutBATMAN:(NSInteger)index;
-(BOOL)GetDutSETLED:(NSInteger)indexColor Com:(NSInteger)indexCom;

-(NSString *)DisCharging:(NSInteger)index;

@end
