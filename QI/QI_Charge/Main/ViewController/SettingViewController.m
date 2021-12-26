//
//  SettingViewController.m
//  B435_WirelessCharge
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "SettingViewController.h"
#import "SerialPort.h"
#import "ConfigStation.h"
#import "ConfigCommands.h"
#import "AppDelegate.h"
#import "ConfigDatas.h"
#import "CSVLog.h"

@interface SettingViewController ()
@property (weak) IBOutlet NSTextField *fixtureIDView;

@property (weak) IBOutlet NSButton *puddingBtn;

@property (weak) IBOutlet NSButton *bobCatBtn;

@property (weak) IBOutlet NSPopUpButton *staionBtn;
@property (weak) IBOutlet NSPopUpButton *WCB1Btn;
@property (weak) IBOutlet NSPopUpButton *WCB2Btn;

@property (copy) NSMutableArray *portNameArray;
@property (copy) NSArray *stationArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.puddingBtn.state = [ConfigStation isPudding];
    self.bobCatBtn.state = [ConfigStation isBobcat];
    // Do view setup here.
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.staionBtn removeAllItems];
    NSArray *array=@[titleWCOTPArcas,titleWCNOOTPArcas];
    if ([[ConfigStation stationTestItem] isEqualToString:titleWCNOOTPArcas]) {
        array =@[titleWCNOOTPArcas,titleWCOTPArcas];
    }
    [self.staionBtn addItemsWithTitles:array];
    [CSVLog saveDubegLog:[NSString stringWithFormat:@"%ld",self.stationArray.count]];
    [self refleshSerial];
    
}

- (IBAction)reflesh:(id)sender {
    
    [self refleshSerial];
    
}

//- (IBAction)serialBtnClick:(id)sender {
//    
//    NSPopUpButton *popBtn = sender;
//    
//    NSString *showingTitle = [popBtn titleOfSelectedItem];
//    NSMutableDictionary *notificationDict = [NSMutableDictionary dictionary];
//    if (popBtn == self.WCB1Btn){
//        [notificationDict setObject:@"UUT1Serial" forKey:@"serialPort"];
//        [notificationDict setObject:showingTitle forKey:@"serialPath"];
//    }else if (popBtn == self.WCB2Btn){
//        [notificationDict setObject:@"UUT2Serial" forKey:@"serialPort"];
//        [notificationDict setObject:showingTitle forKey:@"serialPath"];
//        
//    }else{
//        [notificationDict setObject:@"Staion" forKey:@"serialPort"];
//        [notificationDict setObject:showingTitle forKey:@"serialPath"];
//        
//    }
//    NSNotification *notification = [NSNotification notificationWithName:settingButtonClickNotification object:notificationDict];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//}

-(void)refleshSerial
{
    [self.portNameArray removeAllObjects];
    
    [self.WCB1Btn removeAllItems];
    [self.WCB2Btn removeAllItems];
//    NSMutableArray *tempArray = [NSMutableArray array];
//    for (NSString *serialPath in [SerialPort SearchSerialPorts]) {
//        if ([serialPath containsString:@"usbmodem"]) {
//            [tempArray addObject:serialPath];
//        }
//    }
//
//    [self.WCB1Btn addItemsWithTitles:tempArray];
//    [self.WCB2Btn addItemsWithTitles:tempArray];
    [self.WCB1Btn addItemsWithTitles:[NSArray arrayWithObject:[ConfigStation QI1PortName]]];
    [self.WCB2Btn addItemsWithTitles:[NSArray arrayWithObject:[ConfigStation QI2PortName]]];
    [self.WCB1Btn setEnabled:NO];
    [self.WCB2Btn setEnabled:NO];
   // return tempArray;
}

-(BOOL)puddingState
{
    return self.puddingBtn.state;
}
-(BOOL)bobCheckState
{
    return self.bobCatBtn.state;
}

-(void)exit {
    
    if (self.presentingViewController) {
        [self dismissController:self];
    }
    else {
        [self.view.window close];
    }
}

- (IBAction)Save:(id)sender {

    NSString *uut1SelctedItem =self.WCB1Btn.titleOfSelectedItem;
    NSString *uut2SelctedItem =self.WCB2Btn.titleOfSelectedItem;
    NSString *stationSelctedItem =self.staionBtn.titleOfSelectedItem;
    NSString *fixtureID = self.fixtureIDView.stringValue;
    
    NSString *prompt = @"save information";
    NSString *infoText = [NSString stringWithFormat:@"WCB1PortName:%@;WCB2PortName:%@;stationName:%@;fixtureID:%@",uut1SelctedItem,uut2SelctedItem,stationSelctedItem,fixtureID];

    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@",infoText];
//    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
//
//    [input setStringValue:defaultValue];
//    [alert setAccessoryView:input];
    //设置告警风格
    [alert setAlertStyle:NSAlertStyleInformational];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {

        if (!uut1SelctedItem.length || !uut2SelctedItem.length) {
            
            NSAlert *alert1 = [NSAlert alertWithMessageText: @"WCB Path is null"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"please check connect"];
            [alert1 runModal];
        }else{
            
            [ConfigStation updateQI1PortName:uut1SelctedItem QI2PortName:uut2SelctedItem station:stationSelctedItem fixtureID:fixtureID];
            //[ConfigCommands updateCommunication];
            [CSVLog saveDubegLog:stationSelctedItem];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewControllerSave:)]) {
                
                [CSVLog saveDubegLog:stationSelctedItem];
                [ConfigDatas loadWithPlist:stationSelctedItem];
                
                [self.delegate settingViewControllerSave:stationSelctedItem];
            }
            
            [self exit];
        }
        
        

    }
    else if (button == NSAlertAlternateReturn) {
        NSLog(@"User cancelled");
    }
    else{
        NSLog(@"Should never go here");
    }

//
//    //开始显示告警
//    [alert beginSheetModalForWindow:
//                  completionHandler:^(NSModalResponse returnCode){
//
//                      NSLog(@"returnCode %ld",returnCode);
//                      //用户点击告警上面的按钮后的回调
//
//                  }
//     ];

    
}



- (IBAction)bobCatClick:(NSButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewControllerBobCatClick:)]) {
        [self.delegate settingViewControllerBobCatClick:sender.state];
    }
    
    [ConfigStation updateBobcat:sender.state];
}

- (IBAction)puddingClick:(NSButton *)sender {
    
    if (!sender.state) {
        [self.bobCatBtn setState:NSControlStateValueOff];
        [ConfigStation updateBobcat:sender.state];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewControllerPuddingClick:)]) {
        [self.delegate settingViewControllerPuddingClick:sender.state];
    }
    
    [ConfigStation updatePuddingState:sender.state];
}

@end
