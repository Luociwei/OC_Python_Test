//
//  LogFile.m
//  iPortTest
//
//  Created by Zaffer.yang on 3/22/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "LogFile.h"


@implementation LogFile
static NSDate *startTime = nil;
static bool isCloseLog = false;

+(void)getDebugLogStatus:(BOOL)closeLog{
    isCloseLog=closeLog;
}

+ (NSString*)CurrentTimeForFile{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-HH-mm-ss"];
    NSString* currenttime = [formatter stringFromDate:[NSDate date]];
    return currenttime;
}

+ (NSString*)CurrentDateForLocalCSV{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    NSString* currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}

+ (NSString*)CurrentTimeForLog{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss.SSSSS"];
    NSString* currenttime = [formatter stringFromDate:[NSDate date]];
    return currenttime;
}


+(void)AddLog:(NSString*)logFolder FileName:(NSString*)filename Content:(NSString*)str currenttime:(NSString *)currenttime{
    //Create the file
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    if (!currenttime.length) {
        //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
        currenttime=[formatter stringFromDate:[NSDate date]];
    }
    
    if ([logFolder isEqualToString:DebugFOLDER]) {
        if (isCloseLog) {
            return;
        }
        if (startTime == nil)
        {
            startTime = [NSDate date];
        }
        
        currenttime = [formatter stringFromDate:startTime];
    }
    
    //NSString* currenttime = [formatter stringFromDate:startTime];
    
    NSString * logPath = [logFolder stringByAppendingPathComponent:currenttime];
    
    NSString*filepath = [logPath stringByAppendingPathComponent:filename];
    if (![[NSFileManager defaultManager]fileExistsAtPath:logPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
    }
    
    if (![filename containsString:@".csv"]) {
        str = [NSString stringWithFormat:@"%@\n",str];
    }
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    //Write to the file
    NSFileHandle *fileWrite=[NSFileHandle fileHandleForUpdatingAtPath:filepath];
    @synchronized (fileWrite) {
        if (!([filename isEqualToString:DEFAULCONFIG]
              ||[filename isEqualToString:USERCONFIG])) {
            [fileWrite seekToEndOfFile];
        }
        [fileWrite writeData:data];
        [fileWrite closeFile];
    }
}


+(void)AddLog:(NSString*)logFolder FileName:(NSString*)filename Content:(NSString*)str{
    //Create the file
    
    [self AddLog:logFolder FileName:filename Content:str currenttime:nil];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
//    NSString* currenttime=[formatter stringFromDate:[NSDate date]];
//    if ([logFolder isEqualToString:DebugFOLDER]) {
//        if (isCloseLog) {
//            return;
//        }
//        if (startTime == nil)
//        {
//            startTime = [NSDate date];
//        }
//
//        currenttime = [formatter stringFromDate:startTime];
//    }
//
//    //NSString* currenttime = [formatter stringFromDate:startTime];
//
//    NSString * logPath = [logFolder stringByAppendingPathComponent:currenttime];
//
//    NSString*filepath = [logPath stringByAppendingPathComponent:filename];
//    if (![[NSFileManager defaultManager]fileExistsAtPath:logPath]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
//        [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
//    }
//
//    if (![filename containsString:@".csv"]) {
//        str = [NSString stringWithFormat:@"%@\n",str];
//    }
//
//    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//
//    //Write to the file
//    NSFileHandle *fileWrite=[NSFileHandle fileHandleForUpdatingAtPath:filepath];
//    @synchronized (fileWrite) {
//        if (!([filename isEqualToString:DEFAULCONFIG]
//              ||[filename isEqualToString:USERCONFIG])) {
//            [fileWrite seekToEndOfFile];
//        }
//        [fileWrite writeData:data];
//        [fileWrite closeFile];
//    }
}

+ (NSString*)renameLogFile: (NSString*)logfile OldKey:(NSString*)oldkey NewKey:(NSString*)newkey{
    NSString *newlogFile = [NSString stringWithString:[logfile stringByReplacingOccurrencesOfString:oldkey withString:newkey]];
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileMan moveItemAtPath:logfile toPath:newlogFile error:&error]){
        return logfile;
    }
    
    return newlogFile;
}

@end
