//
//  SettingMode.h
//  iPort
//
//  Created by ciwei luo on 2019/4/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingMode : NSObject
@property BOOL audit;
@property BOOL office;
@property BOOL single;
@property BOOL frist2Right;
@property BOOL isShowMapView;
@property BOOL isShowCommands;
@property BOOL isShowCard;
@property BOOL signPort;
@property BOOL queryProject;
@property BOOL checkGPU;
@property (copy)NSString *configPath;
@property (copy)NSString *updateFWPath;
+ (SettingMode *)getConfig;
+ (void)saveConfig:(SettingMode *)config;
+(void)deleteSettingModeFile;
@end

NS_ASSUME_NONNULL_END
