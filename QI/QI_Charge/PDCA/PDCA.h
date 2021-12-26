//
//  PDCA.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by luocw on 11/06/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstantPudding_API.h"

@interface PDCA : NSObject
+(BOOL)uploadDatasToPDCA:(NSString *)sn SWName:(NSString *)swName SWVersion:(NSString *)swVersion startTime:(time_t)startTime priority:(NSString *)priority key:(NSString *)uut;
@end
