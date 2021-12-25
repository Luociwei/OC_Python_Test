//
//  AppDelegate.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/1/17.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)windowWillClose:(NSNotification *)notification {
    NSWindow *window =notification.object;
    NSString *title = window.title;
    if ([title containsString:@"TestPlanEditor"]) {
        [NSApp terminate:nil];
    }
   
}


- (IBAction)menuClick:(NSMenuItem *)menu {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPMenuClick" object:menu];
}


@end
