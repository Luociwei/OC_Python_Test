//
//  CSVLog2.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 10/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVLog : NSObject
//{
//    NSString * SN;
//    NSString * UUT;
//    NSString * LOG;
//}
//+(BOOL)saveLogParam:(NSString*)UUTName SN:(NSString *)sn;
+(BOOL)isExistSN:(NSString *)sn;
+(NSString *)createConfigFile;
+(void)saveToLogWithContent:(NSString*)contents sn:(NSString *)sn result:(BOOL)isPass;
+(NSString *)readFromFile:(NSString *)filePath;
+(void)saveLog:(NSString*)logString LogPath:(NSString*)logPath;
+(void)saveCSVData:(NSString*)sn StationID:(NSString*)stationID FixtureID:(NSString*)fixtureID SiteID:(NSString*)siteID TestPassFailStatus:(NSString*)TestPassFailStatus StartTime:(NSString*)startTime EndTime:(NSString*)endTime TotalTime:(NSString*)totalTime UUTTestData:(NSMutableArray *) UUTTestData CSVFilePath:(NSString*)filePath SoftwareVersion:(NSString*)softwareVersion StationTestItem:(NSString*)stationTestItem PDCAStationID:(NSString*)PDCAStationID ProductionName:(NSString*)productionName;
//
+(void)saveDubegLog:(NSString *)logString;
//+(void)saveReceiveCommand:(NSString*)contents;
@end
