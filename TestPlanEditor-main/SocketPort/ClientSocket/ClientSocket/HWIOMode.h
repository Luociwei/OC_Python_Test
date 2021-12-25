//
//  HWIOMode.h
//  Xavier_Tool
//
//  Created by ciwei luo on 2019/7/4.
//  Copyright © 2019 ___Intelligent Automation___. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWIOModeAI : NSObject
@property (copy)NSString *fullname;
@property (copy)NSString *itemname;
@property (copy)NSString *iovalue;
@property (copy)NSString *channel;
@property (copy)NSString *gain;
@property (copy)NSString *unit;
@property (copy)NSString *range;
@property (copy)NSString *gnd;
@end

@interface HWIOModeRelay : NSObject
@property (copy)NSString *fullname;
@property (copy)NSString *itemname;
@property (copy)NSString *iovalue;
@property (copy)NSString *dac2;
@property (copy)NSString *R_value;
@end

NS_ASSUME_NONNULL_END
