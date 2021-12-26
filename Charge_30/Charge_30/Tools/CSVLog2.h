//
//  CSVLog2.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 10/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVLog2 : NSObject
+(BOOL)isExistSN:(NSString *)sn;
+(void)saveToLogWithContent:(NSString*)contents sn:(NSString *)sn result:(BOOL)isPass;
+(NSString *)readFromFile:(NSString *)filePath;
+(void)saveSendCommand:(NSString*)contents;
+(void)saveSendCommand:(NSString*)contents sn:(NSString *)sn;
//
+(void)saveCurrnetAndR_contact:(NSString*)contents;
//+(void)saveReceiveCommand:(NSString*)contents;
@end
