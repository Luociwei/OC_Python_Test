//
//  PowerCommuioncation.h
//  test
//
//  Created by 罗词威 on 10/06/18.
//  Copyright © 2018年 luocw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerCommuioncation : NSObject
+(BOOL)connectPowerSupply;
+(BOOL)write:(NSString *)string;
+(NSString *)read;
+(BOOL*)query:(NSString *)str output:(NSString **)ostr;
@end
