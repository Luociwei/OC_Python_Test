//
//  DebugSettingVC.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/2/3.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "DebugSettingVC.h"

@interface DebugSettingVC ()
@property (weak) IBOutlet NSButton *btnDummy;
@property (weak) IBOutlet NSButton *btnSerial;

@property (weak) IBOutlet NSButton *btnSocket;
@property (weak) IBOutlet NSButton *btnFCT;

@property (weak) IBOutlet NSPopUpButton *popBtn_serial;
@property (weak) IBOutlet NSPopUpButton *popBtn_barut;

@property (weak) IBOutlet NSTextField *textField_ip;
@property (weak) IBOutlet NSTextField *textField_portNum;

@property (weak) IBOutlet NSPopUpButton *scopePortName;
@property (weak) IBOutlet NSTextField *scopeIP;
@property (weak) IBOutlet NSTextField *scopePortNum;
@property (weak) IBOutlet NSButton *scopeEnableBtn;

@property (weak) IBOutlet NSButton *smuEnableBtn;
@property (weak) IBOutlet NSPopUpButton *smuPortName;
@property (weak) IBOutlet NSTextField *smuIP;
@property (weak) IBOutlet NSTextField *smuPortNum;

@end

@implementation DebugSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Debug Settings";
    
    [self comsClick:self.btnDummy];
    [self scopeEnableClick:self.scopeEnableBtn];
    [self smuEnableClick:self.smuEnableBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:nil];
    // Do view setup here.
}

- (IBAction)comsClick:(NSButton *)btn {
    self.btnDummy.state = NSOffState;
    self.btnSerial.state = NSOffState;
    self.btnSocket.state = NSOffState;
    self.btnFCT.state = NSOffState;
    
    btn.state = NSOnState;
    
    [self setDutState];
}


-(void)setDutState{
    self.popBtn_serial.enabled = NO;
    self.popBtn_barut.enabled = NO;
    self.textField_ip.enabled = NO;
    self.textField_portNum.enabled = NO;

    if (self.btnSerial.state){
        self.popBtn_serial.enabled = YES;
        self.popBtn_barut.enabled = YES;
    }else if (self.btnSocket.state){
        self.textField_ip.enabled=YES;
        self.textField_portNum.enabled=YES;
    }else if (self.btnFCT.state){
        self.textField_ip.enabled=YES;
    }
}
- (IBAction)scopeEnableClick:(NSButton *)btn {
    if (btn.state) {
        self.scopePortName.enabled=YES;
        self.scopeIP.enabled=YES;
        self.scopePortNum.enabled=YES;
    }else{
        self.scopePortName.enabled=NO;
        self.scopeIP.enabled=NO;
        self.scopePortNum.enabled=NO;
    }
}
- (IBAction)smuEnableClick:(NSButton *)btn {
    if (btn.state) {
        self.smuPortName.enabled=YES;
        self.smuIP.enabled=YES;
        self.smuPortNum.enabled=YES;
    }else{
        self.smuPortName.enabled=NO;
        self.smuIP.enabled=NO;
        self.smuPortNum.enabled=NO;
    }
}

- (IBAction)cancelBtnClick:(NSButton *)sender {
    [self dismiss];

}

- (IBAction)startBtnClick:(NSButton *)sender {
    [self dismiss];

}

- (void)windowWillClose:(NSNotification *)notification {
    
    [self dismiss];
    
}

-(void)dismiss{
    
    if (self.presentingViewController) {
        [self dismissController:self];
    }
    else {
        [self.view.window close];
    }
    self.debugBtn.state = NSOffState;
    [self.debugBtn setImage:[NSImage imageNamed:@"Debug"]];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
