//
//  NSDate+Extension.m
//  aaa
//
//  Created by luocw on 28/04/18.
//  Copyright © 2018年 luocw. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

//get current time to show in the display window
+ (NSString *)nowTimeWithMicrosecond:(BOOL)isMicrosecond
{
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = isMicrosecond ? @"yyyy-MM-dd hh:mm:ss:SS" : @"yyyy-MM-dd hh:mm:ss";
    [outputFormatter setDateFormat:dateFormat];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    //    [outputFormatter release]; //enable ARC,it will automatically insert release sentence in correct place
    return newDateString;
}

+(NSString *)yn_dateTime
{
   return [self nowTimeWithMicrosecond:NO];
}

+(NSString *)yn_dateTimeWithMicrosecond
{
    return [self nowTimeWithMicrosecond:YES];
}

+(time_t)yn_Time_tSince1970
{
    time_t tempTime;
    time(&tempTime);
    return tempTime;
}


@end
