//
//  SplitViewController.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/1/17.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "SplitViewController.h"

extern NSString *kOpenCloseViewNotification;

@interface SplitViewController ()
@property(nonatomic,assign)BOOL isLeftCollapsed;
@property BOOL userIsDraggingDivider ;
@property CGFloat dividerDragX ;
@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandSidebarWithLastObject:) name:kOpenCloseViewNotification object:nil];
    
    self.view.frame= NSMakeRect(0, 0, 1200, 1000);
   

}

- (void)expandSidebarWithIndexOfSplitViewItems:(int)index {
    [[[self.splitViewItems objectAtIndex:index] animator] setCollapsed:NO];
}

- (void)expandSidebarWithLastObject:(NSNotification *)notification {
    NSLog(@"1");
    BOOL isExpanded = [notification.object boolValue];
    isExpanded ? [self expandSidebarWithLastObject]: [self collapseSidebarWithLastObject];
    
}
- (void)expandSidebarWithLastObject {
    //[[[self.splitViewItems objectAtIndex:0] animator] setCollapsed:NO];
    [[[self.splitViewItems objectAtIndex:0] animator] setCollapsed:NO];
//    NSSplitViewController *vc = [self.childViewControllers objectAtIndex:0];
//    [vc.splitViewItems[0] setCollapsed:NO];
    [self setCollapsedForBottom:NO];
}

- (void)collapseSidebarWithLastObject {
    //[[[self.splitViewItems objectAtIndex:0] animator] setCollapsed:YES];
    [[[self.splitViewItems objectAtIndex:0] animator] setCollapsed:YES];
    [self setCollapsedForBottom:YES];

}

- (void)collapseSidebarWithIndexOfSplitViewItems:(int)index {
    [[[self.splitViewItems objectAtIndex:index] animator] setCollapsed:YES];

    
}

-(void)setCollapsedForBottom:(BOOL)isCollapsed{
    NSSplitViewController *vc = [self.childViewControllers objectAtIndex:1];
    
    [vc.splitViewItems[1] setCollapsed:isCollapsed];
}

- (void)setFixedWidth:(CGFloat)width indexOfSplitViewItems:(int)index{
    [[self.splitViewItems objectAtIndex:index] setMinimumThickness:width] ;
    [[self.splitViewItems objectAtIndex:index] setMaximumThickness:width] ;
}

-(void)viewWillAppear{
    [super viewWillAppear];
//    [self collapseSidebarWithLastObject];
}


@end
