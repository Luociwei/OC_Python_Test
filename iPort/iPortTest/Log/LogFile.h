//
//  LogFile.h
//  iPortTest
//
//  Created by Zaffer.yang on 3/22/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOGFOLDER @"/vault/iPortLog"
#define LOGSNDER @"/vault/iPortLog/SNLog"
#define DebugFOLDER @"/vault/iPortLog/iPort_Debug"
#define LOGROOTFOLDER @"/vault/iPortLog"
#define URATFILENAME @"Uratlog.txt"
#define CSVFILENAME @"iPort.csv"
#define ALLCSVFILE @"/vault/iPortLog/iPort_all_csvLog"
#define RunTimeLog @"runtime.txt"
#define DEFAULCONFIG @"iPort_DefaultConfig.csv"
#define USERCONFIG @"iPort_UserConfig.csv"

@interface LogFile : NSObject
+(void)getDebugLogStatus:(BOOL)closeLog;
+ (NSString*)CurrentTimeForFile;
+ (NSString*)CurrentTimeForLog;
+ (NSString*)CurrentDateForLocalCSV;
+ (void)AddLog:(NSString*)logFolder FileName:(NSString*)filename Content:(NSString*)str;
+(void)AddLog:(NSString*)logFolder FileName:(NSString*)filename Content:(NSString*)str currenttime:(NSString *)currenttime;
+ (NSString*)renameLogFile: (NSString*)logfile OldKey:(NSString*)oldkey NewKey:(NSString*)newkey;
@end
