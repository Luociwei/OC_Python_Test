//
//  WindowVC.m
//  DfuDebugTool
//
//  Created by ciwei luo on 2021/2/28.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "WindowVC.h"
#import "AppDelegate.h"
#import "MainVC.h"
#import "ShowingLogVC.h"
#import "SplitViewController.h"
#import "LeftFileVC.h"


NSString *kOpenCloseViewNotification = @"OpenCloseViewNotification";
@interface WindowVC ()
@property(nonatomic,strong)NSSplitViewController *splitVC;
@end




@implementation WindowVC

- (IBAction)help:(NSButton *)sender {
    
    NSLog(@"1111");
}


-(void)windowWillClose:(NSNotification *)notification{
    [CWRedis shutDown];
    [CWZMQ shutdown];
    [super windowWillClose:notification];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self layout];
}


-(void)layout{
    
    SplitViewController *splitMainVC = [[SplitViewController alloc]init];
    
    [splitMainVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [splitMainVC.splitView setVertical:YES];
    
    NSSplitViewController *rigthSplitVC =[[NSSplitViewController alloc]init];
    [rigthSplitVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [rigthSplitVC.splitView setVertical:NO];
    
    MainVC *testPlanVC = [MainVC new];
    NSSplitViewItem *itemTestPlanVC = [NSSplitViewItem splitViewItemWithViewController:testPlanVC];
//    self.testPlanVC = testPlanVC;
    
//    NSSplitViewController *botommVC = [[NSSplitViewController alloc]init];
//    [botommVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
//    [botommVC.splitView setVertical:YES];
    ShowingLogVC *showingLogVC = [ShowingLogVC new];
    NSSplitViewItem *item3 = [NSSplitViewItem splitViewItemWithViewController:showingLogVC];
//    [botommVC addSplitViewItem:item3];
//    DebugVC *debugVC = [DebugVC new];
//    NSSplitViewItem *item4 = [NSSplitViewItem splitViewItemWithViewController:debugVC];
//    [botommVC addSplitViewItem:item4];
    
//    NSSplitViewItem *itemBotomm = [NSSplitViewItem splitViewItemWithViewController:botommVC];
    
    [rigthSplitVC addSplitViewItem:itemTestPlanVC];
    [rigthSplitVC addSplitViewItem:item3];
    
    NSSplitViewItem *item1 = [NSSplitViewItem splitViewItemWithViewController:rigthSplitVC];
    LeftFileVC *leftFileVC = [LeftFileVC new];
    NSSplitViewItem *item2 = [NSSplitViewItem splitViewItemWithViewController:leftFileVC];
    //item2.collapsed=YES;
    [splitMainVC addSplitViewItem:item2];
    [splitMainVC addSplitViewItem:item1];
    
    
    
    self.splitVC=splitMainVC;
    self.window.contentViewController = splitMainVC;
    
    
}

@end
