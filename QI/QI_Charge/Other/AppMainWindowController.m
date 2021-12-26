//
//  AppMainWindowController.m
//  NSWindowArchitecture
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "TabViewController.h"
#import "AppMainWindowController.h"
@interface AppMainWindowController ()

@property (weak) IBOutlet NSButton *otpArcas;
@property (weak) IBOutlet NSButton *otpCallisto;
@property (weak) IBOutlet NSButton *nootpArcas;
@property (weak) IBOutlet NSButton *nootpCallisto;
@property(nonatomic,strong)TabViewController *tabViewController;
@end

@implementation AppMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window center];

    [self button:self.nootpArcas];

}


- (IBAction)button:(NSButton *)sender {
    self.tabViewController.title = sender.title;
    self.contentViewController = self.tabViewController;
    
}

- (TabViewController*)tabViewController
{
    if(!_tabViewController){
        _tabViewController =[[TabViewController alloc]init];
        
    }
    return _tabViewController;
}

- (NSString*)windowNibName {
    return @"AppMainWindowController";
}
@end
