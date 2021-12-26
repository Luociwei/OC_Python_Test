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
        //if (self.isStartPause) continue;
//        NSString *reply = [ConfigCommands configCommandsGetControlBoardReply:_array];
        NSString *reply = [fixtureConsle GetControlBoardReply:_array];
        
        if ([reply containsString:_array[0]]) {//Start

           // [fixtureConsle SendCmd:@"StartOK"];
           // [ConfigCommands configCommandsSendCmd:@"StartOK"];

           // [fixtureConsle SendCmdAndGetOKReply:@"StartOK" TimeOut:0.2 ResponseSuffix:@"ok"];

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
                // self.isStartPause = YES;
            }
            
            continue;
        }
    }
    
}



#pragma boardControl
-(void)testEndWithUUT1Check:(BOOL)uut1Check uut1Result:(BOOL)uut1Result UUT2Check:(BOOL)uut2Check uut2Result:(BOOL)uut2Result
{
    int x = 0;//0
    int y = 0;
    if (uut1Check) {
        x = 1;
    }else{
        x= 0;
    }
    [boardConsle SendCmd:[NSString stringWithFormat:@"testEnd %d %d",x,y]];
}


@end
