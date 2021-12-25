//
//  ViewController.m
//  ClientSocket
//
//  Created by ciwei luo on 2020/1/15.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
//#import <AsyncSocket/GCDAsyncSocket.h>
#import <CWGeneralManager/CWFileManager.h>
#import <CWGeneralManager/NSString+Extension.h>
#import "SearchListVC.h"
#import "HWIOMode.h"
#import "WHPingTester.h"
@interface ViewController ()<WHPingDelegate,GCDAsyncSocketDelegate,SearchListVCDelegate>
@property(nonatomic, strong) WHPingTester* pingTester;
@property (nonatomic,strong)GCDAsyncSocket *clientSocket;
@property (weak) IBOutlet NSTextField *ipAddress;
@property (weak) IBOutlet NSTextField *port;
@property (weak) IBOutlet NSButton *btnConnect;
@property (weak) IBOutlet NSTextField *contextSend;
@property (weak) IBOutlet NSButton *btnSend;
//@property (weak) IBOutlet NSScrollView *contextRecivice;
@property (unsafe_unretained) IBOutlet NSTextView *contextRecivice;
@property (nonatomic, strong)NSMutableString *stringRecivice;
@property (weak) IBOutlet NSButton *btnR;
@property (weak) IBOutlet NSButton *btnN;
@property (weak) IBOutlet NSPopUpButton *scriptPopUpBtn;
@property (weak) IBOutlet NSButton *scriptStartBtn;
@property (weak) IBOutlet NSTextField *labelFilePath;
@property (weak) IBOutlet NSSearchField *btnSearch;
@property(nonatomic,strong)NSPopover *sharePopover;
@property (copy)NSString *currentRead;
//@property (copy)NSArray *searchArrVoltage;
 //NSArray *array = self.searchArrVoltage.count ? self.searchArrVoltage : cellArray_Voltage;
@end


@implementation ViewController{
    NSString *ipAdd;
    NSString *portN;
    NSString *_logDirPath;
   // NSMutableArray *cellArray_Voltage;
}

-(instancetype)initWithIp:(NSString *)ip port:(NSString *)port logDirPath:(NSString *)logDirPath{
    if (self=[super init]) {
        ipAdd = ip;
        portN = port;
        _logDirPath = logDirPath;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ipAddress.stringValue = ipAdd;
    self.port.stringValue=portN;
    self.btnSend.enabled=NO;
    self.scriptStartBtn.enabled=NO;
    self.clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    self.stringRecivice = [NSMutableString string];
    [self.btnSearch setFocusRingType:NSFocusRingTypeNone];
    [self.scriptPopUpBtn removeAllItems];
    [self.scriptPopUpBtn addItemsWithTitles:[self getScriptPathList]];
    
    [self connect:nil];
//    
    // Do any additional setup after loading the view.
}

- (IBAction)connect:(NSButton *)sender {
    NSString *ip = self.ipAddress.stringValue;
    NSString *port =self.port.stringValue;
    if (ip.length<7 || port.length<4 ) {
        return;
    }

    if (self.clientSocket.isConnected) {
        [self showRecivice:@"it is connecting\n"];
        return;
    }
    [self.clientSocket connectToHost:ip onPort:port.integerValue error:nil];
}

- (IBAction)send:(NSButton *)sender {
    
    NSMutableString *cmd = [NSMutableString stringWithFormat:@"%@",self.contextSend.stringValue];
    if (!cmd.length) {
        return;
    }

    if (!self.clientSocket.isConnected) {
        
        [self connect:nil];
    }
    
    if (self.btnR.state == YES) {
        [cmd appendString:@"\r"];
    }
    if (self.btnN.state == YES) {
        [cmd appendString:@"\n"];
    }
    [self sendCmd:cmd];
   // [self.clientSocket writeData:[cmd dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    //[NSString stringWithFormat:@"send:%@",cmd]
}
- (IBAction)clear:(NSButton *)sender {
    self.stringRecivice=[NSMutableString string];
    self.contextRecivice.string = self.stringRecivice;
}

#pragma mark GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)clientSocket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.btnConnect.enabled = NO;
        self.btnSend.enabled=YES;
        self.scriptStartBtn.enabled=YES;
        
    });
    [self showRecivice:[NSString stringWithFormat:@"connect success.addr:%@ %d\n",host,port]];

    [clientSocket readDataWithTimeout:-1 tag:0];
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.btnConnect.enabled = YES;
       // self.btnSend.enabled=NO;
        self.scriptStartBtn.enabled=NO;
    });
    [self showRecivice:[NSString stringWithFormat:@"disconnect error:%@\n",error]];
}

-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [self showRecivice:[NSString stringWithFormat:@"recivice:%@",str]];

    self.currentRead =str;
    [clientSocket readDataWithTimeout:-1 tag:0];
}

- (IBAction)filtre:(NSSearchField *)sender {
   
    
    NSString *strSearch = sender.stringValue;
    
    if (!strSearch.length) {
        self.contextRecivice.string = self.stringRecivice;
        return;
    }
    NSArray *strArr = [self.stringRecivice cw_componentsSeparatedByString:@"\n"];
    NSMutableString *filterStr = [NSMutableString string];
    for (NSString *str in strArr) {
        if ([str.lowercaseString containsString:strSearch.lowercaseString]) {
            [filterStr appendString:str];
            [filterStr appendString:@"\n"];
        }
    }
    self.contextRecivice.string = filterStr;
    
}


-(void)showRecivice:(NSString *)string{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stringRecivice appendString:[NSString stringWithFormat:@"%@:%@\n",[NSString cw_stringFromCurrentDateTimeWithMicrosecond],string]];
        self.contextRecivice.string = self.stringRecivice;
        
        [self.contextRecivice scrollRangeToVisible:NSMakeRange([[self.contextRecivice string] length], 0)];
    });
    
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

-(NSMutableArray *)getScriptPathList{
    
    //NSString *resourcePath =  [NSString cw_getResourcePath];
    
    NSMutableArray *mutArray =[NSString cw_getFileNameListInDirPath:_logDirPath str1:@".json" str2:@"script"];

    return mutArray;
}

- (IBAction)runScript:(NSButton *)sender {

    NSString *file = self.scriptPopUpBtn.titleOfSelectedItem;
    NSString *path =[_logDirPath stringByAppendingPathComponent:file];
    NSDictionary *cmdList = [CWFileManager cw_serializationWithJsonFilePath:path];
    if (cmdList==nil) {
        return;
    }
    NSDictionary *par = [cmdList objectForKey:@"parameters"];
    float commandDelay= [[par objectForKey:@"commandDelay"] floatValue];
    NSInteger times=[[par objectForKey:@"loopTimes"] integerValue];
    NSInteger timeout=[[par objectForKey:@"timeout"] integerValue];
    NSString *endStr =[par objectForKey:@"endStr"];
    NSArray *arr = [cmdList objectForKey:@"commands"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i =0; i<times; i++) {
            
            for (NSString *command in arr){
//                self.currentRead=nil;
//                [self.clientSocket writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
                [self sendCmd:[NSMutableString stringWithString:command]];
                NSDate *date = [NSDate date];
                while (![self.currentRead containsString:endStr]) {
               
                    if ([[NSDate date] timeIntervalSinceDate:date]>timeout) {
                        break;
                    }
                    [NSThread sleepForTimeInterval:0.1];
                }
                
                [NSThread sleepForTimeInterval:commandDelay];
            }
        }
    
    });
   
}

-(void)sendCmd:(NSMutableString *)cmd{
    self.currentRead=nil;
    [self.clientSocket writeData:[cmd dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [self showRecivice:[NSString stringWithFormat:@"send:%@",cmd]];
}

- (IBAction)logFile:(NSButton *)sender {
    system([[NSString stringWithFormat:@"open %@",_logDirPath] UTF8String]);
}
- (IBAction)listBtnClick:(NSButton *)sender {
    NSButton *button = sender;
    //显示在button 下面
    [self.sharePopover showRelativeToRect:[button bounds] ofView:button preferredEdge:NSRectEdgeMaxY];
}

- (NSPopover*)sharePopover
{
    if(!_sharePopover){
        _sharePopover = [[NSPopover alloc]init];
        SearchListVC *vc = [[SearchListVC alloc]init];
        vc.delegate = self;
        if ([self.title.lowercaseString containsString:@"scope"]) {
            vc.file = @"HWIO_Frequency.lua";
        }else if ([self.title.lowercaseString containsString:@"eload"]){
            vc.file = @"HWIO_Current.lua";
        }else if ([self.title.lowercaseString containsString:@"battery"]){
            vc.file = @"HWIO_Voltage.lua";
        }
        _sharePopover.contentViewController = vc;
        _sharePopover.behavior = NSPopoverBehaviorTransient;
        //_sharePopover.appearance = NSPopoverAppearanceHUD;
        
    }
    return _sharePopover;
}

-(void)SearchListSignelClick:(NSString *)cmd{
    self.contextSend.stringValue = cmd;
}
-(void)SearchListDoubleClick:(NSString *)cmd{
    self.contextSend.stringValue = cmd;
    if (self.btnSend.isEnabled) {
        [self send:nil];
    }
}

@end
