//
//  ConfigPlist.h
//  LUXSHARE_B288_24
//
//  Created by luocw on 04/05/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigPlist : NSObject
+(int)specLower;
+(int)specUpper;
+(int)stopcharge;
+(NSString *)appSW;
+(int)voltLimit;
+(int)currentLimit;
//+(BOOL)bobcat;
+(int)failNum;
@end
