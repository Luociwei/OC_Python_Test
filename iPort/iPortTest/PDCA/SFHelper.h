//
//  SFHelper.h
//  SippyCup
//
//  Created by Kai Huang on 9/16/15.
//  Copyright (c) 2015 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GpuResult.h"
@interface SFHelper : NSObject

+ (bool) checkDUTSN_SFIS:(NSString *)dut_sn;
+ (bool) checkCarrierSN_SFIS:(NSString *)carrier_sn;
+ (bool) checkDUTSN_SFIS:(NSString *)dut_sn result:(int *)isUOP;
+(NSString *)getNumberOfGPUsResponseWithSN:(NSString *)dut_sn logFile:(NSString *)logFile;
+ (bool) pairDUT:(NSString *)dut_sn toCarrier:(NSString *)carrier_sn result:(bool)result;
+(GpuResult *)getGPUNumWithSN_new:(NSString *)dut_sn logFile:(NSString *)logFile;
+(GpuResult *)getGPUNumWithSN:(NSString *)dut_sn logFile:(NSString *)logFile;
+ (NSString *) ghStationInfoForKey:(NSString *)key;
+ (NSString *) paramsToURLString:(NSDictionary *)dict;

+(NSInteger)getPortNumbersOfProjectWithSN:(NSString *)dut_sn logFile:(NSString *)logFile;
@end
