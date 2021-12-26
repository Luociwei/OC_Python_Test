//
//  listener.h
//  listen
//
//  Created by 罗词威 on 23/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Communication;

@protocol ListenerDelegate <NSObject>

-(void)FixtureStart;

-(void)FixtureStop;

-(void)FixturRreset;

-(void)FixtureCloseStop;

@end


typedef NS_ENUM(NSUInteger, FixtureReplyType) {
    FixtureReplyTypeStart    = 1,
    FixtureReplyTypeReset    = 2,
    FixtureReplyTypeEStop    = 3,
    FixtureReplyTypeCloseStop     = 4,
 

};

@interface Listener : NSObject

-(void)startListening:(Communication *)fixtureConsle;

@property (weak) id<ListenerDelegate>delegate;
@property FixtureReplyType reply;
@property(assign)BOOL isStartPause;
//@property(copy)NSString *replyStr;

-(void)testEndWithUUT1Check:(BOOL)uut1Check uut1Result:(BOOL)uut1Result UUT2Check:(BOOL)uut2Check uut2Result:(BOOL)uut2Result;

-(void)StartOK;

-(void)ResetCylinder:(int)uutNum;

-(void)DUTSELECTED:(int)DUT1Status DUT2Status:(int)DUT2Status;

@end
