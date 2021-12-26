//
//  configStation.h
//  Callisto_Charge
//
//  Created by luocw on 04/07/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigStation : NSObject

+(NSString *)stationTestItem;
+(NSMutableDictionary *)getSationPlist;
+(NSString *)PDCAStationID;
+(NSString *)PDCAStationSN;
+(NSString *)softwareVersion;
+(NSString *)productionName;
+(NSString *)fixtureID;

+(NSString *)QI1PortName;

+(NSString *)QI2PortName;
+(NSString *)BoardVersion;
+(NSString *)UUT1PortName;

+(NSString *)UUT2PortName;

+(BOOL)isDebugLog;
+(BOOL)isPudding;
+(void)updateBobcat:(BOOL)isBobcat;
+(void)updatePuddingState:(BOOL)isPudding;
+(BOOL)isBobcat;
+(void)updateQI1PortName:(NSString *)QI1PortName QI2PortName:(NSString *)QI2PortName station:(NSString *)staionName fixtureID:(NSString *)fixtureID;

@end
