//
//  TabViewController.m
//  B435_WirelessCharge
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "TabViewController.h"
#import "MainTestViewController.h"
#import "SettingViewController.h"
#import "ChangeListViewController.h"
@interface TabViewController ()

@end

@implementation TabViewController
-(instancetype)init
{
    if (self = [super init]) {
        self.tabStyle = NSTabViewControllerTabStyleUnspecified;
        self.view.frame = CGRectMake(0, 0, 1250, 850);
        //Do view setup here.
        MainTestViewController *testVC = [[MainTestViewController alloc]init];
        
        testVC.title = @"WC_OTP/NOOTP_Arcas";
        [self addChildViewController:testVC];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    [super tabView:tabView willSelectTabViewItem:tabViewItem];
    NSLog(@"willSelectTabViewItem %@",tabViewItem.label);
//    if ([tabViewItem.label isEqualToString:@"setting"]) {
//        self.selectedTabViewItemIndex = 1;
//    }
}
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    [super tabView:tabView didSelectTabViewItem:tabViewItem];
    NSLog(@"didSelectTabViewItem %@",tabViewItem.label);
//    if ([tabViewItem.label isEqualToString:@"setting"]) {
//        self.selectedTabViewItemIndex = 1;
//    }
}

@end
