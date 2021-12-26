//
//  SettingViewController.h
//  B435_WirelessCharge
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SettingViewControllerDelegate <NSObject>

-(void)settingViewControllerSave:(NSString *)title;

-(void)settingViewControllerBobCatClick:(NSControlStateValue)checkState;

-(void)settingViewControllerPuddingClick:(NSControlStateValue)puddingState;

@end

@interface SettingViewController : NSViewController

@property (weak) id<SettingViewControllerDelegate>delegate;

@property (readonly) BOOL puddingState;

@property (readonly) BOOL bobCheckState;

@end
