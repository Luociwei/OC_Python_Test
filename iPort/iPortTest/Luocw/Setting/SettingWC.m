//
//  SettingWC.m
//  iPort
//
//  Created by ciwei luo on 2019/4/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "SettingWC.h"
#import "NSString+File.h"
#import "MyEexception.h"
#import "TestEngine.h"
#import "PlistUtilities.h"
#import "JasonUtilities.h"
#import "NSString+Date.h"
#import "NSString+Cut.h"
@interface SettingWC ()
@property (weak) IBOutlet NSButton *auditBtn;
@property (weak) IBOutlet NSButton *officeBtn;
@property (weak) IBOutlet NSButton *singleBtn;
@property (weak) IBOutlet NSButton *Frist2Right;
@property (weak) IBOutlet NSButton *mapView;
@property (weak) IBOutlet NSButton *commandsList;
@property (weak) IBOutlet NSButton *cardView;

@property (weak) IBOutlet NSPopUpButton *serialNamePopBtn;
@property (weak) IBOutlet NSPopUpButton *setPosCmd;
@property (weak) IBOutlet NSTextField *iportSN;
@property (weak) IBOutlet NSTextField *iportPos;


@property (weak) IBOutlet NSPopUpButton *configPopBtn;
@property (weak) IBOutlet NSPopUpButton *fwPopBtn;

@property (weak) IBOutlet NSButton *writeBtn;

//@property (weak) IBOutlet NSTextField *snLenView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (strong,nonatomic)NSMutableString *mutLogString;
@end

@implementation SettingWC
//@property BOOL isShowMapView;
//@property BOOL isShowCommands;
//@property BOOL isShowCard;
- (void)windowDidLoad {
    [super windowDidLoad];
     _settingMode = [[SettingMode alloc]init];
    NSDictionary  *configDic  = [PlistUtilities loadFile:@"setting"];
    BOOL isA218 = [[configDic objectForKey:@"isA218"] boolValue];
    if (isA218) {
        [self.singleBtn setState:0];
        [self.singleBtn setEnabled:NO];
    }else{
        [self.singleBtn setState:1];
        [self.singleBtn setEnabled:NO];
        [self.Frist2Right setState:0];
        [self.Frist2Right setEnabled:NO];
    }
   
    BOOL isRoot =self.isRootPwd;
        [self.queryProject setEnabled:isRoot];
        [self.checkGpu setEnabled:isRoot];
 
   // [self.officeBtn setState:1];
    [self config];
    
    if (self.TeEngArr.count) {
        
        
        [self.setPosCmd removeAllItems];
        [self.setPosCmd addItemsWithTitles:[self getAvaliblePosCmds]];
        
        [self.serialNamePopBtn removeAllItems];
    
        for (int j =0;j<_TeEngArr.count;j++) {
            
            TestEngine *te = _TeEngArr[j];
            NSString *portName = te.portName;
            [self.serialNamePopBtn addItemWithTitle:portName];
            if (j == 0) {
                
                [self showLog:[NSString stringWithFormat:@"-------------iport serail name:%@-------------\n",portName]];
                [self readIportSnWithTestEng:te];
                [self readIportPosWithTestEng:te];
            }
            
        }
    }

}


- (IBAction)cleanClick:(NSButton *)sender {
    
    self.mutLogString=nil;
    [self.mutLogString appendString:@"Clean all..................\n"];
    self.textView.string = self.mutLogString;
}


-(void)readIportSnWithTestEng:(TestEngine *)te{
    [self showLog:@"send--sysconfig read serial_number\n"];
    NSString *getSnRespond = [te sendCommandAndReadResponse:@"sysconfig read serial_number\n"];
    [self showLog:[NSString stringWithFormat:@"response--%@",getSnRespond]];
    NSDictionary *snDic = [JasonUtilities loadJSONContentToDictionary:getSnRespond];
    NSString *sn = [snDic valueForKey:@"serial_number"];
    if (sn.length) {
        self.iportSN.stringValue = sn;
    }

}

- (IBAction)serialNamePopClick:(NSPopUpButton *)btn {
//    NSString *iportName = btn.title;
    NSInteger index = btn.indexOfSelectedItem;
    TestEngine *te =_TeEngArr[index];
    [self showLog:[NSString stringWithFormat:@"-------------iport serail name:%@-------------\n",te.portName]];
    [self readIportSnWithTestEng:te];
    [self readIportPosWithTestEng:te];
}

- (IBAction)setPosCmdBtnClick:(NSPopUpButton *)btn {
    
}

-(void)showLog:(NSString *)response
{

    NSString *timeString = [NSString cw_stringFromCurrentDateTimeWithMicrosecond];
    [self.mutLogString appendString:[NSString stringWithFormat:@"%@ %@\n",timeString,response]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.string = self.mutLogString;
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.string.length, 1)];
    });
}

-(NSMutableString *)mutLogString{
    if (_mutLogString==nil) {
        _mutLogString = [[NSMutableString alloc]init];
    }
    return _mutLogString;
}

- (IBAction)writePos:(NSButton *)btn {
    
    NSString *cmd = self.setPosCmd.title;
    NSInteger index = self.serialNamePopBtn.indexOfSelectedItem;
    [self writeIportPosWithTestEng:_TeEngArr[index] cmd:cmd];
//    [NSThread sleepForTimeInterval:0.3];
//    [self readIportPosWithTestEng:_TeEngArr[index]];
}


//{"iPort Position": "value": "Left"}
-(void)writeIportPosWithTestEng:(TestEngine *)te cmd:(NSString *)cmd{
    
    [self showLog:[NSString stringWithFormat:@"send command--%@",cmd]];
    NSString *getPosRespond = [te sendCommandAndReadResponse:[NSString stringWithFormat:@"%@\n",cmd]];
    [self showLog:getPosRespond];

    [self showLog:[NSString stringWithFormat:@"response--%@",getPosRespond]];
    
//    NSDictionary *snDic = [JasonUtilities loadJSONContentToDictionary:getPosRespond];
//    NSString *pos = [snDic valueForKey:@"iPort Position"];
    if ([cmd.lowercaseString containsString:@"setpos"]) {
        NSString *pos = [getPosRespond cw_getStringBetween:@"\"iPort Position\": \"value\": \"" and:@"\"}"];
        if (pos.length) {
            self.iportPos.stringValue = pos;
        }
    }

    
}


-(void)readIportPosWithTestEng:(TestEngine *)te{
    [self showLog:@"send command--getpos\n"];
    NSString *getPosRespond = [te sendCommandAndReadResponse:@"getpos\n"];
    [self showLog:[NSString stringWithFormat:@"response--%@",getPosRespond]];
//    NSDictionary *snDic = [JasonUtilities loadJSONContentToDictionary:getPosRespond];
    NSString *pos = [getPosRespond cw_getStringBetween:@"\"iPort Position\": \"value\": \"" and:@"\"}"];
    if (pos.length) {
        self.iportPos.stringValue = pos;
    }
    
}



-(NSArray<NSString *> *)getAvaliblePosCmds
{
    NSArray<NSString *> * array = nil;
    NSDictionary *configDic  = [PlistUtilities loadFile:@"setting"];
    NSString * lp = [configDic valueForKey:@"setPosCmds"];
    if (lp == nil || [lp length] <= 0)
    {
        lp = @"setpos 0;setpos l;setpos r;setpos 1;setpos 2;setpos 3;setpos 4;setpos 5;setpos 6";
    }
    
    lp = [lp lowercaseString];
    
    array = [lp componentsSeparatedByString:@";"];
    return array;
}


-(void)config
{

    self.writeBtn.enabled = _isRootPwd;
    _settingMode = [SettingMode getConfig];
    if (_settingMode!=nil) {
        [self.auditBtn setState:_settingMode.audit];
        [self.officeBtn setState:_settingMode.office];
        [self.singleBtn setState:_settingMode.single];
        [self.Frist2Right setState:_settingMode.frist2Right];
        [self.mapView setState:_settingMode.isShowMapView];
        [self.commandsList setState:_settingMode.isShowCommands];
        [self.cardView setState:_settingMode.isShowCard];
        
        [self.signPortBtn setState:_settingMode.signPort];
        [self.queryProject setState:_settingMode.queryProject];
        [self.checkGpu setState:_settingMode.checkGPU];
        
    }else{
        _settingMode = [[SettingMode alloc]init];
    }
    
    [self.configPopBtn removeAllItems];
    [self.fwPopBtn removeAllItems];
    [self.fwPopBtn addItemsWithTitles:[self getFWUpdatePathList]];
    [self.configPopBtn addItemsWithTitles:[self getConfigPathList]];

}



-(NSMutableArray *)getFWUpdatePathList{
    
    NSString *resourcePath = [NSString getResourcePath];
    NSMutableArray *mutArray =[NSString getFileNameListInDirPath:resourcePath str1:@".s19" str2:@"DE_3_5_"];
    NSString *path=[self getDefaultFWPath];
    if ([mutArray containsObject:path.lastPathComponent]) {
        NSInteger index = [mutArray indexOfObject:path];
        [mutArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
    }
    
    return mutArray;
}

-(NSMutableArray *)getConfigPathList{
    NSString *resourcePath = [NSString getResourcePath];
    NSMutableArray *mutArray =[NSString getFileNameListInDirPath:resourcePath str1:@".csv" str2:@"Config"];
    NSString *path=[self getDefaultConfigPath];
    if ([mutArray containsObject:path]) {
        NSInteger index = [mutArray indexOfObject:path];
        [mutArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
    }
    
    return mutArray;
}


-(NSString*)getDefaultConfigPath{
    
    SettingMode *mode = [SettingMode getConfig];
    if (mode.configPath.length) {
        return mode.configPath.lastPathComponent;
        
    }else
    {
        return @"";
    }
    
    //    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    //    NSString *configPath=[resourcePath stringByAppendingPathComponent:@"DefaultConfig.csv"];
    //    NSArray *list = [NSString getFileNameListInDirPath:resourcePath str1:@".csv" str2:@"Config_"];
    //    if (!list.count) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [MyEexception RemindException:@"check error" Information:[NSString stringWithFormat:@"not found the Config file in path:%@,please add.",resourcePath]];
    //            exit (EXIT_FAILURE);
    //        });
    //    }else{
    //        NSDictionary  *configDic  = [PlistUtilities loadFile:@"setting"];
    //        for (NSString *str in list) {
    //            NSString *updateName = [configDic valueForKey:@"updateConfigName"];
    //            if ([str containsString:updateName]) {
    //                configPath= [resourcePath stringByAppendingPathComponent:str];
    //                break;
    //            }
    //        }
    //    }
    //    //updateConfigName
    //    return configPath.lastPathComponent;
}

-(NSString*)getDefaultFWPath{
    
    SettingMode *mode = [SettingMode getConfig];
    
    if (mode.updateFWPath.length) {
        return mode.updateFWPath.lastPathComponent;
        
    }
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *fwPath=[resourcePath stringByAppendingPathComponent:@"DE_3_5_3.0_1225.s19"];
    NSArray *list = [NSString getFileNameListInDirPath:resourcePath str1:@".s19"];
    if (!list.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"check error" Information:[NSString stringWithFormat:@"not found the FW file in path:%@,please add",resourcePath]];
            exit (EXIT_FAILURE);
        });
    }else{
        NSDictionary  *configDic  = [PlistUtilities loadFile:@"setting"];
        for (NSString *str in list) {
            if ([str isEqualToString:[configDic valueForKey:@"updateFWName"]]) {
                fwPath = [resourcePath stringByAppendingPathComponent:str];
                break;
            }
        }
    }
    //updateConfigName
    return fwPath.lastPathComponent;
}


-(void)setCurrentInfo{
    _settingMode.audit = self.auditBtn.state;
    _settingMode.office = self.officeBtn.state;
    _settingMode.single = self.singleBtn.state;
    _settingMode.frist2Right = self.Frist2Right.state;
    _settingMode.isShowMapView = self.mapView.state;
    _settingMode.isShowCard = self.cardView.state;
    _settingMode.isShowCommands = self.commandsList.state;
    
    _settingMode.signPort = self.signPortBtn.state;
    _settingMode.queryProject = self.queryProject.state;
    _settingMode.checkGPU = self.checkGpu.state;
    
    _settingMode.updateFWPath =self.fwPopBtn.titleOfSelectedItem;
    _settingMode.configPath =self.configPopBtn.titleOfSelectedItem;
    NSString *resourcePath = [NSString getResourcePath];
    _settingMode.updateFWPath =[resourcePath stringByAppendingPathComponent:self.fwPopBtn.titleOfSelectedItem];
    _settingMode.configPath =[resourcePath stringByAppendingPathComponent:self.configPopBtn.titleOfSelectedItem];
    [SettingMode saveConfig:_settingMode];
}

- (IBAction)save:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveClick:)]) {
    
        [self setCurrentInfo];
        
        [self.delegate saveClick:self.settingMode];
    }
    
    [self exit];
}
- (IBAction)cancel:(id)sender {
    [self exit];
}

- (IBAction)queryProjectClick:(id)sender {
    NSButton *btn =sender;
    if (btn.state) {
        [self.checkGpu setState:0];
    }
}

- (IBAction)checkGpuClick:(id)sender {
    NSButton *btn =sender;
    if (btn.state) {
        [self.queryProject setState:0];
    }
}


- (IBAction)auditClick:(id)sender {
    NSButton *btn =sender;
    if (btn.state) {
        [self.officeBtn setState:0];
    }
}

- (IBAction)officeClick:(id)sender {
    NSButton *btn =sender;
    if (btn.state) {
        [self.auditBtn setState:0];
    }
}
- (IBAction)singleClick:(NSButton *)sender {
    if (sender.state) {
        [self.Frist2Right setState:0];
    }
}

- (IBAction)cleanCount:(id)sender {
    
    [self.delegate cleanTestCountClick];
}


- (IBAction)frist2Right:(NSButton *)sender {
    if (sender.state && self.singleBtn.state) {
        [self.singleBtn setState:0];
    }
}


-(void)exit{
    [self.window close];
}

@end
