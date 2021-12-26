

//
//  CSVLog2.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 10/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//
#import "ConfigDatas.h"
#import "CSVLog.h"
#import "NSDate+Extension.h"

typedef NS_ENUM(NSUInteger, CommandType) {
    CommandTypeSend    = 0,
    CommandTypeReceive    = 1,
    
};

static NSString *_currentFilePath;

@implementation CSVLog

+(void)createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        if (isDirectory) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
    }
}

+(void)createTestResultFile:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
//        NSMutableString *mutStr = [NSMutableString stringWithFormat:@"SN"];
//        for (NSString *name in [ConfigDatas getNameArray]) {
//            [mutStr appendString:[NSString stringWithFormat:@",%@",name]];
//        }
        NSLog(@"lcw--%lu",(unsigned long)[ConfigDatas getNameArray].count);
        NSString *mutStr = [NSString stringWithFormat:@"SN,Result,%@",[NSString cw_returnJoinStringWithArray:[ConfigDatas getNameArray]]];
        [self WriteToFile:filePath content:mutStr];
    }
}
+(void)saveCSVData:(NSString*)sn StationID:(NSString*)stationID FixtureID:(NSString*)fixtureID SiteID:(NSString*)siteID TestPassFailStatus:(NSString*)TestPassFailStatus StartTime:(NSString*)startTime EndTime:(NSString*)endTime TotalTime:(NSString*)totalTime UUTTestData:(NSMutableArray *) UUTTestData CSVFilePath:(NSString*)filePath SoftwareVersion:(NSString*)softwareVersion StationTestItem:(NSString*)stationTestItem PDCAStationID:(NSString*)PDCAStationID ProductionName:(NSString*)productionName
{
    NSFileManager *csvfileManager = [NSFileManager defaultManager];
    if (![csvfileManager fileExistsAtPath:filePath])
    {
        [csvfileManager createFileAtPath:filePath contents:nil attributes:nil];
        NSString *row0 = [NSString stringWithFormat:@"%@,%@,SoftWare Version:%@,%@",[NSString stringWithFormat:@"%@/%@", PDCAStationID,productionName],@"Innorev",softwareVersion,stationTestItem,@"EVT_OTP_V1"];
        NSString *row1 = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",@"Serial Number",@"Station ID",@"Fixture ID",@"Site ID",@"Test PASS/FAIL STATUS",@"Error Message",@"List of Failing Tests",@"StartTime",@"EndTime",@"Total Test Time"];
        NSString *row2 = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",@"Upper Limited------>",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSString *row3 = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",@"Lower Limited------>",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSString *row4 = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",@"Measurement Units------>",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        for(int i = 0 ; i <UUTTestData.count;i++)
        {
            TestUnitData* testUnitData      = [UUTTestData objectAtIndex:i];
            row1 = [row1 stringByAppendingString:[NSString stringWithFormat:@",%d_%@",i,[testUnitData getData:@"name"]]];
            row2 = [row2 stringByAppendingString:[NSString stringWithFormat:@",%@",[testUnitData getData:@"max"]]];
            row3 = [row3 stringByAppendingString:[NSString stringWithFormat:@",%@",[testUnitData getData:@"min"]]];
            row4 = [row4 stringByAppendingString:[NSString stringWithFormat:@",%@",[testUnitData getData:@"unit"]]];
        }
        NSMutableData *writer = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        [writer appendData:[[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n",row0,row1,row2,row3,row4] dataUsingEncoding:NSUTF8StringEncoding]];
        [writer writeToFile:filePath atomically:YES];
    }
    NSString *ListOfFailingTests = @"";
    for(int i = 0 ; i <UUTTestData.count;i++)
    {
        TestUnitData* testUnitData      = [UUTTestData objectAtIndex:i];
        if([[testUnitData getData:@"result"] isEqualToString:@"Fail"])
        {
            if([ListOfFailingTests isEqualToString:@""])
            {
                ListOfFailingTests = [ListOfFailingTests stringByAppendingString:[NSString stringWithFormat:@"%d_%@",i,[testUnitData getData:@"name"]]];
            }
            else
            {
                ListOfFailingTests = [ListOfFailingTests stringByAppendingString:[NSString stringWithFormat:@";%d_%@",i,[testUnitData getData:@"name"]]];
            }
        }
    }
    NSMutableData *writer = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSString *data = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",sn,stationID,fixtureID,siteID,TestPassFailStatus,TestPassFailStatus,ListOfFailingTests,startTime,endTime,totalTime];
    for(int i = 0 ; i <UUTTestData.count;i++)
    {
        TestUnitData* testUnitData      = [UUTTestData objectAtIndex:i];
        data = [data stringByAppendingString:[NSString stringWithFormat:@",%@",[testUnitData getData:@"value"]]];
    }
    data = [data stringByAppendingString:@"\n"];
    [writer appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [writer writeToFile:filePath atomically:YES];
}
+(void)saveToLogWithContent:(NSString*)contents sn:(NSString *)sn result:(BOOL)isPass
{
    
    NSString *directory2 = [NSHomeDirectory() stringByAppendingPathComponent:@"B435_Wireless_Datas"];
    [self createFile:directory2 isDirectory:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* fileName = [NSString stringWithFormat:@"%@.csv",[dateFormatter stringFromDate:[NSDate date]]];
    NSString *filePath = [directory2 stringByAppendingPathComponent:fileName];
    _currentFilePath= filePath;
    [self createTestResultFile:filePath];
    NSString *resultStr = isPass ? @"PASS" : @"FAIL";
    NSString *joincontents = [NSString stringWithFormat:@"%@,%@,%@",sn,resultStr,contents];
    [self WriteToFile:filePath content:joincontents];

    
}

+(void)saveDubegLog:(NSString *)logString
{
    [self saveLog:logString LogPath:commandLogPath];
}
//文件是否能够写
+(BOOL) fileCanWrite:(NSString*)filePath
{
    BOOL readFlag=NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager isWritableFileAtPath:filePath]) readFlag= YES;
    
    return readFlag;
}

+(void)saveLog:(NSString*)logString LogPath:(NSString*)logPath
{
    if(logPath == nil || [logPath isEqualToString:@""])
    {
        return;
    }
    
    [self createFile:logPath isDirectory:NO];
    //NSString *appendString = nil;
    
    NSString *string = [logString stringByAppendingString:@"\n" ];
    
    [self WriteToFile:logPath content:[[NSDate cw_dateTimeWithMicrosecond] stringByAppendingString:string]];
    
}

//+(BOOL)saveLogParam:(NSString*)UUTName SN:(NSString *)sn
//{
//    _UUT = UUTName;
//    return true;
//}

+(void)saveLog:(NSString*)contents commandType:(CommandType)commandType
{
  
    [self createFile:[NSHomeDirectory() stringByAppendingPathComponent:@"wirelessLog.txt"] isDirectory:NO];
    NSString *appendString = nil;
    switch (commandType) {
        case CommandTypeSend:
            appendString = @"send:";
            break;
        case CommandTypeReceive:
            appendString = @"receive:";
            break;
            
        default:
            break;
    }
    
    NSString *string = [[appendString stringByAppendingString:contents] stringByAppendingString:@"\n" ];
    
    [self WriteToFile:commandLogPath content:string];

}
+(NSString *)createConfigFile
{
    [self createFile:@"/vault" isDirectory:YES];
    NSString *directory2 = [@"/vault" stringByAppendingPathComponent:@"B435_Wireless_Config"];
    [self createFile:directory2 isDirectory:YES];
    
    NSString *configFilePath = [directory2 stringByAppendingPathComponent:@"ArcasStationInfo.plist"];
    [self createFile:configFilePath isDirectory:NO];
    
    return configFilePath;
    
}

+(BOOL)isExistSN:(NSString *)sn
{
    NSString *content = [self readFromFile:_currentFilePath];
    return [content containsString:sn];
}
+(NSString *)readFromFile:(NSString *)filePath
{
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+(void)WriteToFile:(NSString*)filePath content:(NSString*)content
{
    
    if (![self fileCanWrite:filePath]) {
        NSLog(@"the file can not be write");
        return;
    }
    @synchronized(self) {
        NSMutableData *writer = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        [writer appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [writer writeToFile:filePath atomically:YES];
    }
}
@end
