

//
//  CSVLog2.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 10/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//
#import "CSVLog2.h"
#import "NSDate+Extension.h"
#define commandLogPath [@"/vault" stringByAppendingPathComponent:@"B288DebugLog.txt"]

typedef NS_ENUM(NSUInteger, CommandType) {
    CommandTypeSend    = 0,
    CommandTypeReceive    = 1,
    
};

static NSString *_currentFilePath;

@implementation CSVLog2

+(BOOL)createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory
{
    BOOL isExitFile = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        if (isDirectory) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        isExitFile = NO;
    }
    
    return isExitFile;
    //[self createFile:filePath isDirectory:isDirectory isNeedTime:NO];
}



//+(void)createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory isNeedTime:(BOOL)isNeedTime
//{
//    if (isNeedTime) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"hhmmssSS"];
//        filePath = [NSString stringWithFormat:@"%@_%@",filePath,[dateFormatter stringFromDate:[NSDate date]]];
//    }
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:filePath]) {
//        if (isDirectory) {
//            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }else{
//            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
//        }
//    }
//}

//文件是否能够写
+(BOOL)fileCanWrite:(NSString*)filePath
{
    BOOL readFlag=NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager isWritableFileAtPath:filePath]) readFlag= YES;
    
    return readFlag;
}


+(void)saveSendCommand:(NSString*)contents sn:(NSString *)sn
{
   
    if (!sn.length) {
        return;
    }
    NSString *directory1 = [@"/vault" stringByAppendingPathComponent:@"B288_test_Logs"];
    [self createFile:directory1 isDirectory:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* directory2 = [directory1 stringByAppendingPathComponent:[dateFormatter stringFromDate:[NSDate date]]];
    [self createFile:directory2 isDirectory:YES];
    
    
    NSString *filePath = [directory2 stringByAppendingPathComponent:sn];
    //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:sn];
    //[self createFile:filePath isDirectory:NO];
    [self createFile:filePath isDirectory:NO];
    //NSString *appendString = nil;
    NSString *string = [contents stringByAppendingString:@"\n" ];
    
    [self WriteToFile:filePath content:[[NSDate yn_dateTimeWithMicrosecond] stringByAppendingString:string]];
    
}
+(void)saveSendCommand:(NSString*)contents
{
    
    [self createFile:commandLogPath isDirectory:NO];
    //NSString *appendString = nil;
    
    NSString *string = [contents stringByAppendingString:@"\n" ];
    
    [self WriteToFile:commandLogPath content:[[NSDate yn_dateTimeWithMicrosecond] stringByAppendingString:string]];
    
}

+(void)saveCurrnetAndR_contact:(NSString*)contents
{
    
    NSString *directory = [@"/vault" stringByAppendingPathComponent:@"B288_Currnet&R_contact_Logs"];
    [self createFile:directory isDirectory:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fileName = [NSString stringWithFormat:@"%@.csv",[dateFormatter stringFromDate:[NSDate date]]];
    NSString* filePath = [directory stringByAppendingPathComponent:fileName];
    //[self createFile:directory2 isDirectory:NO];
    
    
   // NSString *filePath = [directory2 stringByAppendingPathComponent:sn];
    //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:sn];
    //[self createFile:filePath isDirectory:NO];
    BOOL isExit = [self createFile:filePath isDirectory:NO];
    //NSString *appendString = nil;
    NSString *string;
    if (!isExit) {
       NSString *titleString = @"SerialNumber,DateTime,Slot,Software_Version,Hardware_Version,Current,R_contact\n";
        string = [titleString stringByAppendingString:[contents stringByAppendingString:@"\n"]];
    }else{
        string = [contents stringByAppendingString:@"\n" ];
    }

    [self WriteToFile:filePath content:string];
    
}
+(void)save
{
    NSString *string = @"SerialNumber,DateTime,Slot,Software_Version,Hardware_Version,Current,Voltage,Percentage,Lid\n";
//    [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
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
      
        
        NSMutableData *writer = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        [writer appendData:[[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n",row0,row1,row2,row3,row4] dataUsingEncoding:NSUTF8StringEncoding]];
        [writer writeToFile:filePath atomically:YES];
    }
    NSString *ListOfFailingTests = @"";
    
    
    NSMutableData *writer = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSString *data = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",sn,stationID,fixtureID,siteID,TestPassFailStatus,TestPassFailStatus,ListOfFailingTests,startTime,endTime,totalTime];
  
    
    data = [data stringByAppendingString:@"\n"];
    [writer appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [writer writeToFile:filePath atomically:YES];
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
