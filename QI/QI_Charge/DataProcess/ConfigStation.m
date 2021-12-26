//
//  configStation.m
//  Callisto_Charge
//
//  Created by luocw on 04/07/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import "ConfigStation.h"
#import "CSVLog.h"

static NSString *_plistFilePath;
static  NSMutableDictionary *_stationPlist;

@implementation ConfigStation

+(void)load
{

    [self configFile];
//    _plistFilePath = [[NSBundle mainBundle] pathForResource:@"ArcasStationInfo" ofType:@"plist"];
//    _stationPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:_plistFilePath];
}

+(void)configFile
{
    _plistFilePath=[CSVLog createConfigFile];
    NSString *content= [NSString stringWithContentsOfFile:_plistFilePath encoding:NSUTF8StringEncoding error:nil];
    if (!content.length) {
        NSString *appPlistPath = [[NSBundle mainBundle] pathForResource:@"ArcasStationInfo" ofType:@"plist"];
        _stationPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:appPlistPath];
        [_stationPlist writeToFile:_plistFilePath atomically:YES];
    }else{
        _stationPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:_plistFilePath];
    }
}

+(NSMutableDictionary *)getSationPlist
{
    return _stationPlist;
}

+(void)updateQI1PortName:(NSString *)QI1PortName QI2PortName:(NSString *)QI2PortName station:(NSString *)staionName fixtureID:(NSString *)fixtureID
{
    [self configFile];
    _stationPlist[@"QI1PortName"] = QI1PortName;
    _stationPlist[@"QI2PortName"] = QI2PortName;
    _stationPlist[@"stationTestItem"] = staionName;
    if (fixtureID.length) {
        _stationPlist[@"fixtureID"] =fixtureID;
    }
    //    _stationPlist[@"QI1PortName"] = @"QI1PortName";
    //     _stationPlist[@"QI2PortName"] = @"QI2PortName";
    
    [_stationPlist writeToFile:_plistFilePath atomically:YES];
    
}
+(NSString *)stationTestItem
{
    return _stationPlist[@"stationTestItem"];
}
+(NSString *)BoardVersion
{
    return _stationPlist[@"BoardVersion"];
}

+(NSString *)QI1PortName
{
    return _stationPlist[@"QI1PortName"];
}
+(NSString *)QI2PortName
{
    return _stationPlist[@"QI2PortName"];
}

+(NSString *)UUT1PortName
{
    return _stationPlist[@"UUT1PortName"];
}
+(NSString *)UUT2PortName
{
    return _stationPlist[@"UUT2PortName"];
}
+(NSString *)PDCAStationID
{
    return _stationPlist[@"PDCAStationID"];
}
+(NSString *)PDCAStationSN
{
    return _stationPlist[@"PDCAStationSN"];
}
+(NSString *)softwareVersion
{
    return _stationPlist[@"softwareVersion"];
}
+(NSString *)productionName
{
    return _stationPlist[@"productionName"];
}
+(NSString *)fixtureID
{
    return _stationPlist[@"fixtureID"];
}

+(BOOL)isDebugLog
{
    return [_stationPlist[@"isDebugLog"] boolValue];
}

+(BOOL)isPudding
{
    return [_stationPlist[@"isPudding"] boolValue];
}
+(void)updatePuddingState:(BOOL)isPudding
{
     [self configFile];
    _stationPlist[@"isPudding"] = [NSString stringWithFormat:@"%d",isPudding];
    
    [_stationPlist writeToFile:_plistFilePath atomically:YES];
    
}
+(BOOL)isBobcat
{
    return [_stationPlist[@"isBobcat"] boolValue];
    
}
+(void)updateBobcat:(BOOL)isBobcat
{
     [self configFile];
    _stationPlist[@"isBobcat"] = [NSString stringWithFormat:@"%d",isBobcat];
    
    [_stationPlist writeToFile:_plistFilePath atomically:YES];
    
}
//stationTestItem = [StationInfo objectForKey:@"stationTestItem"];
//PDCAStationID = [StationInfo objectForKey:@"PDCAStationID"];
//PDCAStationSN = [StationInfo objectForKey:@"PDCAStationSN"];
//softwareVersion = [StationInfo objectForKey:@"softwareVersion"];
//productionName = [StationInfo objectForKey:@"productionName"];
//fixtureID = [StationInfo objectForKey:@"fixtureID"];
//QI1PortName = [StationInfo objectForKey:@"QI1PortName"];
//QI2PortName = [StationInfo objectForKey:@"QI2PortName"];
//UUT1PortName = [StationInfo objectForKey:@"UUT1PortName"];
//UUT2PortName = [StationInfo objectForKey:@"UUT2PortName"];
//FixturePortName = [StationInfo objectForKey:@"FixturePortName"];

@end
