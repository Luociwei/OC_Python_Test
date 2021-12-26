//
//  SettingMode.m
//  iPort
//
//  Created by ciwei luo on 2019/4/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "SettingMode.h"
#import "NSString+File.h"
#import "CWFileManager.h"

@implementation SettingMode

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.audit = [aDecoder decodeIntegerForKey:@"audit"];
        self.office = [aDecoder decodeIntegerForKey:@"office"];
        self.single = [aDecoder decodeIntegerForKey:@"single"];
        self.frist2Right = [aDecoder decodeIntegerForKey:@"frist2Right"];
        self.isShowMapView = [aDecoder decodeIntegerForKey:@"isShowMapView"];
        self.isShowCommands = [aDecoder decodeIntegerForKey:@"isShowCommands"];
        self.isShowCard = [aDecoder decodeIntegerForKey:@"isShowCard"];
        self.configPath=[aDecoder decodeObjectForKey:@"configPath"];;
        self.updateFWPath=[aDecoder decodeObjectForKey:@"updateFWPath"];
        
        self.signPort=[aDecoder decodeIntegerForKey:@"signPort"];
        self.queryProject=[aDecoder decodeIntegerForKey:@"queryProject"];
        self.checkGPU=[aDecoder decodeIntegerForKey:@"checkGPU"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.audit forKey:@"audit"];
    [aCoder encodeInteger:self.office forKey:@"office"];
    [aCoder encodeInteger:self.single forKey:@"single"];
    [aCoder encodeInteger:self.frist2Right forKey:@"frist2Right"];
    [aCoder encodeInteger:self.isShowMapView forKey:@"isShowMapView"];
    [aCoder encodeInteger:self.isShowCommands forKey:@"isShowCommands"];
    [aCoder encodeInteger:self.isShowCard forKey:@"isShowCard"];
    [aCoder encodeObject:self.configPath forKey:@"configPath"];
    [aCoder encodeObject:self.updateFWPath forKey:@"updateFWPath"];
    [aCoder encodeInteger:self.signPort forKey:@"signPort"];
    [aCoder encodeInteger:self.queryProject forKey:@"queryProject"];
    [aCoder encodeInteger:self.checkGPU forKey:@"checkGPU"];
}

//类方法，运用NSKeyedArchiver归档数据
+ (void)saveConfig:(SettingMode *)config
{
    //NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *docPath = [NSString getUserPath];
    NSString *fileName =[self getSettingFileName];
    NSString *path=[docPath stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:config toFile:path];
}

//类方法，使用NSKeyedUnarchiver解档数据
+ (SettingMode *)getConfig
{
//    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *docPath = [NSString getUserPath];
    NSString *fileName =[self getSettingFileName];
    NSString *path=[docPath stringByAppendingPathComponent:fileName];

    SettingMode *config = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return config;
}

+(NSString *)getSettingFileName
{
    NSString *version_bundle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
   // NSString *fileName = [NSString stringWithFormat:@"SettingMode_%@.plist",version_bundle];
   // NSString *fileName = @"SettingMode_1.50.plist";
    return @"SettingMode_1.85.plist";
}

+(void)deleteSettingModeFile{
//    NSString *docPath = [NSString getUserPath];
//    NSString *filePath1= [docPath stringByAppendingPathComponent:@"SettingMode_1.50.plist"];
//    [CWFileManager cw_removeItemAtPath:filePath1];
    
    //[self deleteSettingModeFile:[self getSettingFileName]];
}

+(void)deleteSettingModeFile:(NSString *)file{
    NSString *docPath = [NSString getUserPath];
    NSString *filePath= [docPath stringByAppendingPathComponent:file];
    [CWFileManager cw_removeItemAtPath:filePath];
}

+(void)load{
//    NSString *docPath = [NSString getUserPath];
//    NSString *filePath= [docPath stringByAppendingPathComponent:@"SettingMode.plist"];
//    [CWFileManager cw_removeItemAtPath:filePath];
    [self deleteSettingModeFile:@"SettingMode.plist"];
    [self deleteSettingModeFile:@"SettingMode_1.50.plist"];
    [self deleteSettingModeFile:@"SettingMode_1.60.plist"];
    [self deleteSettingModeFile:@"SettingMode_1.72.plist"];
    
}
@end
