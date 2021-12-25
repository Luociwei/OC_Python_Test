//
//  SplitViewController.h
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/1/17.
//  Copyright © 2020 macdev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SplitViewController : NSSplitViewController

- (void)expandSidebarWithIndexOfSplitViewItems:(int)index;

- (void)collapseSidebarWithIndexOfSplitViewItems:(int)index;

- (void)setFixedWidth:(CGFloat)width indexOfSplitViewItems:(int)index;

@end
