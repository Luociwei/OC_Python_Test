//
//  ConfigPlist.m
//  LUXSHARE_B288_24
//
//  Created by luocw on 04/05/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//
#define ConfigName @"ChargingRackConfig"
#import "ConfigPlist.h"

static NSDictionary *configDict;

@implementation ConfigPlist

+(void)initialize
{
    NSString *configfile = [[NSBundle mainBundle] pathForResource:ConfigName ofType:@"plist"];

    configDict = [NSDictionary dictionaryWithContentsOfFile:configfile];

}

+(int)specLower
{
    return [[configDict objectForKey:@"Spec Lower Limit"] intValue];
}
+(int)specUpper
{
    return [[configDict objectForKey:@"Spec Upper Limit"] intValue];
}
+(int)stopcharge
{
    return [[configDict objectForKey:@"Stop Charging Point"] intValue];
}

+(NSString *)appSW
{
    return [@"SV-" stringByAppendingString:[configDict objectForKey:@"Software Version"]];
}

+(int)voltLimit
{
    return [[configDict objectForKey:@"voltLimit"] intValue];
}
+(int)currentLimit
{
    return [[configDict objectForKey:@"currentLimit"] intValue];
}

+(BOOL)bobcat
{
    
    return [[configDict objectForKey:@"isBobcat"] boolValue];
}
+(int)failNum
{
    return [[configDict objectForKey:@"failNum"] intValue];
}
@end
