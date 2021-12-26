//
//  CutMesTool.h
//  ChargerHost_B288
//
//  Created by luocw on 21/04/18.
//  Copyright © 2018年 ciwei Luo. All rights reserved.
//  cut message tool

#import <Foundation/Foundation.h>
@class BoardController;

@interface CutMesTool : NSObject

+(NSString *)getSerialNumber:(BoardController *)board channelIndex:(NSInteger)i tempSN:(NSString *)sntemp tunnel:(NSInteger)tunnel;

+(NSString *)getSoftwareVersion:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel;

+(NSString *)getHardwareVersion:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel;


//+(NSMutableArray *)getCurrentAndVolt1:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel;


+(NSMutableArray *)getPerAndCurrentAndVolt:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel;

+(NSString *)getLidStatus:(BoardController *)board channelIndex:(NSInteger)i;

@end
