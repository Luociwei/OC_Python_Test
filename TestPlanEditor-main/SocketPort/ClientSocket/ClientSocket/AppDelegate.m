//
//  AppDelegate.m
//  ClientSocket
//
//  Created by ciwei luo on 2020/1/15.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
   // ViewController
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:nil];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:nil];
}

@end
