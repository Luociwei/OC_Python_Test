//
//  ProgressBarVC.h
//  DisplayTest
//
//  Created by ciwei luo on 2021/11/20.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExtensionConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProgressBarVC : PresentViewController
-(void)setProgressBarPercentValue:(float)percent info:(NSString *)info;
@end

NS_ASSUME_NONNULL_END
