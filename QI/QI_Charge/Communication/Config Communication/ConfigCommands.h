//
//  ConfigCommands.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 02/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import <CommonCrypto/CommonCryptor.h>

#import <Security/Security.h>
@class TestCommandModel,Communication;

@interface ConfigCommands : NSObject
{

}
//+(void)configCommandsSendCmd:(NSString *)cmd;
//+(NSString *)configCommandsGetControlBoardReply:(NSArray *)array;
+(NSString *)communicationWithCommands:(NSArray *)testCommands uutConsole:(Communication *)uutConsole wcbConsole:(Communication *)wcbConsole  LogPath:(NSString*)logPath;
+(NSArray *)communicationWithCommands:(NSArray *)testCommands key:(NSString *)key LogPath:(NSString*)logPath ResultForWitreCB:(BOOL*)resultForWitreCB UUTTestData:(NSMutableArray *) UUTTestData bobCatCheck:(BOOL)bobCatCheck;
+(void)configCommands_init:(NSString *)QI1PortName_in QI2PortName:(NSString*)QI2PortName_in UUT1PortName:(NSString*)UUT1PortName_in UUT2PortName:(NSString*)UUT2PortName_in PythonOpenCommand:(NSString*)pythonOpenCommand_in OverlayVersion:(NSString*)OverlayVersion_in;
+(void)unnormalStop:(NSString *)key  LogPath:(NSString*)logPath;
+(void)openPowerSupply:(NSString*)NOOTPorOTP uut1Check:(BOOL)uut1Check uut2Check:(BOOL)uut2Check;
+(void)closePowerSupply;
+(NSString*)GetTimestamp;
+(NSString*)getPassCBKey:(Communication*)port LogPath:(NSString*)logPath;
+(BOOL)getNonsense:(unsigned char *)nonsense error:(NSString *)error Port:(Communication*)unitPort LogPath:(NSString*)logPath Result:(NSString**)nonsense;
+(NSString*) intToHEXString:(int)str_int;
+(void)setCBInfo:(NSString*)lastCBStation_in thisCBStation:(NSString*)thisCBStation_in STATION_FAIL_COUNT_ALLOWED:(int)STATION_FAIL_COUNT_ALLOWED_in STATION_SET_CONTROL_BIT_ON_OFF:(BOOL)STATION_SET_CONTROL_BIT_ON_OFF_in CONTROL_BITS_TO_CHECK_ON_OFF:(BOOL)CONTROL_BITS_TO_CHECK_ON_OFF_in AuditMode:(BOOL)auditMode;
+(NSString *)readWriteCB:(Communication*)port Command:(NSString *)command EndStr:(NSString*)endStr LogPath:(NSString*)logPath ResultForWitreCB:(BOOL*)resultForWitreCB;
+(void)closeCHPowerSupply:(int)uutNum;
@end
