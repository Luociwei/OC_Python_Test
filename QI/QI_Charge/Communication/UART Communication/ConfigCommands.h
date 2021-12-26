//
//  ConfigCommands.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 02/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TestCommandModel,Communication;

@interface ConfigCommands : NSObject
//+(void)configCommandsSendCmd:(NSString *)cmd;
//+(NSString *)configCommandsGetControlBoardReply:(NSArray *)array;
+(NSString *)communicationWithCommands:(NSArray *)testCommands uutConsole:(Communication *)uutConsole wcbConsole:(Communication *)wcbConsole;
+(NSString *)communicationWithCommands:(NSArray *)testCommands key:(NSString *)key;
@end
