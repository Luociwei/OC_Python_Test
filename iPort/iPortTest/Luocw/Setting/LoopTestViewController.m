//
//  LoopTestViewController.m
//  iPort
//
//  Created by ciwei luo on 2020/6/10.
//  Copyright © 2020 Zaffer.yang. All rights reserved.
//

#import "LoopTestViewController.h"

@interface LoopTestViewController ()
@property (weak) IBOutlet NSTextField *loopCountView;

@property (weak) IBOutlet NSTextField *timeIntervalView;

@property (weak) IBOutlet NSTextField *currentLoopView;
@property (weak) IBOutlet NSButton *btnLoopIn;
@property (weak) IBOutlet NSButton *btnLoopOut;
@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;

@end

@implementation LoopTestViewController{
    NSInteger _loopCount;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Do view setup here.
    self.btnLoopOut.enabled = NO;
}

- (IBAction)loopInClick:(NSButton *)sender {
    NSInteger loopCount = [self.loopCountView.stringValue integerValue];
    float timeInterval = [self.timeIntervalView.stringValue floatValue];
    if (loopCount <=0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopInClick:timeInterval:)]) {

        _timeInterval = timeInterval;
        _loopCount = loopCount;
        self.btnLoopOut.enabled = YES;
        
        self.currentLoopView.stringValue=@"1";
        [self.loadingIndicator startAnimation:self];
        self.btnLoopIn.enabled = NO;
        [self.delegate loopInClick:loopCount timeInterval:timeInterval];
    }
    
}

- (IBAction)loopOutClick:(NSButton *)sender {

    [self stopLoop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopOutClick)]) {
        
        [self.delegate loopOutClick];
    }
}


-(void)stopLoop{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.loadingIndicator stopAnimation:self];
            self.btnLoopIn.enabled = YES;
            self.btnLoopOut.enabled = NO;
        });
    });


}

-(void)setCurrentLoop:(NSInteger)currentLoop{
    NSInteger loop_count = _loopCount - currentLoop+1;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.currentLoopView setStringValue:[NSString stringWithFormat:@"%ld",loop_count]];
        });
    });

}

-(void)exit{
    [self.window close];
}
@end
