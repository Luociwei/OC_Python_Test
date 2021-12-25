//
//  ModalViewController.m
//  CPK_Tool
//
//  Created by Louis Luo on 2021/6/24.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "PresentViewController.h"

@interface PresentViewController ()
@property (nonatomic,strong)NSViewController *mainVc;
@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.title = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"VC" withString:@""];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(windowWillClose:)
//                                                 name:NSWindowWillCloseNotification
//                                               object:nil];
}


-(void)viewDidAppear{
    [super viewDidAppear];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(windowWillClose:)
//                                                 name:NSWindowWillCloseNotification
//                                               object:nil];
}

-(void)viewDidDisappear{
    [super viewDidDisappear];
    self.isActive = NO;
//    [self removeNSWindowWillCloseNotificationObserver];
}

-(void)dismisssViewOnViewController:(NSViewController *)vc{
    self.isActive = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [vc dismissViewController:self];
        
    });
    
}

-(void)showViewOnViewController:(NSViewController *)vc{
//    if (self.isActive) {
//        return;
//    }
    self.isActive = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        _mainVc = vc;
        
        [vc presentViewControllerAsModalWindow:self];
        
    });

   // [vc presentViewControllerAsSheet:self];

}
-(void)showViewAsSheetOnViewController:(NSViewController *)vc{
//    if (self.isActive) {
//        return;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _mainVc = vc;
        self.isActive = YES;
        [vc presentViewControllerAsSheet:self];
        
    });
    
    
}
//- (void)windowWillClose:(NSNotification *)notification {
//    [self close];
//}

-(void)close{
    self.isActive = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_mainVc dismissViewController:self];
        
    });
    
}

//-(void)dealloc{
//
//    [self removeNSWindowWillCloseNotificationObserver];
//
//}
//
//-(void)removeNSWindowWillCloseNotificationObserver{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSWindowWillCloseNotification object:nil];
//}


@end
