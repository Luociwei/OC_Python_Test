//
//  NSString+Date.m
//  Callisto_Charge
//
//  Created by ttttttt on 2019/2/25.
//  Copyright © 2019年 Vicky Luo. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

//get current time to show in the display window
+ (NSString *)cw_nowTimeWithMicrosecond:(BOOL)isMicrosecond
{
    
    NSString *dateFormat = isMicrosecond ? @"yyyy-MM-dd hh:mm:ss:SS" : @"yyyy-MM-dd hh:mm:ss";
    
    NSString *newDateString = [self cw_stringFromDate:[NSDate date] dateFormat:dateFormat];
    
    return newDateString;
}

+(NSString *)cw_stringFromCurrentDateTime
{
    return [self cw_stringFromDate:[NSDate date] dateFormat:@"yyyy-MM-dd"];
}

+(NSString *)cw_stringFromCurrentDateTimeWithSecond
{
    return [self cw_nowTimeWithMicrosecond:NO];
}

+(NSString *)cw_stringFromCurrentDateTimeWithMicrosecond
{
    return [self cw_nowTimeWithMicrosecond:YES];
}

+(time_t)cw_Time_tSince1970
{
    time_t tempTime;
    time(&tempTime);
    return tempTime;
}

+(NSString *)cw_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    if (!dateFormat.length) {
        dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}



@end
