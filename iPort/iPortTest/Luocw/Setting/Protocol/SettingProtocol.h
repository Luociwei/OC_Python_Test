//
//  SettingProtocol.h
//  iPort
//
//  Created by ciwei luo on 2019/4/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingMode.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SettingProtocol <NSObject>

-(void)saveClick:(SettingMode *)settingMode;
-(void)cleanTestCountClick;

@end

NS_ASSUME_NONNULL_END
