//
//  Account.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 07/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "Account.h"
#import "CSVLog.h"

@implementation Account

+(void)load
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"llll%f",[[defaults objectForKey:time_key] timeIntervalSinceNow]);
    if ([defaults objectForKey:time_key] == nil) {
        [defaults setObject:[NSDate date] forKey:time_key];
    }else{
        
        if ([[defaults objectForKey:time_key] timeIntervalSinceNow] < -60*60*24*2) {
            [self clearAccount];
        }
    }
 
}

+ (void)saveAccountWithResult:(BOOL)result sn:(NSString *)sn
{
    @synchronized(self) {
        
        //if ([CSVLog isExistSN:sn]) {
       //     return;
       // }
        NSString *count = result ? testPassCount : testFailCount;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [self getAccountWithResult:result];
        
        [defaults setObject:[NSString stringWithFormat:@"%ld",[str integerValue]+1] forKey:count];
        
        
        [defaults synchronize];
    }
}

+ (NSString *)getAccountWithResult:(BOOL)result
{
    @synchronized(self) {
        NSString *count = result ? testPassCount : testFailCount;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *passCount = [defaults objectForKey:count];
        if (passCount == nil) {
            passCount = @"0";
        }
        return passCount;
    }
    
}

+(NSString *)getTestTotalCount
{
    NSString *passCount = [self getAccountWithResult:YES];
    NSString *failCount = [self getAccountWithResult:NO];
    NSInteger totalCount = [passCount integerValue] + [failCount integerValue];
    return [NSString stringWithFormat:@"%ld",totalCount];
}

+(float)getTestYield
{
    NSString *passCount = [self getAccountWithResult:YES];

    NSString *totalCount = [self getTestTotalCount];
    if ([totalCount intValue] <= 0) {
        return 0;
    }
    float testYield = [passCount floatValue] / [totalCount floatValue];
    //return [NSString stringWithFormat:@"%.2f",testYield];
    return testYield * 100;
}


+ (void)clearAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:testPassCount];
    [defaults removeObjectForKey:testFailCount];
    [defaults removeObjectForKey:time_key];
}

@end
