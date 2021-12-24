//
//  WindowVC.m
//  DfuDebugTool
//
//  Created by ciwei luo on 2021/2/28.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "WindowVC.h"
#import "AppDelegate.h"



@interface WindowVC ()

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
    
    
}




@end
