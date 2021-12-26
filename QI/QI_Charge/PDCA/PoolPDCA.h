//
//  PoolPDCA.h
//  PoolingTest
//
//  Created by tod on 6/16/14.
//  Copyright (c) 2014 MINI-007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "InstantPudding_API.h"
#import "AppDelegate.h"

@interface PoolPDCA : NSObject
{
   	IP_UUTHandle UID;
    IP_API_Reply reply;
}
@property(readwrite)NSString *ErrorInfo;
@property(readwrite)BOOL isPDCAStart;
@property(readwrite)BOOL hasWritePDCAAtrribute;

-(BOOL) puddingCheck;

-(BOOL)Bobcat_Check:(const char *)str_SN
          strSWName:(const char *)strSWName
      str_SWVersion:(const char *)str_SWVersion
           colorKey:(const char *)colorKey;

-(NSString*)Bobcat_Check_B435:(const char *)str_SN strSWName:(const char *)strSWName str_SWVersion:(const char *)str_SWVersion FixtureID:(int)fixtureID SiteID:(int)siteID;

-(bool)AdjustPDCAData:(const char *)unitSN
              SWName:(const char *)swName
           SWVersion:(const char *)swVersion
           StationSN:(const char *)stationSN
            PDCAData:(NSArray *)pdcaData
             FailMes:(const char *)failMes
            Priority:(NSString *)priority
           StartTime:(time_t)starttime
             EndTime:(time_t)endtime
                 file:(NSString*)sZip
            FixtureID:(int)fixtureID
               SiteID:(int)siteID
CONTROL_BITS_TO_CHECK:(NSString*)CONTROL_BITS_TO_CHECK
CONTROL_BITS_STATION_NAMES:(NSString*)CONTROL_BITS_STATION_NAMES
STATION_FAIL_COUNT_ALLOWED:(int)STATION_FAIL_COUNT_ALLOWED;


-(BOOL)addAttributeUpload:(NSString*)string station:(NSString*)station;

-(BOOL) AddBlob:(NSString*) fileName FilePath:(NSString*) filePath;

-(void) UIDCancel;

-(bool)uploadBobcatFailPDCAData:(const char *)unitSN
               SWName:(const char *)swName
            SWVersion:(const char *)swVersion
            StationSN:(const char *)stationSN
             PDCAData:(NSArray *)pdcaData
              FailMes:(const char *)failMes
             Priority:(NSString *)priority
            StartTime:(time_t)starttime
              EndTime:(time_t)endtime
                 file:(NSString*)sZip
            FixtureID:(int)fixtureID
               SiteID:(int)siteID;

@end
