//
//  TestUnitData.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by gdadmin on 2018/6/30.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestUnitData : NSObject
@property (readwrite,copy) NSString * testName;
@property (readwrite,copy) NSString * min;
@property (readwrite,copy) NSString * max;
@property (readwrite,copy) NSString * unit;
@property (readwrite,copy) NSString * value;
@property (readwrite,copy) NSString * result;
@property (readwrite,copy) NSString * startTime;
@property (readwrite,copy) NSString * endTime;
@property (readwrite,copy) NSString * time;
@property (readwrite,copy) NSString * finalreult;
@property (readwrite,copy) NSString * errormsg;
@property (readwrite,copy) NSString * reply;
@property (readwrite,copy) NSString * cutResult;
-(NSString*) getData:(NSString*) attribute;
+(NSMutableArray *)initalWithPlistName:(NSString *)plistName;
@end
