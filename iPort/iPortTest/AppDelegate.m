//
//  AppDelegate.m
//  iPortTest
//
//  Created by Zaffer.yang on 3/12/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/time.h>
#import "CommandMode.h"
#import "ConvenienceUtilites.h"
#import "MyEexception.h"
#import "JasonUtilities.h"
#import "LogFile.h"
#import "SSZipArchive.h"
#import "PlistUtilities.h"
#import "crc32Utilities.h"
#import "SerialPort.h"
#import "parseCSV.h"
#import "SFHelper.h"
#import "IPSFCPost_API.h"
#import "NSString+Cut.h"
#import "NSString+File.h"
#import "configECode.h"
#import "ConfigSNMapPort.h"
#import "CWFileManager.h"
#import "GpuResult.h"
#import "LoopTestViewController.h"
#import "JasonUtilities.h"
#define DEVICENAME @"/dev/cu.SLAB_USBtoUART"
#define DEVICENAME2 @"/dev/cu.SLAB_USBtoUART13"

// 1: Not check FW(Call checkFW but exit at first);
#define DEBUGMODE @"DebugMode"
// 1: Not check FW(Not call checkFW at all);
// 2: Not call matchProjIportNum.
#define OFFICEMODE @"OfficeMode"
#define FIRST2RIGHT @"First2Right"
#define AUTO_START_TEST_INTERVAL @"AutoStartInterval"
#define AUTO_FOCUS_INTERVAL @"AutoFocusInterval"
#define LEFTPOS @"LeftPos"
#define RIGHTPOS @"RightPos"
#define POSCHECK @"PosCheck"
#define VBUSTEST @"VBusTest"
#define CCPINTEST @"CCPinTest"
#define DEFAULTGRP @"DefaultGrp"
#define ExtAdjItems @"ExtAdjItems"
#define SKIP_SETITEM @"SkipSetItem"
#define IPORT_NUM @"iPortNum"
#define COMBINETEST @"CombineTest"
#define EXT_ITEMS @"ExtItems"
#define SINGLE_DUT @"SingleDUT"

#define AUDITMODE @"AuditMode"
#define FWVERSION @"FW_Version"
#define FWName @"Seal_FW0826_1535"
#define MAPVIEW @"DisableMapView"
#define DISABLEUOP @"DisableUOP"
#define ClEANLOGFOLDER @"LogClean"
#define EEEECODE @"EEEE_Code"

#define TESTCMD       @"{\"debug\": \"key1\"}"
#define STARTSINGAL   @"{\"group\": \"message\", \"item\": \"start\"}"
#define ENDSINGAL     @"{\"group\": \"message\",\"item\": \"end\"}"

static const char *queueLabel = "com.my.device_queue";

@interface TestResultItem: NSObject
{
@public
    int Index;
    int DeviceIndex;
    NSString * DevSN;
    NSString * Position;
    bool Left;
    NSString * OriginPos;
    NSString * SerialNumber;
    NSString * Type;
    NSString * Group;
    NSString * PinNumber;
    NSString * NetName;
    NSString * OpenLimit;
    NSString * ShortLimit;
    NSString * Value;
    NSString * Unit;
    NSString * Result;
}
-(instancetype)init;

@property (nonatomic, copy) NSString *showingPinNumber;

@end

@implementation TestResultItem


-(instancetype)init
{
    self->Index = 0;
    self->DeviceIndex = 0;
    self->Left = false;
    self->DevSN = @"";
    self->Position = @"";
    self->OriginPos = @"";
    self->SerialNumber = @"";
    self->Type = @"";
    self->Group = @"";
    self->PinNumber = @"";
    self->NetName = @"";
    self->OpenLimit = @"";
    self->ShortLimit = @"";
    self->Value = @"";
    self->Unit = @"";
    self->Result = @"";
    return self;
}

-(NSString *)showingPinNumber
{
    NSString *showingPinNumber = self->PinNumber;
    if ([self->PinNumber isEqualToString:@"a02"]) {
        showingPinNumber = @"a02:TX1+";
    }else if ([self->PinNumber isEqualToString:@"a03"]){
        showingPinNumber = @"a03:TX1-";
    }else if ([self->PinNumber isEqualToString:@"a04"]){
        showingPinNumber = @"a04:VBUS";
    }else if ([self->PinNumber isEqualToString:@"a05"]){
        showingPinNumber = @"a05:CC1";
    }else if ([self->PinNumber isEqualToString:@"a06"]){
        showingPinNumber = @"a06:D+";
    }else if ([self->PinNumber isEqualToString:@"a07"]){
        showingPinNumber = @"a07:D-";
    }else if ([self->PinNumber isEqualToString:@"a08"]){
        showingPinNumber = @"a08:SBU1";
    }else if ([self->PinNumber isEqualToString:@"a09"]){
        showingPinNumber = @"a09:VBUS";
    }else if ([self->PinNumber isEqualToString:@"a10"]){
        showingPinNumber = @"a10:RX2-";
    }else if ([self->PinNumber isEqualToString:@"a11"]){
        showingPinNumber = @"a11:RX2+";
    }else if ([self->PinNumber isEqualToString:@"b02"]){
        showingPinNumber = @"b02:TX2+";
    }else if ([self->PinNumber isEqualToString:@"b03"]){
        showingPinNumber = @"b03:TX2-";
    }else if ([self->PinNumber isEqualToString:@"b04"]){
        showingPinNumber = @"b04:VBUS";
    }else if ([self->PinNumber isEqualToString:@"b05"]){
        showingPinNumber = @"b05:VCONN";
    }else if ([self->PinNumber isEqualToString:@"b06"]){
        showingPinNumber = @"b06:NC";
    }else if ([self->PinNumber isEqualToString:@"b07"]){
        showingPinNumber = @"b07:NC";
    }else if ([self->PinNumber isEqualToString:@"b08"]){
        showingPinNumber = @"b08:SBU2";
    }else if ([self->PinNumber isEqualToString:@"b09"]){
        showingPinNumber = @"b09:VBUS";
    }else if ([self->PinNumber isEqualToString:@"b10"]){
        showingPinNumber = @"b10:RX1-";
    }else if ([self->PinNumber isEqualToString:@"b11"]){
        showingPinNumber = @"b11:RX1+";
    }
    return showingPinNumber;

}

@end

@interface TestResultCount: NSObject
{
@public
    int DeviceIndex;
    NSString * DevSN;
    int LeftPassCount;
    int LeftFailCount;
    int RightPassCount;
    int RightFailCount;
}

-(instancetype)init;
@end

@implementation TestResultCount
-(instancetype)init
{
    self->DeviceIndex = 0;
    self->DevSN = @"";
    self->LeftPassCount = 0;
    self->LeftFailCount = 0;
    self->RightPassCount = 0;
    self->RightFailCount = 0;
    return self;
}
@end

@interface SNDetectingTimerParameters: NSObject
{
@public
    bool isLeft;
    NSString * str;
    struct timeval startTime;
}
@end

@implementation SNDetectingTimerParameters
@end

@interface AppDelegate ()<SettingProtocol,BaseMapPortWCProtocol,LoopTestProtocol>


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
//    [SFHelper getGPUNumWithSN_new:@"" logFile:nil];
    

    
//    [self generateConfigCommand:@"/Users/ciweiluo/Desktop/DefaultConfig_1016.csv"];
   // NSNumber *SS = [NSNumber numberWithFloat:[@"NA" floatValue]];
    _commands = [CommandMode getCommandModes];
    [self GHInfo];
    _isInit=YES;
    flushingFlag = true;
    debugFileName = [NSString stringWithFormat:@"%@_%@",[LogFile CurrentTimeForFile],RunTimeLog];
    allowedECode=[[NSMutableArray alloc] init];
    [_lbTimes setDrawsBackground:false];
    [_lbMode setDrawsBackground:false];
    self->extFlags = [[NSMutableDictionary alloc] init];
    self->extItems = [[NSMutableDictionary alloc] init];
    self->extNames = [[NSMutableSet alloc] init];

    [self initConfiguration];
    [self CleanLogFolder];
    [_lbBuildTime setStringValue:[self StationSoftwareBuildTime]];

    [self initWinTitle];
    
    [self checkInstancesNum];
    
    need_ccpintest=false;
    
   // [self generateConfigCommand:[self getDefaultConfigPath]];

    // There would never need VBUS TEST cause it has already been merged with debugkey1 test.
    need_vbusest = [self checkNeedVbusTest];
    allow_Ecode = false;
    isLatest = false;
    isUpdateFW = false;
    allTestTimes = 0;
//    quickPuddingLefts = [[NSMutableDictionary alloc] init];
//    quickPuddingRights = [[NSMutableDictionary alloc] init];
    testCounts = [[NSMutableArray alloc] init];
    [testCounts removeAllObjects];

   // testItemcCount = [self caculateDefaultConfigLine];
   
    [leftScanView setDelegate:self];
    [rightScaniew setDelegate:self];

//    [_lbTestTime setFloatValue:0.0];
    [_menueLoadConfig setHidden:YES];
    [_menueLogout setHidden:YES];

    TeEngArr = [[NSMutableArray alloc]init];
    threadArr = [[NSMutableArray alloc]init];
    testEng  = [[TestEngine alloc]init];
    
    [self initForTabeView];

    if (![[configDic valueForKey:DEBUGMODE] boolValue]){
        [_debugBtn setHidden:YES];
        
    }
    
    [self->_testView sizeToFit];
    [self->_failOnlyView sizeToFit];
    
   _queue = dispatch_queue_create(queueLabel, DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(_queue, ^{//sc

       // [self loadDefaultConfig:nil configPath:[self getDefaultConfigPath]];
        [self initEngine];
//        if (!_officeMode&&![[configDic valueForKey:DEBUGMODE] boolValue]) {
//            [self matchProjIportNum];
//        }
//

        [self checkSerialConnect];
        _isInit=NO;
    });

    [NSThread detachNewThreadSelector:@selector(updateTestStatusLabel) toTarget:self withObject:nil];

//    if (loopTimes > 0) {
//        [NSThread detachNewThreadSelector:@selector(detectStartTest) toTarget:self withObject:nil];
//    }
    
}

-(void)showConfigUI:(NSString *)config{
    dispatch_async(dispatch_get_main_queue(), ^{
  
        if (config.length) {
           [self.configBtn setTitle:config.lastPathComponent];
        }
        else{
            [self.configBtn setStringValue:@"Last Config"];
        }
        
    });
}

-(void)showVersionUI:(NSString *)version{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *getVerRespond = [te sendCommandAndReadResponse:@"getversion"];
//
//        NSDictionary *fwVerDic = [JasonUtilities loadJSONContentToDictionary:getVerRespond];
//        NSString *FWVersion = [fwVerDic valueForKey:@"version"];
//DE_3_5_3.0_0428.s19
        NSString *string = [version cw_getStringBetween:@"DE_3_5_" and:@".s19"];
        if (string.length) {
            [_lbVersion setStringValue:string];
        }else{
            [_lbVersion setStringValue:version];
        }
        
    });
    
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [self.MainWindow center];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:nil];
}

- (void)windowWillClose:(NSNotification *)notification {
    if (notification.object == self.configWC.window||notification.object == self.settingWC.window||notification.object == self.mapPortWC.window||notification.object == self.ecodeMapPortWC.window||notification.object == self.stationMapPortWC.window||notification.object == self.loopWC.window) {
        [[NSApplication sharedApplication] stopModal];
    }
}


#pragma mark CheckSerailConnect

-(void)mapIPortPosition:(TestEngine *)te num:(int)i FWPath:(NSString *)FWPath{
    
//    if (![FWPath.lastPathComponent containsString:@"201208"]) {
//        return;
//    }
    if ([[configDic valueForKey:@"AutoSetPosUsbcName"] boolValue]) {
        NSString *string = [NSString stringWithFormat:@"setpos %d",i+1];
        for (int j =0; j<2; j++) {
            NSString *posReply =[te sendCommandAndReadResponse:string];
            
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:posReply];
            
            if (![posReply containsString:@"NA"]) {
                break;
            }
        }
    }
}

-(void)checkSerialConnect{
    if ([[configDic valueForKey:DEBUGMODE] boolValue]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        while (YES) {
            [NSThread sleepForTimeInterval:1];
            
            if (isUpdateFW) {
                continue ;
            }
            
            NSArray *ports =[SerialPort serialPortList];
           // NSArray *ports =[self test2];;
            NSMutableSet *currentsSet = [NSMutableSet setWithArray:ports];
            NSMutableSet *originalSet = [NSMutableSet setWithArray:deviceArr];
           // NSArray *testDevices =[self test1];
           // NSMutableSet *originalSet = [NSMutableSet setWithArray:testDevices];
            
            if (currentsSet.count != originalSet.count) {
                
                if (currentsSet.count<originalSet.count) {
                    [originalSet minusSet:currentsSet];
             
                        //                    isYes = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"port name:%@ disconnect,do you need reloading it?",originalSet]];
                        NSString *str = [originalSet anyObject];
                        [self checkSerialConnectShowWithPortName:str];
                }else{
                    [currentsSet minusSet:originalSet];
                   
                        //                   isYes =  [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"port name:%@ new connect,do you need reloading it?",currentsSet]];
                        NSString *str = [currentsSet anyObject];
                     [self checkSerialConnectShowWithPortName:str];
                }
                
                
                
            }else{
                
                if (![currentsSet isEqualToSet:originalSet]) {
                    [currentsSet minusSet:originalSet];
                   
                        //                   isYes = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"port name:%@ new connect,do you need reloading it?",currentsSet]];
                        NSString *str = [currentsSet anyObject];
                  [self checkSerialConnectShowWithPortName:str];
                }
            }
        }

    });
 
}

-(void)checkSerialConnectShowWithPortName:(NSString *)portName{
   // NSArray *testDevices =[self test1];
    NSString * show =[NSString stringWithFormat:@"iport name:%@ Undefined new connect,need restart",portName];
    if ([deviceArr containsObject:portName]) {
//        NSInteger num = [deviceArr indexOfObject:portName];
        show =[NSString stringWithFormat:@"iport name:%@ disconnect,need restart",portName];
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
    [MyEexception RemindException:@"check connect" Information:show];
    [NSApp terminate:nil];
});
}

#pragma mark CheckIportNumbers

/**
 product comes from station file(gh_station_info.json, GHInfo()), not call in OFFICEMODE or DEBUGMODE.
 */
-(void)matchProjIportNum{
    
    NSString *configfile = [[NSBundle mainBundle] pathForResource:@"stationMapPort" ofType:@"json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]) {
    
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            BOOL isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"Not found the file name 'stationMapPort.json' in path:%@,continue?",[NSBundle mainBundle].resourcePath]];
//            //[self ErrorWithInformation:@"not found the file name EEEECode.json in app resouce path" isExit:NO];
//            if (isContinue) {
//                return;
//            }else{
//                exit (EXIT_FAILURE);
//            }
//        });
       
        return;
    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        return;
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *iPortNumDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
   // NSDictionary *iPortNumDic = [configDic valueForKey:IPORT_NUM];
    id numObj = nil;

//     product = @"J152";
//     stationName = @"QT3";
    if (product != nil && [product length] > 0)
    {
        id obj = [iPortNumDic objectForKey:product];
        if (obj != nil)
        {
            NSDictionary * numDic = (NSDictionary * )obj;
            if (numDic != nil)
            {
                NSString * sname = stationName;
                if (stationName == nil || [stationName length] <= 0)
                {
                    sname = @"others";
                }

                numObj = [numDic objectForKey:sname];
                if (numObj == nil)
                {
                    numObj = [numDic objectForKey:@"others"];
                    if (numObj == nil)
                    {
                        numObj = [numDic objectForKey:@""];
                    }

                    if (numObj == nil)
                    {
                        numObj = nil;
                    }
                }
            }
        }
    }

    int iportNum = 1;
    int portNum = 1;
    if (numObj != nil)
    {
        portNum = [numObj intValue];
    }
    else
    {
        return;
    }
    iportNum = (int)(portNum +1)/2;
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [MyEexception RemindException:@"Iport Numbers Check" Information:[NSString stringWithFormat:@"产品:%@ 请检查是否已连接%d个接口", product, portNum]];
//
//    });

    if (iportNum != [deviceArr count])
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"Iport Numbers doesn't match this Project" Information:[NSString stringWithFormat:@"Project:%@ need %d iports to test,please check all iports were connected", product, iportNum]];
            [NSApp terminate:nil];
        });
    }
}

-(void)CleanLogWithFolderPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSInteger totalSecondPerDay = 60*60*24;
    double deleteDay = [[configDic valueForKey:ClEANLOGFOLDER] doubleValue];
    if ([path isEqualToString:DebugFOLDER]) {
        deleteDay = deleteDay * 3;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *de = [fm enumeratorAtPath:path];
    NSString *fileName=@"";
    NSString *filePath=@"";
    
    while ((fileName = [de nextObject]))
    {
        filePath = [path stringByAppendingPathComponent:fileName];
        
        // "yyyy-MM-dd HH-mm-ss";
        //        if ([filePath length] > 0 && ([fileName length] == 19) && !([fileName hasSuffix:@".DS_Store"] || [fileName hasSuffix:@".txt"] || [fileName hasSuffix:@".csv"] || [fileName hasSuffix:@".zip"])) {
        if (YES) {
            NSDictionary* fileAttri = [fileManager attributesOfItemAtPath:filePath error: nil];
            NSDate *folderCreateDate = [fileAttri fileCreationDate];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDoesRelativeDateFormatting:YES];
            //        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"yyyy_mm_dd"];
            
            NSTimeInterval flolderInterval = [[NSDate date] timeIntervalSinceDate:folderCreateDate];
            //        NSLog(@"%f",flolderInterval);
            NSTimeInterval needCleanInterval = totalSecondPerDay * deleteDay;
            NSTimeInterval leftTime = needCleanInterval-flolderInterval;
            
            if (leftTime < 0)
            {
                [fileManager removeItemAtPath:filePath error:&error];
                NSString* cleanTime = [dateFormatter stringFromDate:[NSDate date]];
//                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ The Log Folder is time to clean,remove %@ Succeed! Clean Time:%@",[LogFile CurrentTimeForLog], filePath, cleanTime]];
            }
            else
            {
//                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Left %fs to clean log folder:%@!", [LogFile CurrentTimeForLog], leftTime, filePath]];
            }
        }
        else{
            // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Skip the file path:%@", [LogFile CurrentTimeForLog], filePath]];
        }
    }
}

- (void)CleanLogFolder {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        while (1) {
            [self CleanLogWithFolderPath:ALLCSVFILE];
            [self CleanLogWithFolderPath:DebugFOLDER];
            [self CleanLogWithFolderPath:LOGSNDER];
            
            [NSThread sleepForTimeInterval:3600];
        }
        
    });

}

- (void)checkInstancesNum
{
    if ([[NSRunningApplication runningApplicationsWithBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]] count] > 1) {
         [MyEexception RemindException:[NSString stringWithFormat:@"%@ is already running.",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey]] Information:@"This copy will now quit"];
        [NSApp terminate:nil];
    }
}


- (void) initWinTitle{
    [_MainWindow setTitleVisibility:NSWindowTitleHidden];
    [_winTitle setStringValue:[self getAPPVersion]];
}

- (void) initForTabeView{
    testItems = [[NSMutableArray alloc] init];
    testLeftItems = [[NSMutableArray alloc] init];
    testRightItems = [[NSMutableArray alloc] init];
    failedItems = [[NSMutableArray alloc] init];
    failedLeftItems = [[NSMutableArray alloc] init];
    failedRightItems = [[NSMutableArray alloc] init];
}

- (void) initConfiguration
{
    configDic  = [PlistUtilities loadFile:@"setting"];
    if (configDic==nil) {
        [MyEexception RemindException:@"Error" Information:[NSString stringWithFormat:@"Load setting fail,please check setting.json file"]];
        exit (EXIT_FAILURE);
        
    }
    if (![[configDic valueForKey:@"isSaveSettingParameterToLocal"] boolValue]) {
        [SettingMode deleteSettingModeFile];
    }
//    _isCheckSum =[[configDic valueForKey:@"isCheckSum"] boolValue];
//    _isQueryProject=[[configDic valueForKey:@"isQueryProject"] boolValue];
    _isChangeBackGroudColorWithDefferentMode =[[configDic valueForKey:@"isChangeBackGroudColorForDefferentMode"] boolValue];
    _isA218 =[[configDic valueForKey:@"isA218"] boolValue];
     _isCheckEcode=[[configDic valueForKey:@"isCheckECode"] boolValue];
    //NSArray *arr= [self addNewAdjItems];
    [self.menuUpdateFW setHidden:YES];
    _testCount=[[configDic valueForKey:@"TestCount"] integerValue];
    [LogFile getDebugLogStatus:[[configDic valueForKey:@"CloseDebugLog"] boolValue]];
    
    loopTimes = [[configDic valueForKey:@"LoopTest"] integerValue];
    delay =[[configDic valueForKey:@"delay"] integerValue];
    idVisible = [[configDic valueForKey:@"IDVisible"] boolValue];
    looping = loopTimes > 0;
    testTimesForAudit = [[configDic valueForKey:@"TestTimesForEeachSN"] integerValue];
    isUploadWithAllFail = [[configDic valueForKey:@"isUploadWithAllFail"] boolValue];
    isSignPort = [[configDic valueForKey:@"allowSignPortTest"] boolValue];
    isTestWithCapAndCap2 =[[configDic valueForKey:@"isTestWithCapAndCap2"] boolValue];
    updateFWName = [configDic valueForKey:@"updateFWName"];
    self->posCheck = [[configDic valueForKey:POSCHECK] boolValue];
    self->combineTest = [[configDic valueForKey:COMBINETEST] boolValue];
    bool showMode = [[configDic valueForKey:@"showMode"] boolValue];
    self.lbMode.hidden = !showMode;
    
    [_devIdColumn setHidden:!self->idVisible];
    // [_itemIdColumn setHidden:!self->idVisible];
    [_failedDevIdColumn setHidden:!self->idVisible];
    // [_failedItemIdColumn setHidden:!self->idVisible];
 
    _configWC =[ConfigWC mapPortWC];
    //[self mapUI];
    _loopWC = [[LoopTestViewController alloc]initWithWindowNibName:@"LoopTestViewController"];
    _loopWC.delegate = self;
    
    _settingWC = [[SettingWC alloc]initWithWindowNibName:@"SettingWC"];
    _settingWC.delegate = self;
    NSArray *mutArr = _myTabView.tabViewItems;
   // _mutTableItems = [NSArray alloc] initWithObjects:
    _tableItems = [[NSMutableArray alloc] initWithObjects:mutArr[2],mutArr[3],mutArr[4], nil];
    [self initMapView];
    SettingMode *config = [SettingMode getConfig];
    if (!config.isShowMapView) {
        [_myTabView removeTabViewItem:_tableItems[0]];
        showingMapView=NO;
    }else{
        showingMapView=YES;
    }
    if (!config.isShowCommands) {
        [_myTabView removeTabViewItem:_tableItems[1]];
        showingCommandsView=NO;
    }else{
        showingCommandsView=YES;
    }
    if (!config.isShowCard) {
        [_myTabView removeTabViewItem:_tableItems[2]];
        showingCardView=NO;
    }else{
        showingCardView=YES;
    }
    
     [self updateWithSetting];
    
    [self updateTestCountWithIsAdd:NO];
    
    [self GetExtItemFlags];

}


-(BOOL)updateTestCountWithIsAdd:(BOOL)isAdd{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger newCount = [userDefault integerForKey:@"count"];
    if (isAdd) {
        newCount = newCount + 1;
        [userDefault setInteger:newCount forKey:@"count"];
        [userDefault synchronize];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.countView setStringValue:[NSString stringWithFormat:@"%ld",(long)newCount]];
    });
    
    if (newCount>=_testCount) {//Port saver超出使用次数，请更换port saver
        if (_isA218) {
            NSString *str = [NSString stringWithFormat:@"Port saver超出使用次数%ld，请更换port saver",(long)_testCount];
            [MyEexception RemindException:@"Check testCount ERROR" Information:str];
            return NO;
        }else{
            [self cleanTestCountClick];
        }
        
    }
    return YES;
}



-(void)mapUI{
    
    _ecodeMapPortWC =[ECodeMapPortWC mapPortWC];
    _ecodeMapPortWC.delegate = self;
    
    _mapPortWC = [SNMapPortWC mapPortWC];
    _mapPortWC.delegate = self;
    
    _stationMapPortWC = [StationMapPortWC mapPortWC];
    _stationMapPortWC.delegate = self;

}

-(void)updateWithSetting
{

    [self cleanUI];
    testStatus=READY;
    [_testedSN1 setBackgroundColor:[NSColor clearColor]];
    [_testedSN2 setBackgroundColor:[NSColor clearColor]];
    [_testedSN1 setStringValue:@""];
    [_testedSN2 setStringValue:@""];
    
    SettingMode *config =[SettingMode getConfig];
    if (config !=nil) {
//        isSignPort = config.signPort;
        _queryProject = config.queryProject;
        _checkGPU = config.checkGPU;
        _auditMode = config.audit;
        _officeMode= config.office;
        singleDUT = config.single;
        firstMap2Right = config.frist2Right;
        showMapView = config.isShowMapView;
        showCardView = config.isShowCard;
        showCommandsView = config.isShowCommands;
        

    }else{
        //_officeMode=YES;
        if (_isA218) {
            singleDUT = NO;
            firstMap2Right = YES;
          
        }else{
            singleDUT = YES;
            firstMap2Right = NO;

        }
     
    }
    
    if (showMapView) {
       // [_myTabView addTabViewItem: ]
        
        if (!showingMapView) {
            [_myTabView addTabViewItem:_tableItems[0]];
            showingMapView = YES;
        }
        
    }else{
        if (showingMapView) {  //commands_list  iport_card
          [_myTabView removeTabViewItem:_tableItems[0]];
            showingMapView = NO;
        }
        
    }

    if (showCommandsView) {
     
        if (!showingCommandsView) {
            [_myTabView addTabViewItem:_tableItems[1]];
            showingCommandsView = YES;
        }
    }else{
        if (showingCommandsView) {  //commands_list  iport_card
            [_myTabView removeTabViewItem:_tableItems[1]];
            showingCommandsView = NO;
        }
        
    }
    
    if (showCardView) {
        
        if (!showingCardView) {
            [_myTabView addTabViewItem:_tableItems[2]];
            showingCardView = YES;
        }
    }else{
        
        if (showingCardView) {  //commands_list  iport_card
            [_myTabView removeTabViewItem:_tableItems[2]];
            showingCardView = NO;
        }
        
    }
    if (_auditMode) {
        [_lbMode setStringValue:@"Audit Mode\nInsight On"];
        [self changeBackGroudColor:[NSColor colorWithDisplayP3Red:224.0/255.0 green:56.0/255.0 blue:225.0/255.0 alpha:0.7]];
//        self.groudView.layer.backgroundColor=[NSColor colorWithRed:224.0/255.0 green:56.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
    }
    else {
        
        if ([[configDic valueForKey:DEBUGMODE] boolValue]) {
            [_lbMode setStringValue:@"DebugMode\nInsight Off"];
            
//            [self changeBackGroudColor:[NSColor colorWithDisplayP3Red:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
            self.groudView.layer.backgroundColor=[NSColor clearColor].CGColor;
        }else{
            if (_officeMode) {
                [_lbMode setStringValue:@"OfficeMode\nInsight Off"];
                // [_menuAdmin setHidden:YES];
                [self changeBackGroudColor:[NSColor colorWithDisplayP3Red:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6]];
//                self.groudView.layer.backgroundColor=[NSColor redColor].CGColor;
            }else{
                [_lbMode setStringValue:@"NormalMode\nInsight On"];
                [self changeBackGroudColor:[NSColor clearColor]];
//                self.groudView.layer.backgroundColor=[NSColor clearColor].CGColor;
            }
        }
        
    }
//    if (_auditMode) {
//        [_lbMode setStringValue:@"PDCA OFF"];
//       self.groudView.layer.backgroundColor=[NSColor colorWithRed:224.0/255.0 green:56.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
//    }
//    else {
//        [_lbMode setStringValue:@"PDCA ON"];
//        self.groudView.layer.backgroundColor=[NSColor clearColor].CGColor;
//        if (_officeMode) {
//            [_lbMode setStringValue:@"Office Mode"];
//           // [_menuAdmin setHidden:YES];
//        }
//    }
    
    [self matchWithFirstMap2Right];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//          [self  updateConfigAndFW];
//    });
//
   
    if (_officeMode) {
        self.menuLoopTest.hidden = NO;
    }
}


-(void)changeBackGroudColor:(NSColor *)color{
    if (_isChangeBackGroudColorWithDefferentMode) {
        self.groudView.wantsLayer = YES;
        self.groudView.layer.backgroundColor=color.CGColor;
        
    }
    
}

-(bool)testing1
{
    return [leftEnableBtn state] == 1 || self->singleDUT;
}

-(bool)testing2
{
    return [rightEnableBtn state] == 1 && !self->singleDUT;
}



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
#pragma mark initial TestEngine
-(void)initEngine
{

    testStatus = INIT;
    deviceArr = nil;
    if ([[configDic valueForKey:DEBUGMODE] boolValue]) {
        NSArray *deviceCofig=[configDic valueForKey:@"Device"];
        NSString *iportNum=deviceCofig[1];
        NSMutableArray *mydevice=[[NSMutableArray alloc] init];
        for (int i=0; i< [iportNum intValue]; i++) {
            [mydevice addObject:[NSString stringWithFormat:@"%@%d",deviceCofig[0],i+1]];
        }

        deviceArr=mydevice;

        for (int i = 0; i < [deviceArr count]; i++){
            TestEngine *te = [[TestEngine alloc] init];
            te.fileName = debugFileName;
            [te initDevices:deviceArr[i]];
            [TeEngArr addObject:te];
            
            NSString *debugCheckSum = @"debugCheckSum";
            if (![debugCheckSum isEqualToString:[self getCheckSumFromFile:nil]]) {

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_lbStatusTitle setStringValue:@"Config File Incorrect"];
                    [_lbTestStatus setBackgroundColor:[NSColor orangeColor]];
                    [MyEexception RemindException:@"Config File Incorrect" Information:[NSString stringWithFormat:@"Please use the correct config file!"]];
                });
                [NSApp terminate:nil];
            }else{
                NSLog(@"Debug Mode:config file checksum check pass!");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Debug Mode:config file checksum check pass!",[LogFile CurrentTimeForLog]]];
                testStatus = READY;
            }
            
            //[self checkFW:te num:i];
        }
    }
    else{//sc
        deviceArr = [SerialPort serialPortList];
        [self matchProjIportNum];
        NSLog(@"device = %@",deviceArr);
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ device name = %@,product:%@",[LogFile CurrentTimeForLog],deviceArr,product]];
        if ([deviceArr count] ==0){
//            testStatus = INIT;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"check error" Information:[NSString stringWithFormat:@"no devices connect,Please connect the devices"]];
                });
            [NSApp terminate:nil];
        }

        if (deviceArr.count ==1) {
            isTestWithCapAndCap2 = NO;
        }
        if (([product containsString:@"160"]&&[deviceArr count] !=6)) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"check error" Information:[NSString stringWithFormat:@"product:%@,please make sure to connect 6 iports",product]];
            });
            [NSApp terminate:nil];
        }
        
        for (int i = 0; i < [deviceArr count]; i++){//sc
            
            TestEngine *te = [[TestEngine alloc] init];
            te.fileName = debugFileName;
            [TeEngArr addObject:te];
            
            if(![te initDevices:deviceArr[i]]){
               
                if (![[configDic valueForKey:DEBUGMODE] boolValue]) {
              
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_lbStatusTitle setStringValue:@"Disconnect"];
                        [_lbTestStatus setBackgroundColor:[NSColor orangeColor]];
                        [MyEexception RemindException:@"Disconnect" Information:[NSString stringWithFormat:@"Please connect the device:%@!",deviceArr[i]]];
                    });
                    [NSApp terminate:nil];
                }
            }
            else{
                //open serial pass,start check sum of config file.

//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [self setting:nil];
//
//                });
            
               [self checkAndUpdateFW:te num:i];
                
               [self updateConfigWithPort:te num:i];
            
            }
        }
 
    }
    testStatus = READY;
}



-(void)updateConfigAndFW{
    if ([[configDic valueForKey:DEBUGMODE] boolValue]) {
        return;
    }
    testStatus = INIT;
  
    for (int j =0; j<TeEngArr.count; j++) {
        TestEngine *te = TeEngArr[j];
        
        [self checkAndUpdateFW:te num:j];

        // NSString *defaultConfigPath = [self getDefaultConfigPath];
        [self updateConfigWithPort:te num:j];
    }
    
    testStatus = READY;
}


-(void)checkAndUpdateFW:(TestEngine *)te num:(int)i fwPath:(NSString *)fwPath{
    
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_lbStatusTitle setStringValue:@"checking FW..."];
//     o       });
    //NSString *fwPath=[self getDefaultFWPath];
//    if (_isInit) {
//        [NSThread sleepForTimeInterval:10];
//    }
    if (i) {
        [NSThread sleepForTimeInterval:6/i];
    }else{
       [NSThread sleepForTimeInterval:6];
    }
    
    NSString *getVerRespond = [te sendCommandAndReadResponse:@"getversion"];
    if ([getVerRespond isEqualToString:@"null"] ||[getVerRespond length] == 0) {
        [NSThread sleepForTimeInterval:3];
        getVerRespond = [te sendCommandAndReadResponse:@"getversion"];

    }
    if ([getVerRespond isEqualToString:@"null"] ||[getVerRespond length] == 0) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"Can't get current FW version" Information:[NSString stringWithFormat:@"Please reconnect the devide and open app again"]];
            NSLog(@"red current FW version failure");
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ read current FW version failure!",[LogFile CurrentTimeForLog]]];
        });
        [NSApp terminate:nil];
    }
    
//    NSDictionary *fwVerDic = [JasonUtilities loadJSONContentToDictionary:getVerRespond];
//    NSString *FWVersion = [fwVerDic valueForKey:@"version"];
    NSString *FWVersion = [getVerRespond cw_getStringBetween:@"{\"version\": \"" and:@"\"}\r\n"];
    currentFWName=FWVersion;
    [self showVersionUI:FWVersion];
    
    if (!fwPath.length) {
        return;
    }
    NSString *fwName = [fwPath.lastPathComponent cw_getStringBetween:@"DE_3_5_" and:@".s19"];
    
    if (_officeMode&&_isInit) {
        return;
    }
    
    if ([getVerRespond length] != 0 && [getVerRespond containsString:@"version"]) {
        
        NSLog(@"portname = %@,getversion = %@",te.device.portName,FWVersion);
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ portname = %@,currentFWVersion = %@,updateFWVersion:%@",[LogFile CurrentTimeForLog],te.device.portName,FWVersion,fwName]];
        //                <__NSArrayM 0x600000cb41b0>(
        //                                            /Users/ciweiluo/Library/Developer/Xcode/DerivedData/iPort-eahjzkfecfwcuncytavsfeuglfzw/Build/Products/Debug/iPort.app/Contents/Resources/DE_3_5_3.0_1225.s19,
        //                                            3.0_1225
        //                                            )
        
        if (![fwName containsString:FWVersion]) {
            //before update FW,set check sum to 0
            //            __block  BOOL isContinue = NO;
            //            dispatch_sync(dispatch_get_main_queue(), ^{
            //                isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"Port name:%@,Current FW:%@,Do you need updating fw version to %@.",deviceArr[i],FWVersion,fwName]];
            //
            //
            //            });
            //
            //            if (!isContinue) {
            //
            //                return;
            //            }
            
            NSString *setCmd = [NSString stringWithFormat:@"setcheck 0\0"];
            NSString *cmdRespond = [te sendCommandAndReadResponse:[NSString stringWithFormat:@"%@\0",setCmd]];
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ update FW,set checksum to 0",[LogFile CurrentTimeForLog]]];
            if([cmdRespond containsString:@"\"code\":"]){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [MyEexception RemindException:@"Set New CheckSum" Information:[NSString stringWithFormat:@"Command:%@\nRespond:%@",setCmd,cmdRespond]];
                    NSLog(@"set checksum failure");
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ set checksum failure",[LogFile CurrentTimeForLog]]];
                });
                [NSApp terminate:nil];
            }
            
            //update FW
            
            //                dispatch_sync(dispatch_get_main_queue(), ^{
            //                    [_lbStatusTitle setStringValue:[NSString stringWithFormat:@"Device_%d Old:%@-->New:%@ FW updating...",i+1,FWVersion,fwPath_Version[1]]];
            //                    // [_lbUpdateFW setStringValue:[NSString stringWithFormat:@"(Device_%d Old:%@-->New:%@)FW updating...",i+1,FWVersion,fwPath_Version[1]]];
            //                    [_lbTestStatus setBackgroundColor:[NSColor orangeColor]];
            //                });
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // [_lbUpdateFW setStringValue:[NSString stringWithFormat:@"(Device_%d Old:%@-->New:%@)FW updating...",i+1,FWVersion,fwPath_Version[1]]];
                [_lbTestStatus setBackgroundColor:[NSColor orangeColor]];
                [_MainWindow beginSheet:_updateFWWindow completionHandler:^(NSModalResponse returnCode){
                    
                    //can add some action when after update the FW
                    //                        if (i == [deviceArr count] - 1) {
                    //                            dispatch_async(dispatch_get_main_queue(), ^{
                    //                                [leftScanView setStringValue:@""];
                    //                                [leftScanView becomeFirstResponder];
                    //                                [leftScanView setEditable:[self testing1]];
                    //                                [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
                    //
                    //                                [rightScaniew setStringValue:@""];
                    //                                [rightScaniew becomeFirstResponder];
                    //                                [rightScaniew setEditable:[self testing2]];
                    //                                [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
                    //                            });
                    //                        }
                }];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [_updateFWTitle setStringValue:[NSString stringWithFormat:@"FW Upgrading...Device_%d -->%@",i+1,fwName]];
            });
            
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *pyPath = [[NSBundle mainBundle] pathForResource:@"UpdateFW" ofType:@"py"];
            // NSString *FWPath = fwPath_Version[0];
            
            NSArray *argumentsArr2 = [NSArray arrayWithObjects: pyPath, te.device.portName, fwPath, nil];
            
            [self launchExternalForUpdateFW:@"/usr/bin/python" arguments:argumentsArr2];
            //[self upgradeFw:fwPath serail:te];
            
            NSLog(@"###################update compelete##########################");
//            [NSThread sleepForTimeInterval:10];
            
            
            NSString *getVerRespond = [te sendCommandAndReadResponse:@"getversion"];
            if ([getVerRespond isEqualToString:@"null"] ||[getVerRespond length] == 0) {
                [NSThread sleepForTimeInterval:2];
                getVerRespond = [te sendCommandAndReadResponse:@"getversion"];
                
            }
            if ([getVerRespond isEqualToString:@"null"] ||[getVerRespond length] == 0) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [MyEexception RemindException:@"Update latest Ffireware version successful" Information:[NSString stringWithFormat:@"Please reconnect the devide and open app again"]];
                    NSLog(@"red current FW version failure");
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ read current FW version failure!",[LogFile CurrentTimeForLog]]];
                });
                [NSApp terminate:nil];
            }
            //@"}\n{\"version\": \"3.2_210317\"}\r\n"
             NSString *FWVersion = [getVerRespond cw_getStringBetween:@"{\"version\": \"" and:@"\"}\r\n"];
//            NSDictionary *fwVerDic = [JasonUtilities loadJSONContentToDictionary:getVerRespond];
//            NSString *FWVersion = [fwVerDic valueForKey:@"version"];
            if (i>1 && [FWVersion isNotEqualTo:currentFWName]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [MyEexception RemindException:@"fw version inconsistency" Information:[NSString stringWithFormat:@"Please check all the iports fw version are the same"]];
                    NSLog(@"red current FW version failure");
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ fw version inconsistency----serial port:%@!",[LogFile CurrentTimeForLog],te.device.portName]];
                });
                [NSApp terminate:nil];
            }
            currentFWName=FWVersion;
            [self showVersionUI:FWVersion];
      
        }else{
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:@"same fw version,no need update"];
        }
    }else{
        NSLog(@"can't get the FW version,please check serial connect!");
        
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ can't get the FW version,please check serial connect!",[LogFile CurrentTimeForLog]]];
    }
    
      [self mapIPortPosition:te num:i FWPath:fwPath];
    
    //    if (![[configDic valueForKey:DEBUGMODE] boolValue]) {
    //        [self mapIPortPosition:te num:i];
    //    }
    
}


-(void)updateFWWithInfo:(NSString *)extStr{

        if ([extStr containsString:@"error"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"Incorrect response from iPort." Information:@"upgraded FW fail! Please try upgrading again."];
                [_MainWindow endSheet:_updateFWWindow];
            });
            
            [Task terminate];
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ upgraded FW Fail!",[LogFile CurrentTimeForLog]]];
            
            [NSApp terminate:nil];
        }
        
    
        extStr = [extStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"standard string ready %@",extStr);
        //        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ standard data ready %ld bytes--extStr:%@",[LogFile CurrentTimeForLog],data.length,extStr]];
        NSScanner *scanner = [NSScanner scannerWithString:extStr];
        [scanner scanUpToString:@"t:" intoString:NULL];
        NSString *strPercent;
        [scanner scanUpToString:@"%" intoString:&strPercent];
        strPercent=[strPercent stringByReplacingOccurrencesOfString:@"t: " withString:@""];
        
        float percent = [strPercent floatValue];
        if (isUpdateFW) {
            // only for FW update
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![extStr containsString:@"-----Upadate start-----"]) {
                    [_EnableSN1 setEnabled:NO];
                    [_EnableSN2 setEnabled:NO];
                    [leftScanView setEditable:NO];
                    [rightScaniew setEditable:NO];
                    [leftScanView setBackgroundColor:NSColor.controlColor];
                    [rightScaniew setBackgroundColor:NSColor.controlColor];
                    [_btnStart setEnabled:NO];
                    [_fwProgressIndicator setDoubleValue:percent/100];
                    [_lbFWUpdateStatus setStringValue:extStr];
                }
            });
            
            if ([extStr containsString:@"Quit."]) {

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_MainWindow endSheet:_updateFWWindow];
                });
                
                NSLog(@"Update FW Finish!");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Update FW Finish!",[LogFile CurrentTimeForLog]]];
            }
        }
    
    
}
-(BOOL)upgradeFw:(NSString *)fwFile serail:(TestEngine *)te{
    BOOL upgradeSucess = NO;
    NSString *fwContent = [CWFileManager cw_readFromFile:fwFile];
    if (fwContent.length) {
        NSArray *arr = [fwContent componentsSeparatedByString:@"\r\n"];
        if (arr.count) {
            NSString *output =[te sendCommandAndReadResponse:@"update mcu"];
            if ([output containsString:@"next\n"]) {
                NSDate *t0 = [NSDate date];
                for (int i =0; i<arr.count; i++) {
                    NSString *cmd =arr[i];
                    NSString *reply = [te sendCommandAndReadResponse:cmd];
                    if ([reply containsString:@"next\n"]) {
                        NSTimeInterval interval = [t0 timeIntervalSinceDate:[NSDate date]];
                        float per = i*100.0/arr.count;
                        NSString *exstr = [NSString stringWithFormat:@"\rTime: %f s\tPercent: %.2f %%",interval,per];
                        [self updateFWWithInfo:exstr];
                    }else{
                        [self updateFWWithInfo:@"error"];
                        return NO;
                    }
                }
                
                NSString *reply =[te sendCommandAndReadResponse:@"update end"];
                if ([reply isEqualToString:@"next\n"]) {
                    upgradeSucess = YES;
                    NSLog(@"Update success");
                }
            }
        }
    }
    
    [self updateFWWithInfo:@"Quit.\n"];
    return upgradeSucess;
    
}

-(void)checkAndUpdateFW:(TestEngine *)te num:(int)i{
    [self checkAndUpdateFW:te num:i fwPath:[self getDefaultFWPath]];
}



//-(void)checkAndUpdateFW:(TestEngine *)te num:(int)i{
//    [self checkAndUpdateFW:te num:i fwName:nil];
//}


-(NSString*)getCheckSumFromFile:(NSString*)path{
    if ([[configDic valueForKey:DEBUGMODE] boolValue]) {
        return @"debugCheckSum";
    }
    //NSString *configPath = [[NSBundle mainBundle] pathForResource:@"DefaultConfig" ofType:@"csv"];
    //NSString *configPath = [NSString stringWithFormat:@"/tmp/%@",USERCONFIG];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //NSString *defaultConfigPath = [[NSBundle mainBundle] pathForResource:@"DefaultConfig" ofType:@"csv"];
        if (path ==nil) {
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ use default configuration",[LogFile CurrentTimeForLog]]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"No Confige file" Information:[NSString stringWithFormat:@"Please make sure have config file:DefaultConfig.csv"]];
            });
            [NSApp terminate:nil];
        }
        return @"0";
    }
    else{
        NSString *configContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        uLong crc = [crc32Utilities crc32WithFilePath:path];
        NSLog(@"configContent = %@\ncrc = %lu",configContent,crc);
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ configContent = %@\ncrc = %lu",[LogFile CurrentTimeForLog],configContent,crc]];
        return [NSString stringWithFormat:@"%lu",crc];
    }
}

-(void) DoStartTest
{
    
    if (testStatus == TESTING)
    {
        return;
    }
    
    if (!self->singleDUT && !self -> testingLeft && !self -> testingRight)
    {
        return;
    }

    if (![self updateTestCountWithIsAdd:YES]) {
        return;
    }
    
    [self updateTestSNs];

    testStatus = TESTING;

    allTestTimes++;

//    [leftScanView setEditable:NO];
//    [rightScaniew setEditable:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_EnableSN1 setEnabled:NO];
        [_EnableSN2 setEnabled:NO];
        [leftScanView setBackgroundColor:NSColor.controlColor];
        [rightScaniew setBackgroundColor:NSColor.controlColor];
        [_btnStart setEnabled:NO];
    });


    NSLog(@"Disable controlling while starting testing.");

    NSDateFormatter* nsdf = [[NSDateFormatter alloc]init];
    [nsdf setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    startdate = [NSDate date];
    StartTestTime = [nsdf stringFromDate:startdate];

    NSLog(@"Starting test, test times: %ld", (long)allTestTimes);
    
    [self startCycleTimer];
    [NSThread detachNewThreadSelector:@selector(StartTest) toTarget:self withObject:nil];
}

#pragma mark StartButtonClick
- (IBAction)btnStartTest:(id)sender {
    //check device before test
    _isTesting = YES;
    BOOL isDebug =[[configDic valueForKey:DEBUGMODE] boolValue];
    if (isDebug||_officeMode) {
        
        [self btnDebugSNClick:self];
        
        
        // deviceArr = [SerialPort serialPortList];
        //        if ([deviceArr count] ==0 ) {
        //            testStatus = INIT;
        //            dispatch_sync(dispatch_get_main_queue(), ^{
        //                [MyEexception RemindException:@"Disconnect" Information:[NSString stringWithFormat:@"Please connect the iport then repopen the app"]];
        //            });
        //
        //            [NSApp terminate:nil];
        //        }
    }


    
    if ([self ScanSNValidation]) {
        NSLog(@"Kick off a test while start button clicking.");
        [self DoStartTest];
    }else{
        [leftEnableBtn setEnabled:YES];
        [rightEnableBtn setEnabled:YES];
    }
}

-(void)cleanUI{
    [rightScaniew setStringValue:@""];
    [leftScanView setStringValue:@""];
    [leftScanView setEnabled:YES];
    [rightScaniew setEnabled:YES];
    [testItems removeAllObjects];
    [testLeftItems removeAllObjects];
    [testRightItems removeAllObjects];
    [failedItems removeAllObjects];
    [failedRightItems removeAllObjects];
    [failedLeftItems removeAllObjects];
    [testCounts removeAllObjects];
    //[quickPuddingLefts removeAllObjects];
   // [quickPuddingRights removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cleanAllInfo];
        [_testView reloadData];
        [_failOnlyView reloadData];
    });
}

- (void)StartTest{//sc
    //[self sendMainCommandWithPort:nil];
    
    [testItems removeAllObjects];
    [testLeftItems removeAllObjects];
    [testRightItems removeAllObjects];
    [failedItems removeAllObjects];
    [failedRightItems removeAllObjects];
    [failedLeftItems removeAllObjects];
    [testCounts removeAllObjects];
    //[quickPuddingLefts removeAllObjects];
   // [quickPuddingRights removeAllObjects];

    dispatch_sync(dispatch_get_main_queue(), ^{
        [self cleanAllInfo];
        [_testView reloadData];
        [_failOnlyView reloadData];
    });

    if (!self->singleDUT && !self -> testingLeft && !self -> testingRight)
    {
        return;
    }

    // start puddying
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"StartTest--deviceCount=%d--debugMode=%d--officeMode=%d--auditMode=%d--combineTest=%d--testingLeft=%d--testingRight=%d--singleDUT=%d",deviceCount,[[configDic valueForKey:DEBUGMODE] boolValue],_officeMode,_auditMode,combineTest,testingLeft,testingRight,singleDUT]];
   
    
    if (![[configDic valueForKey:DEBUGMODE] boolValue]){
        [self handleIportTest];
    }
    else{
        [self handleIportTest_Debug];
    }
    
    if (loopTimes ==0 && looping) {
        [self.loopWC stopLoop];
        looping = NO;
    }
    

}
#pragma mark handleIportTest
-(NSString *)sendMainCommandWithPort:(TestEngine *)te{
    [NSThread sleepForTimeInterval:delay/2];
//
    NSString *getVerRespond = [te sendCommandAndReadResponse:@"getversion\n"];
    NSString *FWVersion = [getVerRespond cw_getStringBetween:@"{\"version\": \"" and:@"\"}\r\n"];
//    NSDictionary *fwVerDic = [JasonUtilities loadJSONContentToDictionary:getVerRespond];
//    NSString *FWVersion = [fwVerDic valueForKey:@"version"];
    if ([FWVersion isNotEqualTo:currentFWName]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"fw version inconsistency" Information:[NSString stringWithFormat:@"Please check all the iports fw version are the same"]];
            NSLog(@"red current FW version failure");
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ fw version inconsistency----serial port:%@!",[LogFile CurrentTimeForLog],te.device.portName]];
        });
        [NSApp terminate:nil];
    }

    [te sendCommandAndReadResponse:@"getcfg grp\n"];
    [NSThread sleepForTimeInterval:delay/2];
    NSDate *t0 = [NSDate date];
    NSString *output = [te sendCommandAndReadResponse:@"debug key1"];

    if (!([output containsString:STARTSINGAL]&&[output containsString:ENDSINGAL])) {//!str.length && !output.length
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"ERROR" Information:@"send debugkey1 command but wrong reponse,pls check device!"];
            exit (EXIT_FAILURE);
        });

    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:t0];
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ debug key1 execute time:%f",[LogFile CurrentTimeForLog],interval]];
//    NSString *output  = @"";
    return output;
}

-(void)handleIportTest{//sc
    // Below group has never been used, so comment it.
    // dispatch_group_t group = dispatch_group_create();
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--handleIportTest--deviceCount=%d,app_version=%@",[LogFile CurrentTimeForLog],deviceCount,[self getAPPVersion]]];
    
    NSString *dir=[NSString stringWithFormat:@"%@/%@",LOGSNDER,[LogFile CurrentDateForLocalCSV]];
    [CWFileManager cw_createFile:dir isDirectory:YES];
    NSString *snFileLeft=[NSString stringWithFormat:@"%@/%@",dir,snOnLeft];
    NSString *snFileRight=[NSString stringWithFormat:@"%@/%@",dir,snOnRight];
    NSString *currentTime = [LogFile CurrentTimeForFile];
    
    if ([[configDic valueForKey:@"iPortType"] isEqualToString:@"iPortAir"]) {
        NSMutableArray * dataDic = [[NSMutableArray alloc] init];
        if ([deviceArr count] == 1) {
            NSString *comboStr = @"";
            NSString *ccpin_comboStr = @"";
            NSInteger totalCount = 0;
            NSString *output = @"";
            __block NSString *ccpin_output = @"";
            NSString *vbus_comboStr = @"";
            TestEngine *te = TeEngArr[0];
            
//            NSString *str = [NSString stringWithFormat:@"send command:getcfg grp\nreply:%@",[te sendCommandAndReadResponse:@"getcfg grp"]];
//            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:str];
//       
//            output = [te sendCommandAndReadResponse:@"debug key1"];
//            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"send command:debug key1\nreply:%@",output]];
          
            
            output = [self sendMainCommandWithPort:te];
            
            if (self -> testingLeft)
            {
                [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_Uart.txt",snOnLeft,[LogFile CurrentTimeForFile]] Content:output currenttime:currentTime];
            }
            
            if (self -> testingRight && !self->singleDUT)
            {
                [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_Uart.txt",snOnRight,[LogFile CurrentTimeForFile]] Content:output currenttime:currentTime];
            }
            

            

            if ([output containsString:TESTCMD]) {
                NSRange range = [output rangeOfString:TESTCMD];
                output = [output substringFromIndex:range.location + range.length + 1];
            }

            if (need_ccpintest) {
                ccpin_output = [te sendCommandAndReadResponse:@"ccpintest"];
                if (self -> testingLeft)
                {
                    [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_ccpintest.txt",snOnLeft,[LogFile CurrentTimeForFile]] Content:ccpin_output currenttime:currentTime];
                }

                if (self -> testingRight && !self->singleDUT)
                {
                    [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_ccpintest.txt",snOnRight,[LogFile CurrentTimeForFile]] Content:ccpin_output currenttime:currentTime];
                }

                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:ccpin_output];

                if ([ccpin_output containsString:STARTSINGAL]) {
                    NSRange range = [ccpin_output rangeOfString:STARTSINGAL];
                    ccpin_output = [ccpin_output substringFromIndex:range.location + range.length + 1];
                    if ([ccpin_output containsString:ENDSINGAL]) {
                        NSRange range2 = [ccpin_output rangeOfString:ENDSINGAL];
                        ccpin_output = [ccpin_output substringToIndex:range2.location -1];
                    }
                }

                ccpin_comboStr = [ccpin_comboStr stringByAppendingString:[NSString stringWithFormat:@"%@",ccpin_output]];
            }

            // for vbustest
            // There would never need VBUS TEST cause it has already been merged with debugkey1 test from FW 1126 on.
            if (![product isEqualToString:@"J174"] && need_vbusest) {
                NSString *vbus_output = [te sendCommandAndReadResponse:@"vbustest"];
                if (self -> testingLeft)
                {
                    [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_vbustest.txt",snOnLeft,[LogFile CurrentTimeForFile]] Content:vbus_output currenttime:currentTime];
                }

                if (self -> testingRight && !self->singleDUT)
                {
                    [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_vbustest.txt",snOnRight,[LogFile CurrentTimeForFile]] Content:vbus_output currenttime:currentTime];
                }

                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:vbus_output];

                if ([vbus_output containsString:STARTSINGAL]) {
                    NSRange range = [vbus_output rangeOfString:STARTSINGAL];
                    vbus_output = [vbus_output substringFromIndex:range.location + range.length + 1];
                    if ([vbus_output containsString:ENDSINGAL]) {
                        NSRange range2 = [vbus_output rangeOfString:ENDSINGAL];
                        vbus_output = [vbus_output substringToIndex:range2.location -1];
                    }
                }

                NSInteger vbus_itemCount = [[ccpin_output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ vbustest output items count is:%ld",[LogFile CurrentTimeForLog],vbus_itemCount]];
                vbus_comboStr = [vbus_comboStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",vbus_output]];
            }

            comboStr = [comboStr stringByAppendingString:[NSString stringWithFormat:@"%@", output]];
            totalCount = [[comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ totally output items count is:%ld",[LogFile CurrentTimeForLog],totalCount]];

            NSArray *jsonArr = [comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSMutableArray *finalArr=[NSMutableArray arrayWithArray:jsonArr];

            // remove the empty
            for (int i = 0; i < [finalArr count]; i++) {
                NSString *tmp = finalArr[i];
                if ([tmp length] == 0) {
                    [finalArr removeObject:tmp];
                }
            }

            if (need_ccpintest) {
                NSArray *ccpin_jsonArr = [ccpin_comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                for (NSString *ccpin in ccpin_jsonArr) {
                    if ([ccpin length] > 0) {
                        [finalArr insertObject:ccpin atIndex:[finalArr count]-1];
                    }
                }
            }

            NSArray *vbus_jsonArr=[vbus_comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            for (NSString *vbus in vbus_jsonArr) {
                if ([vbus length] > 0) {
                    [finalArr insertObject:vbus atIndex:[finalArr count]-1];
                }
            }

            [dataDic addObject:finalArr];
        }
        else{
            for (int i = 0; i < deviceCount; i++) {
                NSString *comboStr = @"";
                NSString *ccpin_comboStr = @"";
                NSInteger totalCount = 0;
                NSString *output = @"";
                __block NSString *ccpin_output = @"";
                NSInteger itemCount = 0;
                NSString *vbus_comboStr = @"";
                TestEngine *te = TeEngArr[i];
                if ([te.device.portName isEqualToString:deviceArr[i]]) {

                    output = [self sendMainCommandWithPort:te];
                    if (self -> testingLeft)
                    {
                        [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_Uart.txt", snOnLeft, currentTime] Content:output currenttime:currentTime];
                    }

                    if (self -> testingRight && !self->singleDUT)
                    {
                        [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_Uart.txt", snOnRight, currentTime] Content:output currenttime:currentTime];
                    }

                    if (self->combineTest && deviceCount > 1)
                    {
                        if (i == 0) {
                            if ([output containsString:TESTCMD]) {
                                NSRange range = [output rangeOfString:TESTCMD];
                                output = [output substringFromIndex:range.location + range.length + 1];
                                if ([output containsString:ENDSINGAL]) {
                                    NSRange range2 = [output rangeOfString:ENDSINGAL];
                                    output = [output substringToIndex:range2.location - 1];
                                }
                            }
                        }
                        else if(i == deviceCount - 1){
                            if ([output containsString:TESTCMD]) {
                                NSRange range = [output rangeOfString:TESTCMD];
                                output = [output substringFromIndex:range.location + range.length + 1];
                                if ([output containsString:STARTSINGAL]) {
                                    NSRange range2 = [output rangeOfString:STARTSINGAL];
                                    output = [output substringFromIndex:range2.location + range2.length + 1];
                                }
                            }
                        }
                        else if ([output containsString:TESTCMD]) {
                            NSRange range = [output rangeOfString:TESTCMD];
                            output = [output substringFromIndex:range.location + range.length + 1];
                            if ([output containsString:STARTSINGAL]) {
                                NSRange range2 = [output rangeOfString:STARTSINGAL];
                                output = [output substringFromIndex:range2.location+range2.length +1];
                            }

                            if ([output containsString:ENDSINGAL]) {
                                NSRange range3 = [output rangeOfString:ENDSINGAL];
                                output = [output substringToIndex:range3.location -1];
                            }
                        }
                    }
                    else if ([output containsString:TESTCMD]){
                        NSRange range = [output rangeOfString:TESTCMD];
                        output = [output substringFromIndex:range.location + range.length + 1];
                    }

                    itemCount = [[output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-- iport_%d output items count is:%ld",[LogFile CurrentTimeForLog],i,itemCount]];
                    
                    comboStr = [comboStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",output]];

                    totalCount = [[comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-- totally output items count is:%ld",[LogFile CurrentTimeForLog], totalCount]];

                    if (need_ccpintest) {
                        // for ccpintest
                        ccpin_output = [te sendCommandAndReadResponse:@"ccpintest"];
                        if (self -> testingLeft)
                        {
                            [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_ccpintest_%d.txt",snOnLeft,[LogFile CurrentTimeForFile], i + 1] Content:ccpin_output currenttime:currentTime];
                        }

                        if (self -> testingRight && !self->singleDUT)
                        {
                            [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_ccpintest_%d.txt",snOnRight,[LogFile CurrentTimeForFile], i + 1] Content:ccpin_output currenttime:currentTime];
                        }

                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:ccpin_output];

                        if ([ccpin_output containsString:STARTSINGAL]) {
                            NSRange range = [ccpin_output rangeOfString:STARTSINGAL];
                            ccpin_output = [ccpin_output substringFromIndex:range.location + range.length + 1];
                            if ([ccpin_output containsString:ENDSINGAL]) {
                                NSRange range2 = [ccpin_output rangeOfString:ENDSINGAL];
                                if (range2.location > 0)
                                {
                                    ccpin_output = [ccpin_output substringToIndex:range2.location - 1];
                                }
                                else
                                {
                                    ccpin_output = @"";
                                }
                            }
                        }

                        __block NSInteger ccpin_itemCount = 0;
                        ccpin_itemCount = [[ccpin_output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ ccpintest_%d output items count is:%ld",[LogFile CurrentTimeForLog],i+1,ccpin_itemCount]];
                        ccpin_comboStr = [ccpin_comboStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",ccpin_output]];
                    }

                    // for vbus test
                    // There would never need VBUS TEST cause it has already been merged with debugkey1 test.
                    if (![product isEqualToString:@"J174"] && need_vbusest) {
                        NSString *vbus_output = [te sendCommandAndReadResponse:@"vbustest"];
                        if (self -> testingLeft)
                        {
                            [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_vbustest_%d.txt", snOnLeft, [LogFile CurrentTimeForFile], i + 1] Content:vbus_output currenttime:currentTime];
                        }

                        if (self -> testingRight && !self->singleDUT)
                        {
                            [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_vbustest_%d.txt", snOnRight, [LogFile CurrentTimeForFile], i + 1] Content:vbus_output currenttime:currentTime];
                        }

                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:vbus_output];

                        if ([vbus_output containsString:STARTSINGAL]) {
                            NSRange range = [vbus_output rangeOfString:STARTSINGAL];
                            vbus_output = [vbus_output substringFromIndex:range.location + range.length + 1];
                            if ([vbus_output containsString:ENDSINGAL]) {
                                NSRange range2 = [vbus_output rangeOfString:ENDSINGAL];
                                if (range2.location > 0)
                                {
                                    vbus_output = [vbus_output substringToIndex:range2.location - 1];
                                }
                                else
                                {
                                    vbus_output = @"";
                                }
                            }
                        }

                        NSInteger vbus_itemCount = [[vbus_output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ vbustest_%d output items count is:%ld", [LogFile CurrentTimeForLog], i+1, vbus_itemCount]];
                        vbus_comboStr = [vbus_comboStr stringByAppendingString:[NSString stringWithFormat:@"\n%@", vbus_output]];
                    }

                    NSArray *jsonArr = [comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    NSMutableArray *finalArr=[NSMutableArray arrayWithArray:jsonArr];

                    // remove the empty
                    for (int i = 0; i < [finalArr count]; i++) {
                        NSString *tmp = finalArr[i];
                        if ([tmp length] == 0) {
                            [finalArr removeObject:tmp];
                        }
                    }

                    if (need_ccpintest) {
                        NSArray *ccpin_jsonArr = [ccpin_comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                        for (NSString *ccpin in ccpin_jsonArr) {
                            if ([ccpin length] > 0) {
                                [finalArr insertObject:ccpin atIndex:[finalArr count]-1];
                            }
                        }
                    }

                    NSArray *vbus_jsonArr=[vbus_comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    for (NSString *vbus in vbus_jsonArr) {
                        if ([vbus length] > 0) {
                            [finalArr insertObject:vbus atIndex:[finalArr count]-1];
                        }
                    }
                    NSLog(@"Data Item: %ld, currently: %ld, device count: %d", (totalCount - 2), (totalCount - 2) / deviceCount, deviceCount);

//                    NSLog(@"Data Item: %ld, currently: %ld, device count: %d, expected: %ld", (totalCount - 2), (totalCount - 2) / deviceCount, deviceCount, testItemcCount * 2);

                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ total test item is %ld",[LogFile CurrentTimeForLog],[finalArr count]]];

                    if (self->combineTest)
                    {
                        if ([dataDic count] > 0)
                        {
                            NSArray * arr = dataDic[0];
                            arr = [arr arrayByAddingObjectsFromArray:finalArr];
                            [dataDic setObject:arr atIndexedSubscript:0];
                        }
                        else
                        {
                            [dataDic addObject:finalArr];
                        }
                    }
                    else
                    {
                        [dataDic addObject:finalArr];
                    }
                }
            }
        }

        [self loadTestData:dataDic snFileLeft:snFileLeft snFileRight:snFileRight currenttime:currentTime];
    }
}



#pragma mark handleIportTest Debug
-(void)handleIportTest_Debug{
    dispatch_group_t group = dispatch_group_create();
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Enter handle %ld Iport in Debug Mode",[LogFile CurrentTimeForLog],[deviceArr count]]];
    NSString *dir=[NSString stringWithFormat:@"%@/%@",LOGSNDER,[LogFile CurrentDateForLocalCSV]];
    [CWFileManager cw_createFile:dir isDirectory:YES];
    NSString *snFileLeft=[NSString stringWithFormat:@"%@/%@",dir,snOnLeft];
    NSString *snFileRight=[NSString stringWithFormat:@"%@/%@",dir,snOnRight];
    if ([[configDic valueForKey:@"iPortType"] isEqualToString:@"iPortAir"]) {
        NSMutableArray * dataDic = [[NSMutableArray alloc] init];
        if ([deviceArr count]==1) {
            NSString *output=@"";
            __block NSString *ccpin_output=@"";
            NSString *comboStr=@"";
            __block NSString *ccpin_comboStr=@"";
            TestEngine *te = TeEngArr[0];
          
            output = mytest ? [te ReadFromTestFile]: [te ReadFromTestFile2];
            mytest = !mytest;
            if (self -> testingLeft)
            {
                [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_debug_Uart.txt",snOnLeft,[LogFile CurrentTimeForFile]] Content:output];
            }

            if (self -> testingRight && !self->singleDUT)
            {
                [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_debug_Uart.txt",snOnRight,[LogFile CurrentTimeForFile]] Content:output];
            }

            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:output];

            if ([output containsString:TESTCMD]) {
                NSRange range = [output rangeOfString:TESTCMD];
                output = [output substringFromIndex:range.location + range.length + 1];
            }

            sleep(1);
            if (need_ccpintest) {
                ccpin_output = [te ReadForCcpinTest];
                if (self -> testingLeft)
                {
                    [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_debug_ccpintest.txt",snOnLeft,[LogFile CurrentTimeForFile]] Content:ccpin_output];
                }

                if (self -> testingRight && !self->singleDUT)
                {
                    [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_debug_ccpintest.txt",snOnRight,[LogFile CurrentTimeForFile]] Content:ccpin_output];
                }

                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:ccpin_output];

                if ([ccpin_output containsString:STARTSINGAL]) {
                    NSRange range = [ccpin_output rangeOfString:STARTSINGAL];
                    ccpin_output =[ccpin_output substringFromIndex:range.location + range.length + 1];
                    if ([ccpin_output containsString:ENDSINGAL]) {
                        NSRange range2 = [ccpin_output rangeOfString:ENDSINGAL];
                        ccpin_output = [ccpin_output substringToIndex:range2.location -1];
                    }
                }
                ccpin_comboStr=[ccpin_comboStr stringByAppendingString:[NSString stringWithFormat:@"%@",ccpin_output]];
            }

            sleep(1);
            comboStr = [comboStr stringByAppendingString:[NSString stringWithFormat:@"%@",output]];

            NSArray *jsonArr = [comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSMutableArray *finalArr=[NSMutableArray arrayWithArray:jsonArr];

            // remove the empty
            for (int i=0; i<[finalArr count]; i++) {
                NSString *tmp = finalArr[i];
                if ([tmp length] == 0) {
                    [finalArr removeObject:tmp];
                }
            }

            if (need_ccpintest) {
                NSArray *ccpin_jsonArr=[ccpin_comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                for (NSString *ccpin in ccpin_jsonArr) {
                    if ([ccpin length]>0) {
                        [finalArr insertObject:ccpin atIndex:[finalArr count]-1];
                    }
                }
            }

            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ total test item is %ld",[LogFile CurrentTimeForLog],[finalArr count]]];
            [dataDic addObject:finalArr];
        }
        else{
            for (int i = 0; i < deviceCount; i++) {
                NSString *output=@"";
                __block NSString *ccpin_output=@"";
                NSInteger itemCount=0;
                NSString *comboStr=@"";
                __block NSString *ccpin_comboStr=@"";
                NSInteger totalCount = 0;
                TestEngine *te = TeEngArr[i];
                if ([te.device.portName isEqualToString:deviceArr[i]]) {
                  // output = [te ReadFromTestFile];
                    output = i%2 ? [te ReadFromTestFile2] : [te ReadFromTestFile];
                    if (self -> testingLeft)
                    {
                        [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_Uart.txt",snOnLeft,[LogFile CurrentTimeForFile]] Content:output];
                    }

                    if (self -> testingRight && !self->singleDUT)
                    {
                        [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_Uart.txt",snOnRight,[LogFile CurrentTimeForFile]] Content:output];
                    }

                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:output];

                    if (need_ccpintest) {
                        dispatch_group_async(group, _queue, ^{
                            ccpin_output = [te ReadForCcpinTest];
                            if (self -> testingLeft)
                            {
                                [LogFile AddLog:snFileLeft FileName:[NSString stringWithFormat:@"%@_%@_ccpintest_%d.txt",snOnLeft,[LogFile CurrentTimeForFile], i + 1] Content:ccpin_output];
                            }

                            if (self -> testingRight && !self->singleDUT)
                            {
                                [LogFile AddLog:snFileRight FileName:[NSString stringWithFormat:@"%@_%@_ccpintest_%d.txt",snOnRight,[LogFile CurrentTimeForFile], i + 1] Content:ccpin_output];
                            }

                            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:ccpin_output];

                            if ([ccpin_output containsString:STARTSINGAL]) {
                                NSRange range = [ccpin_output rangeOfString:STARTSINGAL];
                                ccpin_output =[ccpin_output substringFromIndex:range.location + range.length + 1];
                                if ([ccpin_output containsString:ENDSINGAL]) {
                                    NSRange range2 = [ccpin_output rangeOfString:ENDSINGAL];
                                    ccpin_output = [ccpin_output substringToIndex:range2.location -1];
                                }
                            }
                        });

                        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
                        NSInteger ccpin_itemCount = 0;
                        ccpin_itemCount=[[ccpin_output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ ccpintest_%d output items count is:%ld",[LogFile CurrentTimeForLog],i+1,ccpin_itemCount]];
                    }

                    if (self->combineTest)
                    {
                        if (i==0) {
                            if ([output containsString:TESTCMD]) {
                                NSRange range = [output rangeOfString:TESTCMD];
                                output = [output substringFromIndex:range.location + range.length + 1];
                                if ([output containsString:ENDSINGAL]) {
                                    NSRange range2 = [output rangeOfString:ENDSINGAL];
                                    output = [output substringToIndex:range2.location -1];
                                }
                            }
                        }
                        else if(i==deviceCount-1){
                            if ([output containsString:TESTCMD]) {
                                NSRange range = [output rangeOfString:TESTCMD];
                                output = [output substringFromIndex:range.location + range.length + 1];
                                if ([output containsString:STARTSINGAL]) {
                                    NSRange range2 = [output rangeOfString:STARTSINGAL];
                                    output = [output substringFromIndex:range2.location+range2.length +1];
                                }
                            }
                        }
                        else{
                            if ([output containsString:TESTCMD]) {
                                NSRange range = [output rangeOfString:TESTCMD];
                                output = [output substringFromIndex:range.location + range.length + 1];
                                if ([output containsString:STARTSINGAL]) {
                                    NSRange range2 = [output rangeOfString:STARTSINGAL];
                                    output = [output substringFromIndex:range2.location+range2.length +1];
                                }
                                if ([output containsString:ENDSINGAL]) {
                                    NSRange range3 = [output rangeOfString:ENDSINGAL];
                                    output = [output substringToIndex:range3.location -1];
                                }
                            }
                        }
                    }
                    else if ([output containsString:TESTCMD]) {
                        NSRange range = [output rangeOfString:TESTCMD];
                        output = [output substringFromIndex:range.location + range.length + 1];
                    }

                    itemCount=[[output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ iport_%d output items count is:%ld",[LogFile CurrentTimeForLog],i+1,itemCount]];
                    
                    comboStr=[comboStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",output]];
                    if (need_ccpintest) {
                        ccpin_comboStr=[ccpin_comboStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",ccpin_output]];
                    }
                    
                }

                sleep(1);

                totalCount = [[comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ totally output items count is:%ld",[LogFile CurrentTimeForLog],totalCount]];

                NSArray *jsonArr = [comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                NSMutableArray *finalArr=[NSMutableArray arrayWithArray:jsonArr];

                // remove the empty
                for (int i=0; i<[finalArr count]; i++) {
                    NSString *tmp = finalArr[i];
                    if ([tmp length] == 0) {
                        [finalArr removeObject:tmp];
                    }
                }

                if (need_ccpintest) {
                    NSArray *ccpin_jsonArr=[ccpin_comboStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    for (NSString *ccpin in ccpin_jsonArr) {
                        if ([ccpin length]>0) {
                            [finalArr insertObject:ccpin atIndex:[finalArr count]-1];
                        }
                    }
                }

                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ total test item is %ld",[LogFile CurrentTimeForLog],[finalArr count]]];

                if (self->combineTest)
                {
                    if ([dataDic count] > 0)
                    {
                        NSArray * arr = dataDic[0];
                        [arr arrayByAddingObjectsFromArray:finalArr];
                    }
                    else
                    {
                        [dataDic addObject:finalArr];
                    }
                }
                else
                {
                    [dataDic addObject:finalArr];
                }
            }
        }

        [self loadTestData:dataDic snFileLeft:snFileLeft snFileRight:snFileRight currenttime:nil];
    }
}

#pragma mark LoadTestData
-(void)loadTestData:(NSArray *)dataDic snFileLeft:(NSString *)snFileLeft snFileRight:(NSString *)snFileRight currenttime:(NSString *)currentTime{//sc
    
    if (!self->singleDUT && !self -> testingLeft && !self -> testingRight)
    {
        return;
    }

    int dutCount = deviceCount;
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--loadTestData--count:%lu",[LogFile CurrentTimeForLog],(unsigned long)dataDic.count]];
    if (self->combineTest)
    {
        dutCount = 1;
    }

    NSString *csvtitle = [NSString stringWithFormat:@"NO.,Pos,Group,Type,Item Name,Map Name,OpenLimit,ShortLimit,Value,Unit,Result\n"];
    NSString *csvFileNameLeft = @"";;
    NSString *csvFileNameRight = @"";
    if (dataDic.count) {
        
        if (self -> testingLeft)
        {
            csvFileNameLeft = [NSString stringWithFormat:@"%@_%@_%@", snOnLeft, [LogFile CurrentTimeForFile], CSVFILENAME];
            [LogFile AddLog:snFileLeft FileName:csvFileNameLeft Content:csvtitle currenttime:currentTime];
        }
        
        if (self -> testingRight && !self->singleDUT)
        {
            csvFileNameRight = [NSString stringWithFormat:@"%@_%@_%@", snOnRight, [LogFile CurrentTimeForFile], CSVFILENAME];
            [LogFile AddLog:snFileRight FileName:csvFileNameRight Content:csvtitle currenttime:currentTime];
        }
        
       // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:csvtitle];
    }
    
    for (int idx = 0; idx < dutCount; idx++)
    {
        if ([dataDic count] <= idx)
        {
            break;
        }

        NSArray * jsonData = [dataDic objectAtIndex:idx];
        u_long count = [jsonData count];
        for(NSString *lineConte in jsonData) {
            if ([lineConte isEqualToString:@""]) {
                NSLog(@"minus a emptey line");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ minus a emptey line",[LogFile CurrentTimeForLog]]];
                count--;
            }
        }

        // minus the start and end test item singal.
        count -= 2;
        int index = 0;
        NSLog(@"itemCount = %ld", (long)count);
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ itemCount = %ld", [LogFile CurrentTimeForLog], (long)count]];
        if (count > 0) {
            //add csv title
//            NSString *csvtitle = [NSString stringWithFormat:@"NO.,Pos,Group,Pin No.,Net Name,Type,OpenLimit,ShortLimit,Value,Unit,Result\n"];
//            NSString *csvFileNameLeft = @"";;
//            NSString *csvFileNameRight = @"";
//            if (self -> testingLeft)
//            {
//                csvFileNameLeft = [NSString stringWithFormat:@"%@_%@_%@_%d", snOnLeft, [LogFile CurrentTimeForFile], CSVFILENAME,idx+1];
//                [LogFile AddLog:[NSString stringWithFormat:@"%@/%@", LOGFOLDER, snOnLeft] FileName:csvFileNameLeft Content:csvtitle];
//            }
//
//            if (self -> testingRight && !self->singleDUT)
//            {
//                csvFileNameRight = [NSString stringWithFormat:@"%@_%@_%@_%d", snOnRight, [LogFile CurrentTimeForFile], CSVFILENAME,idx+1];
//                [LogFile AddLog:[NSString stringWithFormat:@"%@/%@", LOGFOLDER, snOnRight] FileName:csvFileNameRight Content:csvtitle];
//            }
//
//            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:csvtitle];

            bool deviceFinished = false;
            for (int i=0; i < [jsonData count]; i++) {
                if (![jsonData[i] isEqualToString:@""]) {
//                    if (i==7) {
//                        NSLog(@"111");
//                    }
//                    NSLog(@"debug ----%d",i);
                    /*******No need to use PinNo any More*************/
                    //                NSString *PinNo = @"";
                    /*******No need to use PinNo any More*************/
                    NSDictionary *jsonDic = nil;

                    // NSString *Number;
                    NSString *Pos;
                    NSString *GroupNme;
                    NSString *ItemName;
                   // NSString *ItemNameCSV;
                    NSString *Type;
                    NSString *OpenLimit;
                    NSString *ShortLimit;
                    NSString *Value;
                    NSString *Unit;
                    NSString *Result;
                    NSString *PinNumber;
                    NSString *NetName;

                    @try {
                        jsonDic = [JasonUtilities loadJSONContentToDictionary:jsonData[i]];
                        if ([jsonDic count] == 0) {
                            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Find some invalid characters in below jason content\n%@", jsonData[i]]];
                            NSString *myJson = @"{\"pos\": \"Left\", \"group\": \"adj\", \"item\": \"IssueItem\", \"value\": 13472266.00, \"typ\": \"res\", \"lim\": {\"open\": 200000000, \"short\": 5}, \"result\": \"Pass\"}";
                            jsonDic = [JasonUtilities loadJSONContentToDictionary:myJson];
                            //                    dispatch_sync(dispatch_get_main_queue(), ^{
                            //                        [self ForceTerminate:[NSString stringWithFormat:@"invalide jason content!\n%@",jsonArr[i]]];
                            //                    });
                        }

                        if ([[[jsonDic valueForKey:@"item"] uppercaseString] isEqualToString:@"START"]){
                            NSLog(@"got the start test singal，continue");
                            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ got the start test singal，continue",[LogFile CurrentTimeForLog]]];
                            continue;
                        }
                        else if([[[jsonDic valueForKey:@"item"] uppercaseString] isEqualToString:@"END"]) {
                            NSLog(@"at the end of the test，break");
                            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ at the end of the test，break",[LogFile CurrentTimeForLog]]];
                            [self testFinish: idx final:idx == dutCount - 1 snFileLeft:snFileLeft snFileRight:snFileRight currentTime:currentTime];
                            deviceFinished = true;
                            break;
                        }

                        Pos = [jsonDic valueForKey:@"pos"];
                        Type = [jsonDic valueForKey:@"typ"];
                        GroupNme = [jsonDic valueForKey:@"group"];
                        ItemName = [jsonDic valueForKey:@"item"];

                        // NSString *reult = [jsonDic valueForKey:@"result"];
                        NSDictionary *lim = [jsonDic valueForKey:@"lim"];
                        OpenLimit = [lim valueForKey:@"open"];
                        ShortLimit = [lim valueForKey:@"short"];
                        Value = [jsonDic valueForKey:@"value"];
                        Result = [jsonDic valueForKey:@"result"];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Exception occurred while analyzing json data:\n%@", jsonData[i]);
                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Exception occurred while analyzing json data:\n%@", jsonData[i]]];
                        //                    NSString *myJson = @"{\"pos\": \"Left\", \"group\": \"adj\", \"item\": \"ExceptionItem\", \"value\": 13472266.00, \"typ\": \"res\", \"lim\": {\"open\": 200000000, \"short\": 5}, \"result\": \"Fail\"}";
                        //                    jsonDic = [JasonUtilities loadJSONContentToDictionary:myJson];
                        //                    Pos = [jsonDic valueForKey:@"pos"];
                        //                    Type = [jsonDic valueForKey:@"typ"];
                        //                    GroupNme = [jsonDic valueForKey:@"group"];
                        //                    ItemName = [jsonDic valueForKey:@"item"];
                        //                    NSDictionary *lim = [jsonDic valueForKey:@"lim"];
                        //                    OpenLimit = [lim valueForKey:@"open"];
                        //                    ShortLimit = [lim valueForKey:@"short"];
                        //                    Value = [jsonDic valueForKey:@"value"];
                        //                    Result = [jsonDic valueForKey:@"result"];
                    }
                    @finally {
                        // Nothing to do.
                    }

                    if (Pos == nil || Type == nil || GroupNme == nil || ItemName == nil || OpenLimit == nil || ShortLimit == nil || Value == nil || Result == nil)
                    {
                        NSLog(@"Find some invalid characters in below jason content\n%@", jsonData[i]);
                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Find some invalid characters in below jason content\n%@", jsonData[i]]];
                        NSString *myJson = @"{\"pos\": \"Left\", \"group\": \"adj\", \"item\": \"InvalidItem\", \"value\": 0.00, \"typ\": \"res\", \"lim\": {\"open\": 0, \"short\": 0}, \"result\": \"Fail\"}";
                        jsonDic = [JasonUtilities loadJSONContentToDictionary:myJson];
                        Pos = [jsonDic valueForKey:@"pos"];
                        Type = [jsonDic valueForKey:@"typ"];
                        GroupNme = [jsonDic valueForKey:@"group"];
                        ItemName = [jsonDic valueForKey:@"item"];
                        NSDictionary *lim = [jsonDic valueForKey:@"lim"];
                        OpenLimit = [lim valueForKey:@"open"];
                        ShortLimit = [lim valueForKey:@"short"];
                        Value = [jsonDic valueForKey:@"value"];
                        Result = [jsonDic valueForKey:@"result"];
                    }

                    //Left;LR;RF;Left Rear;Right Front  ---Right;LF;RR;Left Front;Right Rear
                    bool isForLeft = [[self AvalibleLeftPos] containsObject:[Pos uppercaseString]];

                    NSString * position = isForLeft ? @"Left" : @"Right";
//                    if ([Pos containsString:@"LR"]) {
//                        position = @"Left Rear";
//                    }
//                    else if ([Pos containsString:@"LF"]){
//                        position = @"Left Front";
//                    }
//                    else if ([Pos containsString:@"RR"]){
//                        position = @"Right Rear";
//                    }
//                    else if ([Pos containsString:@"RF"]){
//                        position = @"Right Front";
//                    }
//                    position = isForLeft ? @"Left" : @"Right";
                    
                    if ((self -> posCheck) && !self->singleDUT && ((isForLeft && !self -> testingLeft) || (!isForLeft && !self -> testingRight)))
                    {

                        NSLog(@"Invalid position: %@, being ignored， %@", Pos, jsonData[i]);
                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"poscheck:%d,singleDUT:%d,isForLeft:%d,testingLeft:%d,testingRight：%d,\nInvalid position: %@, being ignored.\n%@",self -> posCheck, self->singleDUT,isForLeft,self -> testingLeft,self -> testingRight,Pos, jsonData[i]]];
                        continue;
                    }
                    NSLog(@"Whether the left side: %@， %@", isForLeft ? @"TRUE" : @"FALSE", jsonData[i]);
                    
                    // position = [NSString stringWithFormat:@"%@%@", logicPos, [position caseInsensitiveCompare:logicPos] == NSOrderedSame ? @"" : [NSString stringWithFormat:@"[%@]", position]];

                    if ([Type isEqualToString:@"vdrp"]) {
                        Type = @"vdrop";
                        Unit = @"mV";
                    }
                    else if ([Type isEqualToString:@"res"]) {
                        Unit = @"ohm";//@"Ω"; can't upload to PDCA as units
                    }
                    else if ([Type containsString:@"cap"]) {
                        Unit = @"nF";
                    }
                    else if ([[Type uppercaseString] isEqualToString:@"TR"]) {
                        Unit = @"uS";//@"µS";can't upload to PDCA as units
                    }
                    else if ([[Type uppercaseString] isEqualToString:@"DDS"]
                             ||[[Type uppercaseString] isEqualToString:@"VOH"]
                             ||[[Type uppercaseString] isEqualToString:@"VOL"]) {
                        Unit = @"mV";
                    }else{
                        Unit = @"";
                    }

                    GroupNme = [GroupNme uppercaseString];

                    NSString *mapName = [self mapItemName:ItemName groupName:GroupNme];

                    //*************************************20170810-add mapview for station
                    if (![[configDic valueForKey:MAPVIEW] boolValue]) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self updateMapView:ItemName pos:Pos group:GroupNme showName:mapName testResult:Result forLeft:isForLeft];
                        });
                    }
                    //*************************************20170810-add mapview for station
                    if ([GroupNme isEqualToString:@"GND"] || [GroupNme isEqualToString:@"VBUS"]) {
                        if(!([[Type uppercaseString] isEqualToString:@"VOH"]||[[Type uppercaseString] isEqualToString:@"VOL"])){
                            if (mapName.length==0) {
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [self ForceTerminate:[NSString stringWithFormat:@"pin:%@ can't be tested in the group %@", ItemName, GroupNme]];
                                });
                            }
                        }
                        
                       // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ pos:%@, position:%@, mapName=%@,self.ItemName=%@,self.GroupNme=%@",[LogFile CurrentTimeForLog], Pos,position,mapName, ItemName, GroupNme]];
                        /*******No need to use PinNo any More*************/
                        //                    PinNo = [self mapPinNumber:self.ItemName groupName:self.GroupNme];
                        //                    self.ItemName = PinNo;
                        /*******No need to use PinNo any More*************/
                        //========================================================
                        //add positon and result in the test item
                        
                        if([ItemName isEqualToString:@"a05"]){
                            mapName = [NSString stringWithFormat:@"%@_CC1",Pos];
                        }
                        else if([ItemName isEqualToString:@"b05"]){
                            mapName = [NSString stringWithFormat:@"%@_CC2",Pos];
                        }else{
                            mapName = [NSString stringWithFormat:@"%@_%@",Pos,mapName];
                        }
                        
                        //========================================================
                        /*******No need to use PinNo any More*************/
                        //                    [pinNumberArr addObject:PinNo];
                        /*******No need to use PinNo any More*************/
                        
                        //remove the "-a01" for GND group and remove "-a04" fro Vbus group==========
                        if ([ItemName containsString:@"-a01"]) {
                            ItemName= [ItemName substringToIndex:[ItemName rangeOfString:@"-a01"].location];
                        }
                        else if ([ItemName containsString:@"-a04"]) {
                            ItemName= [ItemName substringToIndex:[ItemName rangeOfString:@"-a04"].location];
                        }
                        
                        //=========================================
                        // [pinNumberArr addObject:ItemName];
                        // [netNameArr addObject:mapName];
                        PinNumber = ItemName;
                        NetName = mapName;
                    }
                    else if([GroupNme.uppercaseString isEqualToString:@"ADJ2"]){
                        PinNumber = mapName;
                        NetName = ItemName;
                        // [pinNumberArr addObject:self.ItemName];
                        // [netNameArr addObject:self.ItemName];
                    }else{
                        PinNumber = ItemName;
                        NetName = ItemName;
                    }

                    if ([OpenLimit integerValue] == -1) {
                        OpenLimit = @"NA";
                    }

                    if ([ShortLimit integerValue] == -1) {
                        ShortLimit = @"NA";
                    }

                    if ([Type isEqualToString:@"res"]) {
                        float tmpValue = [Value floatValue];
                        if (tmpValue/1000 > 1 && tmpValue / 1000000 < 1) {
                            Value = [NSString stringWithFormat:@"%1.2fK",tmpValue / 1000];
                        }
                        else if (tmpValue / 1000000 > 1){
                            Value = [NSString stringWithFormat:@"%1.2fM",tmpValue / 1000000];
                        }
                    }

                    if ([mapName isEqualToString:@"NC"]) {
                        Result = @"Skip";
                    }

                    //===========================================================
                    //add positon and result in the test item

                    if (([[Type uppercaseString] isEqualToString:@"TR"]
                         || [[Type uppercaseString] isEqualToString:@"DDS"])
                        && [[Result uppercaseString] isEqualToString:@"SHORT"]) {
                        ItemName = [NSString stringWithFormat:@"%@_%@_TR",Pos,ItemName];
                        //ItemNameCSV =[NSString stringWithFormat:@"%@_%@_TR", Pos, ItemName];
                    }else{
                        ItemName = [NSString stringWithFormat:@"%@_%@_%@",Pos,ItemName,Type];
                        //ItemNameCSV =[NSString stringWithFormat:@"%@_%@_%@", Pos, ItemName,Type];
                    }
                    //===========================================================

                    bool failed = false;
                     // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Result=%@",Result]];
                 
                    if ([ItemName length] != 0) {
                        ItemName = [NSString stringWithFormat:@"[%d]_%@_%@",i, ItemName,Result];
                    }
                 
                    if (![[Result uppercaseString] isEqualToString:@"PASS"]
                        &&![[Result uppercaseString] isEqualToString:@"SKIP"]) {
                        failed = true;
                       // NSString* strLog = [NSString stringWithFormat:@"AddTestItem:%@, Value=%@, Result=%@, OpenL=%@ ShortL=%@ Units=%@  ErrorInfo:%@", ItemName, [NSString stringWithFormat :@"%f", [Value floatValue]], @"FAIL", [NSString stringWithFormat:@"%f", [OpenLimit floatValue]], [NSString stringWithFormat:@"%f", [ShortLimit floatValue]], Unit, @"-Failure-"];
                        
                        //[LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ %@", [LogFile CurrentTimeForLog], strLog]];
                        
//                        QuickPudding * pudding = self->singleDUT ? quickPuddingLeft : quickPuddingRight;
                        QuickPudding * pudding =nil;
                        
                        if (self->singleDUT) {
                            pudding = quickPuddingLeft;

                        }else{//2-up need to separate left and right datas but singleDUT
                            pudding = isForLeft ? quickPuddingLeft : quickPuddingRight;
                        }
           
                        
                        if (pudding != nil)
                        {
                            bool pdaca_ok =[pudding AddTestItem:ItemName TestValue:[NSString stringWithFormat :@"%0.2f",[Value floatValue]] TestResult:@"FAIL" HighLimit:[NSString stringWithFormat:@"%ld",(long)[OpenLimit integerValue]]LowLimit:[NSString stringWithFormat :@"%ld",(long)[ShortLimit integerValue]] Units:Unit ErrorInfo:@"-Failure-" Priority:@"1" logfile:debugFileName];
                            if (pdaca_ok) {
                                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Test Item:%@ upload to PDCA succeed!", ItemName]]];
                            }
                            else{
                                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Test Item:%@ upload to PDCA Failure!", ItemName]]];
                            }
                        }
                    }
                    else{//sc
                        //upload pass item info to PDCA
                        //NSArray *subName =[NSArray arrayWithObject:@""];
                        NSArray *subName =[NSArray array];
                        
                        
                        if (!(_officeMode)) {// || [[configDic valueForKey:DEBUGMODE] boolValue]
                           // QuickPudding * pudding = self->singleDUT ? quickPuddingLeft : quickPuddingRight;
                            QuickPudding * pudding =nil;
                            
                            if (self->singleDUT) {
                                pudding = quickPuddingLeft;
                                
                            }else{//2-up need to separate left and right datas but singleDUT
                                pudding = isForLeft ? quickPuddingLeft : quickPuddingRight;
                            }
                            
//                            if (self->singleDUT) {
//                                pudding = [quickPuddingLefts objectForKey:[NSString stringWithFormat:@"%d", 0]];
//
//                            }else{//2-up need to separate left and right datas but singleDUT
//                                pudding = [isForLeft ? quickPuddingLefts : quickPuddingRights objectForKey:[NSString stringWithFormat:@"%d", 0]];
//
//                                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"isForLeft=%d--idx:%d",isForLeft,idx]];
//                            }
//
                            
                       
                            
                            if (pudding != nil)
                            {
//                                NSMutableString *item = [NSMutableString stringWithFormat:@"%@", ItemName];
                    
                                [pudding addParameterWithDictionary:@{
                                                                      kIPParametricKey:ItemName,
                                                                      kIPLowerLimit   :[NSNumber numberWithFloat:[ShortLimit floatValue]],
                                                                      kIPUpperLimit   :[NSNumber numberWithFloat:[OpenLimit floatValue]],
                                                                      kIPValue        :[NSNumber numberWithFloat:[Value floatValue]],
                                                                      kIPMessage      :@"",
                                                                      kIPUnits        :Unit,
                                                                      kIPBooleanResult:@1,
                                                                      kIPTestNameTree :subName
                                                                      }];
                            }
                            
                            //                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Test Item:%@ upload pass to PDCA ", ItemName]]];
                        }
                    }

                    

                    if (self->singleDUT)
                    {
                        NSString *csvdata = @"";
                        if ([mapName length]>0) {
                            csvdata = [NSString stringWithFormat:@"%d,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n", i-1, Pos, GroupNme, Type, ItemName, mapName, OpenLimit, ShortLimit, Value, Unit, Result];
                        }
                        else{
                            csvdata = [NSString stringWithFormat:@"%d,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n", i-1, Pos, GroupNme, Type, ItemName, ItemName, OpenLimit, ShortLimit, Value, Unit, Result];
                        }
                        [LogFile AddLog:snFileLeft FileName:csvFileNameLeft Content:csvdata currenttime:currentTime];
//                        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:csvdata];
                    }
                    else{
                        
                        if (self -> testingLeft && isForLeft)
                        {
                            NSString *csvDataLeft=[NSString stringWithFormat:@"%d,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n", i-1, Pos, GroupNme, Type, ItemName, ItemName, OpenLimit, ShortLimit, Value, Unit, Result];
                            [LogFile AddLog:snFileLeft FileName:csvFileNameLeft Content:csvDataLeft currenttime:currentTime];
                        }
                        
                        if (self -> testingRight && !self->singleDUT && !isForLeft)
                        {
                            NSString *csvDataRight=[NSString stringWithFormat:@"%d,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n", i-1, Pos, GroupNme, Type, ItemName, ItemName, OpenLimit, ShortLimit, Value, Unit, Result];
                            [LogFile AddLog:snFileRight FileName:csvFileNameRight Content:csvDataRight currenttime:currentTime];
                        }
                    }

                    TestResultItem * resultItem = [[TestResultItem alloc] init];
                    resultItem->DeviceIndex = idx;
                    resultItem->Group = GroupNme;
                    resultItem->Type = Type;
                    resultItem->Position = position;
                    resultItem->Left = isForLeft;
                    resultItem->OriginPos = Pos;
                    resultItem->Index = index++;
                    resultItem->OpenLimit = OpenLimit;
                    resultItem->ShortLimit = ShortLimit;
                    resultItem->Value = Value;
                    resultItem->Unit = Unit;
                    resultItem->SerialNumber = isForLeft || self->singleDUT ? snOnLeft : snOnRight;
                    resultItem->PinNumber = PinNumber;
                    resultItem->NetName = NetName;
                    resultItem->Result = Result;
                    [testItems addObject:resultItem];
                    
                    

                    if (isForLeft) {
                        [testLeftItems addObject:resultItem];
                    }else{
                         [testRightItems addObject:resultItem];
                    }
                    
                    TestResultCount * testResultCount = nil;
                    while ([testCounts count] <= idx)
                    {
                        testResultCount = [[TestResultCount alloc] init];
                        [testCounts addObject:testResultCount];
                    }

                    testResultCount = testCounts[idx];
                    testResultCount->DeviceIndex = idx;
                    testResultCount->DevSN = @"";

                    if (failed)
                    {
                        if (isForLeft)
                        {
                            testResultCount->LeftFailCount += 1;
                            [failedLeftItems addObject:resultItem];
                        }
                        else
                        {
                            testResultCount->RightFailCount += 1;
                            [failedRightItems addObject:resultItem];
                        }

                        [failedItems addObject:resultItem];
                    }
                    else
                    {
                        if (isForLeft)
                        {
                            testResultCount->LeftPassCount += 1;
                        }
                        else
                        {
                            testResultCount->RightPassCount += 1;
                        }
                    }
                }
            }

            if (!deviceFinished)
            {
                // Should wait END singal but not just simply finish testing.
                // NSLog(@"No end line，finished");
                // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ No end line，finished",[LogFile CurrentTimeForLog]]];
                // [self testFinish: idx final: idx == deviceCount - 1];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [_testView reloadData];
                [_failOnlyView reloadData];
            });

            //add for office mode
            //*************************************20170810-add mapview for station
            if (![[configDic valueForKey:MAPVIEW] boolValue]) {
                [self updateMapViewAfterAllTestItem];
            }
            //*************************************20170810-add mapview for station
        }
        else{
            //*************************************20170810-add mapview for station
            //        if (_officeMode) {
             dispatch_async(dispatch_get_main_queue(), ^{
                [_lbleftResult setTextColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
                [_lbleftResult setStringValue:@"Not Connected"];
                
                [_lbRightResult setTextColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
                [_lbRightResult setStringValue:@"Not Connected"];
            });
            
            //        }
            //*************************************20170810-add mapview for station
            [self testCancel: idx final: idx == dutCount - 1];
            NSLog(@"Nothing test,Cancel");
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Nothing test,Cancel",[LogFile CurrentTimeForLog]]];
        }
    }
}

#pragma mark TestFinish
- (void)testFinish: (int)idx
             final: (bool)final snFileLeft:(NSString *)snFileLeft snFileRight:(NSString *)snFileRight currentTime:(NSString *)currentTime{
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"--------testFinish----idx:%d--final:%d--",idx,final]];
    if (!final) {
        return;
    }
    

    NSInteger LeftFailAllCount = 0;//RightFailCount
    NSInteger RightFailAllCount = 0;//
    
    NSInteger rightFailedTimes = 0;//RightFailCount
    NSInteger leftFailedTimes = 0;//
    if (testCounts.count) {//a218 need check
        
        for (int idx = 0; idx < [testCounts count]; idx++){
            
            TestResultCount * testCount = [testCounts objectAtIndex:idx];
            RightFailAllCount = RightFailAllCount +testCount -> RightFailCount;
            LeftFailAllCount = RightFailAllCount +testCount -> LeftFailCount;
            if ((testCount -> RightFailCount == 0 && testCount -> RightPassCount == 0)){
                
                if (!isSignPort) {
                    rightFailedTimes = rightFailedTimes +1;
                }
                
            }else if (testCount -> RightFailCount > 0){
                
                rightFailedTimes = rightFailedTimes +1;
            }
            
            
            if ((testCount -> LeftFailCount == 0 && testCount -> LeftPassCount == 0)){

                if (!isSignPort) {
                    leftFailedTimes = leftFailedTimes +1;
                }
                
            }else if (testCount -> LeftFailCount > 0){
                
                leftFailedTimes = leftFailedTimes +1;
            }
 
        }
        
    
        //        for (int idx = 0; idx < [testCounts count]; idx++)
        //        {
        //            TestResultCount * testCount = [testCounts objectAtIndex:idx];
        //            RightFailCount = RightFailCount +testCount -> RightFailCount;
        //            LeftFailCount = LeftFailCount +testCount -> LeftFailCount;
        //            if ((testCount -> RightFailCount == 0 && testCount -> RightPassCount == 0))
        //            {
        //
        //                rightFailed = isSignPort ? false : true;
        //                if (leftFailed && rightFailed)
        //                {
        //                    break;
        //                }
        //
        //            }
        //
        //            if (testCount -> RightFailCount > 0)
        //            {
        //
        //                rightFailed = true;
        //
        //                if (leftFailed && rightFailed)
        //                {
        //                    break;
        //                }
        //            }
        //
        //
        //            if ((testCount -> LeftFailCount == 0 && testCount -> LeftPassCount == 0))
        //            {
        //                leftFailed = isSignPort ? false : true;
        //                if (leftFailed && rightFailed)
        //                {
        //                    break;
        //                }
        //
        //            }
        //            if (testCount -> LeftFailCount > 0)
        //            {
        //                leftFailed = true;
        //
        //                if (leftFailed && rightFailed)
        //                {
        //                    break;
        //                }
        //            }
        //        }
    }
    
    bool rightFailed = rightFailedTimes ? true : false;
    bool leftFailed = leftFailedTimes ? true : false;
    
    //*************************************20170810-add mapview for station
    //    NSString *leftTestResult = self -> testingLeft ? ((testCount -> LeftFailCount > 0) ? @"Fail" : @"Pass") :@"";
    //    NSString * rightTestResult = self -> testingRight || self -> singleDUT ? (testCount -> RightFailCount > 0 ? @"Fail" : @"Pass") :@"";
    //
    //    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-leftTestCount:%d--RightTestCount:%d--singleDUT:%d",[LogFile CurrentTimeForLog],testCount -> LeftFailCount,testCount -> RightFailCount,singleDUT]];
    
    NSString *leftTestResult = self -> testingLeft ? ((LeftFailAllCount > 0) ? @"Fail" : @"Pass") :@"";
    NSString * rightTestResult = self -> testingRight || self -> singleDUT ? (RightFailAllCount > 0 ? @"Fail" : @"Pass") :@"";
    
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-leftTestCount:%ld--RightTestCount:%ld--singleDUT:%d",[LogFile CurrentTimeForLog],(long)LeftFailAllCount,(long)RightFailAllCount,singleDUT]];
    
    if (self -> testingLeft)
    {
        //*************************************20170810-add mapview for station
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbleftResult setTextColor:[NSColor blackColor]];
            
            [_lbleftResult setStringValue:leftTestResult];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbleftResult setTextColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
            [_lbleftResult setStringValue:@"Not Connected"];
        });
    }
    
    if (self -> testingRight || self -> singleDUT)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbRightResult setTextColor:[NSColor blackColor]];
            [_lbRightResult setStringValue:rightTestResult];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbRightResult setTextColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
            [_lbRightResult setStringValue:@"Not Connected"];
        });
    }
    
    // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"testingLeft is %d--testingRight is %d",testingLeft,testingRight]];
    
    if ((!_officeMode)) {// || [[configDic valueForKey:DEBUGMODE] boolValue]
        
        if (self -> testingLeft)
        {
            // rename the folder will cause unzip failure.
            NSString * result = [NSString stringWithFormat:@"%@%@", leftTestResult , self->singleDUT ? rightTestResult : @""];
            NSString *blobFileNameLeft = [NSString stringWithFormat:@"%@-%@_%@.zip", snOnLeft, [LogFile CurrentTimeForFile], result];
            NSString *filePathLeft = [NSString stringWithFormat:@"%@/%@-%@_%@.zip", LOGFOLDER, snOnLeft, [LogFile CurrentTimeForFile], result];
            NSString *dirLeft=[snFileLeft stringByAppendingPathComponent:currentTime];
            [SSZipArchive createZipFileAtPath:filePathLeft withContentsOfDirectory:dirLeft];
            // int puddingIndex = self->singleDUT ? 0 : idx;
            //            QuickPudding * puddingLeft=[quickPuddingLefts objectForKey:[NSString stringWithFormat:@"%d", 0]];
            //        QuickPudding * puddingLeft=nil;
            //        if (self->singleDUT) {
            //            puddingLeft = [quickPuddingLefts objectForKey:[NSString stringWithFormat:@"%d", 0]];
            //        }else{
            //            puddingLeft = [quickPuddingLefts objectForKey:[NSString stringWithFormat:@"%d", idx]];
            //        }
            
            if (quickPuddingLeft != nil)
            {
                bool failed = leftFailed;
                if (self->singleDUT)
                {
                    failed |= rightFailed;
                }
                
                [quickPuddingLeft addBlobFile:blobFileNameLeft FilePath:filePathLeft];
                //                if (isUploadWithAllFail) {
                //                    failed = false;
                //                }
                quickPuddingLeft.debugFileName = debugFileName;
                // NSLog(@"Uploaded test result L:%@,", !failed ? @"Succeed" : @"Failed");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-Uploaded test result\n",[LogFile CurrentTimeForLog]]];
                if ([quickPuddingLeft submitPudding:!failed]) {
                    // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Uploaded test result L:%@ to PDCA", !failed ? @"Succeed" : @"Failed"]];
                }else{
                    
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-Uploaded test result L:Failed to PDCA",[LogFile CurrentTimeForLog]]];
                }
                
                [CWFileManager cw_removeItemAtPath:filePathLeft];
            }
        }
        
        if (self -> testingRight && !self->singleDUT)
        {
            NSString *blobFileNameRight = [NSString stringWithFormat:@"%@-%@_%@.zip", snOnRight, [LogFile CurrentTimeForFile], rightTestResult];
            NSString *filePathRight = [NSString stringWithFormat:@"%@/%@-%@_%@.zip", LOGFOLDER, snOnRight, [LogFile CurrentTimeForFile], rightTestResult];
            [SSZipArchive createZipFileAtPath:filePathRight withContentsOfDirectory:[snFileRight stringByAppendingPathComponent:currentTime]];
            // QuickPudding * puddingRight = [quickPuddingRights objectForKey:[NSString stringWithFormat:@"%d", 0]];
            if (quickPuddingRight != nil)
            {
                quickPuddingRight.debugFileName = debugFileName;
                [quickPuddingRight addBlobFile:blobFileNameRight FilePath:filePathRight];
                NSLog(@"Uploaded test result R:%@,", !rightFailed ? @"Succeed" : @"Failed");
                if ([quickPuddingRight submitPudding:!rightFailed]) {
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Uploaded test result R:%@ to PDCA", !rightFailed ? @"Succeed" : @"Failed"]];
                }else{
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Uploaded test result R:Failed to PDCA"]];
                }
                [CWFileManager cw_removeItemAtPath:filePathRight];
            }
        }
    }else{
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-officeMode do not need upload insight",[LogFile CurrentTimeForLog]]];
        
    }
    
    if (final)
    {
        testStatus = FINISH;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopCycleTimer];
            [_EnableSN1 setEnabled:YES];
            [_EnableSN2 setEnabled:YES];
            
            [_btnStart setEnabled:[self testing1] || [self testing2]];
            
            [leftScanView setStringValue:@""];
            [leftScanView setEditable:[self testing1]];
            [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
            [leftScanView becomeFirstResponder];
            
            [rightScaniew setStringValue:@""];
            [rightScaniew setEditable:[self testing2]];
            [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
            
            if (loopTimes == 0 && looping) {
                [detectTimer invalidate];
                if (_auditMode){
                    if (allTestTimes <= testTimesForAudit)
                    {
                        TestResultCount * testCount = [[TestResultCount alloc] init];
                        for(int idx = 0 ; idx < [testCounts count]; idx++)
                        {
                            TestResultCount * count = [testCounts objectAtIndex:idx];
                            testCount -> LeftFailCount += count -> LeftFailCount;
                            testCount -> LeftPassCount += count -> LeftPassCount;
                            testCount -> RightFailCount += count -> RightFailCount;
                            testCount -> RightPassCount += count -> RightPassCount;
                            testCount -> DeviceIndex = 0;
                            testCount -> DevSN = @"";
                        }
                        
                        [_lbTimes setStringValue:[NSString stringWithFormat:@"Total:%ld, LP:%ld LF:%ld RP:%ld RF:%ld", (long)allTestTimes, (long)testCount->LeftPassCount, (long)testCount->LeftFailCount, (long)testCount->RightPassCount, (long)testCount->RightFailCount]];
                        if (allTestTimes == testTimesForAudit) {
                            allTestTimes = 0;
                            
                            [_lbTimes setStringValue:[NSString stringWithFormat:@"Total:%ld, LP:%ld LF:%ld RP:%ld RF:%ld", (long)allTestTimes, (long)testCount->LeftPassCount, (long)testCount->LeftFailCount, (long)testCount->RightPassCount, (long)testCount->RightFailCount]];
                            [leftScanView setStringValue:@""];
                            [rightScaniew setStringValue:@""];
                        }
                    }
                }
                else{
                    [leftScanView setStringValue:@""];
                    [rightScaniew setStringValue:@""];
                }
            }
            
            NSLog(@"Enable controlling after finished tests.");
        });
        
        NSDateFormatter* nsdf = [[NSDateFormatter alloc]init];
        NSDate *stopTime = [NSDate date];
        [nsdf setDateFormat:@"yyy-MM-dd HH:mm:ss"];
        EndTestTime = [nsdf stringFromDate:stopTime];
        testTime = [stopTime timeIntervalSinceDate:startdate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_txtScanSN1 becomeFirstResponder];
        });
        
        [self writeLocalCSV];
        
        //_nextStart = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self testFinishShowUI:rightFailed leftFailed:leftFailed];
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-*******************Test Finsh****************\n\n\n\n",[LogFile CurrentTimeForLog]]];
        });
        
    }
}

#pragma mark TestCancel

- (void)testCancel: (int)idx
             final: (bool)final{
    if (self -> testingLeft)
    {
//        QuickPudding * puddingLeft = [quickPuddingLefts objectForKey:[NSString stringWithFormat:@"%d", idx]];
        if (quickPuddingLeft != nil)
        {
            [quickPuddingLeft cancel];
        }
    }

    if (self -> testingRight && !self->singleDUT)
    {
//        QuickPudding * puddingRight = [quickPuddingRights objectForKey:[NSString stringWithFormat:@"%d", idx]];
        if (quickPuddingRight != nil)
        {
            [quickPuddingRight cancel];
        }
    }

    if (final)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopCycleTimer];

            testStatus = CANCEL;
            [_EnableSN1 setEnabled:YES];
            [_EnableSN2 setEnabled:YES];
            [_btnStart setEnabled:[self testing1] || [self testing2]];
            [leftScanView setStringValue:@""];
            [leftScanView setEditable:[self testing1]];
            [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
            [leftScanView becomeFirstResponder];

            [rightScaniew setStringValue:@""];
            [rightScaniew setEditable:[self testing2]];
            [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
            NSLog(@"Enable controlling while canceling");
        });
    }
}

#pragma mark detect start test
- (void)detectStartTest{
    detectTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(loopTest) userInfo:self repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:detectTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)GHInfo
{
    NSString* strGHConfig = [[NSString alloc]initWithFormat:@"/vault/data_collection/test_station_config/gh_station_info.json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:strGHConfig]) {
        NSString* jsonString = [[NSString alloc] initWithContentsOfFile:strGHConfig encoding:NSUTF8StringEncoding error:nil];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* allKeysValues = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if ([[allKeysValues allKeys] containsObject:@"ghinfo"]){
            NSMutableString *strGHinfoUI = [[NSMutableString alloc]init];
            NSDictionary *allValues = [allKeysValues valueForKey:@"ghinfo"];
            
            if ([[allValues allKeys] containsObject:@"SITE"]) { // SITE
                strGHinfoUI = [NSMutableString stringWithFormat:@"%@SITE: %@\n",strGHinfoUI,[allValues valueForKey:@"SITE"]];
                siteID = [allValues valueForKey:@"SITE"];
            }
            
            if ([[allValues allKeys] containsObject:@"PRODUCT"]){ // PRODUCT
                strGHinfoUI = [NSMutableString stringWithFormat:@"%@PRODUCT: %@\n",strGHinfoUI,[allValues valueForKey:@"PRODUCT"]];
                product = [allValues valueForKey:@"PRODUCT"];
            }
            
            if ([[allValues allKeys] containsObject:@"BUILD_STAGE"]){ // BUILD_STAGE
                buildStage = [allValues valueForKey:@"BUILD_STAGE"];
            }
            
            if ([[allValues allKeys] containsObject:@"DISPLAY_NAME"]){ // DISPLAY_NAME
                displaName = [allValues valueForKey:@"DISPLAY_NAME"];
            }
            
            if ([[allValues allKeys] containsObject:@"STATION_ID"]){ // STATION_ID
                stationID = [allValues valueForKey:@"STATION_ID"];
            }
            if ([[allValues allKeys] containsObject:@"STATION_TYPE"]){ // STATION_TYPE
                stationName =[allValues valueForKey:@"STATION_TYPE"];
            }
            if ([[allValues allKeys] containsObject:@"SFC_QUERY_UNIT_ON_OFF"]){//SFC  Switch
                SFCQuerySwitch =[allValues valueForKey:@"SFC_QUERY_UNIT_ON_OFF"];
            }
            if ([[allValues allKeys] containsObject:@"SFC_URL"]){//SFC_URL
                SFC_URL =[allValues valueForKey:@"SFC_URL"];
            }
            if ([[allValues allKeys] containsObject:@"SFC_QUERY_UNIT_ON_OFF"]){//SFC_QUERY_UNIT_ON_OFF
                SFC_QUERY =[allValues valueForKey:@"SFC_QUERY_UNIT_ON_OFF"];
            }
        }
    }
}

-(void)cleanAllInfo{
    [self initMapView];
}

-(NSString*)mapItemName:(NSString*)itemName groupName:(NSString*)GroupName{
    
    NSDictionary *Adj2_PinnameDict = @{
                                      @"B03-B10":@"A10-A3",
                                      @"A11-A05":@"B2-A5",
                                      @"B05-B06":@"B5-B6",
                                      @"A10-A02":@"B3-B11",
                                      @"B02-A07":@"A11-A7",
                                      @"A11-A06":@"B2-A6",
                                      @"A10-A03":@"B3-B10",
                                      @"B05-B07":@"B5-B7",
                                      @"B08-B11":@"A8-A2",
                                      
          
                                      };
    
    NSDictionary *Gnd_PinnameDict = @{@"a02-a01":@"TX1+",
                                      @"a03-a01":@"TX1-",
                                      @"a04-a01":@"Vbus",
                                      @"a05-a01":@"CC1",
                                      @"a06-a01":@"D+",
                                      @"a07-a01":@"D-",
                                      @"a08-a01":@"SBU1",
                                      @"a09-a01":@"Vbus",
                                      @"a10-a01":@"RX2-",
                                      @"a11-a01":@"RX2+",
                                      @"b02-a01":@"TX2+",
                                      @"b03-a01":@"TX2-",
                                      @"b04-a01":@"Vbus",
                                      @"b05-a01":@"CC2",
                                      @"b06-a01":@"D+",
                                      @"b07-a01":@"D-",
                                      @"b08-a01":@"SBU2",
                                      @"b09-a01":@"Vbus",
                                      @"b10-a01":@"RX1-",
                                      @"b11-a01":@"RX1+"
                                      };
    NSDictionary *Vbus_PinnameDict = @{@"a01-a04":@"GND",
                                       @"a02-a04":@"TX1+",
                                       @"a03-a04":@"TX1-",
                                       @"a05-a04":@"CC",
                                       @"a06-a04":@"D-",
                                       @"a07-a04":@"D+",
                                       @"a08-a04":@"SBU1",
                                       @"a10-a04":@"RX2-",
                                       @"a11-a04":@"RX2+",
                                       @"a12-a04":@"GND",
                                       @"b01-a04":@"GND",
                                       @"b02-a04":@"TX2+",
                                       @"b03-a04":@"TX2-",
                                       @"b05-a04":@"VCON",
                                       @"b06-a04":@"D-",
                                       @"b07-a04":@"D+",
                                       @"b08-a04":@"SBU2",
                                       @"b10-a04":@"RX1-",
                                       @"b11-a04":@"RX1+",
                                       @"b12-a04":@"GND"
                                       };
    
    
    
    NSString *configfile = [[NSBundle mainBundle] pathForResource:@"pinMapNetName" ofType:@".json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]) {
        
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in pinMapNetName.json"];
    
        
    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in pinMapNetName.json"];
     
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject==nil || !jsonObject.count) {
        
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in pinMapNetName.json"];
  
        // return;
    }
    
    Gnd_PinnameDict = [jsonObject objectForKey:@"gnd"];
    Vbus_PinnameDict = [jsonObject objectForKey:@"vbus"];
    Adj2_PinnameDict = [jsonObject objectForKey:@"adj2"];
    
    NSString *mapName = @"";
    if ([GroupName isEqualToString:@"GND"]) {
        mapName = [Gnd_PinnameDict valueForKey:itemName];
        //        if ([itemName isEqualToString:@"b06-a01"]
        //           ||[itemName isEqualToString:@"b07-a01"]
        //            ) {
        //            mapName = @"NC";
        //        }
    }
    else if([GroupName isEqualToString:@"VBUS"]){
        mapName = [Vbus_PinnameDict valueForKey:itemName];
    }else if([GroupName.uppercaseString isEqualToString:@"ADJ2"]){
        mapName = [Adj2_PinnameDict valueForKey:itemName.uppercaseString];
    }
    
    return mapName;
}

-(NSString*)mapPinNumber:(NSString*)itemName groupName:(NSString*)GroupName{
    NSDictionary *pin_Name_GND_Dic =@{@"a02-a01":@"B11",
                                      @"a03-a01":@"B10",
                                      @"a04-a01":@"A04",
                                      @"a05-a01":@"A05",
                                      @"a06-a01":@"A06",
                                      @"a07-a01":@"A07",
                                      @"a08-a01":@"B08",
                                      @"a09-a01":@"A09",
                                      @"a10-a01":@"B03",
                                      @"a11-a01":@"B02",
                                      @"b02-a01":@"A11",
                                      @"b03-a01":@"A10",
                                      @"b04-a01":@"B04",
                                      @"b05-a01":@"B05",
                                      @"b06-a01":@"B06",
                                      @"b07-a01":@"B07",
                                      @"b08-a01":@"A08",
                                      @"b09-a01":@"B09",
                                      @"b10-a01":@"A03",
                                      @"b11-a01":@"A02"
                                      };
    
    NSDictionary *pin_Name_VBUS_Dic=@{@"a01-a04":@"a01",
                                      @"a02-a04":@"B11",
                                      @"a03-a04":@"B10",
//                                      @"a04-a04":@"A04",
                                      @"a05-a04":@"A05",
                                      @"a06-a04":@"A06",
                                      @"a07-a04":@"A07",
                                      @"a08-a04":@"B08",
//                                      @"a09-a04":@"A09",
                                      @"a10-a04":@"B03",
                                      @"a11-a04":@"B02",
                                      @"a12-a04":@"a12",
                                      
                                      @"b01-a04":@"b01",
                                      @"b02-a04":@"A11",
                                      @"b03-a04":@"A10",
//                                      @"b04-a04":@"B04",
                                      @"b05-a04":@"B05",
                                      @"b06-a04":@"B06",
                                      @"b07-a04":@"B07",
                                      @"b08-a04":@"A08",
                                      @"b09-a04":@"B09",
                                      @"b10-a04":@"A03",
                                      @"b11-a04":@"A02",
                                      @"b12-a04":@"b12"
                                      };
    NSString *pinNumber = @"";
    if ([GroupName isEqualToString:@"GND"]) {
        pinNumber = [pin_Name_GND_Dic valueForKey:itemName];
    }
    else if([GroupName isEqualToString:@"VBUS"]) {
        pinNumber = [pin_Name_VBUS_Dic valueForKey:itemName];
    }
    return pinNumber;
}

#pragma mark - StartTimer
- (void)startCycleTimer
{
    NSLog(@"Start cycle timer.");
    gettimeofday(&startTime, NULL);
    cycleTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:cycleTimer forMode:NSDefaultRunLoopMode];
}

- (void)updateTimer:(NSTimer *)timer
{
    if (testStatus == TESTING)
    {
        struct timeval now;
        gettimeofday(&now, NULL);
        float totalTestTime = ((float)subtractTimeVal(&now, &startTime)) / USEC_PER_SEC;
        [_lbTestTime setStringValue:[NSString stringWithFormat:@"%.01f s", totalTestTime]];
        if (totalTestTime > 100 * deviceCount) {
            [self testCancel: deviceCount - 1 final: true];
        }
    }
    else
    {
        [self stopCycleTimer];
    }
}

- (void)stopCycleTimer
{
    NSLog(@"Stop cycle timer.");
    [cycleTimer invalidate];
}
#pragma mark baseMapPortWCProtocol

-(void)baseMapPortWCSaveClick{
    
    
    
}
#pragma mark SettingProtocol
-(void)saveClick:(SettingMode *)settingMode{
    
    [self updateWithSetting];
    
}

-(void)cleanTestCountClick{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"count"];
    [userDefault synchronize];
    [self.countView setStringValue:@"0"];
}
#pragma mark AadminMenu
- (IBAction)menuLogin:(id)sender {
    if ([[sender title] isEqualToString:@"Login..."]) {
        
    }
    else if([[sender title] isEqualToString:@"LogOut"]){
        
    }
    [_MainWindow beginSheet:_LoginWindow completionHandler:^(NSModalResponse returnCode){
        switch (returnCode) {
            case NSModalResponseOK:
                NSLog(@"press ok");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ press ok",[LogFile CurrentTimeForLog]]];
                [MyEexception messageBox:@"Login" Information:@"Login Successfully!"];
                [_menueLogin setHidden:YES];
                [_menueLoadConfig setHidden:NO];
                [_menuSetting setHidden:NO];
                
                [_menuLoopTest setHidden:!_officeMode];
//                self.menuECodeMap.hidden = NO;
//                self.menuSNMap.hidden=NO;
//                self.menuStationMap.hidden=NO;
                [self.menuUpdateFW setHidden:[[configDic valueForKey:DEBUGMODE] boolValue]];//[[configDic valueForKey:DEBUGMODE] boolValue]
                [_menueLogout setHidden:NO];
                break;
            case NSModalResponseCancel:
                NSLog(@"press cancel ok");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ press cancel",[LogFile CurrentTimeForLog]]];
                break;
            default:
                break;
                
        }
    }];
}

- (IBAction)checkPassword:(id)sender {
    NSString *rootPwd = [configDic valueForKey:@"rootPwd"];
    if (!rootPwd.length) {
        rootPwd = @"impedanceDRI";
    }
    if([[_txtPassword stringValue] isEqualToString:@"admin"] || [[_txtPassword stringValue] isEqualToString:rootPwd])
    {

        self.settingWC.isRootPwd =[[_txtPassword stringValue] isEqualToString:rootPwd];
        
        [_txtPassword setStringValue:@""];
        [_txtWarningInfo setStringValue:@""];
        [_MainWindow endSheet:_LoginWindow returnCode:NSModalResponseOK];
        
        
    }
    else
    {
        [_txtPassword setStringValue:@""];
        NSDictionary        *dicAttributeFail   = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString	*attriStringInfo	= [[NSAttributedString alloc] initWithString:@"Incorrect Password" attributes:dicAttributeFail];
        [_txtWarningInfo setAttributedStringValue:attriStringInfo];
    }
}

- (IBAction)cancelPasswordCheck:(id)sender {
    [_txtPassword setStringValue:@""];
    [_txtWarningInfo setStringValue:@""];
    [_LoginWindow orderOut:nil];
    [_MainWindow endSheet:_LoginWindow returnCode:NSModalResponseCancel];
}

//-(NSInteger)caculateDefaultConfigLine{
//    NSString *defaultPath = [self getDefaultConfigPath];
//    NSInteger lineCount=0;
//    CSVParser *csv_parse= [[CSVParser alloc] init];
//    if ([csv_parse openFile:defaultPath]) {
//        NSMutableArray *csvArr = [csv_parse parseFile];
//
//        // remove the title line
//        [csvArr removeObjectAtIndex:0];
//        lineCount=[csvArr count];
//    }
//
//    return lineCount;
//}


- (void)loadDefaultConfig:(TestEngine*)te configPath:(NSString *)configPath{
    
//    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"DefaultConfig" ofType:@".csv"];
    //NSString *defaultPath = [self getDefaultConfigPath];
    NSMutableArray *cmdArr = [self generateConfigCommand:configPath];
    for (NSString *cmd in cmdArr) {
        NSString *cmdRespond = [te sendCommandAndReadResponse:[NSString stringWithFormat:@"%@\0",cmd]];
        NSLog(@"cmdRespond = %@",cmdRespond);
//        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ sendCommand:%@,cmdRespond = %@",[LogFile CurrentTimeForLog],cmd,cmdRespond]];
        if([cmdRespond containsString:@"\"code\":"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"Set Config Wrong" Information:[NSString stringWithFormat:@"Command:%@\nRespond:%@",cmd,cmdRespond]];
                NSLog(@"set command failure");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ set command failure",[LogFile CurrentTimeForLog]]];
            });
            [NSApp terminate:nil];
        }
    }
    
    SettingMode *config =[SettingMode getConfig];
    config.configPath = configPath;
    
    
}
//-(void)changeDefaultConfig:(NSString *)csvPath
//{
//    NSString *csvPath2 = [self getDefaultConfigPath];
//    NSString *sum1 = [self getCheckSumFromFile:csvPath];
//    NSString *sum2 = [self getCheckSumFromFile:csvPath2];
//
//    if (![sum1 isEqualToString:sum2]) {
//
//        BOOL isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"save this config file,if yes,app will use it as default config?"]];
//        //[self ErrorWithInformation:@"not found the file name EEEECode.json in app resouce path" isExit:NO];
//        if (isContinue) {
//            NSString *content1 = [CWFileManager cw_readFromFile:csvPath];
//            [CWFileManager cw_removeItemAtPath:csvPath2 ];
//            [CWFileManager cw_writeToFile:csvPath2 content:content1];
//        }
//
//    }
//}


- (IBAction)configBtnClick:(id)sender {
   
    NSButton *btn = sender;
    if (testStatus==INIT|| ![btn.title containsString:@".csv"]) {
        return;
    }
    self.configWC.configPath =btn.title;
    [[NSApplication sharedApplication]runModalForWindow:self.configWC.window];
}

- (IBAction)stationMapPort:(id)sender {
    _stationMapPortWC.type = BaseMapPortWCTypeStation;
    [[NSApplication sharedApplication]runModalForWindow:_stationMapPortWC.window];
}


- (IBAction)snMapPort:(id)sender {
    
   // snMap.delegate = self;
    //BaseMapPortWC *mp = [[BaseMapPortWC alloc] initWithWindowNibName:@"BaseMapPortWC"];
    _mapPortWC.type = BaseMapPortWCTypeSN;
    [[NSApplication sharedApplication]runModalForWindow:_mapPortWC.window];

}
- (IBAction)ECodeMap:(id)sender {
    
   
    _ecodeMapPortWC.type = BaseMapPortWCTypeEcode;
    [[NSApplication sharedApplication]runModalForWindow:_ecodeMapPortWC.window];
  
}

- (IBAction)setting:(id)sender {//cwdebug
    if (testStatus==TESTING||testStatus==INIT) {
        NSLog(@"The test is not ready!pls wait a moment.");
        [MyEexception RemindException:@"Warning" Information:@"The test is not ready!pls wait a moment."];
        return;
    }

    self.settingWC.TeEngArr = TeEngArr;
    [self.settingWC config];
//    self.settingWC.isRootPwd = isRootPwd;
    if (self.settingWC) {
        BOOL isRoot =self.settingWC.isRootPwd;
        self.settingWC.queryProject.enabled = isRoot;
        self.settingWC.checkGpu.enabled = isRoot;
    }

    [[NSApplication sharedApplication]runModalForWindow:self.settingWC.window];
    
    if (self.settingWC.isRootPwd) {
        [self Logout:nil];
    }
    
    
    
}

- (IBAction)loadUserConfig:(id)sender {
    NSOpenPanel *openPanel=[NSOpenPanel openPanel];
    NSString *openPath =[[NSBundle mainBundle] resourcePath];
    //NSString *openPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:openPath]];
    
    NSArray *fileType=[NSArray arrayWithObjects:@"csv",nil];
    [openPanel setAllowedFileTypes:fileType];
    ;
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setPrompt:@"Choose"];
    
    [openPanel beginSheetModalForWindow:_MainWindow completionHandler:^(NSInteger result){
        if (result==NSFileHandlingPanelOKButton)
        {
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:@"----loadUserConfig----"];
            // testStatus = UNREADY;
            testStatus = INIT;
            //            [_EnableSN1 setEnabled:NO];
            //            [_EnableSN2 setEnabled:NO];
            //            [leftScanView setEditable:NO];
            //            [rightScaniew setEditable:NO];
            //            [leftScanView setBackgroundColor:NSColor.controlColor];
            //            [rightScaniew setBackgroundColor:NSColor.controlColor];
            //            [_btnStart setEnabled:NO];
            //            [_lbStatusTitle setStringValue:@"Loading User Config File..."];
            //            [_lbTestStatus setBackgroundColor:[NSColor orangeColor]];
            //            NSLog(@"Disable controlling while loading user configuration.");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                NSArray *urls=[openPanel URLs];
                
                for (int i=0; i<[urls count]; i++)
                {
                    NSString *csvPath = [[urls objectAtIndex:i] path];
                    NSLog(@"pathName = %@",csvPath);
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ chooseFilePathName = %@,,TeEngArr count=%lu",[LogFile CurrentTimeForLog],csvPath,(unsigned long)TeEngArr.count]];
                    
                    //                    SettingMode *mode = [SettingMode getConfig];
                    //                    mode.configPath = csvPath;
                    //                    [SettingMode saveConfig:mode];
                    
                    for (int j=0; j<[TeEngArr count]; j++) {
                        
                       [self updateConfigWithPort:TeEngArr[j] configPath:csvPath num:j];
                        //[self updateConfigWithPort:TeEngArr[j]];
                    }
                    
                    //[self changeDefaultConfig:csvPath];
                    
                    testStatus = READY;
                    //                    dispatch_sync(dispatch_get_main_queue(), ^{
                    //                        [_EnableSN1 setEnabled:YES];
                    //                        [_EnableSN2 setEnabled:YES];
                    //                        [leftScanView setEditable:[self testing1]];
                    //                        [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
                    //                        [leftScanView becomeFirstResponder];
                    //                        [rightScaniew setEditable:[self testing2]];
                    //                        [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
                    //
                    //                        [_btnStart setEnabled:[self testing1] || [self testing2]];
                    //                        NSLog(@"Enable controlling after loaded user configuration.");
                    //                    });
                    //}
                }
            });
        }
    }];
}


- (IBAction)menuLoadConfig:(id)sender {
    //[self loadUserConfig:self];
    NSLog(@"11");
}


- (IBAction)menuLoopTestClick:(NSMenuItem *)sender {
    
//    if (testStatus==INIT) {
//        NSLog(@"can not set while testing");
//        return;
//    }
    [[NSApplication sharedApplication]runModalForWindow:self.loopWC.window];
    
}

-(void)loopOutClick{
    loopTimes =0;
}
-(void)loopInClick:(NSInteger)count timeInterval:(float)timeInterval{

    [self btnStartTest:nil];
    loopTimes = count-1;
    looping = loopTimes > 0;
    if (loopTimes>0) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self detectStartTest];
        });
        //[NSThread detachNewThreadSelector:@selector(detectStartTest) toTarget:self withObject:nil];
    }



}


- (IBAction)menuUpdateFW:(id)sender {
    
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:@"----menuUpdateFW----"];
    
    NSOpenPanel *openPanel=[NSOpenPanel openPanel];
    
    //NSString *openPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    NSString *openPath =[[NSBundle mainBundle] resourcePath];
    
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:openPath]];
    
    NSArray *fileType=[NSArray arrayWithObjects:@"s19",nil];
    [openPanel setAllowedFileTypes:fileType];
    ;
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setPrompt:@"Choose"];
    
    [openPanel beginSheetModalForWindow:_MainWindow completionHandler:^(NSInteger result){
        if (result==NSFileHandlingPanelOKButton)
        {
            //testStatus = UNREADY;
            testStatus = INIT;
            //
            [_EnableSN1 setEnabled:NO];
            [_EnableSN2 setEnabled:NO];
            [leftScanView setEditable:NO];
            [rightScaniew setEditable:NO];
            [leftScanView setBackgroundColor:NSColor.controlColor];
            [rightScaniew setBackgroundColor:NSColor.controlColor];
            [_btnStart setEnabled:NO];
            [_lbStatusTitle setStringValue:[NSString stringWithFormat:@"Upgrading FW..."]];
            [_lbTestStatus setBackgroundColor:[NSColor orangeColor]];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSArray *urls=[openPanel URLs];
                for (int i=0; i<[urls count]; i++)
                {
                    NSString *fwPath = [[urls objectAtIndex:i] path];
                    NSLog(@"pathName = %@",fwPath);
                    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ pathName = %@",[LogFile CurrentTimeForLog],fwPath]];
                    //                    SettingMode *mode = [SettingMode getConfig];
                    //                    mode.updateFWPath = fwPath;
                    //                    [SettingMode saveConfig:mode];
                    for (int j=0; j<[TeEngArr count]; j++) {
                        TestEngine *te = TeEngArr[j];
                        
                        [self checkAndUpdateFW:te num:j fwPath:fwPath];
                        
                        //                        if (![[configDic valueForKey:DEBUGMODE] boolValue]) {
                        //                            [self mapIPortPosition:te num:j];
                        //                        }
                        //
                        // NSString *defaultConfigPath = [self getDefaultConfigPath];
                        //  [self updateConfigWithPort:te];
                    }
                    
                    
                    testStatus = READY;
                    //                    dispatch_sync(dispatch_get_main_queue(), ^{
                    //                        [_EnableSN1 setEnabled:YES];
                    //                        [_EnableSN2 setEnabled:YES];
                    //                        [leftScanView setEditable:[self testing1]];
                    //                        [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
                    //                        [leftScanView becomeFirstResponder];
                    //                        [rightScaniew setEditable:[self testing2]];
                    //                        [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
                    //
                    //                        [_btnStart setEnabled:[self testing1] || [self testing2]];
                    //
                    //                    });
                    
                }
            });
        }
    }];
}


- (IBAction)menuUpdateFW1:(id)sender {
    if (![[configDic valueForKey:DEBUGMODE] boolValue]) {
        for (int i = 0; i<[TeEngArr count]; i++) {
            NSString *pyPath = [[NSBundle mainBundle] pathForResource:@"UpdateFW" ofType:@"py"];
            NSString *FWPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
            FWPath = [FWPath stringByAppendingPathComponent:@"iPort/FW"];
            
            //            FWPath = @"/vault/iPort";
            
            NSFileManager *fm = [NSFileManager defaultManager];
            NSDirectoryEnumerator *de = [fm enumeratorAtPath:FWPath];
            NSString *f;
            NSString *fqn;
            BOOL findFW = false;
            while ((f = [de nextObject]))
            {
                fqn = [FWPath stringByAppendingPathComponent:f];
                if ([fqn length]>0 && [f hasSuffix:@"s19"]&&([f hasPrefix:@"Seal_FW"] ||[f hasPrefix:@"iPort_FW"])) {
                    findFW = true;
                    break;
                }
                else{
                    continue;
                }
            }
            if (!findFW) {
                [MyEexception RemindException:@"Invalidate FW" Information:[NSString stringWithFormat:@"Please make sure FW file at path:%@\nPrefix with \"Seal_FW\" or \"iPort_FW\"\nSuffix with \".s19\"",FWPath]];
                return;
            }
            
            NSRange rang = [f rangeOfString:@"FW"];
            NSString *wantVer = [f substringFromIndex:rang.location+rang.length];//0722_0155.s19
            wantVer = [wantVer substringToIndex:4];//0722
            int updateVer = [wantVer intValue];
            
            NSString *currentVer = [TeEngArr[i] sendCommandAndReadResponse:@"getversion"];//{"version": "1.3_0705"}
            NSLog(@"currentVer= %@",currentVer);
            if ([currentVer length]==0) {
                NSLog(@"can't get the current device's FW version, need to reconnect and restart app");
                [MyEexception RemindException:@"Get FW Version Failure!" Information:[NSString stringWithFormat:@"Can't get FW version, pls reconnect and restart app!"]];
                return;
            }
            NSRange current_rang = [currentVer rangeOfString:@"_"];
            NSString *cVer = [currentVer substringFromIndex:current_rang.location+current_rang.length];
            cVer = [cVer substringToIndex:4];//0705
            int c_ver = [cVer intValue];
            if (updateVer>c_ver) {
                [MyEexception RemindException:@"Upgrade FW" Information:[NSString stringWithFormat:@"Your FW is Upgrading to version %@",f]];
                [_lbStatusTitle setStringValue:[NSString stringWithFormat:@"Upgrading FW to version:%@", f]];
            }
            else if (updateVer == c_ver){
                [MyEexception RemindException:@"The Same FW version " Information:[NSString stringWithFormat:@"Your FW is already latest one"]];
                return;
            }
            else if (updateVer < c_ver){
                bool downgrade = [MyEexception messageBoxYesNo:@"You are going to downgrade the iPort FW, are you sure?"];
                if (downgrade) {
                    [_lbStatusTitle setStringValue:[NSString stringWithFormat:@"Downgrade FW to version:%@",f]];
                }
                else{
                    return;
                }
            }
            testStatus = UPGRADE;
            // need co commant after add compare function
            [_lbStatusTitle setStringValue:[NSString stringWithFormat:@"FW Upgrading to version:%@", f]];
            [_MainWindow beginSheet:_updateFWWindow completionHandler:^(NSModalResponse returnCode){
                //can add some action when after update the FW
                if (i == [TeEngArr count] - 1) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [leftScanView setStringValue:@""];
                        [rightScaniew setStringValue:@""];
                        [leftScanView becomeFirstResponder];
                    });
                }
            }];
            
            TestEngine *te = TeEngArr[i];
            NSLog(@"%@ %@ %@",pyPath,te.device.portName,fqn);
            NSArray *argumentsArr2 = [NSArray arrayWithObjects: pyPath,te.device.portName,fqn,nil];
            dispatch_async(_queue, ^{
                //isUpdateFW = true;
                [self launchExternalForUpdateFW:@"/usr/bin/python" arguments:argumentsArr2];
            });
        }
    }
}
- (IBAction)Logout:(id)sender {
    [MyEexception messageBox:@"Logout" Information:@"Logout Successfully!"];
    [_menueLogin setHidden:NO];
    [self.menuSetting setHidden:YES];

    [_menuLoopTest setEnabled:NO];
    [_menuLoopTest setHidden:YES];
    
//    self.menuECodeMap.hidden = YES;
//    self.menuSNMap.hidden=YES;
//    self.menuStationMap.hidden=YES;
    [_menueLoadConfig setHidden:YES];
    self.menuUpdateFW.hidden=YES;
    [_menueLogout setHidden:YES];
}

-(NSString*)CheckSNLength:(NSString*)checkSN
{
//    bool result = [checkSN length] == 12 || [checkSN length] == 14 || [checkSN length] == 17 || [checkSN length] == 13;
    NSArray *snArr =[self getSnLength];
    NSString *snStr= [NSString stringWithFormat:@"%ld",checkSN.length];
    bool result = [snArr containsObject:snStr];
    if (!result)
    {
        return nil;
    }

    if ([checkSN length] == 14) {
        if ([[[checkSN substringFromIndex:12] lowercaseString] isEqualToString:@"dd"]) {
            return [checkSN substringToIndex:12];
        }
    }else if([checkSN length] == 12){
        if ([[[checkSN substringFromIndex:10] lowercaseString] isEqualToString:@"dd"]) {
            return [checkSN substringToIndex:10];
        }
        
    }else if ([checkSN length] == 13){
        return [checkSN substringFromIndex:1];
    }
    
    return checkSN;
}

-(float)autoStartTestInterval
{
    return [[configDic valueForKey:AUTO_START_TEST_INTERVAL] floatValue];
}

-(float)autoFocusInterval
{
    return [[configDic valueForKey: AUTO_FOCUS_INTERVAL] floatValue];
}

#pragma mark CheKVbusTest
// There would never need VBUS TEST cause it has already been merged with debugkey1 test.
-(bool)checkNeedVbusTest{
    return [[configDic valueForKey:VBUSTEST] boolValue];
}

#pragma mark CheckCcpinTest
-(bool)checkNeedCcpinTest{
    NSArray<NSString *> * array = nil;
    NSString * lp = [configDic valueForKey: CCPINTEST];
    if (lp == nil || [lp length] <= 0)
    {
        lp = @"J132:QT3;J140:QT3;J680:QT3;J780:QT3";
    }

    lp = [lp uppercaseString];

    array = [lp componentsSeparatedByString:@";"];
    for (NSString *item in array) {
        NSArray<NSString *> * subs = [item componentsSeparatedByString:@":"];
        if ([subs count] >= 2 && [subs[0] caseInsensitiveCompare:product] == NSOrderedSame && [subs[1] caseInsensitiveCompare:stationName] == NSOrderedSame)
        {
            return true;
        }
    }

    return false;
}

-(NSArray<NSString *> *)AvalibleLeftPos
{
    NSArray<NSString *> * array = nil;
    NSString * lp = [configDic valueForKey: LEFTPOS];
    if (lp == nil || [lp length] <= 0)
    {
        lp = @"Left;LR;RF;Left Rear;Right Front";
    }

    lp = [lp uppercaseString];
    
    array = [lp componentsSeparatedByString:@";"];
    return array;
}

-(NSArray<NSString *> *)DefaultGroup
{
    NSArray<NSString *> * array = nil;
    NSString * lp = [configDic valueForKey: DEFAULTGRP];
    if (lp == nil || [lp length] <= 0)
    {
        lp = @"adj;gnd;vbus;dds;dds2;voh;vol;TR";
    }
    
    array = [lp componentsSeparatedByString:@";"];
    return array;
}

-(NSArray<NSString *> *)getSnLength
{
    if (!snArr.count) {
        
        NSString * lp = [configDic valueForKey: @"allowSnLength"];
        if (lp == nil || [lp length] <= 0)
        {
            lp = @"12;13;14;17";
        }
        
        snArr = [lp componentsSeparatedByString:@";"];
        
    }
    return snArr;
    
    
}

//-(NSArray<NSString *> *)getSnLength
//{
//    NSArray<NSString *> * array = nil;
//    NSString * lp = [configDic valueForKey: @"allowSnLength"];
//    if (lp == nil || [lp length] <= 0)
//    {
//        lp = @"12;13;14;17";
//    }
//
//    array = [lp componentsSeparatedByString:@";"];
//    return array;
//}

-(NSArray<NSString *> *)addNewAdjItems
{
    NSArray<NSString *> * array = nil;
    NSString * lp = [configDic valueForKey:ExtAdjItems];
//    if ([lp containsString:@";"]) {
//       array = [lp componentsSeparatedByString:@";"];
//    }else{
//
//    }
    array = [lp componentsSeparatedByString:@";"];
    return array;
}


-(NSArray<NSString *> *)SkipSetItem
{
    NSArray<NSString *> * array = nil;
    NSString * lp = [configDic valueForKey: SKIP_SETITEM];
    if (lp == nil || [lp length] <= 0)
    {
        lp = @"DDS;DDS2;VOH;VOL;TR";
    }

    lp = [lp uppercaseString];

    array = [lp componentsSeparatedByString:@";"];
    return array;
}

-(void)GetExtItemFlags
{
    NSMutableDictionary * extItemsInConfig = [configDic valueForKey: EXT_ITEMS];
    if (extItemsInConfig == nil || [extItemsInConfig count] <= 0)
    {
        /*
         <?xml version="1.0" encoding="UTF-8"?>
         <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
         <plist version="1.0">
         <dict>
         <key>dds2</key>
         <dict>
         <key>pga</key>
         <integer>0</integer>
         <key>frequency</key>
         <integer>20</integer>
         <key>buff</key>
         <integer>2</integer>
         <key>shortlim</key>
         <integer>400</integer>
         </dict>
         <key>dds</key>
         <dict>
         <key>pga</key>
         <integer>4</integer>
         <key>frequency</key>
         <integer>800</integer>
         <key>buff</key>
         <integer>3</integer>
         </dict>
         </dict>
         </plist>
         */
        if (extItemsInConfig == nil)
        {
            extItemsInConfig = [[NSMutableDictionary alloc] init];
        }

        NSDictionary * dds2 = [[NSDictionary alloc] init];
        [extItemsInConfig setObject:dds2 forKey:@"dds2"];
        [dds2 setValue:@"0" forKey:@"pga"];
        [dds2 setValue:@"20" forKey:@"frequency"];
        [dds2 setValue:@"2" forKey:@"buff"];
        [dds2 setValue:@"400" forKey:@"shortlim"];

        NSDictionary * dds = [[NSDictionary alloc] init];
        [extItemsInConfig setObject:dds forKey:@"dds"];
        [dds setValue:@"4" forKey:@"pga"];
        [dds setValue:@"800" forKey:@"frequency"];
        [dds setValue:@"3" forKey:@"buff"];
    }

    // The original group is needed to add to the array then to be disabled as well.
    if (extItemsInConfig != nil)
    {
        // Enumerate all ext key of ext items;
        for(NSString * extName in [extItemsInConfig allKeys])
        {
            // Get the ext value dictionary;
            NSDictionary * extValueDic = [extItemsInConfig objectForKey:extName];
            if (extValueDic != nil && [extValueDic count] > 0)
            {
                // Does have a valie dictionary;
                for (NSString * extParaKey in [extValueDic allKeys])
                {
                    // Enumerate all para keys;
                    // Get a para value;
                    id extParaValue = [extValueDic objectForKey:extParaKey];

                    [self->extNames addObject:extName];

                    // Separate key into two parts;
                    NSArray * extParaKeys = [extParaKey componentsSeparatedByString:@":"];
                    if ([extParaKeys count] >= 2)
                    {
                        // Does have two parts;
                        // Whether has flag prefix or not;
                        bool whetherFlag = [extParaKeys[0] caseInsensitiveCompare:@"FLAG"] == NSOrderedSame;
                        if (whetherFlag)
                        {
                            // Is a flag.
                            // Whether has flag name;
                            if ([extParaKeys count] > 1 && extParaValue != nil)
                            {
                                // Flag name;
                                NSString * flagName = extParaKeys[1];

                                // Whether the flag dictionary for the current flag name was created or not;
                                NSMutableDictionary * flags = [self->extFlags objectForKey:extName];
                                if (flags == nil)
                                {
                                    // Not created yet, alloc and init a new one then put it into the dictionary.
                                    flags = [[NSMutableDictionary alloc] init];
                                    [self->extFlags setObject:flags forKey:extName];
                                }

                                // Add new flag into the flags dictionary.
                                [flags setObject:extParaValue forKey:flagName];
                            }
                            else
                            {
                                // The second part is just empty, so it is invalid and would be ignored;
                            }
                        }
                        else
                        {
                            // Does not have a flag prefix, so it is not a flag but just remain it as a future surpose;
                        }
                    }
                    else
                    {
                        // Only one part in the para key, so it would never be a flag(must have two part and the first part is "flag");
                        // Whether the flag dictionary for the current flag name was created or not;
                        NSMutableDictionary * paras = [self->extItems objectForKey:extName];
                        if (paras == nil)
                        {
                            // Not created yet, alloc and init a new one then put it into the dictionary.
                            paras = [[NSMutableDictionary alloc] init];
                            [self->extItems setObject:paras forKey:extName];
                        }

                        // Add new flag into the flags dictionary.
                        [paras setObject:extParaValue forKey:extParaKey];
                    }
                }
            }
        }
    }
}

-(NSArray<NSString *> *)AvalibleRightPos
{
    NSArray<NSString *> * array = nil;
    NSString * lp = [configDic valueForKey: RIGHTPOS];
    if (lp == nil || [lp length] <= 0)
    {
        lp = @"Right;LF;RR;Left Front;Right Rear";
    }

    lp = [lp uppercaseString];

    array = [lp componentsSeparatedByString:@";"];
    return array;
}

#pragma mark validatSN
//-(void)checkGPUWithSN:(NSString *)sn{
//    if (![[configDic valueForKey:@"isCheckGPU"] boolValue]) {
//        return;
//    }
//    NSArray *arr = [SFHelper checkGPUWithSN:sn];
//    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"sfc_url:%@--%lu",arr[0],(unsigned long)arr.count]];
//    //    NSArray *mutArr=[NSArray arrayWithObjects:sfc_url,return_str, nil];
//    if (arr.count!=2) {
//        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:@"GPU CHECK EMPTY"];
//
//        return;
//    }
//    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"return_str:%@---",arr[1]]];
//}

-(void)setPudding
{
    if (!_officeMode) {
        
       // for (int i = 0; i < 1; i++) {
            if (self -> testingLeft)
            {
                quickPuddingLeft =nil;
                quickPuddingLeft = [[QuickPudding alloc] init];
                [quickPuddingLeft startInstantPudding];
                [quickPuddingLeft setSerialNumber:snOnLeft];
                [quickPuddingLeft addAttributeValue:@"500" forKey:@"DC_Current_Source(uA)"];
                [quickPuddingLeft addAttributeValue:@"660" forKey:@"AC_Source(mV)"];
                [quickPuddingLeft addAttributeValue:@"100" forKey:@"AC_Source_Resistance(kohm)"];
                [quickPuddingLeft addAttributeValue:@"800" forKey:@"AC_Source_Frequency(Hz)"];
                [quickPuddingLeft setPriority:_auditMode?-2:0];
               // [quickPuddingLefts setObject:quickPuddingLeft forKey:[NSString stringWithFormat:@"%d", i]];
            }
            
            if (self -> testingRight && !self->singleDUT)
            {
                quickPuddingRight=nil;
                quickPuddingRight = [[QuickPudding alloc] init];
                [quickPuddingRight startInstantPudding];
                [quickPuddingRight setSerialNumber:snOnRight];
                [quickPuddingRight addAttributeValue:@"500" forKey:@"DC_Current_Source(uA)"];
                [quickPuddingRight addAttributeValue:@"660" forKey:@"AC_Source(mV)"];
                [quickPuddingRight addAttributeValue:@"100" forKey:@"AC_Source_Resistance(kohm)"];
                [quickPuddingRight addAttributeValue:@"800" forKey:@"AC_Source_Frequency(Hz)"];
                [quickPuddingRight setPriority:_auditMode?-2:0];
              //  [quickPuddingRights setObject:quickPuddingRight forKey:[NSString stringWithFormat:@"%d", i]];
            }
        }
   // }
}

-(bool)ScanSNValidation {//sc
    if (testStatus == TESTING) {
        return false;
    }
    [self GHInfo];
    [leftEnableBtn setEnabled:NO];
    [rightEnableBtn setEnabled:NO];
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:@"---sc---ScanSNValidation---"];
    NSString* checkSN1 = nil;
    bool sn1 = true;
    if ([self testing1])//[_EnableSN1 state] == 1 || self->singleDUT;
    {
        checkSN1 = [[leftScanView stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        checkSN1 = [self CheckSNLength:checkSN1];
        sn1 = checkSN1 != nil;
        
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"---sc---checkSN1:%@---",checkSN1]];
    }
    
    NSString* checkSN2 = nil;
    bool sn2 = true;
    if (!self->singleDUT)
    {
        if ([self testing2])
        {
            checkSN2 = [[rightScaniew stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            checkSN2 = [self CheckSNLength:checkSN2];
            sn2 = checkSN2 != nil;
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"---sc---checkSN2:%@---",checkSN2]];
        }
    }else{
        [_labelSN2 setStringValue: @""];
    }
    
    if (checkSN1 != nil && checkSN2 != nil)
    {
        if ([checkSN1 caseInsensitiveCompare: checkSN2] == NSOrderedSame)
        {

            return false;
        }
    }
    
    
    if (sn1 && sn2) {//sc
        
        deviceCount = (int)[deviceArr count];
        
        [self matchWithSN1:checkSN1 SN2:checkSN2];
        
        if (_queryProject) {//[[configDic valueForKey:@"isQueryProject"] boolValue]&& !_officeMode
            NSInteger port = [SFHelper getPortNumbersOfProjectWithSN:snOnLeft logFile:[NSString stringWithFormat:@"%@/%@",DebugFOLDER,debugFileName]];
            if (port>=1){
                int iport_count =(int)(port+1)/2;
                deviceCount = iport_count;}
            else{
                [_labelSN2 setStringValue:[NSString stringWithFormat:@"usbc port:%ld",(long)port]];
            }
        }
        
        else if (_checkGPU&& !_officeMode) {//[[configDic valueForKey:@"isCheckGPU"] boolValue]&& !_officeMode
            //[self saveSnLogWithContent:[NSString stringWithFormat:@"--CheckGPU--begin--deviceCount:%d",deviceCount]];
            GpuResult *gpuResult = [SFHelper getGPUNumWithSN_new:snOnLeft logFile:[NSString stringWithFormat:@"%@/%@",DebugFOLDER,debugFileName]];

            int num = gpuResult.num;
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--get GPU Num is %ld",[LogFile CurrentTimeForLog],(long)num]];
          
            if (num>=2){
                deviceCount = (int)num/2;
        
                if (singleDUT&&gpuResult.GPU_type.length){//[product containsString:@"160"]&&
                    [_labelSN2 setStringValue:gpuResult.GPU_type];
                }
//                if ([product containsString:@"160"]&&singleDUT) {
//                    [MyEexception RemindException:@"" Information:[NSString stringWithFormat:@"please insert %ld cables",(long)num]];
//                }
                
            }else{
                if (num==-1) {
                    [MyEexception RemindException:@"Check GPU ERROR" Information:@"SF Network Connect Fail,BOBCAT_DIRECT Is Not ON"];
                    [NSApp terminate:nil];
                }else{
                    [MyEexception RemindException:@"Check GPU ERROR" Information:@"Get wrong reponse,Please check the reponse in log"];
                    return false;
                }
            }
            //[self saveSnLogWithContent:[NSString stringWithFormat:@"--CheckGPU--end--deviceCount:%d",deviceCount]];
        }else{
            if (!_officeMode) {
                if (![self handleEcodeWithSN1:checkSN1 SN2:checkSN2]) {
                    return false;
                }
            }
            
        }
        
        [self setPudding];
        
        if (!_officeMode&&!_auditMode) {
            NSMutableString *mutErrorMes = [NSMutableString string];
            
            bool amIOK = true;
            
            if (self -> testingLeft && ![[configDic valueForKey:DEBUGMODE] boolValue])//
            {
                // check AMIOK
//                QuickPudding *amIokPudding = [[QuickPudding alloc] init];
//                [amIokPudding startInstantPudding];
               
                // AMIOK For left SN.
                NSString *amIokrespond = [quickPuddingLeft amIOKWithRespond:snOnLeft];
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--sc--amIokrespond = %@",[LogFile CurrentTimeForLog],amIokrespond]];
                
                if (!([amIokrespond containsString:@"PASS"]|| [amIokrespond containsString:@"File is old"])) {//File is old 
                   // [quickPuddingLeft setSerialNumber:snOnLeft];
                    [quickPuddingLeft submitPudding:NO];
                    
                    NSArray * arr = [self GetDebugSNs];
                    if (![arr containsObject:snOnLeft])
                    {
                        if (amIokrespond.length<=2) {
                            amIokrespond =@"No response from amIokrespond";
                        }
                 
                        [mutErrorMes appendString:amIokrespond];
                        
                        amIOK = false;
                    }
                }

            }
            
            if (self -> testingRight && !self->singleDUT&& ![[configDic valueForKey:DEBUGMODE] boolValue])
            {
                //check AMIOK
//                QuickPudding *amIokPudding = [[QuickPudding alloc] init];
//                [amIokPudding startInstantPudding];
                // AMIOK For right SN.
                NSString * amIokrespond = [quickPuddingRight amIOKWithRespond:snOnRight];
                if (!([amIokrespond containsString:@"PASS"] || [amIokrespond containsString:@"File is old"])) {
                    //[quickPuddingRight setSerialNumber:snOnRight];
                    [quickPuddingRight submitPudding:NO];
                    
                    NSArray * arr = [self GetDebugSNs];
                    if (![arr containsObject:snOnRight])
                    {
                        if (amIokrespond.length<=2) {
                            amIokrespond =@"No response from amIokrespond";
                        }
                        [mutErrorMes appendString:amIokrespond];
                        amIOK = false;
                        
                        
                    }
                }

            }
            
            if (!amIOK)
            {
                if (mutErrorMes.length) {
                    testStatus = ERROR;
                    if (snOnLeft.length) {
                        [leftTestedView setStringValue:snOnLeft];
                    }
                    if (snOnRight.length) {
                        [rightTestedView setStringValue:snOnRight];
                    }
                    
                    [rightScaniew setStringValue:@""];
                    [leftScanView setStringValue:@""];
                    
                    [self cleanUI];
                    
                    [_lbSNwarningInfo setStringValue:mutErrorMes];
                    
                    [MyEexception RemindException:@"ERROR" Information:mutErrorMes];
                }
                
                return false;
            }
            
             [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--sc--SFCQuerySwitch = %@",[LogFile CurrentTimeForLog],[SFCQuerySwitch uppercaseString]]];
            if (![[configDic valueForKey:DEBUGMODE] boolValue]) {//
                
                //check SFC is OFF
               
                NSString *str =[SFCQuerySwitch uppercaseString];
                
                if (![str containsString:@"ON"]) {
                    return true;
                }
                
                // unit_process_check
                bool uopByAPI = true;
                if (self -> testingLeft)
                {
                    NSString * msg = [[NSString alloc] init];
                    if (![self checkUOPByAPI:snOnLeft msg: &msg]) {
                       
                        //[quickPuddingLeft setSerialNumber:snOnLeft];
        
                        [quickPuddingLeft submitPudding:NO];
                        // NSTextField *testFiled = self -> firstMap2Right ? _testedSN2 : _testedSN1;
                        [leftTestedView setBackgroundColor:[NSColor redColor]];
                        NSArray * arr = [self GetDebugSNs];
                        if (![arr containsObject:snOnLeft])
                        {
                            [mutErrorMes appendString:[NSString stringWithFormat:@"%@\n",msg]];
                            
                            uopByAPI = false;
                            
                        }
                    }
                }
                
                if (self -> testingRight && !self->singleDUT)
                {
                    NSString * msg = [[NSString alloc] init];
                    if (![self checkUOPByAPI:snOnRight msg: &msg]) {
                        
//                        QuickPudding *amIokPudding = nil;
//                        amIokPudding = [[QuickPudding alloc] init];
//                        [amIokPudding startInstantPudding];
//
//                        [amIokPudding setSerialNumber:snOnRight];
//                        [amIokPudding amIOkay:snOnRight];
//                        [NSThread sleepForTimeInterval:3];
//                        [amIokPudding submitPudding:NO];
                        
                        [quickPuddingRight submitPudding:NO];
                        //NSTextField *testFiled = self -> firstMap2Right ? _testedSN1 : _testedSN2;
                        [rightTestedView setBackgroundColor:[NSColor redColor]];
                        NSArray * arr = [self GetDebugSNs];
                        if (![arr containsObject:snOnRight])
                        {
                            [mutErrorMes appendString:msg];
                            
                            uopByAPI = false;
                            
                        }
                    }
                }
                if (mutErrorMes.length) {
                    testStatus = ERROR;
                    
                    if (snOnLeft.length) {
                        [leftTestedView setStringValue:snOnLeft];
                    }
                    if (snOnRight.length) {
                        [rightTestedView setStringValue:snOnRight];
                    }
                    
                    [rightScaniew setStringValue:@""];
                    [leftScanView setStringValue:@""];
                    
                    [self cleanUI];
                    
                    [_lbSNwarningInfo setStringValue:mutErrorMes];
                    
                    [MyEexception RemindException:@"ERROR" Information:mutErrorMes];
                }
                
                return uopByAPI;
            }
        }
       
        
        return true;
    }
    else{
        if (testStatus != INIT) {
            bool leftEmpty = [[leftScanView stringValue] length] <= 0 && [self testing1];
            bool rightEmpty = [[rightScaniew stringValue] length] <= 0 && [self testing2];
            [_lbSNwarningInfo setStringValue:(sn1 ? (rightEmpty ? @"" : @"Invalid SN for RIGHT DUT!") : (sn2 ? (leftEmpty ? @"" : @"Invalid SN for LEFT DUT!") : (leftEmpty && rightEmpty ? @"": (leftEmpty ? @"Invalid SN for RIGHT DUT.": (rightEmpty ? @"Invalid SN for LEFT DUT." : @"Invalid SNs for both sides.")))))];
        }
    }
    
    return false;
}





-(BOOL)handleEcodeWithSN1:(NSString *)checkSN1 SN2:(NSString *)checkSN2
{//sc
    if (!_isCheckEcode) {
        return YES;
    }
    NSDictionary *dict = [ConfigECode getDatas];
    if ([ConfigECode isRight]) {
        // BOOL isExistProduct = NO;
        for (NSString *key in dict) {
            if ([key isEqualToString:product]) {
                //isExistProduct = YES;
                ProductInfo *productInfo = dict[key];
                NSString *FourECode1=nil;
                NSString *FourECode2=nil;
                //1. deviceCount
                deviceCount = (int)[deviceArr count] - 2;
                //2.get code
                if (productInfo.types.count) {
                    for (Type *type in productInfo.types) {
                        
                        FourECode1=[checkSN1 cw_getSubstringFromIndex:8 toLength:4];
                        if (!singleDUT) {
                            FourECode2=[checkSN2 cw_getSubstringFromIndex:8 toLength:4];
                        }
                        
                        if (type.snLength == checkSN1.length) {
                            FourECode1=[checkSN1 cw_getSubstringFromIndex:type.codeIndex toLength:type.codeLength];
                            if (!singleDUT) {
                                FourECode2=[checkSN2 cw_getSubstringFromIndex:type.codeIndex toLength:type.codeLength];
                            }
                            break;
                        }
                    }
                    
                }else{
                    FourECode1=[checkSN1 cw_getSubstringFromIndex:8 toLength:4];
                    if (!singleDUT) {
                        FourECode2=[checkSN2 cw_getSubstringFromIndex:8 toLength:4];
                    }
                }
                
                //3.match allowCode
                if (productInfo.allowCodes.count) {
                    
                    for (AllowCode *allowCode in productInfo.allowCodes) {
                        if ([allowCode.code isEqualToString:FourECode1]) {
                            allow_Ecode=true;
                            deviceCount =(int)allowCode.fixSerialPortsCount ? :(int)[deviceArr count];
                            
                            break;
                        }
                    }
                    
                }
                
                if (allow_Ecode && !self->singleDUT){//sn1 length not sn2
                    
                    if (FourECode1 != FourECode2) {
                        
                        if (testStatus != INIT && ([checkSN1 length] != 0 || [checkSN2 length] != 0) ) {
                            [_lbSNwarningInfo setStringValue:@"Different EEEE code between SN1 and SN2!"];
                        }
                        return NO;
                    }
                    
                }
                
            }
        }
        
        if (deviceCount==0) {
            
            [MyEexception RemindException:@"check ECode error" Information:[NSString stringWithFormat:@"deviceCount=0,no iport to be tested"]];
            
            [NSApp terminate:nil];
        }
    }
    return YES;
}
- (bool)checkUOPByAPI:(NSString *)SN msg:(NSString **) msg{
    // get station id from gh_station_info.json file.
    
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:@"---sc---checkUOPByAPI---"];
    
    NSString *stationID=@"";
    NSString* strGHConfig = [[NSString alloc]initWithFormat:@"/vault/data_collection/test_station_config/gh_station_info.json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:strGHConfig]) {
        NSString* jsonString = [[NSString alloc] initWithContentsOfFile:strGHConfig encoding:NSUTF8StringEncoding error:nil];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* allKeysValues = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if ([[allKeysValues allKeys] containsObject:@"ghinfo"]){
            NSDictionary *allValues = [allKeysValues valueForKey:@"ghinfo"];
            if ([[allValues allKeys] containsObject:@"STATION_ID"]){ // STATION_ID
                stationID = [allValues valueForKey:@"STATION_ID"];
            }
        }
    }
    
    const char *sfcQuqeryResult = SFCQueryRecordUnitCheck([SN UTF8String],[stationID UTF8String]);
    
    if (sfcQuqeryResult == NULL)
    {
        NSString * error = @"Failed to query result.";
        NSLog(@"Failed to get station ID: %@", error);
        if (msg != nil)
        {
            *msg = error;
        }
        
        return false;
    }
  
    NSString *return_str=[NSString stringWithUTF8String:sfcQuqeryResult];
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--sc--stationID= %@, SFC Respond:%@", [LogFile CurrentTimeForLog],stationID,return_str]];
    
    //EXAMPLE SFC information:
    //    NSString *return_str=@"ts::QT4::unit_process_check=UNIT OUT OF PROCESS UOP:violate AAB policy. Go to another QT4,Response=0 SFC_OK,";
    //    NSString *return_str=@"SFC no respond";
    //    NSString *return_str=@"ts::QT4::unit_process_check=OK.,Response=0 SFC_OK,";
    NSString *find_str = @"rocess_check=OK";

    if (![return_str containsString:find_str]) {//sc
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@--sc--SFC abnormal, failure info:not contain unit_process_check=OK",[LogFile CurrentTimeForLog]]];
        if (msg != nil)
        {
            NSString *str=@"";
            if ([return_str containsString:@"rocess_check="]) {
                str = [return_str cw_getSubstringFromStringToEnd:@"rocess_check="];
            }else{
                str = return_str;
                if (return_str.length<=2) {
                    str =@"SFC no respond";
                }
            }
//            else if([return_str containsString:@"unit_process_check="]){
//                str = [return_str cw_getSubstringFromStringToEnd:@"unit_process_check="];
//            }
//            
            *msg = [NSString stringWithFormat:@"sn:%@,%@",SN,str] ;
           
        }
        
        return false;
    }
    else{
        
        return true;
    }
    
}

- (bool)checkUOP:(NSString *)SN
             msg:(NSString **) msg{
    NSString *querSFC_URL = [SFC_URL stringByAppendingString:@"?"];
    NSDictionary *q_param = @{ @"sn" : SN, @"c" : @"QUERY_RECORD", @"p" : @"unit_process_check", @"tsid" : stationID };
    querSFC_URL = [querSFC_URL stringByAppendingString:[SFHelper paramsToURLString:q_param]];
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Sent SFC Request: %@",[LogFile CurrentTimeForLog],querSFC_URL]];
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:querSFC_URL]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    //0 SFC_OK
    if ([return_str length]==0) {
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Network Disconnect!",[LogFile CurrentTimeForLog]]];
        if (msg != nil)
        {
            *msg = @"Network Disconnect!";
        }

        return false;
    }
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ SFC Respond: %@", [LogFile CurrentTimeForLog],return_str]];
    
    NSString *find = @"unit_process_check";
    
    NSUInteger idx = [return_str rangeOfString:find].location;
    if (idx == NSNotFound) {
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Respond didn't contain unit_process_check",[LogFile CurrentTimeForLog]]];
        if (msg != nil)
        {
            *msg = return_str;
        }

        return false;
    }
    
    return_str = [return_str substringFromIndex:idx + [find length] +1];
    if ([return_str rangeOfString:@"OK"].location == NSNotFound) {
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Respond didn't contain SFC OK",[LogFile CurrentTimeForLog]]];
        if (msg != nil)
        {
            *msg = return_str;
        }

        return false;
    }

    return true;
}


#pragma mark TableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    //set table columns header
    NSArray *tableColumnsArr = [tableView tableColumns];
    for (NSTableColumn *tableColumn in tableColumnsArr) {
        [tableColumn setEditable:NO];

        NSTableHeaderCell *headerCell =  [tableColumn headerCell];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attrDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor headerTextColor], NSForegroundColorAttributeName, [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName, [NSFont boldSystemFontOfSize:11], NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil];
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[tableColumn title] attributes:attrDic];
        [headerCell setTitle:(NSString*)attrStr];
    }
    
    if ([tableView.identifier isEqualToString:@"CommandList"]) {
        NSLog(@"11");
    }
    if ([[tableView identifier] isEqualToString:@"TestView"]) {
        return [testItems count];
    }
    else if ([[tableView identifier] isEqualToString:@"FailOnly"]){
        NSLog(@"[failonlyItemArr count] = %lu",(unsigned long)[failedItems count]);
        return [failedItems count];
    }else if ([[tableView identifier] isEqualToString:@"CommandList"]){
        return _commands.count;
    }
    
    return 0;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableView.identifier isEqualToString:@"CommandList"]) {
        NSLog(@"tableColumn--%@",tableColumn.identifier);
        
    }
    TestResultItem * item = nil;
    CommandMode *command=nil;
    if ([[tableView identifier] isEqualToString:@"TestView"])
    {
        if (row >= [testItems count])
        {
            return @"";
        }

        item = testItems[row];
    }
    else if ([[tableView identifier] isEqualToString:@"CommandList"])
    {

        command = _commands[row];
    }
    else if ([[tableView identifier] isEqualToString:@"FailOnly"])
    {
        if (row >= [failedItems count])
        {
            return @"";
        }
        
        item = failedItems[row];
    }
    else
    {
        return @"";
    }

    if ([[tableColumn identifier] isEqualToString:@"Item"]) {
        return [NSString stringWithFormat:@"%d", item -> Index];
    }
    else if ([[tableColumn identifier] isEqualToString:@"DEVID"])
    {
        return [NSString stringWithFormat:@"%d", item -> DeviceIndex];
    }
    else if ([[tableColumn identifier] isEqualToString:@"Position"]) {
//        if ([item->Position caseInsensitiveCompare:item->OriginPos] == NSOrderedSame)
//        {
//            return item -> Position;
//        }
        if ([item -> OriginPos.lowercaseString containsString:@"usbc"]) {//[[configDic valueForKey:@"AutoSetPosUsbcName"] boolValue]
            return item -> OriginPos;
            
        }else{
            return [NSString stringWithFormat:@"%@[%@]", item -> Position, item -> OriginPos];
        }
        
    }
    else if ([[tableColumn identifier] isEqualToString:@"SN"]) {
        return item -> SerialNumber;
    }
    else if ([[tableColumn identifier] isEqualToString:@"GroupName"]) {
        return item -> Group;
    }
    else if ([[tableColumn identifier] isEqualToString:@"PinNumber"]) {
        return item.showingPinNumber;
        //return item -> PinNumber;

    }
    else if ([[tableColumn identifier] isEqualToString:@"NetName"]) {
        return item -> NetName;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Type"]) {
        return item -> Type;
    }
    else if ([[tableColumn identifier] isEqualToString:@"OpenLimit"]) {
        return item -> OpenLimit;
    }
    else if ([[tableColumn identifier] isEqualToString:@"ShortLimit"]) {
        return item -> ShortLimit;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Value"]) {
        return item -> Value;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Unit"]) {
        return item -> Unit;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Result"]) {
        return item -> Result;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Num"]) {
        return [NSString stringWithFormat:@"%ld",row+1];
    }
    else if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        return command.name;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Send"]) {
        return command.send;
    }
    else if ([[tableColumn identifier] isEqualToString:@"Response"]) {
        return command.response;
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if ([tableView.identifier isEqualToString:@"CommandList"]) {
        NSLog(@"11");
    }
    TestResultItem * item = nil;
    if ([[tableView identifier] isEqualToString:@"TestView"])
    {
        if (row >= [testItems count])
        {
            return;
        }

        item = testItems[row];
    }
    else if ([[tableView identifier] isEqualToString:@"FailOnly"])
    {
        if (row >= [failedItems count])
        {
            return;
        }

        item = failedItems[row];
    }
    else
    {
        return;
    }

    NSTextFieldCell *myCell = (NSTextFieldCell*)cell;
    [myCell setAlignment:NSTextAlignmentCenter];

    // [[self window] ]
    // [myCell setTextColor:[NSColor textColor]];
    NSString * result = [item -> Result uppercaseString];
    bool resultColumn = [[tableColumn identifier] isEqualToString:@"Result"] || [[tableColumn identifier] isEqualToString:@"Value"];
    NSColor * color = [NSColor selectedTextBackgroundColor];
    if (![result isEqualToString:@"PASS"]
        && ![result isEqualToString:@"SKIP"]) {
        color = [NSColor colorWithRed:0.95 green:0.39 blue:0.39 alpha:1.0];
    }
    else if ([result isEqualToString:@"SKIP"]){
        color = [NSColor grayColor];
    }
    else{
        color = [NSColor colorWithRed:0.2 green:0.82 blue:0.2 alpha:1.0];
    }

    if (resultColumn)
    {
        [myCell setDrawsBackground:YES];
        [myCell setBackgroundColor:color];
    }
    else
    {
        // [myCell setTextColor:color];
    }
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    
    if ([tableView.identifier isEqualToString:@"CommandList"]) {
        CommandMode *mode = _commands[row];
        if (mode.rowHeight.length) {
            return [mode.rowHeight integerValue];
        }else{
            return 20;
        }
      
    }else
        return 20;
}

-(NSArray *)GetDebugSNs
{
    if (debugSNs != nil)
    {
        return debugSNs;
    }

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DebugSN" ofType:@"txt"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    debugSNs = [fileContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return debugSNs;
}

- (IBAction)btnDebugSNClick:(id)sender {
    NSArray *SNArr = [self GetDebugSNs];
    NSInteger count = [SNArr count];
    int i = 0;
    if ([self testing1])
    {
        i = arc4random() % count;
        [leftScanView setStringValue:SNArr[i]];
    }

    if ([self testing2])
    {
        i = arc4random() % count;
        [rightScaniew setStringValue:SNArr[i]];
    }
}


-(void)matchWithFirstMap2Right{//sc
    
    if (self->singleDUT)
    {
        
        testingLeft = true;
        snOnRight = nil;
        testingRight = false;
        leftTestedView = _testedSN1;
        leftScanView = _txtScanSN1;
        leftEnableBtn = _EnableSN1;
        [leftEnableBtn setHidden:false];
        
        [self SwitchClick:leftEnableBtn];
        [_labelSN1 setStringValue: @"SN"];
        
        [_EnableSN2 setHidden:true];
        [_EnableSN2 setState:0];
        [_txtScanSN2 setHidden:true];
        [_testedSN2 setHidden:true];
        [_titleSN2 setHidden:false];
        [_labelSN2 setStringValue: @""];
        _labelSN2.textColor = [NSColor redColor];
        _labelSN2.font = [NSFont systemFontOfSize:13];
        [_titleTestedSN2 setHidden:true];

        // self->firstMap2Right = false;
       // self->posCheck = false;
        
    }
    else
    {
    
        leftTestedView = self -> firstMap2Right ?_testedSN2:_testedSN1;
        rightTestedView = self -> firstMap2Right ?_testedSN1:_testedSN2;
        leftScanView = self -> firstMap2Right ?_txtScanSN2:_txtScanSN1;
        rightScaniew = self -> firstMap2Right ?_txtScanSN1:_txtScanSN2;
        leftEnableBtn=firstMap2Right?_EnableSN2:_EnableSN1;
        rightEnableBtn=firstMap2Right?_EnableSN1:_EnableSN2;
        //        [_EnableSN2 setState: 1];
        [_EnableSN2 setHidden:false];
        [self SwitchClick:_EnableSN2];
        [_txtScanSN2 setHidden:false];
        [_txtScanSN2 setBackgroundColor:[NSColor selectedControlColor]];
        [_testedSN2 setHidden:false];
        [_titleSN2 setHidden:false];
        [_titleTestedSN2 setHidden:false];
        
        if (self -> firstMap2Right)
        {
            [_labelSN1 setStringValue: @"SN 1(R)"];
            [_labelSN2 setStringValue: @"SN 2(L)"];
        }
        else
        {
            [_labelSN1 setStringValue: @"SN 1(L)"];
            [_labelSN2 setStringValue: @"SN 2(R)"];
        }
        
        
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [leftScanView setEditable:[self testing1]];
        [rightScaniew setEditable:[self testing2]];
        [_btnStart setEnabled:[self testing1] || [self testing2]];
    });
}

-(void)matchWithSN1:(NSString *)sn1 SN2:(NSString *)sn2{//sc
    if (self->singleDUT)
    {
        snOnLeft = sn1;

    }
    else
    {
        snOnRight = sn2;
        snOnLeft = sn1;
        testingLeft = [self testing1];
        testingRight = [self testing2];
    }
}

-(void)updateTestSNs{//sc
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self testing1])
        {
            [leftTestedView setStringValue:snOnLeft];
        }
        else{
            [leftTestedView setStringValue:@""];
            
        }
        
        if ([self testing2])
        {
            [rightTestedView setStringValue:snOnRight];
        }
        else{
            [rightTestedView setStringValue:@""];
            
        }
        [_lbSNwarningInfo setStringValue:@""];
        
        
        [leftTestedView setBackgroundColor:[NSColor clearColor]];
        [rightTestedView setBackgroundColor:[NSColor clearColor]];
    });

    
    
}
- (void)updateTestStatusLabel{//sc
    while (true) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (testStatus == INIT) {
                [_EnableSN1 setEnabled:NO];
                [_EnableSN2 setEnabled:NO];
                [leftScanView setEditable:NO];
                [rightScaniew setEditable:NO];
                [leftScanView setBackgroundColor:NSColor.controlColor];
                [rightScaniew setBackgroundColor:NSColor.controlColor];
                [_btnStart setEnabled:NO];
                [_lbStatusTitle setStringValue:@"Initializing..."];//Init...
                [_lbTestStatus setBackgroundColor:[NSColor systemOrangeColor]];
                NSLog(@"Disable controlling while initializing");
            }
            else if (testStatus == UPGRADE) {//CONFIG
                [_lbStatusTitle setStringValue:@"Upgrading FW..."];
                [_lbTestStatus setBackgroundColor:[NSColor systemOrangeColor]];
            }
            
//            else if (testStatus == CONFIG) {//CONFIG
//                [_lbStatusTitle setStringValue:@"Upgrading Config..."];
//                [_EnableSN1 setEnabled:NO];
//                [_EnableSN2 setEnabled:NO];
//                [leftScanView setEditable:NO];
//                [rightScaniew setEditable:NO];
//                [leftScanView setBackgroundColor:NSColor.controlColor];
//                [rightScaniew setBackgroundColor:NSColor.controlColor];
//                [_btnStart setEnabled:NO];
//                [_lbTestStatus setBackgroundColor:[NSColor systemOrangeColor]];
//            }
//            
            else if (testStatus == READY) {
                if (_officeMode) {
                    // enable scanSN function for officeMode
                    if (![rightScaniew isEditable])
                    {
                        [rightScaniew setEditable:YES];
                        [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
                    }

                    if (![leftScanView isEditable])
                    {
                        [leftScanView setEditable:YES];
                        [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
                    }
                }
                else{
                    if (![rightScaniew isEditable])
                    {
                        [rightScaniew setEditable:YES];
                        [rightScaniew setBackgroundColor:[self testing2] ? NSColor.selectedControlColor : NSColor.controlColor];
                    }

                    if (![leftScanView isEditable])
                    {
                        [leftScanView setEditable:YES];
                        [leftScanView setBackgroundColor:[self testing1] ? NSColor.selectedControlColor : NSColor.controlColor];
                    }
                }

                [_EnableSN1 setEnabled:YES];
                [_EnableSN2 setEnabled:YES];
                [_btnStart setEnabled:[self testing1] || [self testing2]];
                [_lbStatusTitle setStringValue:@"Ready"];

                [_lbTestStatus setBackgroundColor:[NSColor colorWithRed:.11 green:.56 blue:1 alpha:1.0]];
                NSLog(@"Enable controlling while ready to test");
            }
            else if (testStatus == TESTING){
                [_lbStatusTitle setStringValue:@"Testing..."];
                if ([leftScanView isEditable])
                {
                    [leftScanView setEditable:NO];
                    if (flushingFlag)
                    {
                        [leftScanView setBackgroundColor:[NSColor systemBlueColor]];
                    }
                    else
                    {
                        [leftScanView setBackgroundColor:[NSColor systemYellowColor]];
                    }
                }

                if ([rightScaniew isEditable])
                {
                    [rightScaniew setEditable:NO];
                    if (flushingFlag)
                    {
                        [rightScaniew setBackgroundColor:[NSColor systemBlueColor]];
                    }
                    else
                    {
                        [rightScaniew setBackgroundColor:[NSColor systemYellowColor]];
                    }
                }

                if ([_btnStart isEnabled])
                {
                    [_btnStart setEnabled:NO];
                }

                [_EnableSN1 setEnabled:NO];
                [_EnableSN2 setEnabled:NO];

                if (flushingFlag)
                {
                    [_lbTestStatus setBackgroundColor:[NSColor systemBlueColor]];
                }
                else
                {
                    [_lbTestStatus setBackgroundColor:[NSColor systemYellowColor]];
                }

                flushingFlag = !flushingFlag;
                NSLog(@"Disable controlling while testing");
            }


            else if (testStatus == ERROR){
            
                [_lbStatusTitle setStringValue:@"FAIL"];
                [_lbTestStatus setBackgroundColor:[NSColor colorWithRed:0.95 green:0.39 blue:0.39 alpha:1.0]];
            }
            else if (testStatus == CANCEL){
                [_lbStatusTitle setStringValue:@"Cancel"];
                [_lbTestStatus setBackgroundColor:[NSColor magentaColor]];
            }
        });

        sleep(1);
    }
}


-(void)testFinishShowUI:(bool)rightFailed leftFailed:(bool)leftFailed{
    
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-testFinishShowUI\n",[LogFile CurrentTimeForLog]]];
    
//    bool rightFailed = false;
//    bool leftFailed = false;
//    if (testCounts.count) {
//
//        for (int idx = 0; idx < [testCounts count]; idx++)
//        {
//            TestResultCount * testCount = [testCounts objectAtIndex:idx];
//
//
//            if ((testCount -> RightFailCount == 0 && testCount -> RightPassCount == 0))
//            {
//
//                rightFailed = isSignPort ? false : true;
//                if (leftFailed && rightFailed)
//                {
//                    break;
//                }
//
//            }
//
//            if (testCount -> RightFailCount > 0)
//            {
//
//                rightFailed = true;
//
//                if (leftFailed && rightFailed)
//                {
//                    break;
//                }
//            }
//
//
//            if ((testCount -> LeftFailCount == 0 && testCount -> LeftPassCount == 0))
//            {
//                leftFailed = isSignPort ? false : true;
//                if (leftFailed && rightFailed)
//                {
//                    break;
//                }
//
//            }
//            if (testCount -> LeftFailCount > 0)
//            {
//                leftFailed = true;
//
//                if (leftFailed && rightFailed)
//                {
//                    break;
//                }
//            }
//        }
//    }
    
    if (self -> singleDUT && (leftFailed || rightFailed))
    {
        [_lbStatusTitle setStringValue:@"FAIL"];
        [_lbTestStatus setBackgroundColor:[NSColor colorWithRed:0.95 green:0.39 blue:0.39 alpha:1.0]];
        
        // Force the leftFailed to true to lead the tested SN 1 text box been red color.
        leftFailed = true;
    }
    else if ((self -> testingLeft && leftFailed) || (self -> testingRight && rightFailed) )
    {
        [_lbStatusTitle setStringValue:@"FAIL"];
        [_lbTestStatus setBackgroundColor:[NSColor colorWithRed:0.95 green:0.39 blue:0.39 alpha:1.0]];
    }
    else{
        [_lbStatusTitle setStringValue:@"PASS"];
        [_lbTestStatus setBackgroundColor:[NSColor colorWithRed:0.2 green:0.82 blue:0.2 alpha:1.0]];
    }
    
    
    //NSTextField * testField = self -> firstMap2Right ? _testedSN2 : _testedSN1;
    
    [leftTestedView setBackgroundColor:self -> testingLeft ? (leftFailed ? (flushingFlag ? [NSColor redColor] : [NSColor brownColor]): [NSColor greenColor]): [NSColor controlColor]];
    [leftTestedView setDrawsBackground:self -> testingLeft];
    
    if (!self -> singleDUT&&testingRight)
    {
        [rightTestedView setBackgroundColor:self -> testingRight ? (rightFailed ? (flushingFlag ? [NSColor redColor] : [NSColor brownColor]): [NSColor greenColor]): [NSColor controlColor]];
        [rightTestedView setDrawsBackground:self -> testingRight];
    }
    
    
    // [leftScanView becomeFirstResponder];
    
    flushingFlag = !flushingFlag;
}


-(void)launchExternalForUpdateFW:(NSString*)extLaunchPath arguments:(NSArray*)praArr{//sc
    NSString *logCmd1 = @"ps -ef |grep -i python |grep -i UpdateFW.py |grep -v grep|awk '{print $2}' |xargs kill -9";
    system([logCmd1 UTF8String]);
    NSString *logCmd2 = @"ps -ef |grep -i python |grep -i Python |grep -v grep|awk '{print $2}' |xargs kill -9";
    system([logCmd2 UTF8String]);
    isUpdateFW  =true;
    Task = [[NSTask alloc] init];
    [Task setLaunchPath:extLaunchPath];
    
   // NSArray *praArr = [NSArray arrayWithObjects: pyPath, te.device.portName, fwPath, nil];
    [Task setArguments:praArr];
    
    NSPipe *pipe = [NSPipe pipe];
    [Task setStandardOutput: pipe];
    
    filehandler = [pipe fileHandleForReading];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readCompletionNotification:) name:NSFileHandleReadCompletionNotification object:filehandler];
    [filehandler readInBackgroundAndNotify];
    
    [Task launch];
    [Task waitUntilExit];
    [NSThread sleepForTimeInterval:16];
    isUpdateFW  =false;
    
    
}

-(NSString*)launchExternalForSerial:(NSString*)extLaunchPath arguments:(NSArray*)praArr
{
    NSTask *SerialTask = [[NSTask alloc] init];
    [SerialTask setLaunchPath:extLaunchPath];
    [SerialTask setArguments:praArr];
    
    NSPipe *pipe = [NSPipe pipe];
    [SerialTask setStandardOutput: pipe];
    
    filehandler = [pipe fileHandleForReading];
    
    [SerialTask launch];
    [SerialTask waitUntilExit];
    if ([SerialTask terminationStatus] != 0) {
        NSLog(@"execute fail,return empty");
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ execute fail,return empty",[LogFile CurrentTimeForLog]]];
        [NSApp terminate:nil];
        return @"";
    }
    NSData *data = [filehandler readDataToEndOfFile];
    NSString *extStr = [[NSString alloc] initWithData: data
                                             encoding: NSUTF8StringEncoding];
    return extStr;
}

-(NSString*)launchExternalForSerial2:(NSString*)extLaunchPath arguments:(NSArray*)praArr
{
    NSTask *Task2 = [[NSTask alloc] init];
    [Task2 setLaunchPath:extLaunchPath];
    [Task2 setArguments:praArr];
    
    NSPipe *pipe = [NSPipe pipe];
    [Task2 setStandardOutput: pipe];
    
    filehandler = [pipe fileHandleForReading];
    
    [Task2 launch];
    [Task2 waitUntilExit];
    if ([Task2 terminationStatus] != 0) {
        NSLog(@"execute fail,return empty");
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ execute fail,return empty",[LogFile CurrentTimeForLog]]];
        return @"";
    }
    NSData *data = [filehandler readDataToEndOfFile];
    NSString *extStr = [[NSString alloc] initWithData: data
                                             encoding: NSUTF8StringEncoding];
    return extStr;
}
-(void)readCompletionNotification:(NSNotification*)aNotification{
    if (Task != nil) {
        NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
        
        if ([data length] ==0 ) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"Incorrect response from iPort." Information:@"upgraded FW fail! Please try upgrading again."];
                [_MainWindow endSheet:_updateFWWindow];
            });

            [Task terminate];
            [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ upgraded FW Fail!",[LogFile CurrentTimeForLog]]];
            
            [NSApp terminate:nil];
        }

        
        NSString *extStr = [[NSString alloc] initWithData: data
                                                 encoding: NSUTF8StringEncoding];
        extStr = [extStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSLog(@"standard string ready %@",extStr);
        
//        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ standard data ready %ld bytes--extStr:%@",[LogFile CurrentTimeForLog],data.length,extStr]];
        NSScanner *scanner = [NSScanner scannerWithString:extStr];
      //  NSArray * arr =[extStr componentsSeparatedByString:@"\n"];
//        if ([arr.lastObject containsObject:@"Percent:"]&&[arr.lastObject containsObject:@"Time:"]) {
//            scanner =[NSScanner scannerWithString:arr.lastObject];
//        }
        [scanner scanUpToString:@"t:" intoString:NULL];
        NSString *strPercent;
        [scanner scanUpToString:@"%" intoString:&strPercent];
        strPercent=[strPercent stringByReplacingOccurrencesOfString:@"t: " withString:@""];

        float percent = [strPercent floatValue];
        if (isUpdateFW) {
            // only for FW update
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![extStr containsString:@"-----Upadate start-----"]) {
                    [_EnableSN1 setEnabled:NO];
                    [_EnableSN2 setEnabled:NO];
                    [leftScanView setEditable:NO];
                    [rightScaniew setEditable:NO];
                    [leftScanView setBackgroundColor:NSColor.controlColor];
                    [rightScaniew setBackgroundColor:NSColor.controlColor];
                    [_btnStart setEnabled:NO];
                    [_fwProgressIndicator setDoubleValue:percent/100];
                    
                    [_lbFWUpdateStatus setStringValue:extStr];
                }
            });

            if (![extStr containsString:@"Quit."]) {
                [filehandler readInBackgroundAndNotify];
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_MainWindow endSheet:_updateFWWindow];
                });

                [Task terminate];
                NSLog(@"Update FW Finish!");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ Update FW Finish!",[LogFile CurrentTimeForLog]]];
            }
        }
        else{
            //for read serial port
            if(![extStr containsString:@"{\"group\": \"message\",\"item\": \"end\"}"]){
                [filehandler readInBackgroundAndNotify];
            }else{
                [Task terminate];
                NSLog(@"Read from serial port Finish!");
            }
        }
    }
}



-(void)updateConfigWithPort:(TestEngine *)te configPath:(NSString *)configPath num:(int)num{
    
    NSString *defaultConfigPath = configPath;
    if (!configPath.length || ![[NSFileManager defaultManager] fileExistsAtPath:configPath]) {
        return;
        // defaultConfigPath=[self getDefaultConfigPath];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_lbStatusTitle setStringValue:@"checking config..."];
//    });
    testStatus = CONFIG;
    NSString *defaultCheckSum = [self getCheckSumFromFile:defaultConfigPath];

    if (num ==0) {
        [self showConfigUI:defaultConfigPath];
 
    }
    
    [NSThread sleepForTimeInterval:6];

    NSString *readCheckSum = @"";
    for (int j =0; j<3; j++) {
        //{"Getchecksum": "3435696029"}//{"command": "getcheckgetcheck", "code": 1, "message": "command not supported!"}
        readCheckSum = [te.device sendCommandAndReadResponse:@"getcheck"];
        if ([readCheckSum containsString:@"command not supported"] || readCheckSum.length==0) {
            [NSThread sleepForTimeInterval:2];
            continue;
        }else{
            if ([readCheckSum containsString:@"Getchecksum"]) {
                
                break;
            }
        }
    }
    
    NSDictionary *checkSumDic = [JasonUtilities loadJSONContentToDictionary:readCheckSum];
    readCheckSum = [checkSumDic valueForKey:@"Getchecksum"];
    NSLog(@"readCheckSum = %@",readCheckSum);
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ readCheckSum = %@,defaultCheckSum:%@",[LogFile CurrentTimeForLog],readCheckSum,defaultCheckSum]];
    if (![defaultCheckSum isEqualToString:readCheckSum] || isTestWithCapAndCap2) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbStatusTitle setStringValue:[NSString stringWithFormat:@"Loading Config to %@",defaultConfigPath.lastPathComponent]];
        });
        
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ checksum value is change,need to load default config file，defaultConfigPath:%@",[LogFile CurrentTimeForLog],defaultConfigPath]];
        
        [self loadDefaultConfig:te configPath:defaultConfigPath];
        
        if (isTestWithCapAndCap2) {
            defaultCheckSum =@"4000000000";
        }
        NSString *setCmd = [NSString stringWithFormat:@"setcheck %@\0",defaultCheckSum];
        NSString *setCheckSumRespond = [te sendCommandAndReadResponse:setCmd];
        NSLog(@"setCheckSumRespond = %@",setCheckSumRespond);
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ sendCommand:%@,--setCheckSumRespond = %@",[LogFile CurrentTimeForLog],setCmd,setCheckSumRespond]];
        if([setCheckSumRespond containsString:@"\"code\":"]){
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"Set Default CheckSum" Information:[NSString stringWithFormat:@"Command:%@\nRespond:%@",setCmd,setCheckSumRespond]];
                NSLog(@"set checksum failure");
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ set checksum failure!!",[LogFile CurrentTimeForLog]]];
            });
            [NSApp terminate:nil];
        }
        
        
        
        [self showConfigUI:defaultConfigPath];
    }
    
    
}

-(void)updateConfigWithPort:(TestEngine *)te num:(int)num{
    //upgrade config
    [self updateConfigWithPort:te configPath:[self getDefaultConfigPath] num:num];
    NSString *reply= [te sendCommandAndReadResponse:@"getcfg grp"];//}\r\n
    NSDictionary *dit = [JasonUtilities loadJSONContentToDictionary:reply];
    //   NSString stringWithFormat:@"\"dds2\":\"off\"}\r\n"
    if ([[dit objectForKey:@"dds2"] isEqualToString:@"off"]) {
        te.gecfg_end_key=@"\"dds2\": \"off\"}\r\n";
    }else{
        te.gecfg_end_key=@"\"dds2\": \"on\"}\r\n";
    }//{"adj": "on", "gnd": "on", "vbus": "off", "dds": "on", "voh": "off", "vol": "off", "dds2": "on"}
    NSLog(@"1");
    if ([[dit objectForKey:@"gnd"] isEqualToString:@"on"] && isTestWithCapAndCap2) {
        NSString *itm_gnd_str= [te sendCommandAndReadResponse:@"getcfg itm gnd\n"];//}\r\n
        itm_gnd_str = [itm_gnd_str stringByReplacingOccurrencesOfString:@"{\"gnd\": {," withString:@"{\"gnd\": {"];
        NSDictionary *itm_gnd_dit = [JasonUtilities loadJSONContentToDictionary:itm_gnd_str];
        NSDictionary *itm_gnd_vaule_dit = [itm_gnd_dit objectForKey:@"gnd"];
        if ([itm_gnd_vaule_dit.allKeys containsObject:@"cap"]) {
            NSString *cmd = [itm_gnd_vaule_dit objectForKey:@"cap"];
            if (num%2==1) {
                
                [te sendCommandAndReadResponse:[NSString stringWithFormat:@"setitm gnd cap2 %@\n",cmd]];
                
            }
            
        }else if ([itm_gnd_vaule_dit.allKeys containsObject:@"cap2"]) {
            NSString *cmd = [itm_gnd_vaule_dit objectForKey:@"cap2"];
            if (num%2==0) {
                [te sendCommandAndReadResponse:[NSString stringWithFormat:@"setitm gnd cap %@\n",cmd]];
            }
            
        }
    }
    
    
}

-(NSString*)CheckUserConfigIfContainTypeDDSorTR:(NSString*)csvFile{
    CSVParser *csv_parse= [[CSVParser alloc] init];
    if ([csv_parse openFile:csvFile]) {
        NSMutableArray *csvArr = [csv_parse parseFile];

        // remove the title line
        NSString *str0 = csvArr[0][0];
        if ([str0.uppercaseString containsString:@"GROUP"]) {
            [csvArr removeObjectAtIndex:0];
        }
        NSMutableArray *userTypeArr = [[NSMutableArray alloc]init];

        // get all the group name with arry
        for (int i=0 ; i< [csvArr count] ; i++) {
            [userTypeArr addObject:csvArr[i][2]];
        }

        // get all the group name with set
        NSMutableSet *userTypeNameSet=[NSMutableSet setWithArray:userTypeArr];
        for (NSString *type in userTypeNameSet) {
            if ([[type uppercaseString] isEqualToString:@"DDS"]
                || [[type uppercaseString] isEqualToString:@"TR"]) {
                return type;
            }
        }
    }
    return @"No DDS_OR_TR";
}
//adj    a03-a06    vdrp    2600    100
//adj    a06-b11    vdrp    2600    100
//adj    a07-a10    vdrp    2600    100
//adj    a11-b03    vdrp    2600    100
//adj    a04-b07    vdrp    2600    100
//adj    b02-b08    vdrp    2600    100
//adj    b10-a07    vdrp    2600    100

//@"a03-a06",@"a06-b11",@"b10-a07",@"a07-a10",@"a11-b03",@"b02-b08",@"a04-b07",
-(NSMutableArray*)adj2_generateConfigCommand:(NSString*)csvFile{//sc
    
    NSString *cmd1 = @"setgrp adj off";
    NSString *cmd2 = @"setgrp gnd off";
    NSString *cmd3 = @"setgrp dds off";
    NSString *cmd4 = @"setgrp dds2 off";
    NSString *cmd5 = @"setgrp adj2 on";
    NSMutableArray *generatedCmd = [[NSMutableArray alloc]initWithArray:@[cmd1,cmd2,cmd3,cmd4,cmd5]];
    CSVParser *csv_parse= [[CSVParser alloc] init];
    if ([csv_parse openFile:csvFile]) {
        NSMutableArray *csvArr = [csv_parse parseFile];
        int i =0;
        for (NSArray *arr in csvArr) {
            if (i==0) {
                i = i+1;
                continue;
            }
            NSString *cmd = [NSString stringWithFormat:@"setlim %@ %@ %@ %@ %@",arr[0],arr[2],arr[3],arr[4],arr[1]];
            [generatedCmd addObject:cmd];
            i = i+1;
            
        }

    }
    
    return generatedCmd;
}


-(NSMutableArray*)generateConfigCommand:(NSString*)csvFile{//sc
    NSString *content = [CWFileManager cw_readFromFile:csvFile];
    if ([content.lowercaseString containsString:@"adj2"]) {
        
        return [self adj2_generateConfigCommand:csvFile];
        
    }
    CSVParser *csv_parse= [[CSVParser alloc] init];
//    NSMutableSet *adjAvliableItmSet=[NSMutableSet setWithObjects:@"a01-a02",@"a02-a03",@"a03-a04",@"a04-a05",@"a05-a06",@"a06-a07",@"a07-a08",@"a08-a09",@"a09-a10",@"a10-a11",@"a11-a12",@"b01-b02",@"b02-b03",@"b03-b04",@"b04-b05",@"b05-b06",@"b06-b07",@"b07-b08",@"b08-b09",@"b09-b10",@"b10-b11",@"b11-b12",@"a02-b11",@"a03-b10",@"a05-b08",@"a06-b07",@"a07-b06",@"a08-b05",@"a10-b03",@"a11-b02",@"a03-a06",@"a06-b11",@"b10-a07",@"a07-a10",@"a11-b03",@"b02-b08",@"a04-b07",nil];
    
//    NSMutableSet *adj2AvliableItmSet=[NSMutableSet setWithObjects:@"b03-b10",@"a11-a05",@"b05-b06",@"a10-a02",@"b02-a07",@"a11-a06",@"b05-b07",@"b08-b11",nil];
    
     NSMutableSet *adjAvliableItmSet=[NSMutableSet setWithObjects:@"a01-a02",@"a02-a03",@"a03-a04",@"a04-a05",@"a05-a06",@"a06-a07",@"a07-a08",@"a08-a09",@"a09-a10",@"a10-a11",@"a11-a12",@"b01-b02",@"b02-b03",@"b03-b04",@"b04-b05",@"b05-b06",@"b06-b07",@"b07-b08",@"b08-b09",@"b09-b10",@"b10-b11",@"b11-b12",@"a02-b11",@"a03-b10",@"a05-b08",@"a06-b07",@"a07-b06",@"a08-b05",@"a10-b03",@"a11-b02",nil];
    if (_isA218) {
//        [adjAvliableItmSet addObjectsFromArray:@[@"a03-a06",@"a06-b11",@"b10-a07",@"a07-a10",@"a11-b03",@"b02-b08",@"a04-b07",@"b07-b09"]];
        [adjAvliableItmSet addObjectsFromArray:[self addNewAdjItems]];
    }
    NSMutableSet *gndAvliableItmSet=[NSMutableSet setWithObjects:@"a02",@"a03",@"a04",@"a05",@"a06",@"a07",@"a08",@"a09",@"a10",@"a11",@"b02",@"b03",@"b04",@"b05",@"b06",@"b07",@"b08",@"b09",@"b10",@"b11",nil];
//     NSMutableSet *gndAvliableItmSet=[NSMutableSet setWithObjects:@"a02:TX1+",@"a03:TX1-",@"a04:VBUS",@"a05:CC1",@"a06:D+",@"a07:D-",@"a08:SBU1",@"a09:VBUS",@"a10:RX2-",@"a11:RX2+",@"b02:TX2+",@"b03:TX2-",@"b04:VBUS",@"b05:VCONN",@"b06:NC",@"b07:NC",@"b08:SBU2",@"b09:VBUS",@"b10:RX1-",@"b11:RX1+",nil];
    NSMutableSet *vbusAvliableItmSet=[NSMutableSet setWithObjects:@"a01",@"a02",@"a03",@"a05",@"a06",@"a07",@"a08",@"a10",@"a11",@"a12",@"b01",@"b02",@"b03",@"b05",@"b06",@"b07",@"b08",@"b10",@"b11",@"b12",nil];
    NSMutableSet *ccpinAvliableItmSet=[NSMutableSet setWithObjects:@"a01",@"a02",@"a03",@"a05",@"a06",@"a07",@"a08",@"a10",@"a11",@"a12",@"b01",@"b02",@"b03",@"b05",@"b06",@"b07",@"b08",@"b10",@"b11",@"b12",nil];

    NSMutableArray *generatedCmd = [[NSMutableArray alloc]init];

//        [generatedCmd addObject:@"setitm adj res a01-a02,a02-a03,a03-a04,a04-a05,a05-a06,a06-a07,a07-a08,a08-a09,a09-a10,a10-a11,a11-a12"];
//        [generatedCmd addObject:@"setitm adj res b01-b02,b02-b03,b03-b04,b04-b05,b05-b06,b06-b07,b07-b08,b08-b09,b09-b10,b10-b11,b11-b12"];
//        [generatedCmd addObject:@"setitm adj res a02-b11,a03-b10,a05-b08,a06-b07,a07-b06,a08-b05,a10-b03,a11-b02"];
//        [generatedCmd addObject:@"setitm gnd cap a02,a03,a10,a11,b02,b03,b10,b11"];
//        [generatedCmd addObject:@"setitm gnd vdrp a04,a05,a06,a07,a08,a09"];
//        [generatedCmd addObject:@"setitm gnd vdrp b04,b05,b06,b07,b08,b09"];

//    

    //    // Never mind if have DDS or TR type, need to send command "setgrp TR off" first
    //    NSString *offTRCmd=@"setgrp TR off";
    //    [generatedCmd addObject:offTRCmd];
    //
    //    NSString* checkTypeStr=[self CheckUserConfigIfContainTypeDDSorTR:csvFile];
    //    if ([[checkTypeStr uppercaseString] isEqualToString:@"DDS"]) {
    //        NSString *DDSCmd=@"setgrp dds on";
    //        [generatedCmd addObject:DDSCmd];
    //    }
    //    else if ([[checkTypeStr uppercaseString] isEqualToString:@"DDS2"]) {
    //        NSString *DDSCmd=@"setgrp dds2 on";
    //        [generatedCmd addObject:DDSCmd];
    //    }
    //    else if ([[checkTypeStr uppercaseString] isEqualToString:@"TR"]){
    //        NSString *TRCmd=@"setgrp TR on";
    //        [generatedCmd addObject:TRCmd];
    //    }

    if ([csv_parse openFile:csvFile]) {
        NSMutableArray *csvArr = [csv_parse parseFile];

        // remove the title line
        // remove the title line
        NSString *str0 = csvArr[0][0];
        if ([str0.uppercaseString containsString:@"GROUP"]) {
            [csvArr removeObjectAtIndex:0];
        }
        

        // compare with all test item
        // NSMutableSet *defaultAvliableGrpNameSet=[NSMutableSet setWithObjects:@"adj",@"gnd",@"vbus",@"dds",@"dds2",@"voh",@"vol", nil];
        NSMutableSet *defaultAvliableGrpNameSet=[NSMutableSet setWithArray:[self DefaultGroup]];

        // create a dictionary   adj;gnd;dds;dds2;voh;vol
        NSMutableDictionary *grpItemSetDic = [[NSMutableDictionary alloc] init];
        for (NSString *grpName in defaultAvliableGrpNameSet) {
            if ([[grpName uppercaseString] isEqualToString:@"ADJ"]) {
                [grpItemSetDic setValue:adjAvliableItmSet forKey:grpName];
            }
            else if ([[grpName uppercaseString] isEqualToString:@"GND"]){
                [grpItemSetDic setValue:gndAvliableItmSet forKey:grpName];
            }
            else if ([[grpName uppercaseString] isEqualToString:@"VBUS"]){
                [grpItemSetDic setValue:vbusAvliableItmSet forKey:grpName];
            }
            else if ([[grpName uppercaseString] isEqualToString:@"VOH"] || [[grpName uppercaseString] isEqualToString:@"VOL"]){
                [grpItemSetDic setValue:ccpinAvliableItmSet forKey:grpName];
            }
//            else if ([[grpName uppercaseString] isEqualToString:@"ADJ2"]){
//                [grpItemSetDic setValue:ccpinAvliableItmSet forKey:grpName];
//            }
        }
        
        NSMutableArray *grpArrInConfig = [[NSMutableArray alloc]init];

        // get all the group name with arry
        NSMutableArray *itemArrInConfig = [NSMutableArray arrayWithArray:csvArr];
        for (int i=0 ; i< [itemArrInConfig count] ; i++) {
            [grpArrInConfig addObject:itemArrInConfig[i][0]];
        }

        // get all the group name with set
        NSMutableSet *grpNameSetInConfig=[NSMutableSet setWithArray:grpArrInConfig];

        // Group name set in configuration must be in default avaliable group name set.
        BOOL ret = [grpNameSetInConfig isSubsetOfSet:defaultAvliableGrpNameSet];

        if (!ret) {
            //            dispatch_async(dispatch_get_main_queue(), ^{
//                            [self ForceTerminate:[NSString stringWithFormat:@"Group set:%@ is invalid, please check the configuration file (%@).", grpNameSetInConfig, defaultAvliableGrpNameSet]];
            //            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [MyEexception RemindException:@"Set Config Wrong" Information:[NSString stringWithFormat:@"Group set:%@ is invalid, please check the configuration file (%@).", grpNameSetInConfig, defaultAvliableGrpNameSet]];
                exit (EXIT_FAILURE);
            });
            
        }

        // get all the item name with arry
        NSMutableDictionary *userItemDic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *userTypeDic = [[NSMutableDictionary alloc]init];
        for (NSString *grpName in grpNameSetInConfig) {
            NSMutableArray *itmForGrpArr = [[NSMutableArray alloc] init];
            [userItemDic setObject:itmForGrpArr forKey:grpName];
            NSMutableArray *typForGrpArr = [[NSMutableArray alloc] init];
            [userTypeDic setObject:typForGrpArr forKey:grpName];
            for (int i = 0 ; i< [itemArrInConfig count] ; i++) {
                if ([itemArrInConfig[i][0] isEqualToString:grpName]) {
                    if ([itemArrInConfig[i] count] >= 2)
                    {
                        [[userItemDic valueForKey:grpName] addObject:itemArrInConfig[i][1]];
                    }

                    if ([itemArrInConfig[i] count] >= 3)
                    {
                        [[userTypeDic valueForKey:grpName] addObject:itemArrInConfig[i][2]];
                    }
                }
            }
        }

        /*
         在上一版3.0_0806基础上，把ccpintest和vbustest命令测试项整合到debug key1命令测试中（并保留ccpintest和vbustest命令），版本号为3.0_1022，s19文件及强度测试结果（总共测试约5300次，未发现异常）。
         即每个TYPE-C口多出5个测试项（已用红框标识）。以下为其增加的阈值及开关读写命令：
         1、a04，VBUS脚相关参数配置命令(其频率，pga，buff配置命令未更改)：
         1）、开关设置命令:setgrp dds2 [on/off]，例如：
         PC:setgrp dds2 off
         ACK:{"dds2": "off"}
         2）、写阈值命令：setlim vbuspin dds2 [open_limit] [short_limit] a04，例如：
         PC:setlim vbuspin dds2 -1 400 a04
         ACK:{"vbuspin": {"dds2": {"open limit": -1, "short limit": 400, "a04"}}}
         3）、读阈值命令：getcfg lim dds2，例如：
         PC:getcfg lim dds2
         ACK:{"dds2": {"a04": {"open": -1, "short": 400}}}
         4）、result判定方法：
         value >= short_limit : Pass
         value < short_limit : Short


         2、a05,b05,CC脚相关参数配置命令：
         1）、开关设置命令:setgrp [voh/vol] [on/off]，例如：
         PC:setgrp voh on
         ACK:{"voh": "on"}
         2）、写阈值命令：setlim ccpin [voh/vol] [open_limit] [short_limit] a05,b05，例如：
         PC:setlim ccpin voh 2500 -1 a05,b05
         ACK:{"ccpin": {"voh": {"open limit": 2500, "short limit": -1, "a05,b05"}}}
         PC:setlim ccpin vol -1 100 a05,b05
         ACK:{"ccpin": {"vol": {"open limit": -1, "short limit": 100, "a05,b05"}}}
         3）、读阈值命令：getcfg lim [voh/vol]，例如：
         PC:getcfg lim voh
         ACK:{"voh": {"a05": {"open": 2500, "short": -1}, "b05": {"open": 2500, "short": -1}}}
         PC:getcfg lim vol
         ACK:{"vol": {"a05": {"open": -1, "short": 100}, "b05": {"open": -1, "short": 100}}}
         4）、voh,result判定方法：
         value >= open_limit : Pass
         value < open_limit : Open
         5）、vol,result判定方法：
         value <= short_limit : Pass
         value > short_limit : Short


         3、getcfg读取配置项开关状态命令的返回值也做相应修改（增加voh,vol,dds2的状态），如下：
         PC:getcfg grp
         ACK:{"adj": "on", "gnd": "on", "vbus": "off", "dds": "on", "voh": "on", "vol": "on", "dds2": "on"}
        */

        NSMutableSet * extTypes = [[NSMutableSet alloc] init];

        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ userGrpItemDic = %@",[LogFile CurrentTimeForLog],userItemDic]];
        for (NSString *grpName in grpNameSetInConfig) {
            NSString *setGrpCmd=[NSString stringWithFormat:@"setgrp %@ on", grpName];
            [generatedCmd addObject:setGrpCmd];

            if ([grpName caseInsensitiveCompare:@"GND"] == NSOrderedSame)
            {
                // get typ arr.
                NSMutableArray *typArr = [userTypeDic valueForKey:grpName];
                if ([typArr count] > 0)
                {
                    for (NSString * typ in typArr)
                    {
                        bool found = false;
                        for (NSString * extItem in self->extNames)
                        {
                            found = [extItem caseInsensitiveCompare:typ] == NSOrderedSame;
                            if (found)
                            {
                                break;
                            }
                        }

                        if (found){
                            [extTypes addObject:typ];
                        }
                    }
                }
            }

            // set skip item.
            NSMutableArray *currentItmArr = [userItemDic valueForKey:grpName];

            // no longer special handle for gnd and vbus
            if ([currentItmArr count]>0) {
                NSMutableSet *usrItmSet = [NSMutableSet setWithArray:currentItmArr];

                NSMutableSet *skippingImSet = [grpItemSetDic valueForKey:grpName];
                bool ret = [usrItmSet isSubsetOfSet:skippingImSet];

                if (!ret) {//!ret
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [self ForceTerminate:[NSString stringWithFormat:@"Incorrect item set:%@, please check the configuration file",usrItmSet]];
//                    });
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MyEexception RemindException:@"Set Config Wrong" Information:[NSString stringWithFormat:@"Group set:%@ is invalid, please check the configuration file (%@).", grpNameSetInConfig, defaultAvliableGrpNameSet]];
                        exit (EXIT_FAILURE);
                    });
                    
                }

                // get the item need to skip.
                [skippingImSet minusSet:usrItmSet];
                if ([skippingImSet count] > 0) {
                    NSString *skipItm = @"";
                    for (NSString *leftItm in skippingImSet) {
                        skipItm = [skipItm stringByAppendingString:[NSString stringWithFormat:@"%@,", leftItm]];
                    }

                    skipItm = [skipItm substringToIndex:[skipItm length]-1];
                    
            
                    NSMutableArray *arr = [self separateditems:skipItm];
                    if (arr.count) {
                        for (NSString *string in arr) {
                            NSString *command = [NSString stringWithFormat:@"setitm %@ skip %@",grpName,string];
                            
                            NSLog(@"setGndSkipItmCmd--%@", command);
                            [generatedCmd addObject:command];
                        }
                    }

//                    NSString *setGndSkipItmCmd= [NSString stringWithFormat:@"setitm %@ skip %@", grpName, skipItm];
//
//
//                    NSLog(@"setGndSkipItmCmd = %@",setGndSkipItmCmd);
//                    [generatedCmd addObject:setGndSkipItmCmd];
                }
                else{
                    NSLog(@"No item need to set skip for group %@",grpName);
                }
            }
        }

        if ([extTypes count] > 0)
        {
            for (NSString *extName in extTypes) {
                NSDictionary * flags = [self->extFlags objectForKey:extName];
                NSString * grpSwitch = extName;
                if (flags != nil && [flags count] > 0)
                {
                    for (NSString * flagName in [flags allKeys])
                    {
                        if ([flagName caseInsensitiveCompare:@"GRPSWITCH"] == NSOrderedSame)
                        {
                            grpSwitch = [flags objectForKey:flagName];
                        }
                    }
                }

                // Add the grp switch to disable further disabling this grp with "setgrp * off" anyway;
                [grpNameSetInConfig addObject:grpSwitch];
                NSString * grpSwitchOn = [NSString stringWithFormat:@"setgrp %@ on", grpSwitch];
                [generatedCmd addObject:grpSwitchOn];
            }

            for (NSString *extName in extTypes) {
                // The original group is needed to add to the array then to be disabled as well.
                NSDictionary * paras = [self->extItems objectForKey:extName];
                if (paras != nil && [paras count] > 0)
                {
                    for (NSString * paraKey in [paras allKeys])
                    {
                        id paraValue = [paras objectForKey:paraKey];
                        if (paraValue != nil)
                        {
                            NSString * cmd = [NSString stringWithFormat:@"%@ set %@ %d", extName, paraKey, [paraValue intValue]];
                            [generatedCmd addObject:cmd];
                        }
                    }
                }
            }
        }

        // get the group need to set off.
        [defaultAvliableGrpNameSet minusSet:grpNameSetInConfig];
        for (NSString *grpName in defaultAvliableGrpNameSet) {
            NSString *setGrpCmd=[NSString stringWithFormat:@"setgrp %@ off",grpName];
            [generatedCmd addObject:setGrpCmd];
        }

        NSLog(@"total row = %lu",(unsigned long)[csvArr count]);
        [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ total row = %lu",[LogFile CurrentTimeForLog],(unsigned long)[csvArr count]]];

        //        NSString *vbusCmd=@"dds2 set shortlim 500";
        //        [generatedCmd addObject:vbusCmd];

        // generate setitem command
        itemArrInConfig = [NSMutableArray arrayWithArray:csvArr];
        while ([itemArrInConfig count]>0) {
            // get set item command
            NSString *tmpGroupName =itemArrInConfig[0][0];
            NSString *tmpTypeName = nil;
            if ([itemArrInConfig[0] count] >= 3)
            {
                tmpTypeName = itemArrInConfig[0][2];
            }

            NSMutableArray *sortMutArr = [[NSMutableArray alloc]init];
            for (int i=0; i<[itemArrInConfig count]; i++) {
                if ([itemArrInConfig[i][0] isEqualToString:tmpGroupName]
                    && (([itemArrInConfig[i] count] < 3
                         && tmpTypeName == nil)
                        || ([itemArrInConfig[i] count] >= 3
                            && tmpTypeName != nil
                            && [itemArrInConfig[i][2] isEqualToString:tmpTypeName] ))) {
                            [sortMutArr addObject:itemArrInConfig[i]];
                        }
            }

            if ([sortMutArr count] <= 0)
            {
                tmpGroupName = nil;
                tmpTypeName = nil;
                [itemArrInConfig removeObjectAtIndex:0];
                continue;
            }

            NSString * settingItems = @"";
            for (int j=0; j< [sortMutArr count]; j++) {
                // remove the obj allready generate command
                [itemArrInConfig removeObject:sortMutArr[j]];
                if ([sortMutArr[j] count] >= 2)
                {
                    if (j == [sortMutArr count] - 1) {
                        settingItems = [settingItems stringByAppendingString:[NSString stringWithFormat:@"%@", sortMutArr[j][1]]];
                    }
                    else{
                        settingItems = [settingItems stringByAppendingString:[NSString stringWithFormat:@"%@,", sortMutArr[j][1]]];
                    }
                }
            }

            if ([settingItems length] <= 0)
            {
                tmpGroupName = nil;
                tmpTypeName = nil;
                continue;
            }

            // NSMutableSet *skippingSetItems=[NSMutableSet setWithArray:[self SkipSetItem]];

            // if ([[tmpTypeName uppercaseString] isEqualToString:@"DDS"]
            //             || [[tmpTypeName uppercaseString] isEqualToString:@"DDS2"]
            //             || [[tmpTypeName uppercaseString] isEqualToString:@"VOH"]
            //             || [[tmpTypeName uppercaseString] isEqualToString:@"VOL"]
            //             || [[tmpTypeName uppercaseString] isEqualToString:@"TR"]) {

            if ([tmpTypeName containsString:@"dds2"]) {
                NSLog(@"11");
            }
            bool skipSetItem = [[self SkipSetItem] containsObject:[tmpTypeName uppercaseString]];
            NSMutableDictionary * flags = [self->extFlags objectForKey:tmpTypeName];
            if (flags != nil)
            {
                id flag = [flags objectForKey:@"SKIPITEM"];
                if (flag != nil)
                {
                    skipSetItem = [flag boolValue];
                }
            }

            if (skipSetItem){
                NSString *skipForDDS = [NSString stringWithFormat:@"Don't support setitm %@ %@ %@ any more!", tmpGroupName, tmpTypeName, settingItems];
                NSLog(@"%@", skipForDDS);
                [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ generatedCmd = %@", [LogFile CurrentTimeForLog], skipForDDS]];
            }else{
                if (flags != nil)
                {
                    id flag = [flags objectForKey:@"GRP"];
                    if (flag != nil)
                    {
                        tmpGroupName = flag;
                    }

                    flag = [flags objectForKey:@"TYP"];
                    if (flag != nil)
                    {
                        tmpTypeName = flag;
                    }
                }


                NSMutableArray *arr = [self separateditems:settingItems];
                if (arr.count) {
                    for (NSString *string in arr) {
                        NSString *command = [NSString stringWithFormat:@"setitm %@ %@ %@", tmpGroupName, tmpTypeName, string];

                        NSLog(@"command--%@", command);
                        [generatedCmd addObject:command];
                    }
                }
                
            }

            // set empty for next loop
            tmpGroupName = @"";
            tmpTypeName = @"";
        }

        // generate setlimit command
        itemArrInConfig = [NSMutableArray arrayWithArray:csvArr];
        while ([itemArrInConfig count]>0) {
            if ([itemArrInConfig[0] count] < 5)
            {
                NSLog(@"Ignore item with less than 5 subitems(%lu) for limits", (unsigned long)[itemArrInConfig[0] count]);
                [itemArrInConfig removeObjectAtIndex:0];
                continue;
            }

            // get set limit command
            NSString *openLimit = itemArrInConfig[0][3];
            NSString *shorLimit = itemArrInConfig[0][4];
            NSString *tmpTypeName = itemArrInConfig[0][2];
            NSString *grpName = itemArrInConfig[0][0];
            if ([tmpTypeName containsString:@"dds2"]) {
                NSLog(@"11");
            }
            NSMutableDictionary * flags = [self->extFlags objectForKey:tmpTypeName];

            // sort by group name
            NSString *grp = itemArrInConfig[0][0];
            NSMutableArray *sortMutArr = [[NSMutableArray alloc]init];
            for (int i=0; i<[itemArrInConfig count]; i++) {
                if ([itemArrInConfig[i][2] isEqualToString:tmpTypeName] && [itemArrInConfig[i][0] isEqualToString:grp] && [itemArrInConfig[i][3] isEqualToString:openLimit] && [itemArrInConfig[i][4] isEqualToString:shorLimit]) {
                    [sortMutArr addObject:itemArrInConfig[i]];
                }
            }

            NSString *settingItems=@"";

            // NSMutableArray *sortMutArr = [[NSMutableArray alloc]init];
            for (int j=0; j < [sortMutArr count]; j++) {
                // remove the obj allready generate command
                [itemArrInConfig removeObject:sortMutArr[j]];
                if (j == [sortMutArr count]-1) {
                    settingItems = [settingItems stringByAppendingString:[NSString stringWithFormat:@"%@",sortMutArr[j][1]]];
                }else{
                    settingItems = [settingItems stringByAppendingString:[NSString stringWithFormat:@"%@,",sortMutArr[j][1]]];
                }
            }

            if (flags != nil)
            {
                id flag = [flags objectForKey:@"GRP"];
                if (flag != nil)
                {
                    grpName = flag;
                }

                flag = [flags objectForKey:@"TYP"];
                if (flag != nil)
                {
                    tmpTypeName = flag;
                }
            }

            // DDS2 does not share upper/lower limits with TR, but DDS does, so both DDS and TR call "setlim TR TR %@ %@ %@"
            // || [[tmpTypeName uppercaseString] isEqualToString:@"DDS2"]
            //            if ([[tmpTypeName uppercaseString] isEqualToString:@"DDS"]
            //                || [[tmpTypeName uppercaseString] isEqualToString:@"TR"]) {
            //                grpName = @"TR";
            //                tmpTypeName = @"TR";
            //            }

            
            NSMutableArray *arr = [self separateditems:settingItems];
            if (arr.count) {
                for (NSString *string in arr) {
                    NSString *command = [NSString stringWithFormat:@"setlim %@ %@ %@ %@ %@", grpName, tmpTypeName, openLimit, shorLimit, string];
                    
                    NSLog(@"command--%@", command);
                    [generatedCmd addObject:command];
                }
            }
            
//            NSString *command = [NSString stringWithFormat:@"setlim %@ %@ %@ %@ %@", grpName, tmpTypeName, openLimit, shorLimit, settingItems];
//            NSLog(@"%@", command);
//            [generatedCmd addObject:command];

            // set empty for next loop
            openLimit = @"";
            shorLimit = @"";
        }
    }

    NSLog(@"generatedCmd = %@",generatedCmd);
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ generatedCmd = %@",[LogFile CurrentTimeForLog],generatedCmd]];

    return generatedCmd;
}


-(NSMutableArray *)separateditems:(NSString *)items{
    NSArray *arr= [items componentsSeparatedByString:@","];
    NSMutableArray *mutArray=[NSMutableArray array];
    if (arr.count>20) {
        
        int cmds_count = arr.count/20.0 +0.9;
        for (int i =0; i<cmds_count; i++) {
            NSMutableString *mutString = [NSMutableString string];
            int sub_cmds_count =20*(i+1);
            if (i == cmds_count-1) {
                sub_cmds_count = (int)arr.count;
            }
            for (int j =20*i ; j<sub_cmds_count; j++) {
                
                [mutString appendString:arr[j]];
                if (j!=sub_cmds_count-1) {
                    [mutString appendString:@","];
                }
                
            }
            if (mutString.length) {
                [mutArray addObject:mutString];
            }
            
        }
        
//        NSMutableString *mutString1 = [NSMutableString string];
//        NSMutableString *mutString2 = [NSMutableString string];
//        for (int j =0 ; j<20; j++) {
//            [mutString1 appendString:arr[j]];
//            if (j!=19) {
//                [mutString1 appendString:@","];
//            }
//
//        }
//        for (int j =20 ; j<arr.count; j++) {
//            [mutString2 appendString:arr[j]];
//            if (j!=arr.count-1) {
//                [mutString2 appendString:@","];
//            }
//
//        }
//        [mutArray addObject:mutString1];
//        [mutArray addObject:mutString2];
        
    }else{
        [mutArray addObject:items];
    }
    return mutArray;
}

-(NSString *) StationSoftwareName
{
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    return name;
}

-(NSString *)StationSoftwareVersion
{
    if (!currentFWName.length) {
        NSString *fwPath=[self getDefaultFWPath];
        
        NSString *fwName = [fwPath.lastPathComponent cw_getStringBetween:@"DE_3_5_" and:@".s19"];
        currentFWName=fwName;
    }
    
    //
    //    return fwName;
    return currentFWName;
    
    //
    //    if (!_updateFWPath.length) {
    //        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    //        fwPath_Version =[self findFW:resourcePath];
    //    }else{
    //
    //        [fwPath_Version addObject:_updateFWPath];
    //        [fwPath_Version addObject:[_updateFWPath getStringBetween:@"DE_3_5_" and:@".s19"]];
    //    }
    //
    //    return fwPath_Version[1];
}

-(NSString *) StationSoftwareBuildTime
{
    NSDate * buildTime       = (NSDate *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CustomBundleTime"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    // 2014年10月15日 16:35:42
    // stringFromDate 将日期类型格式化，转为NSString 类型
    return [formatter stringFromDate:buildTime];
}

-(NSString *) getAPPVersion
{
    //set window title here
    
    // The title now comes from plist file configurablely.
    
    NSString *version_bundle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString *winTitle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Win Title Name"];
    if ([winTitle length] <= 0)
    {
        winTitle = @"iPort 3 V%@";
    }
    
    NSString *string =[NSString stringWithFormat:winTitle, version_bundle];
    
    
    return string;
    
}

- (void)controlTextDidBeginEditing:(NSNotification *)obj{
    //     NSLog(@"controlTextDidBeginEditing=%@",[[obj userInfo] valueForKey:NSControlTextDidBeginEditingNotification]);
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{//sc
    
    NSTextField *textF = obj.object;
//    NSInteger snLen = textF.stringValue.length;
    NSString *snLenStr = [NSString stringWithFormat:@"%ld",textF.stringValue.length];
    NSArray *snArr = [self getSnLength];
    if ([snArr containsObject:snLenStr]) {
        
        bool check =[self ScanSNValidation];
        if (check) {
            NSLog(@"Kick off a test after test field end editing.");
            [self DoStartTest];
            
        }else{
            [leftEnableBtn setEnabled:YES];
            [rightEnableBtn setEnabled:YES];
        }
    }
}




- (void)controlTextDidChange:(NSNotification *)obj{
    [txtEditorTimer invalidate];
    txtEditorTimer = nil;
    NSTextField *textF = [obj object];
    bool left = textF == leftScanView;
    NSLog(@"left ? %@", left ? @"Left" : @"Right");

    NSInteger snLen = textF.stringValue.length;
    
    if (snLen>=12) {
        [self startDetectSN:[[obj object] stringValue] isLeft:left];
    }
}



- (void)startDetectSN:(NSString *)str
               isLeft:(bool)isLeft{
    SNDetectingTimerParameters * para = [[SNDetectingTimerParameters alloc] init];
    para->isLeft = isLeft;
    para->str = str;
    struct timeval startTime;
    gettimeofday(&startTime, NULL);
    para->startTime = startTime;

    float interval = [self autoFocusInterval];
    interval = interval < 1 ? 1 : interval;

    txtEditorTimer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(CheckSNCorrect) userInfo:para repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:txtEditorTimer forMode:NSDefaultRunLoopMode];
}

- (void)CheckSNCorrect{
    
    id userInfo = [txtEditorTimer userInfo];
    if (userInfo == nil)
    {
        // Normally, this code would never been called, cause the userInfo would never be null.
        [txtEditorTimer invalidate];
        txtEditorTimer = nil;
        NSLog(@"User info: NULL.");
        return;
    }

    // Get the thread parameters.
    SNDetectingTimerParameters* para = (SNDetectingTimerParameters*)userInfo;
    if (para == nil)
    {
        // Normally, this code would never been called, cause the userInfo would never be null.
        [txtEditorTimer invalidate];
        txtEditorTimer = nil;
        NSLog(@"User info: not a SNDetectingTimerParameters.");
        return;
    }

    struct timeval now;
    gettimeofday(&now, NULL);
    float totalDetectTime = ((float)subtractTimeVal(&now, &para->startTime)) / USEC_PER_SEC;

    float interval = [self autoStartTestInterval];
    interval = interval < 0 ? 0 : interval;
    bool final = totalDetectTime > interval;

    // No operation within 3 secs, any keyboard operation would kill the timer.
    if (final) {
        [txtEditorTimer invalidate];
        txtEditorTimer = nil;
    }

    NSLog(@"String: %@, %@, %f.", para->str, para->isLeft ? @"left" : @"right", totalDetectTime);

    // Check the current text.
    NSString * str = [self CheckSNLength:para->str];
    if (str == nil)
    {
        // The current editor does not have a correct sn.
        // Then, nothing would be done.
        NSLog(@"Incorrect current sn.");
        return;
    }

    if (![self testing2] || ![self testing1])
    {
        // Single test, and whether automatically start test or not.
        if (final)
        {
            // Start test.
            if ([self ScanSNValidation]) {
                NSLog(@"Kick off a test with a correct sn.");
                [self DoStartTest];
            }else{
                [leftEnableBtn setEnabled:YES];
                [rightEnableBtn setEnabled:YES];
            }

            return;
        }

        NSLog(@"Single test.");
        return;
    }

    // Get the other text field.
    NSTextField * txtFieldOther = nil;
    if (para->isLeft)
    {
        txtFieldOther = rightScaniew;
    }
    else
    {
        txtFieldOther = leftScanView;
    }

    // The other text field is null, this code would never be called.
    if (txtFieldOther == nil)
    {
        return;
    }

    // The other SN.
    NSString* checkSN = [[txtFieldOther stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    checkSN = [self CheckSNLength:checkSN];
    if (checkSN == nil)
    {
        // Other sn is incorrect.
        NSTextView * view = (NSTextView *)[_MainWindow firstResponder];
        if (view == nil)
        {
            // The current first responder is null;
            [txtFieldOther becomeFirstResponder];
            return;
        }

        NSTextField * field = (NSTextField *)[view delegate];
        if (field == nil)
        {
            // The delegate of current first responder is null;
            [txtFieldOther becomeFirstResponder];
            return;
        }

        if (field == txtFieldOther)
        {
            // Do nothing cause the focusing editor is already the correct one.
            return;
        }

        // focus the other editor.
        [txtFieldOther becomeFirstResponder];
    }
    else if (final)
    {
        // Both two sns are correct, and 3 secs no operation, start test then.
        if ([self ScanSNValidation]) {
            NSLog(@"Kick off a test with two correct sns.");
            [self DoStartTest];
        }else{
            [leftEnableBtn setEnabled:YES];
            [rightEnableBtn setEnabled:YES];
        }
    }
}



- (void)loopTest{
    NSLog(@"loopTimes = %ld", (long)loopTimes);
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@ loopTimes = %ld",[LogFile CurrentTimeForLog],(long)loopTimes]];
    

    if (loopTimes > 0 && testStatus == FINISH) {
       
        self.loopWC.currentLoop = loopTimes;
        NSLog(@"Kick off a test from a looping test.");
        [self DoStartTest];
        loopTimes--;
        [NSThread sleepForTimeInterval:2.0];
        

        
    }
}

-(void)  writeLocalCSV{
    if (!self->singleDUT && !self -> testingLeft && !self -> testingRight)
    {
        return;
    }
    [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"%@-write data to Local CSV\n",[LogFile CurrentTimeForLog]]];

    if (self->singleDUT) {
        [self writeLocalCSV:true];
    }else{
        if (testingLeft) {
            [self writeLocalCSV:true];
        }
        if (testingRight) {
            [self writeLocalCSV:false];
        }
    }
}




-(void) writeLocalCSV:(bool)left{
    if (!self->singleDUT && ((left && !self -> testingLeft) || (!left && !self -> testingRight)))
    {
        return;
    }
    
    //check if the csv file is empty

    NSString *localCSVPath = [NSString stringWithFormat:@"%@/%@_%d.csv",ALLCSVFILE,[LogFile CurrentDateForLocalCSV],deviceCount];
    //    NSString *localCSVContent = [NSString stringWithContentsOfFile:localCSVPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSFileManager *csvfileManager = [NSFileManager defaultManager];
    
    if (![csvfileManager fileExistsAtPath:ALLCSVFILE]) {
        [csvfileManager createDirectoryAtPath:ALLCSVFILE withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![csvfileManager fileExistsAtPath:localCSVPath]) {//![csvfileManager fileExistsAtPath:localCSVPath]
        
        [csvfileManager createFileAtPath:localCSVPath contents:nil attributes:nil];
//        NSString *stationInfo = [NSString stringWithFormat:@"%@,config:%@,APP:%@,,,,,,,,", stationName,[self getDefaultConfigPath].lastPathComponent,[self getAPPVersion]];
        NSString *stationInfo = [NSString stringWithFormat:@"%@,APP:%@,,,,,,,,,", stationName,[self getAPPVersion]];
        NSString *testInfo = @"";
        testInfo = [NSMutableString stringWithFormat:@"Product,SerialNumber,Special Build Name,Special Build Description,Unit Number,Station ID,Test Pass/Fail Status,Start Time,End Time,List Of Failing Tests,FW Version"];
        
        NSString *displayName   = [NSMutableString stringWithFormat:@"Display Name---------->,,,,,,,,,,"];
        NSString *type = [NSMutableString stringWithFormat:@"Type--------->,,,,,,,,,,"];
        NSString *openLimit     = [NSMutableString stringWithFormat:@"Upper Limit------------>,,,,,,,,,,"];
        NSString *shortLimit    = [NSMutableString stringWithFormat:@"Lower Limit----------->,,,,,,,,,,"];
        NSString *unit          = [NSMutableString stringWithFormat:@"Measure Unit---------->,,,,,,,,,,"];
        for (int i = 0; i < testItems.count; i++) {
            TestResultItem * item = testItems[i];
            stationInfo = [stationInfo stringByAppendingString:[NSString stringWithFormat:@",%d", item->Index+1]];
            testInfo = [testInfo stringByAppendingString:[NSString stringWithFormat:@",%@_%@",item->OriginPos,item->PinNumber]];
            displayName = [displayName stringByAppendingString:[NSString stringWithFormat:@",%@", displaName]];
            //            PDCA_Priority = [PDCA_Priority stringByAppendingString:[NSString stringWithFormat:@",%d",!_auditMode]];
            type =[type stringByAppendingString:[NSString stringWithFormat:@",%@", item->Type]];
            openLimit = [openLimit stringByAppendingString:[NSString stringWithFormat:@",%@", item->OpenLimit]];
            shortLimit = [shortLimit stringByAppendingString:[NSString stringWithFormat:@",%@", item->ShortLimit]];
            unit = [unit stringByAppendingString:[NSString stringWithFormat:@",%@",item->Unit]];
        }
        
        NSString *localCSVTitle = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n",stationInfo,testInfo,displayName,type,openLimit,shortLimit,unit];
        
        [CWFileManager cw_writeToFile:localCSVPath content:localCSVTitle];
        
    }
    
    NSString *localCSVData = [NSString stringWithFormat:@"%@,%@,%@,\"\",\"\",%@", product, left ? snOnLeft : snOnRight, buildStage, stationID];
    //add test result
    NSString *failures = @"";
    
    bool isPass = true;
    if (self->singleDUT) {
        for (int i = 0; i < [failedItems count]; i++) {
            TestResultItem * item = failedItems[i];
            
            if (i==0)
            {
                failures =  [NSString stringWithFormat:@"%@_%@",item->OriginPos,item->PinNumber];
            }
            else
            {
                failures = [failures stringByAppendingString:[NSString stringWithFormat:@";%@_%@",item->OriginPos,item -> PinNumber]];
            }
            
            isPass = false;
            
        }
    }else{
        NSMutableArray *mutFailItems = left ? [NSMutableArray arrayWithArray:failedLeftItems] : [NSMutableArray arrayWithArray:failedRightItems];
        
        for (int i=0; i<mutFailItems.count; i++) {
            TestResultItem * item = mutFailItems[i];
            if (i==0)
            {
                failures =  [NSString stringWithFormat:@"%@_%@",item->OriginPos,item->PinNumber];
            }
            else
            {
                failures = [failures stringByAppendingString:[NSString stringWithFormat:@";%@_%@",item->OriginPos,item -> PinNumber]];
            }
            
            isPass = false;
        }
    }
    
    
    if (!isPass)
    {
        localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",FAIL"]];
    }
    else
    {
        localCSVData = [localCSVData stringByAppendingString:@",PASS"];
    }
    
    //add test time
    //        localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@,%@,%1.1f",StartTestTime,EndTestTime,testTime]];
    localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@,%@", StartTestTime, EndTestTime]];
    
    //add List Of Failing Tests
    if (!isPass){
        localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@",failures]];
    }
    else{
        localCSVData = [localCSVData stringByAppendingString:@","];
    }
    
    //add version
    localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@", [self StationSoftwareVersion]]];
    if (self->singleDUT) {
        for (int i = 0; i < [testItems count]; i++) {
            TestResultItem * item = testItems[i];
            localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@", item->Value]];
        }
    }else{
        if (left) {
            for (int i = 0; i < [testLeftItems count]; i++) {
                TestResultItem * item = testLeftItems[i];
                localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@", item->Value]];
            }
        }else{
            for (int k=0; k < testRightItems.count; k++) {
                localCSVData = [localCSVData stringByAppendingString:@","];
            }
            for (int i = 0; i < [testRightItems count]; i++) {
                TestResultItem * item = testRightItems[i];
                localCSVData = [localCSVData stringByAppendingString:[NSString stringWithFormat:@",%@", item->Value]];
            }
        }
    }
    
    
    [CWFileManager cw_writeToFile:localCSVPath content:[NSString stringWithFormat:@"%@\n",localCSVData]];

    
}

-(void)ForceTerminate:(NSString *)msg{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:msg];
    [alert addButtonWithTitle:@"退出 Exit"];
    
    NSInteger result = [alert runModal];
    
    if(result == NSAlertFirstButtonReturn)
    {
        int pid = getpid();
        NSString *strPid = [NSString stringWithFormat:@"kill %d",pid];
        system([strPid UTF8String]);
    }
}




-(void)updateMapView:(NSString*)itmName
                 pos:(NSString*)pos
               group:(NSString*)group
            showName:(NSString*)mapName
          testResult:(NSString*)result
             forLeft: (bool)forLeft
{
    if (forLeft) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftBox setBorderColor:[NSColor blackColor]];
            [_lblfpos setTextColor:[NSColor blackColor]];
        });
        if ([[group uppercaseString] isEqualToString:@"GND"]) {
            NSDictionary *gndLItm_btDic=@{
                                         @"a02-a01":_btLefta2,
                                         @"a03-a01":_btLefta3,
                                         @"a04-a01":_btLefta4,
                                         @"a05-a01":_btLefta5,
                                         @"a06-a01":_btLefta6,
                                         @"a07-a01":_btLefta7,
                                         @"a08-a01":_btLefta8,
                                         @"a09-a01":_btLefta9,
                                         @"a10-a01":_btLefta10,
                                         @"a11-a01":_btLefta11,
                                         
                                         @"b02-a01":_btLeftb2,
                                         @"b03-a01":_btLeftb3,
                                         @"b04-a01":_btLeftb4,
                                         @"b05-a01":_btLeftb5,
                                         @"b06-a01":_btLeftb6,
                                         @"b07-a01":_btLeftb7,
                                         @"b08-a01":_btLeftb8,
                                         @"b09-a01":_btLeftb9,
                                         @"b10-a01":_btLeftb10,
                                         @"b11-a01":_btLeftb11,
                                         };
            dispatch_async(dispatch_get_main_queue(), ^{
                [[gndLItm_btDic valueForKey:itmName] setTitle:mapName];
            });
            if ([[result uppercaseString] isEqualToString:@"PASS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[gndLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Normal.png"]];
                });
            }
            else if ([[result uppercaseString] isEqualToString:@"SHORT"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[gndLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"shorWithGnd.png"]];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[gndLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Open.png"]];
                });
            }

        }
        if ([[group uppercaseString] isEqualToString:@"VBUS"]) {
            NSDictionary *vbusLItm_btDic=@{
                                          @"a01-a04":_btLefta1,
                                          @"a02-a04":_btLefta2,
                                          @"a03-a04":_btLefta3,
                                          @"a05-a04":_btLefta5,
                                          @"a06-a04":_btLefta6,
                                          @"a07-a04":_btLefta7,
                                          @"a08-a04":_btLefta8,
                                          @"a10-a04":_btLefta10,
                                          @"a11-a04":_btLefta11,
                                          @"a12-a04":_btLefta12,
                                          
                                          @"b01-a04":_btLeftb1,
                                          @"b02-a04":_btLeftb2,
                                          @"b03-a04":_btLeftb3,
                                          @"b05-a04":_btLeftb5,
                                          @"b06-a04":_btLeftb6,
                                          @"b07-a04":_btLeftb7,
                                          @"b08-a04":_btLeftb8,
                                          @"b10-a04":_btLeftb10,
                                          @"b11-a04":_btLeftb11,
                                          @"b12-a04":_btLeftb12,
                                          };

            [[vbusLItm_btDic valueForKey:itmName] setTitle:mapName];
            
            if ([[result uppercaseString] isEqualToString:@"PASS"]) {
                [[vbusLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Normal.png"]];
            }
            else if ([[result uppercaseString] isEqualToString:@"SHORT"]){
                [[vbusLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"shortWithVbus.png"]];
            }
            else{
                [[vbusLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Open.png"]];
            }
        }
        if ([[group uppercaseString] isEqualToString:@"ADJ"]) {
            NSDictionary *adjLItm_btDic=@{
                                           @"a01-a02":_btLefta1,
                                           @"a02-a03":_btLefta2,
                                           @"a03-a04":_btLefta3,
                                           @"a04-a05":_btLefta4,
                                           @"a05-a06":_btLefta5,
                                           @"a06-a07":_btLefta6,
                                           @"a07-a08":_btLefta7,
                                           @"a08-a09":_btLefta8,
                                           @"a09-a10":_btLefta9,
                                           @"a10-a11":_btLefta10,
                                           @"a11-a12":_btLefta11,
                                           
                                           @"b01-b02":_btLeftb1,
                                           @"b02-b03":_btLeftb2,
                                           @"b03-b04":_btLeftb3,
                                           @"b04-b05":_btLeftb4,
                                           @"b05-b06":_btLeftb5,
                                           @"b06-b07":_btLeftb6,
                                           @"b07-b08":_btLeftb7,
                                           @"b08-b09":_btLeftb8,
                                           @"b09-b10":_btLeftb9,
                                           @"b10-b11":_btLeftb10,
                                           @"b11-b12":_btLeftb11,
                                           };
            NSDictionary *adjLItm_lbDic=@{
                                          @"a01-a02":_lbLefta1_2,
                                          @"a02-a03":_lbLefta2_3,
                                          @"a03-a04":_lbLefta3_4,
                                          @"a04-a05":_lbLefta4_5,
                                          @"a05-a06":_lbLefta5_6,
                                          @"a06-a07":_lbLefta6_7,
                                          @"a07-a08":_lbLefta7_8,
                                          @"a08-a09":_lbLefta8_9,
                                          @"a09-a010":_lbLefta9_10,
                                          @"a10-a11":_lbLefta10_11,
                                          @"a11-a12":_lbLefta11_12,
                                          
                                          @"b01-b02":_lbLeftb1_2,
                                          @"b02-b03":_lbLeftb2_3,
                                          @"b03-b04":_lbLeftb3_4,
                                          @"b04-b05":_lbLeftb4_5,
                                          @"b05-b06":_lbLeftb5_6,
                                          @"b06-b07":_lbLeftb6_7,
                                          @"b07-b08":_lbLeftb7_8,
                                          @"b08-b09":_lbLeftb8_9,
                                          @"b09-b10":_lbLeftb9_10,
                                          @"b10-b11":_lbLeftb10_11,
                                          @"b11-b12":_lbLeftb11_12,
                                          };
            dispatch_async(dispatch_get_main_queue(), ^{
                [[adjLItm_btDic valueForKey:itmName] setTitle:itmName];//adj have no net name now
            });
            if ([[result uppercaseString] isEqualToString:@"PASS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[adjLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Normal.png"]];
                });
            }
            else if ([[result uppercaseString] isEqualToString:@"SHORT"]){
                [[adjLItm_lbDic valueForKey:itmName] setDrawsBackground:YES];
                [[adjLItm_lbDic valueForKey:itmName] setBackgroundColor:[NSColor colorWithRed:.93 green:.38 blue:.38 alpha:1.0]];
            }
            else{
                [[adjLItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Open.png"]];
            }
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_rightBox setBorderColor:[NSColor blackColor]];
            [_lbRtpos setTextColor:[NSColor blackColor]];
        });

        if ([[group uppercaseString] isEqualToString:@"GND"]) {
            NSDictionary *gndRItm_btDic=@{
                                         @"a02-a01":_btRighta2,
                                         @"a03-a01":_btRighta3,
                                         @"a04-a01":_btRighta4,
                                         @"a05-a01":_btRighta5,
                                         @"a06-a01":_btRighta6,
                                         @"a07-a01":_btRighta7,
                                         @"a08-a01":_btRighta8,
                                         @"a09-a01":_btRighta9,
                                         @"a10-a01":_btRighta10,
                                         @"a11-a01":_btRighta11,
                                         @"b02-a01":_btRightb2,
                                         @"b03-a01":_btRightb3,
                                         @"b04-a01":_btRightb4,
                                         @"b05-a01":_btRightb5,
                                         @"b06-a01":_btRightb6,
                                         @"b07-a01":_btRightb7,
                                         @"b08-a01":_btRightb8,
                                         @"b09-a01":_btRightb9,
                                         @"b10-a01":_btRightb10,
                                         @"b11-a01":_btRightb11,
                                         };
            dispatch_async(dispatch_get_main_queue(), ^{
                [[gndRItm_btDic valueForKey:itmName] setTitle:mapName];
            });
            if ([[result uppercaseString] isEqualToString:@"PASS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[gndRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Normal.png"]];
                });
            }
            else if ([[result uppercaseString] isEqualToString:@"SHORT"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[gndRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"shorWithGnd.png"]];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[gndRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Open.png"]];
                });
            }
        }

        if ([[group uppercaseString] isEqualToString:@"VBUS"]) {
            NSDictionary *vbusRItm_btDic=@{
                                          @"a01-a04":_btRighta1,
                                          @"a02-a04":_btRighta2,
                                          @"a03-a04":_btRighta3,
                                          @"a05-a04":_btRighta5,
                                          @"a06-a04":_btRighta6,
                                          @"a07-a04":_btRighta7,
                                          @"a08-a04":_btRighta8,
                                          @"a10-a04":_btRighta10,
                                          @"a11-a04":_btRighta11,
                                          @"a12-a04":_btRighta12,
                                          
                                          @"b01-a04":_btRightb1,
                                          @"b02-a04":_btRightb2,
                                          @"b03-a04":_btRightb3,
                                          @"b05-a04":_btRightb5,
                                          @"b06-a04":_btRightb6,
                                          @"b07-a04":_btRightb7,
                                          @"b08-a04":_btRightb8,
                                          @"b10-a04":_btRightb10,
                                          @"b11-a04":_btRightb11,
                                          @"b12-a04":_btRightb12,
                                          };
            //            self.Result = @"short";//for test vbus
            [[vbusRItm_btDic valueForKey:itmName] setTitle:mapName];
            if ([[result uppercaseString] isEqualToString:@"PASS"]) {
                [[vbusRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Normal.png"]];
            }
            else if ([[result uppercaseString] isEqualToString:@"SHORT"]){
                [[vbusRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"shortWithVbus.png"]];
            }
            else{
                [[vbusRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Open.png"]];
            }
        }

        if ([[group uppercaseString] isEqualToString:@"ADJ"]) {
            NSDictionary *adjRItm_btDic=@{
                                          @"a01-a02":_btRighta1,
                                          @"a02-a03":_btRighta2,
                                          @"a03-a04":_btRighta3,
                                          @"a04-a05":_btRighta4,
                                          @"a05-a06":_btRighta5,
                                          @"a06-a07":_btRighta6,
                                          @"a07-a08":_btRighta7,
                                          @"a08-a09":_btRighta8,
                                          @"a09-a10":_btRighta9,
                                          @"a10-a11":_btRighta10,
                                          @"a11-a12":_btRighta11,
                                          
                                          @"b01-b02":_btRightb1,
                                          @"b02-b03":_btRightb2,
                                          @"b03-b04":_btRightb3,
                                          @"b04-b05":_btRightb4,
                                          @"b05-b06":_btRightb5,
                                          @"b06-b07":_btRightb6,
                                          @"b07-b08":_btRightb7,
                                          @"b08-b09":_btRightb8,
                                          @"b09-b10":_btRightb9,
                                          @"b10-b11":_btRightb10,
                                          @"b11-b12":_btRightb11,
                                          };
            NSDictionary *adjRItm_lbDic=@{
                                          @"a01-a02":_lbRighta1_2,
                                          @"a02-a03":_lbRighta2_3,
                                          @"a03-a04":_lbRighta3_4,
                                          @"a04-a05":_lbRighta4_5,
                                          @"a05-a06":_lbRighta5_6,
                                          @"a06-a07":_lbRighta6_7,
                                          @"a07-a08":_lbRighta7_8,
                                          @"a08-a09":_lbRighta8_9,
                                          @"a09-a10":_lbRighta9_10,
                                          @"a10-a11":_lbRighta10_11,
                                          @"a11-a12":_lbRighta11_12,
                                          
                                          @"b01-b02":_lbRightb1_2,
                                          @"b02-b03":_lbRightb2_3,
                                          @"b03-b04":_lbRightb3_4,
                                          @"b04-b05":_lbRightb4_5,
                                          @"b05-b06":_lbRightb5_6,
                                          @"b06-b07":_lbRightb6_7,
                                          @"b07-b08":_lbRightb7_8,
                                          @"b08-b09":_lbRightb8_9,
                                          @"b09-b10":_lbRightb9_10,
                                          @"b10-b11":_lbRightb10_11,
                                          @"b11-b12":_lbRightb11_12,
                                          };
            dispatch_async(dispatch_get_main_queue(), ^{
                [[adjRItm_btDic valueForKey:itmName] setTitle:itmName];//adj have no mapname now.
            });
            if ([[result uppercaseString] isEqualToString:@"PASS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[adjRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Normal.png"]];
                });
            }
            else if ([[result uppercaseString] isEqualToString:@"SHORT"]){
                [[adjRItm_lbDic valueForKey:itmName] setDrawsBackground:YES];
                [[adjRItm_lbDic valueForKey:itmName] setBackgroundColor:[NSColor colorWithRed:.93 green:.38 blue:.38 alpha:1.0]];
            }
            else{
                [[adjRItm_btDic valueForKey:itmName] setImage:[NSImage imageNamed:@"Open.png"]];
            }
        }
    }
}

-(void)updateMapViewAfterAllTestItem{
    // NSMutableSet * grpSet = [NSMutableSet setWithArray:groupNameArr];
    for (TestResultItem * item in testItems) {
        NSString * grpName = item->Group;
        NSLog(@"%@", item->Group);
        // no sure need this.
        if ([grpName isEqualToString:@"GND"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self -> testingLeft){
                    [_btLefta1 setTitle:@"GND"];
                    [_btLefta12 setTitle:@"GND"];
                    [_btLeftb1 setTitle:@"GND"];
                    [_btLeftb12 setTitle:@"GND"];
                    
                    [_btLefta1 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btLefta12 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btLeftb1 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btLeftb12 setImage:[NSImage imageNamed:@"Normal.png"]];
                }

                if (self -> testingLeft){
                    [_btRighta1 setTitle:@"GND"];
                    [_btRighta12 setTitle:@"GND"];
                    [_btRightb1 setTitle:@"GND"];
                    [_btRightb12 setTitle:@"GND"];
                    
                    [_btRighta1 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btRighta12 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btRightb1 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btRightb12 setImage:[NSImage imageNamed:@"Normal.png"]];

                }
            });
        }
        else if ([grpName isEqualToString:@"VBUS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self -> testingLeft){
                    [_btLefta4 setTitle:@"GND"];
                    [_btLefta9 setTitle:@"GND"];
                    [_btLeftb4 setTitle:@"GND"];
                    [_btLeftb9 setTitle:@"GND"];
                    
                    [_btLefta4 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btLefta9 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btLeftb4 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btLeftb9 setImage:[NSImage imageNamed:@"Normal.png"]];
                }

                if (self -> testingLeft){
                    [_btRighta4 setTitle:@"GND"];
                    [_btRighta9 setTitle:@"GND"];
                    [_btRightb4 setTitle:@"GND"];
                    [_btRightb9 setTitle:@"GND"];
                    
                    [_btRighta4 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btRighta9 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btRightb4 setImage:[NSImage imageNamed:@"Normal.png"]];
                    [_btRightb9 setImage:[NSImage imageNamed:@"Normal.png"]];
                }
            });
        }
    }

    NSArray *lBtnArr = [NSArray arrayWithObjects:_btLefta1,_btLefta2,_btLefta3,_btLefta4,_btLefta5,_btLefta6,_btLefta7,_btLefta8,_btLefta9,_btLefta10,_btLefta11,_btLefta12,_btLeftb1,_btLeftb2,_btLeftb3,_btLeftb4,_btLeftb5,_btLeftb6,_btLeftb7,_btLeftb8,_btLeftb9,_btLeftb10,_btLeftb11,_btLeftb12,nil];
    
    NSArray *rBtnArr = [NSArray arrayWithObjects:_btRighta1,_btRighta2,_btRighta3,_btRighta4,_btRighta5,_btRighta6,_btRighta7,_btRighta8,_btRighta9,_btRighta10,_btRighta11,_btRighta12,_btRightb1,_btRightb2,_btRightb3,_btRightb4,_btRightb5,_btRightb6,_btRightb7,_btRightb8,_btRightb9,_btRightb10,_btRightb11,_btRightb12,nil];
    if (self -> testingLeft){
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSButton *lBtn in lBtnArr) {
                if ([[lBtn title] length]==0) {
                    [lBtn setTitle:@"NC"];
                }
            }
        });
    }

    if (self -> testingRight){
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSButton *rBtn in rBtnArr) {
                if ([[rBtn title] length]==0) {
                    [rBtn setTitle:@"NC"];
                }
            }
        });
    }
}

//judge if int
-(bool)isPureInt:(NSString*)str{
    NSScanner *scan =[NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//judge if float
-(bool)isPureFloat:(NSString*)str{
    NSScanner *scan =[NSScanner scannerWithString:str];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

-(NSMutableArray *)findFW:(NSString *)dir{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *de = [fm enumeratorAtPath:dir];
    NSString *f;
    NSString *fqn;
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    BOOL findFW = false;
 
    while ((f = [de nextObject]))
    {

        fqn = [dir stringByAppendingPathComponent:f];
        if ([fqn length]>0 && [f containsString:updateFWName]&&
            (([f hasPrefix:@"Seal_FW"] ||[f hasPrefix:@"iPort_FW"])
             ||[f containsString:@"3.0_"])) {
            findFW = true;
            break;
        }
        else{
            continue;
        }
    }
    if (!findFW) {
        [MyEexception RemindException:@"Invalidate FW" Information:[NSString stringWithFormat:@"Please make sure FW file at path:%@\nPrefix with \"Seal_FW\" or \"iPort_FW\"\nSuffix with \".s19\"",dir]];
        return NULL;
    }
    [mutArr addObject:fqn];
    
    NSRange rang = NSMakeRange(0, 0);
    if([[configDic valueForKey:@"iPortType"] isEqualToString:@"iPortAir"]){
        rang = [f rangeOfString:@"3.0_"];
    }
    else{
        rang = [f rangeOfString:@"FW"];
    }
    NSString *wantVer = [f substringFromIndex:rang.location+rang.length];//0722_0155.s19
    wantVer = [wantVer substringToIndex:4];//0722
    
    if([[configDic valueForKey:@"iPortType"] isEqualToString:@"iPort2"]){
        wantVer = [@"2.1_"  stringByAppendingString:wantVer];
    }
    if([[configDic valueForKey:@"iPortType"] isEqualToString:@"iPortAir"]){
        wantVer = [@"3.0_"  stringByAppendingString:wantVer];
    }
    else{
        wantVer = [@"1.3_"  stringByAppendingString:wantVer];
    }
    [mutArr addObject:wantVer];
    return mutArr;
}


-(NSString*)getDefaultFWPath{
    
//    SettingMode *mode = [SettingMode getConfig];
//
//    if (mode.updateFWPath.length) {
//        return mode.updateFWPath;
//
//    }
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *fwPath=nil;
    NSArray *list = [NSString getFileNameListInDirPath:resourcePath str1:@".s19"];//DE_3_5_
    if (!list.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"check error" Information:[NSString stringWithFormat:@"not found the FW file in path:%@,please add",resourcePath]];
            exit (EXIT_FAILURE);
        });
    }else{
        for (NSString *str in list) {
            if ([str isEqualToString:[configDic valueForKey:@"updateFWName"]]) {
                fwPath = [resourcePath stringByAppendingPathComponent:str];
                break;
            }
        }
    }

    return fwPath;
}

-(NSString*)getDefaultConfigPath{

//    SettingMode *mode = [SettingMode getConfig];
//    if (mode.configPath.length) {
//        return mode.configPath;
//
//    }
//
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *configPath=nil;
    NSArray *list = [NSString getFileNameListInDirPath:resourcePath str1:@".csv"];
    if (!list.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyEexception RemindException:@"check error" Information:[NSString stringWithFormat:@"not found the Config file in path:%@,please add.",resourcePath]];
            exit (EXIT_FAILURE);
        });
    }else{
        for (NSString *str in list) {
            NSString *updateName = [configDic valueForKey:@"updateConfigName"];
            if ([str isEqualToString:updateName]) {
                configPath= [resourcePath stringByAppendingPathComponent:str];
                break;
            }
        }
    }
 
    return configPath;
  
}

- (IBAction)SwitchClick:(id)sender {
    NSButton * senderButton = (NSButton *)sender;
    if (senderButton == nil)
    {
        return;
    }

    if ([senderButton state] == 0) {
        [senderButton setTitle:@"Disable"];
    }
    else{
        [senderButton setTitle:@"Enable"];
        if (senderButton == leftEnableBtn) {
            [leftScanView setEditable:YES];
        }else{
            [rightScaniew setEditable:YES];
        }
        
       
    }

    bool firstButton = senderButton == leftEnableBtn;

    if (firstButton)
    {
        [leftScanView setEnabled:[senderButton state] == 1];
        [leftScanView setBackgroundColor:[senderButton state] == 1 ? NSColor.selectedControlColor : NSColor.controlColor];
        self->testingLeft = leftEnableBtn.state;
    }
    else
    {
        [rightScaniew setEnabled:[senderButton state] == 1];
        [rightScaniew setBackgroundColor:[senderButton state] == 1 ? NSColor.selectedControlColor : NSColor.controlColor];
        self->testingRight = rightEnableBtn.state;
    }

    [_btnStart setEnabled: [leftEnableBtn state] == 1 || [rightEnableBtn state] == 1];
    // NSLog(@"Enable controlling while switching to enabled.");
    //self->testingLeft =
    
}

- (void) initMapView{
    [_lbAdjShort setBordered:NO];
    [_lbAdjShort setDrawsBackground:YES];
    [_lbAdjShort setBackgroundColor:[NSColor colorWithRed:.93 green:.38 blue:.38 alpha:1.0]];
    
    //Box Init
    [_leftBox setBoxType:4];
    [_leftBox setBorderWidth:1.5];
    
    [_rightBox setBoxType:4];
    [_rightBox setBorderWidth:1.5];
    
    [_leftBox setBorderColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
    [_rightBox setBorderColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
    
    //Label init
    [_lblfpos setTextColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
    [_lbRtpos setTextColor:[NSColor colorWithRed:.88 green:.88 blue:.88 alpha:1.0]];
    
    [_lbleftResult setStringValue:@""];
    [_lbRightResult setStringValue:@""];
    
    [_lbLefta1_2 setBordered:NO];
    [_lbLefta1_2 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta2_3 setBordered:NO];
    [_lbLefta2_3 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta3_4 setBordered:NO];
    [_lbLefta3_4 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta4_5 setBordered:NO];
    [_lbLefta4_5 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta5_6 setBordered:NO];
    [_lbLefta5_6 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta6_7 setBordered:NO];
    [_lbLefta6_7 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta7_8 setBordered:NO];
    [_lbLefta7_8 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta8_9 setBordered:NO];
    [_lbLefta8_9 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta9_10 setBordered:NO];
    [_lbLefta9_10 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta10_11 setBordered:NO];
    [_lbLefta10_11 setBackgroundColor:[NSColor whiteColor]];
    [_lbLefta11_12 setBordered:NO];
    [_lbLefta11_12 setBackgroundColor:[NSColor whiteColor]];
    
    [_lbLeftb1_2 setBordered:NO];
    [_lbLeftb1_2 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb2_3 setBordered:NO];
    [_lbLeftb2_3 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb3_4 setBordered:NO];
    [_lbLeftb3_4 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb4_5 setBordered:NO];
    [_lbLeftb4_5 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb5_6 setBordered:NO];
    [_lbLeftb5_6 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb6_7 setBordered:NO];
    [_lbLeftb6_7 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb7_8 setBordered:NO];
    [_lbLeftb7_8 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb8_9 setBordered:NO];
    [_lbLeftb8_9 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb9_10 setBordered:NO];
    [_lbLeftb9_10 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb10_11 setBordered:NO];
    [_lbLeftb10_11 setBackgroundColor:[NSColor whiteColor]];
    [_lbLeftb11_12 setBordered:NO];
    [_lbLeftb11_12 setBackgroundColor:[NSColor whiteColor]];
    
    [_lbRighta1_2 setBordered:NO];
    [_lbRighta1_2 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta2_3 setBordered:NO];
    [_lbRighta2_3 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta3_4 setBordered:NO];
    [_lbRighta3_4 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta4_5 setBordered:NO];
    [_lbRighta4_5 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta5_6 setBordered:NO];
    [_lbRighta5_6 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta6_7 setBordered:NO];
    [_lbRighta6_7 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta7_8 setBordered:NO];
    [_lbRighta7_8 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta8_9 setBordered:NO];
    [_lbRighta8_9 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta9_10 setBordered:NO];
    [_lbRighta9_10 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta10_11 setBordered:NO];
    [_lbRighta10_11 setBackgroundColor:[NSColor whiteColor]];
    [_lbRighta11_12 setBordered:NO];
    [_lbRighta11_12 setBackgroundColor:[NSColor whiteColor]];
    
    [_lbRightb1_2 setBordered:NO];
    [_lbRightb1_2 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb2_3 setBordered:NO];
    [_lbRightb2_3 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb3_4 setBordered:NO];
    [_lbRightb3_4 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb4_5 setBordered:NO];
    [_lbRightb4_5 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb5_6 setBordered:NO];
    [_lbRightb5_6 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb6_7 setBordered:NO];
    [_lbRightb6_7 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb7_8 setBordered:NO];
    [_lbRightb7_8 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb8_9 setBordered:NO];
    [_lbRightb8_9 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb9_10 setBordered:NO];
    [_lbRightb9_10 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb10_11 setBordered:NO];
    [_lbRightb10_11 setBackgroundColor:[NSColor whiteColor]];
    [_lbRightb11_12 setBordered:NO];
    [_lbRightb11_12 setBackgroundColor:[NSColor whiteColor]];
    
    //Button init
    [_btLefta1 setTitle:@""];
    [_btLefta1 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta2 setTitle:@""];
    [_btLefta2 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta3 setTitle:@""];
    [_btLefta3 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta4 setTitle:@""];
    [_btLefta4 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta5 setTitle:@""];
    [_btLefta5 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta6 setTitle:@""];
    [_btLefta6 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta7 setTitle:@""];
    [_btLefta7 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta8 setTitle:@""];
    [_btLefta8 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta9 setTitle:@""];
    [_btLefta9 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta10 setTitle:@""];
    [_btLefta10 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta11 setTitle:@""];
    [_btLefta11 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLefta12 setTitle:@""];
    [_btLefta12 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    
    [_btLeftb1 setTitle:@""];
    [_btLeftb1 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb2 setTitle:@""];
    [_btLeftb2 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb3 setTitle:@""];
    [_btLeftb3 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb4 setTitle:@""];
    [_btLeftb4 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb5 setTitle:@""];
    [_btLeftb5 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb6 setTitle:@""];
    [_btLeftb6 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb7 setTitle:@""];
    [_btLeftb7 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb8 setTitle:@""];
    [_btLeftb8 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb9 setTitle:@""];
    [_btLeftb9 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb10 setTitle:@""];
    [_btLeftb10 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb11 setTitle:@""];
    [_btLeftb11 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btLeftb12 setTitle:@""];
    [_btLeftb12 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    
    [_btRighta1 setTitle:@""];
    [_btRighta1 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta2 setTitle:@""];
    [_btRighta2 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta3 setTitle:@""];
    [_btRighta3 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta4 setTitle:@""];
    [_btRighta4 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta5 setTitle:@""];
    [_btRighta5 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta6 setTitle:@""];
    [_btRighta6 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta7 setTitle:@""];
    [_btRighta7 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta8 setTitle:@""];
    [_btRighta8 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta9 setTitle:@""];
    [_btRighta9 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta10 setTitle:@""];
    [_btRighta10 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta11 setTitle:@""];
    [_btRighta11 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRighta12 setTitle:@""];
    [_btRighta12 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    
    [_btRightb1 setTitle:@""];
    [_btRightb1 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb2 setTitle:@""];
    [_btRightb2 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb3 setTitle:@""];
    [_btRightb3 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb4 setTitle:@""];
    [_btRightb4 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb5 setTitle:@""];
    [_btRightb5 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb6 setTitle:@""];
    [_btRightb6 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb7 setTitle:@""];
    [_btRightb7 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb8 setTitle:@""];
    [_btRightb8 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb9 setTitle:@""];
    [_btRightb9 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb10 setTitle:@""];
    [_btRightb10 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb11 setTitle:@""];
    [_btRightb11 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    [_btRightb12 setTitle:@""];
    [_btRightb12 setImage:[NSImage imageNamed:@"NotConnect.png"]];
    
}
@end
