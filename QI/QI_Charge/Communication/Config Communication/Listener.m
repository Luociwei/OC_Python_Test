//
//  listener.m
//  listen
//
//  Created by 罗词威 on 23/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "Listener.h"
#import "Communication.h"
#import "ConfigCommands.h"

@interface Communication()

@end

static NSArray<NSString *> *_array;
static Communication *boardConsle;

@implementation Listener

+(void)load
{
    _array = @[@"Start\r\n",@"EmergencyStop\r\n",@"ClearEmergency\r\n",@"Reset\r\n"];
}


-(void)startListening:(Communication *)fixtureConsle
{

    boardConsle = fixtureConsle;
    while (1) {
        [NSThread sleepForTimeInterval:0.3];
        //一直监听下位机发送的消息
        NSString *reply = [fixtureConsle GetControlBoardReply:_array];
        if ([reply containsString:_array[0]]) {//Start
            if (self.delegate && [self.delegate respondsToSelector:@selector(FixtureStart)]) {
                [self.delegate FixtureStart];
            }
            continue;
        }
        
        if ([reply containsString:_array[1]]) {//EmergencyStop
            if (self.delegate && [self.delegate respondsToSelector:@selector(FixtureStop)]) {
                [self.delegate FixtureStop];
            }
            continue;
        }
        
       
        if ([reply containsString:_array[2]]) {//ClearEmergency
      
            if (self.delegate && [self.delegate respondsToSelector:@selector(FixtureCloseStop)]) {
                [self.delegate FixtureCloseStop];
             
            }
            
            continue;
        }
        
        if ([reply containsString:_array[3]]) {//reset
            if (self.delegate && [self.delegate respondsToSelector:@selector(FixturRreset)]) {
                [self.delegate FixturRreset];
            }
            continue;
        }
    }
    
}

//-(NSString *)getBoardVersion
//{
//    
//}


#pragma boardControl
-(void)testEndWithUUT1Check:(BOOL)uut1Check uut1Result:(BOOL)uut1Result UUT2Check:(BOOL)uut2Check uut2Result:(BOOL)uut2Result
{
    int uut1status = 0;// 0==>uut1 ligth close  1==>uut1 ligth green  2==>uut1 light red
    int uut2status = 0;// 0==>uut2 ligth close  1==>uut2 ligth green  2==>uut2 light red
    if(uut1Check)
    {
        if(uut1Result)
        {
            uut1status = 1;
        }
        else
        {
            uut1status = 2;
        }
    }
    if(uut2Check)
    {
        if(uut2Result)
        {
            uut2status = 1;
        }
        else
        {
            uut2status = 2;
        }
    }
    [boardConsle SendCmd:[NSString stringWithFormat:@"testEnd %d %d",uut1status,uut2status]];
}

-(void)StartOK
{
    [boardConsle SendCmd:[NSString stringWithFormat:@"StartOK"]];
}

-(void)ResetCylinder:(int)uutNum
{
    [boardConsle SendCmd:[NSString stringWithFormat:@"ResetCylinder %d",uutNum]];
}

-(void)DUTSELECTED:(int)DUT1Status DUT2Status:(int)DUT2Status
{
    [boardConsle SendCmd:[NSString stringWithFormat:@"DUTSELECTED %d %d",DUT1Status,DUT2Status]];
}

@end
