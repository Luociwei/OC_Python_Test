//
//  AppDelegate.m
//  B435_WirelessCharge
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//
#include "visa.h"
#import "AppDelegate.h"
#import "AppMainWindowController.h"
#import "PowerCommuioncation.h"
#import "NSString+Extension.h"
#import "TabViewController.h"
#import "MainTestViewController.h"

@interface AppDelegate ()
//@property(nonatomic,strong)AppMainWindowController *mainWindowController;
@property (weak) IBOutlet NSWindow *window;
@property(nonatomic,strong)MainTestViewController *mainWindowController;
@property(nonatomic,strong)TabViewController *tabViewController;
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    // self.window.contentViewController = self.tabViewController;
    
    //self.mainWindowController.contentViewController = self.tabViewController;
    
    //[self.mainWindowController showWindow:self];
    
    TabViewController *vc = [[TabViewController alloc]init];
    self.tabViewController = vc;
    [self.window center];
    self.window.styleMask =NSWindowStyleMaskClosable | NSWindowStyleMaskTitled;
    self.window.contentViewController = vc;
    
}
- (IBAction)setting:(id)sender {
    
    MainTestViewController *mainTestVC = self.tabViewController.childViewControllers[0];
    [mainTestVC openSetting];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end

