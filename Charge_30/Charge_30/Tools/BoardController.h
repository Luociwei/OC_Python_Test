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
    //NSMutableArray* m_PortNameArray;
    UART        *port;
    NSLock      *theLock;
}
@property (copy) NSMutableArray *snArray;
@property NSInteger boardIndex;
-(id)initWithIndex:(NSInteger)index;
-(NSString *)GetDutChargingStatus:(NSInteger)index;
-(int)Open:(NSString *)path andBaudRate:(unsigned)baud_rate;
-(BOOL)Close;
-(NSString *)Sendstr:(NSInteger)channelindex Commandstr:(NSString *)commandstr Delay:(unsigned int)delaytime  Findstr:(NSString *)findstr Findlength:(unsigned int)findlength;
-(NSString *)Sendstr:(NSInteger)channelindex Commandstr:(NSString *)commandstr Delay:(unsigned int)delaytime ;

-(NSString *)GetDutSerialName:(NSInteger)index;
-(NSString *)GetDutBATMAN:(NSInteger)index;
-(BOOL)GetDutSETLED:(NSInteger)indexColor Com:(NSInteger)indexCom;
-(BOOL)StopCharging:(NSInteger)index;
-(NSString *)SetPWM:(NSInteger)indexmode Channel:(NSInteger)indexchannel;
-(NSString *)GetLID:(NSInteger)indexchannel;
-(NSString *)GetDutSV:(NSInteger)index;
-(NSString *)GetDutHV:(NSInteger)index;
-(NSString *)GetDutMSN:(NSInteger)index;

-(NSString *)SetTUNNEL:(NSInteger)indextunnel Channel:(NSInteger)indexchannel;
-(NSString *)GetMLB:(NSInteger)index Channel:(NSInteger)indexchannel;
-(NSString *)SetBYE:(NSInteger)indexchannel;
-(NSString *)SetBOUT:(NSInteger)outchannel Channel:(NSInteger)indexchannel;
-(NSString *)SetPLSN:(NSInteger)index Channel:(NSInteger)indexchannel;
-(NSString *)SetFATP:(NSInteger)index Channel:(NSInteger)indexchannel;
-(NSString *)SetBSR:(NSInteger)indexchannel;
-(NSString *)SetBHR:(NSInteger)indexchannel;
-(NSString *)SetTTIM:(NSInteger)indexchannel;
-(NSString *)GetDutSR:(NSInteger)index;
-(NSString *)GetDutHVSV:(NSInteger)index Channel:(NSInteger)indexchannel;


-(NSString *)GetDutBLS:(NSInteger)index;
-(NSString *)SetDCDC:(NSInteger)index Channel:(NSInteger)indexchannel;

-(NSString *)SetTM:(NSInteger)index;
-(NSString *)setChargeMode:(NSInteger)index;
-(NSString *)setChargeSlow:(NSInteger)index;

-(NSString *)SendCmdAndGetOKReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix index:(NSInteger)channel;

-(void)resetDut:(NSInteger)i;
-(void)resetAllDuts:(NSInteger)boardDutsCount;

-(NSString *)CloseTunnel:(NSInteger)indexchannel;

-(NSString *)setDischarge:(NSInteger)index;
-(void)setResetSystem:(NSInteger)index;
-(NSString *)StopDisCharging:(NSInteger)index;
-(void)setUVP:(NSInteger)index;
@end
