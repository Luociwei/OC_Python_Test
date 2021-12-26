//
//  Account.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 07/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

+ (void)saveAccountWithResult:(BOOL)result sn:(NSString *)sn;

+ (NSString *)getAccountWithResult:(BOOL)result;

+(NSString *)getTestTotalCount;

+(float)getTestYield;

+ (void)clearAccount;

@end
