//
//  NSDate+Extension.h
//  aaa
//
//  Created by 罗词威 on 28/04/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+(NSString *)cw_dateTime;

+(NSString *)cw_dateTimeWithMicrosecond;

+(time_t)cw_Time_tSince1970;

@end
