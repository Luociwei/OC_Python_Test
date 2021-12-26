//
//  SettingWC.h
//  iPort
//
//  Created by ciwei luo on 2019/4/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SettingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingWC : NSWindowController
-(void)config;
@property (weak) id<SettingProtocol>delegate;
@property (copy,readonly) SettingMode *settingMode;
@property BOOL isRootPwd;
- (void)changeBtnState:(BOOL)rootPwd;
@property (weak) IBOutlet NSButton *queryProject;
@property (weak) IBOutlet NSButton *signPortBtn;
@property (weak) IBOutlet NSButton *checkGpu;

@property (strong,nonatomic) NSArray *TeEngArr;

@end

NS_ASSUME_NONNULL_END
