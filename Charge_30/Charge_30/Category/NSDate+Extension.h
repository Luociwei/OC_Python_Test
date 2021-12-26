//
//  NSDate+Extension.h
//  aaa
//
//  Created by luocw on 28/04/18.
//  Copyright © 2018年 luocw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+(NSString *)yn_dateTime;

+(NSString *)yn_dateTimeWithMicrosecond;

+(time_t)yn_Time_tSince1970;

@end
