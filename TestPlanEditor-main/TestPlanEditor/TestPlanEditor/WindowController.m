//
//  WindowController.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/1/17.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "WindowController.h"
#import "DebugVC.h"
#import "TestPlanVC.h"
#import "ShowingLogVC.h"
#import "SplitViewController.h"
#import "LeftFileVC.h"
NSString *kOpenCloseViewNotification = @"OpenCloseViewNotification";
@interface WindowController ()

@property(nonatomic,strong)NSSplitViewController *splitVC;
@property(nonatomic,strong)TestPlanVC *testPlanVC;

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    
    [self layout2];
}


-(void)layout2{
    
    SplitViewController *splitMainVC = [[SplitViewController alloc]init];
    
    [splitMainVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [splitMainVC.splitView setVertical:YES];
    
    NSSplitViewController *rigthSplitVC =[[NSSplitViewController alloc]init];
    [rigthSplitVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [rigthSplitVC.splitView setVertical:NO];
    
    TestPlanVC *testPlanVC = [TestPlanVC new];
    NSSplitViewItem *itemTestPlanVC = [NSSplitViewItem splitViewItemWithViewController:testPlanVC];
    self.testPlanVC = testPlanVC;
    
    NSSplitViewController *botommVC = [[NSSplitViewController alloc]init];
    [botommVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [botommVC.splitView setVertical:YES];
    ShowingLogVC *showingLogVC = [ShowingLogVC new];
    NSSplitViewItem *item3 = [NSSplitViewItem splitViewItemWithViewController:showingLogVC];
    [botommVC addSplitViewItem:item3];
    DebugVC *debugVC = [DebugVC new];
    NSSplitViewItem *item4 = [NSSplitViewItem splitViewItemWithViewController:debugVC];
    [botommVC addSplitViewItem:item4];
    
    NSSplitViewItem *itemBotomm = [NSSplitViewItem splitViewItemWithViewController:botommVC];
    
    [rigthSplitVC addSplitViewItem:itemTestPlanVC];
    [rigthSplitVC addSplitViewItem:itemBotomm];
    
    NSSplitViewItem *item1 = [NSSplitViewItem splitViewItemWithViewController:rigthSplitVC];
    LeftFileVC *leftFileVC = [LeftFileVC new];
    NSSplitViewItem *item2 = [NSSplitViewItem splitViewItemWithViewController:leftFileVC];
    //item2.collapsed=YES;
    [splitMainVC addSplitViewItem:item2];
    [splitMainVC addSplitViewItem:item1];
    
    self.splitVC=splitMainVC;
    
    self.window.contentViewController = splitMainVC;
    
    
}


-(void)layout1{
        SplitViewController *splitMainVC = [[SplitViewController alloc]init];
    
        [splitMainVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
        [splitMainVC.splitView setVertical:NO];
    
        NSSplitViewController *topVC = [[NSSplitViewController alloc]init];
        [topVC.splitView setVertical:YES];
        TestPlanVC *testPlanVC = [TestPlanVC new];
        NSSplitViewItem *item1 = [NSSplitViewItem splitViewItemWithViewController:testPlanVC];
        self.testPlanVC = testPlanVC;
        LeftFileVC *leftFileVC = [LeftFileVC new];
        NSSplitViewItem *item2 = [NSSplitViewItem splitViewItemWithViewController:leftFileVC];
        //item2.collapsed=YES;
        [topVC addSplitViewItem:item2];
        [topVC addSplitViewItem:item1];
    
    
    
        NSSplitViewController *botommVC = [[NSSplitViewController alloc]init];
        [botommVC.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
        [botommVC.splitView setVertical:YES];
        ShowingLogVC *showingLogVC = [ShowingLogVC new];
        NSSplitViewItem *item3 = [NSSplitViewItem splitViewItemWithViewController:showingLogVC];
        [botommVC addSplitViewItem:item3];
        DebugVC *debugVC = [DebugVC new];
        NSSplitViewItem *item4 = [NSSplitViewItem splitViewItemWithViewController:debugVC];
        [botommVC addSplitViewItem:item4];
    
        NSSplitViewItem *itemTop = [NSSplitViewItem splitViewItemWithViewController:topVC];
        NSSplitViewItem *itemBotomm = [NSSplitViewItem splitViewItemWithViewController:botommVC];
    
        [splitMainVC addSplitViewItem:itemTop];
        [splitMainVC addSplitViewItem:itemBotomm];
    
        self.splitVC=splitMainVC;
    
        self.window.contentViewController = splitMainVC;
}

- (IBAction)openCloseAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kOpenCloseViewNotification object:nil];
    
    
}





@end
