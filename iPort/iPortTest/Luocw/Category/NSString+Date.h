//
//  NSString+Date.h
//  Callisto_Charge
//
//  Created by ttttttt on 2019/2/25.
//  Copyright © 2019年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Date)

+(NSString *)cw_stringFromCurrentDateTimeWithSecond;

+(NSString *)cw_stringFromCurrentDateTimeWithMicrosecond;

+(time_t)cw_Time_tSince1970;

+(NSString *)cw_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
