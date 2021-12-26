//
//  MainTestViewController.m
//  B435_WirelessCharge
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//


#import "MainTestViewController.h"
#import "SettingViewController.h"
#import "ConfigStation.h"
#import <QuartzCore/QuartzCore.h>
@interface MainTestViewController ()<NSTableViewDataSource,NSTabViewDelegate,ListenerDelegate,NSTextFieldDelegate,SettingViewControllerDelegate>

@property (weak) IBOutlet NSTextField *PDCAIsShowView;
@property (nonatomic,strong)NSTimer *PDCAShowTimer;
@property (weak) IBOutlet NSTextField *BrdSW;
@property (nonatomic,strong)SettingViewController *settingVC;
@property (weak) IBOutlet NSButton *auditBtn;
@property (weak) IBOutlet NSTextField *testSW;

@property (weak) IBOutlet NSTextField *UUT1SNLabel;
@property (weak) IBOutlet NSTextField *UUT2SNLabel;
@property (weak) IBOutlet NSButton *clearBtn;

@property (weak) IBOutlet NSTextField *logPathLabel;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSView *uut1BackgroudView;
@property (weak) IBOutlet NSButton *uut1CheckButton;
@property (weak) IBOutlet NSTextField *uut1ResultLabel;
//@property (weak) IBOutlet NSTextField *uut1TextField;

@property (weak) IBOutlet NSView *uut2BackgroudView;
@property (weak) IBOutlet NSButton *uut2CheckButton;
@property (weak) IBOutlet NSTextField *uut2ResultLabel;
//@property (weak) IBOutlet NSTextField *uut2TextField;

@property (weak) IBOutlet NSTableView *tableView;
@property (copy,nullable) NSArray *datasArray;
@property (copy,nullable) NSArray *commandsArrays;

@property (weak) IBOutlet NSButton *resetBtn;

@property (nonatomic,strong) Listener *listenr;

@property (weak) IBOutlet NSTextField *testCountView;
@property (weak) IBOutlet NSTextField *passCountView;
@property (weak) IBOutlet NSTextField *failCountView;
@property (weak) IBOutlet NSTextField *YieldView;

@property (weak) IBOutlet NSTextField *uut1TimeView;
@property (weak) IBOutlet NSTextField *uut2TimeView;

@end

@implementation MainTestViewController
{

    NSInteger _times;
    NSInteger _uut1ColumnIndex;
    BOOL _isRun;
    BOOL _isEmergencyStop;
    BOOL _isClearEmergencyStop;
    BOOL _isStart;
    BOOL _isReset;
    NSControlStateValue _uut1Check;
    NSControlStateValue _uut2Check;
    NSString *_sn1;
    NSString *_sn2;
    BOOL _uut1Result;
    BOOL _uut2Result;
    Communication *_boardConsole;
    
    NSControlStateValue _auditCheck;
    NSControlStateValue _puddingCheck;
    NSControlStateValue _bobCatCheck;
    
    NSInteger timerScoend;
    
}

- (IBAction)START:(id)sender {
    //_isStart=YES;
    //[ConfigDatas initalPlistDatas];
    
}
- (IBAction)cleanCount:(id)sender {
//    NSTableView
    
    NSString *prompt = @"PassWord Protected Function!!!";
    NSString *infoText = @"Please enter password to clear data:";
    NSString *defaultValue = @"Enter your password here";
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@",infoText];
    NSSecureTextField *input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setPlaceholderString:defaultValue];
    [alert setAccessoryView:input];
  
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        if(![[input stringValue] isEqualToString:@"123"]){
            
            
             NSRunAlertPanel(@"Error",@"Password is not correct", @"OK", nil, nil);
        }
        else{
            [Account clearAccount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showInfo];
            });
           
            NSRunAlertPanel(nil,@"clean success", nil, nil, nil);
        }
        NSLog(@"User entered: %@", [input stringValue]);
    }
    else if (button == NSAlertAlternateReturn) {
        NSLog(@"User cancelled");
    }
    else{
        NSLog(@"Should never go here");
    }
   
    
}

- (IBAction)uut1Select:(id)sender {
    _uut1Check = self.uut1CheckButton.state;
    self.uut1BackgroudView.layer.backgroundColor = [NSColor colorWithRed:177.0/255.0 green:178.0/255.0 blue:177.0/255.0 alpha:0.8].CGColor;
    if(_uut1Check&&_uut2Check)
    {
        [self.listenr DUTSELECTED:1 DUT2Status:1];
    }
    else if(!_uut1Check&&_uut2Check)
    {
        [self.listenr DUTSELECTED:0 DUT2Status:1];
    }
    else if(_uut1Check&&!_uut2Check)
    {
        [self.listenr DUTSELECTED:1 DUT2Status:0];
    }
    else if(!_uut1Check&&!_uut2Check)
    {
        [self.listenr DUTSELECTED:0 DUT2Status:0];
    }
}

- (IBAction)uut2Select:(id)sender {
    _uut2Check = self.uut2CheckButton.state;
    self.uut2BackgroudView.layer.backgroundColor = [NSColor colorWithRed:177.0/255.0 green:178.0/255.0 blue:177.0/255.0 alpha:0.8].CGColor;
    if(_uut1Check&&_uut2Check)
    {
        [self.listenr DUTSELECTED:1 DUT2Status:1];
    }
    else if(!_uut1Check&&_uut2Check)
    {
        [self.listenr DUTSELECTED:0 DUT2Status:1];
    }
    else if(_uut1Check&&!_uut2Check)
    {
        [self.listenr DUTSELECTED:1 DUT2Status:0];
    }
    else if(!_uut1Check&&!_uut2Check)
    {
        [self.listenr DUTSELECTED:0 DUT2Status:0];
    }
}



#pragma mark- init
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initAllParameter];

    NSLog(@"%@",[NSBundle mainBundle].bundlePath);
    NSLog(@"%@",NSHomeDirectory());
    _isRun = NO;

    [self settingData];
    
    [self settingUI];
    
    [self settingControllerBoardListenr];

    [self waiting_for_test];
    
    [ConfigCommands configCommands_init:QI1PortName QI2PortName:QI2PortName UUT1PortName:UUT1PortName UUT2PortName:UUT2PortName PythonOpenCommand:pythonOpenCommand OverlayVersion:OverlayVersion];
}

-(void)initAllParameter
{
    UUT1TestData = [[NSMutableArray alloc] init];
    UUT2TestData = [[NSMutableArray alloc] init];
    configTestData = [[NSArray alloc] init];
    NSMutableDictionary *configStation = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"configStation" ofType:@"plist"]];
    stationMode       = [configStation objectForKey:@"station_mode"];
    NSMutableDictionary *StationInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[stationMode stringByAppendingString:@"StationInfo"] ofType:@"plist"]];
    stationTestItem = [StationInfo objectForKey:@"stationTestItem"];
    PDCAStationID = [StationInfo objectForKey:@"PDCAStationID"];
    PDCAStationSN = [StationInfo objectForKey:@"PDCAStationSN"];
    softwareVersion = [StationInfo objectForKey:@"softwareVersion"];
    productionName = [StationInfo objectForKey:@"productionName"];
    fixtureID = [StationInfo objectForKey:@"fixtureID"];
    pythonOpenCommand = [StationInfo objectForKey:@"pythonOpenCommand"];
    QI1PortName = [StationInfo objectForKey:@"QI1PortName"];
    QI2PortName = [StationInfo objectForKey:@"QI2PortName"];
    UUT1PortName = [StationInfo objectForKey:@"UUT1PortName"];
    UUT2PortName = [StationInfo objectForKey:@"UUT2PortName"];
    OverlayVersion = [StationInfo objectForKey:@"OverlayVersion"];
    NSString *path = [[NSBundle mainBundle] pathForResource:stationTestItem ofType:@"plist"];
    configTestData = [NSArray arrayWithContentsOfFile:path];
    [self resetTestData];
}

-(void)resetTestData
{
    NSString *plistName =[ConfigStation stationTestItem];
    [ConfigDatas loadWithPlist:plistName];
    self.datasArray = [ConfigDatas getPlistDatas] ;
    self.commandsArrays = [ConfigDatas getCommadsArrays];
    
    NSMutableDictionary *StationInfo = [ConfigStation getSationPlist];
    stationTestItem = [StationInfo objectForKey:@"stationTestItem"];
    NSString *path = [[NSBundle mainBundle] pathForResource:stationTestItem ofType:@"plist"];
     configTestData = [NSArray arrayWithContentsOfFile:path];
    UUT1TestData = [NSMutableArray new];
    UUT2TestData = [NSMutableArray new];
    for (NSDictionary *testItem in configTestData)
    {
        TestUnitData* testUnitData      = [TestUnitData new];
        testUnitData.testName       = ([testItem objectForKey:@"name"] ? : @"subTestName");
        testUnitData.min            = ([testItem objectForKey:@"min"] ? : @"NA");
        testUnitData.max            = ([testItem objectForKey:@"max"] ? : @"NA");
        testUnitData.unit           = ([testItem objectForKey:@"unit"] ? : @"NA");
        testUnitData.value          = @"";
        testUnitData.result         = @"";
        testUnitData.time           = @"";
        testUnitData.startTime   = @"";
        testUnitData.endTime     = @"";
        testUnitData.finalreult = @"";
        testUnitData.errormsg    = @"";
        testUnitData.reply       = @"";
        testUnitData.cutResult   = @"";
        [UUT1TestData addObject:testUnitData];
        [UUT2TestData addObject:testUnitData];
    }
    ///init csv file
    NSString *directory2 = @"/vault/QI_Datas";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directory2])
    {
        [fileManager createDirectoryAtPath:directory2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    CSVOTPFilePath = [directory2 stringByAppendingPathComponent:[NSString stringWithFormat:@"QI_OTP_%@.csv",[dateFormatter stringFromDate:[NSDate date]]]];
    CSVOTPAuditFilePath = [directory2 stringByAppendingPathComponent:[NSString stringWithFormat:@"Audit_QI_OTP_%@.csv",[dateFormatter stringFromDate:[NSDate date]]]];
    CSVNOOTPFilePath = [directory2 stringByAppendingPathComponent:[NSString stringWithFormat:@"QI_NO_OTP_%@.csv",[dateFormatter stringFromDate:[NSDate date]]]];
    CSVNOOTPAuditFilePath  = [directory2 stringByAppendingPathComponent:[NSString stringWithFormat:@"Audit_QI_NO_OTP_%@.csv",[dateFormatter stringFromDate:[NSDate date]]]];

    NSString* content;
    NSData* data;
    NSString *Configfile = @"/vault/data_collection/test_station_config/gh_station_info.json";
    NSMutableDictionary *ConfigContent = [[NSMutableDictionary alloc] initWithContentsOfFile:Configfile];
    content = [NSString stringWithContentsOfFile:Configfile encoding:NSUTF8StringEncoding error:nil];
    data=[content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict_contrlbits = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    dict_contrlbits = [dict_contrlbits objectForKey:@"controlbits"];
    CONTROL_BITS_TO_CHECK = [[dict_contrlbits objectForKey:@"CONTROL_BITS_TO_CHECK"] objectAtIndex:0];
    CONTROL_BITS_STATION_NAMES = [[dict_contrlbits objectForKey:@"CONTROL_BITS_STATION_NAMES"] objectAtIndex:0];
    STATION_FAIL_COUNT_ALLOWED = [[dict_contrlbits objectForKey:@"STATION_FAIL_COUNT_ALLOWED"] integerValue];
    [self setCBStation:CONTROL_BITS_TO_CHECK];
    NSDictionary* dict_ghInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    dict_ghInfo = [dict_ghInfo objectForKey:@"ghinfo"];
    //cwluo
    NSString *dict_BUILD_STAGE = [dict_ghInfo objectForKey:@"BUILD_STAGE"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dict_BUILD_STAGE isEqualToString:@"MP"]) {//MP
            //[self.clipView setHidden:YES];
            [self.tableView setHidden:YES];
            
        }else{
            //[self.clipView setHidden:YES];
            [self.tableView setHidden:NO];
        }
    });
    
    
    NSString *STATION_SET_CONTROL_BIT_ON_OFF_json = [dict_ghInfo objectForKey:@"STATION_SET_CONTROL_BIT_ON_OFF"];
    if([STATION_SET_CONTROL_BIT_ON_OFF_json containsString:@"ON"])
    {
        STATION_SET_CONTROL_BIT_ON_OFF = true;
    }
    else
    {
        STATION_SET_CONTROL_BIT_ON_OFF = false;
    }
    NSString *CONTROL_BITS_TO_CHECK_ON_OFF_json = [dict_ghInfo objectForKey:@"CONTROL_BITS_TO_CHECK_ON_OFF"];
    if([CONTROL_BITS_TO_CHECK_ON_OFF_json containsString:@"ON"])
    {
        CONTROL_BITS_TO_CHECK_ON_OFF = true;
    }
    else
    {
        CONTROL_BITS_TO_CHECK_ON_OFF = false;
    }
    NSString *SFC_QUERY_UNIT_ON_OFF_json = [dict_ghInfo objectForKey:@"SFC_QUERY_UNIT_ON_OFF"];
    if([SFC_QUERY_UNIT_ON_OFF_json containsString:@"ON"])
    {
        SFC_QUERY_UNIT_ON_OFF = true;
    }
    else
    {
        SFC_QUERY_UNIT_ON_OFF = false;
    }
    [ConfigCommands setCBInfo:lastCBStation thisCBStation:thisCBStation STATION_FAIL_COUNT_ALLOWED:STATION_FAIL_COUNT_ALLOWED STATION_SET_CONTROL_BIT_ON_OFF:STATION_SET_CONTROL_BIT_ON_OFF CONTROL_BITS_TO_CHECK_ON_OFF:CONTROL_BITS_TO_CHECK_ON_OFF AuditMode:_auditCheck];
}

-(void)setCBStation:(NSString*)CONTROL_BITS_TO_CHECK
{
    if(![CONTROL_BITS_TO_CHECK containsString:@"0x"])
    {
        return;
    }
    NSRange range_from = [CONTROL_BITS_TO_CHECK rangeOfString:@"0x"];
    NSString * string_to = [CONTROL_BITS_TO_CHECK substringWithRange:NSMakeRange(range_from.location+range_from.length, CONTROL_BITS_TO_CHECK.length - (range_from.location+range_from.length))];
    lastCBStation = string_to;
    int lastCBStation_int = [string_to integerValue];
    int thisCBStation_int = lastCBStation_int + 1;
    if(thisCBStation_int<10)
    {
        thisCBStation = [NSString stringWithFormat:@"0%d",thisCBStation_int];
    }
    else
    {
        thisCBStation = [NSString stringWithFormat:@"%d",thisCBStation_int];
    }
}


-(void)settingData
{
    NSString *plistName =[ConfigStation stationTestItem];
    [ConfigDatas loadWithPlist:plistName];
    self.datasArray = [ConfigDatas getPlistDatas] ;
    self.commandsArrays = [ConfigDatas getCommadsArrays];
    [self.logPathLabel setStringValue:commandLogPath];
    //config by defult
//    _auditCheck = self.auditBtn.state;
//    _puddingCheck = 1;
//    _bobCatCheck = 1;
}

-(void)settingUI
{
    self.testSW.stringValue = [NSString stringWithFormat:@"Test SW Ver: %@",[ConfigStation softwareVersion]];
    self.settingVC = [[SettingViewController alloc]init];
    self.settingVC.delegate = self;
    _auditCheck = self.auditBtn.state;
    _bobCatCheck = [ConfigStation isBobcat];
    _puddingCheck = [ConfigStation isPudding];
    if (!_puddingCheck) {
        [self.PDCAIsShowView setHidden:NO];
       // [self startPDCATimer];
    }
    [self showInfo];
    NSLog(@"%@",[NSBundle mainBundle].bundlePath) ;
    
    [self.titleLabel setStringValue:[ConfigStation stationTestItem]];
    self.UUT1SNLabel.stringValue = @"UUT1";
    self.UUT2SNLabel.stringValue = @"UUT2";
    self.uut1CheckButton.wantsLayer = YES;
    self.uut1CheckButton.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.uut2CheckButton.wantsLayer = YES;
    self.uut2CheckButton.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.uut1BackgroudView.wantsLayer = YES;
    self.uut1BackgroudView.layer.backgroundColor = [NSColor colorWithRed:177.0/255.0 green:178.0/255.0 blue:177.0/255.0 alpha:0.8].CGColor;
    self.uut2BackgroudView.wantsLayer = YES;
    self.uut2BackgroudView.layer.backgroundColor = [NSColor colorWithRed:177.0/255.0 green:178.0/255.0 blue:177.0/255.0 alpha:0.8].CGColor;
    _uut1Check = self.uut1CheckButton.state;
    _uut2Check = self.uut2CheckButton.state;
    _uut1ColumnIndex = [self.tableView columnWithIdentifier:key_uut1];
    [self.tableView reloadData];
  
}
-(void)settingControllerBoardListenr
{
    
    
    Communication *fixtureConsole = [Communication communicationWithPath:@"/dev/cu.usbserial-FIX" baudRate:115200];
    if (fixtureConsole.portUartHandle)
    {
        [fixtureConsole SendCmdAndGetReply:@"DUTSELECTED 1 1" TimeOut:1 ResponseSuffix:@"/r/n>" LogPath:nil];
        NSString *fwVersion;
        for (int i = 0; i< 3; i++)
        {
            NSString *reply= [fixtureConsole SendCmdAndGetReply:@"FIRMWARE" TimeOut:1 ResponseSuffix:@"/r/n>" LogPath:nil];
            //FirmWare:930001F980WCFBA11
            //NSString *reply= @"FirmWare:930001F980WCFBA11/r/n>";
            [CSVLog saveDubegLog:[NSString stringWithFormat:@"$$$#########%@",reply]];
            NSLog(@"%ld",reply.length);//40
            if (reply.length >= 40)
            {
                NSRange range1 = [reply rangeOfString:@"\r\n>"];
                NSRange range2= NSMakeRange(range1.location-2, 2);
                NSString *fwTemp =[NSString stringWithFormat:@"%@",[reply substringWithRange:range2]];
                NSLog(@"11");
                NSMutableString *tempVersion = [[NSMutableString alloc]initWithString:fwTemp];
                    [tempVersion insertString:@"." atIndex:1];
                    NSString *fwVer = [NSString stringWithFormat:@"V%@",tempVersion];
                    [CSVLog saveDubegLog:[NSString stringWithFormat:@"$$$#########%@",fwVer]];
                self.BrdSW.stringValue = [NSString stringWithFormat:@"HW Ver: %@",fwVer];
                fwVersion = fwVer;
                break;
            }
        }

        if (![fwVersion isEqualToString:[ConfigStation BoardVersion]]) {
            NSRunAlertPanel(@"Error",@"Please check Borad SW Ver", @"exit", nil, nil);
            [NSThread sleepForTimeInterval:2.0];
            exit (EXIT_FAILURE);

        }
        //else{
        
            self.listenr = [[Listener alloc] init];
            self.listenr.delegate = self;
            self.listenr.isStartPause = YES;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.listenr startListening:fixtureConsole];
            });
     //  }
        
        
    }
    else
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"THE FIXTURE IS BUSY"];
        [alert setInformativeText:@"Please check the fixture connecton!"];
        [alert runModal];
        [NSThread sleepForTimeInterval:1.0];
        exit (EXIT_FAILURE);
    }
}

-(void)waiting_for_test
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            [NSThread sleepForTimeInterval:0.1];
            if (_isEmergencyStop)
            {
                if(_isClearEmergencyStop==YES&&_isRun == NO)
                {
                    _isEmergencyStop = NO;
                    _isClearEmergencyStop = NO;
                    if(_uut1Check&&_uut2Check)
                    {
                        [self.listenr DUTSELECTED:1 DUT2Status:1];
                    }
                    else if(!_uut1Check&&_uut2Check)
                    {
                        [self.listenr DUTSELECTED:0 DUT2Status:1];
                    }
                    else if(_uut1Check&&!_uut2Check)
                    {
                        [self.listenr DUTSELECTED:1 DUT2Status:0];
                    }
                    else if(!_uut1Check&&!_uut2Check)
                    {
                        [self.listenr DUTSELECTED:0 DUT2Status:0];
                    }
                }
                continue;
            }
            if(_isReset == YES&&_isRun == NO)
            {
                _isReset = NO;
                if(_uut1Check&&_uut2Check)
                {
                    [self.listenr DUTSELECTED:1 DUT2Status:1];
                }
                else if(!_uut1Check&&_uut2Check)
                {
                    [self.listenr DUTSELECTED:0 DUT2Status:1];
                }
                else if(_uut1Check&&!_uut2Check)
                {
                    [self.listenr DUTSELECTED:1 DUT2Status:0];
                }
                else if(!_uut1Check&&!_uut2Check)
                {
                    [self.listenr DUTSELECTED:0 DUT2Status:0];
                }
            }
            if (_isStart)
            {
                if(_isRun == NO)
                {
                    _isRun = YES;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.uut1CheckButton setEnabled:NO];
                        [self.uut2CheckButton setEnabled:NO];
                        [self.clearBtn setEnabled:NO];
                        [self.auditBtn setEnabled:NO];
                    });
                    
                    [self resetTestData];
                    [self work];
                }
            }
        }
    });
}

#pragma mark- Test
-(void)work
{
    [ConfigDatas initalPlistDatas];
    [self.listenr StartOK];
    [ConfigCommands openPowerSupply:stationTestItem uut1Check:_uut1Check uut2Check:_uut2Check];
    
    [NSThread sleepForTimeInterval:0.5];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollRowToVisible:0];
        if (_uut1Check) {
            self.UUT1SNLabel.stringValue = @"UUT1";
            self.UUT2SNLabel.stringValue = @"UUT2";
            [self.uut1ResultLabel setStringValue:@""];
            self.uut1BackgroudView.layer.backgroundColor = [NSColor yellowColor].CGColor;
        }
        if (_uut2Check) {
            [self.uut2ResultLabel setStringValue:@""];
            self.uut2BackgroudView.layer.backgroundColor = [NSColor yellowColor].CGColor;
        }
    });

    dispatch_queue_t barrier = dispatch_queue_create("lcwbarrier", DISPATCH_QUEUE_CONCURRENT);
    
    if (_uut1Check) {
        dispatch_async(barrier, ^{//0:uut1
            [self testItems:key_uut1];
        });
    }
    if (_uut2Check) {
        dispatch_async(barrier, ^{//1:uut2
            [self testItems:key_uut2];
        });
    }
    dispatch_barrier_async(barrier, ^{
        NSLog(@"test finish");
        
    });
    dispatch_async(barrier, ^{
        _isRun = NO;
        _isStart = NO;
        [self testEnd];
    });
}


-(void)testItems:(NSString *)uutName
{
    __weak typeof(self) weakSelf = self;
    NSString * logPath = [[NSString alloc] init];
    time_t startTime;
    time(&startTime);
    NSDate *overTime = [NSDate date];
    NSDateFormatter *startTimeFormatter = [[NSDateFormatter alloc] init];
    [startTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* startTime_Str = [NSString stringWithFormat:@"%@",[startTimeFormatter stringFromDate:[NSDate date]]];
    
    NSMutableArray * UUTTestData;
    NSString *key;
    int uutNumber = 0;
    NSTextField *uutTextField;
    
    if([uutName isEqualToString:key_uut1])
    {
        UUTTestData = UUT1TestData;
        key = key_uut1;
        uutNumber = 0;
       // uutTextField =weakSelf.uut1TextField;
        uutTextField =weakSelf.UUT1SNLabel;
    }
    else if([uutName isEqualToString:key_uut2])
    {
        UUTTestData = UUT2TestData;
        key = key_uut2;
        uutNumber = 1;
        uutTextField =weakSelf.UUT2SNLabel;
    }
    BOOL errorBreak = false;
    BOOL isPass = YES;
    NSString *sn ;
    NSTimer *__block timer;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *percens =@0;
        NSNumber *seconds =@0;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{time_percens:percens,time_seconds:seconds,time_key:key}];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:weakSelf selector:@selector(startTimer:) userInfo:dict repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
        [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, weakSelf.datasArray.count)] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex, 2)]];
    });
    [NSThread sleepForTimeInterval:0.2];
    
    int itemNum = 0;
    for (itemNum = 0; itemNum<weakSelf.datasArray.count-1; itemNum++)
    {
        NSLog([NSString stringWithFormat:@"########Test Item Name : %@ #########",[UUTTestData[itemNum] getData:@"name"]]);
        if(_isEmergencyStop == YES)
        {
            [ConfigCommands unnormalStop:key LogPath:logPath];
            isPass = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [timer invalidate];
                timer = nil;
                [weakSelf showInfo];
                [weakSelf showResult:isPass uutIndex:uutName];
            });
            errorBreak = true;
            NSLog(@"######## EmergencyStop break ########");
            break;
        }
        if(_isReset == YES)
        {
            [ConfigCommands unnormalStop:key LogPath:logPath];
            isPass = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [timer invalidate];
                timer = nil;
                [weakSelf showInfo];
                [weakSelf showResult:isPass uutIndex:uutName];
            });
            errorBreak = true;
            NSLog(@"######## Reset break ########");
            break;
        }
        if(!_puddingCheck&&([[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_LastStation_CB_Result"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Write_CB_Str_I"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Write_CB"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_CB_FailCount"]))
        {
            [ConfigDatas skip:itemNum UUTTestData:UUTTestData key:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollRowToVisible:itemNum];
                [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:itemNum] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
            });
            continue;
        }

        //audit mode flow
        if(_auditCheck&&([[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_LastStation_CB_Result"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Write_CB_Str_I"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Write_CB"]))
        {
            [ConfigDatas skip:itemNum UUTTestData:UUTTestData key:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollRowToVisible:itemNum];
                [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:itemNum] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
            });
            continue;
        }

        //do not dot this CB item based on the json value
        if(([[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Write_CB_Str_I"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Write_CB"])&&STATION_SET_CONTROL_BIT_ON_OFF ==false)
        {
            [ConfigDatas skip:itemNum UUTTestData:UUTTestData key:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollRowToVisible:itemNum];
                [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:itemNum] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
            });

            continue;
        }
        if(([[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_LastStation_CB_Result"]||[[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_CB_FailCount"])&&CONTROL_BITS_TO_CHECK_ON_OFF ==false)
        {
            [ConfigDatas skip:itemNum UUTTestData:UUTTestData key:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollRowToVisible:itemNum];
                [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:itemNum] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
            });
            continue;
        }
        
        //jdye
        if(itemNum == 7)
        {
            NSLog(@"");
        }
     
        NSArray *commandsArray = weakSelf.commandsArrays[itemNum];
        NSArray *reponseArray = [ConfigCommands communicationWithCommands:commandsArray key:key LogPath:logPath ResultForWitreCB:isPass UUTTestData:UUTTestData bobCatCheck:_bobCatCheck];
        NSString *cutReponse = [ConfigDatas updatePlistDatasWithReponse:reponseArray row:itemNum isPass:&isPass key:key UUTTestData:UUTTestData CBResult:isPass CBFailCount:STATION_FAIL_COUNT_ALLOWED bobCatCheck:_bobCatCheck  AuditMode:_auditCheck];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        [weakSelf.tableView scrollRowToVisible:itemNum];
            
        [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:itemNum] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
        });
        
        if([[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_LastStation_CB_Result"])
        {
            if([[UUTTestData[itemNum] getData:@"result"] isEqualToString:@"Fail"])
            {
                NSLog(@"######## Check_LastStation_CB_Result fail break ########");
                break;
            }
        }
        if([[UUTTestData[itemNum] getData:@"name"]isEqualToString:@"Check_CB_FailCount"])
        {
            if([[UUTTestData[itemNum] getData:@"result"] isEqualToString:@"Fail"]&&!_auditCheck)
            {
                NSLog(@"######## Check_CB_FailCount fail break ########");
                break;
            }
        }
        //get SN
        if ([[UUTTestData[itemNum] getData:@"name"] isEqualToString:@"DUT_SN"])
        {
            sn = cutReponse;
           
            dispatch_async(dispatch_get_main_queue(), ^{
     
                [uutTextField setStringValue:sn];
               
            });
            if([sn isEqualToString:@""]||[sn isEqualToString:@"NULL"]||[sn containsString:@"ERROR"])
            {
                errorBreak = true;
                NSLog(@"######## Can't get SN fail break ########");
                break;
            }
            
            if (!_auditCheck&&_bobCatCheck&&SFC_QUERY_UNIT_ON_OFF)
            {
                PoolPDCA *pool = [[PoolPDCA alloc] init];
                NSString *PDCASoftwareVersion;
                if([stationTestItem containsString:@"NO"])
                {
                    PDCASoftwareVersion = [softwareVersion stringByAppendingString:@"_NO_OTP"];
                }
                else
                {
                    PDCASoftwareVersion = [softwareVersion stringByAppendingString:@"_OTP"];
                }
                NSString *bobcatmsg = [pool Bobcat_Check_B435:[sn UTF8String] strSWName:[PDCAStationID UTF8String] str_SWVersion:[PDCASoftwareVersion UTF8String] FixtureID:[fixtureID intValue] SiteID:uutNumber+1];
                
                if([bobcatmsg isNotEqualTo:@""])
                {
                    isPass = NO;
                    errorBreak = true;
                    
                    NSLog([NSString stringWithFormat:@"######## BobCat fail break BobCatMsg: %@########",bobcatmsg]);
                    NSAlert *alert = [NSAlert alertWithMessageText:@"BobCat Fail"
                                                     defaultButton:@"OK"
                                                   alternateButton:@"Cancel"
                                                       otherButton:nil
                                         informativeTextWithFormat:@"%@",bobcatmsg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alert runModal];
                    });
                    
                    break;
                }
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *logFilePath = [NSString stringWithFormat:@"/vault/QI_Datas/%@_LogFiles",[dateFormatter stringFromDate:[NSDate date]]];
            if (![fileManager fileExistsAtPath:logFilePath])
            {
                [fileManager createDirectoryAtPath:logFilePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString* datetime = [dateFormatter stringFromDate:[NSDate date]];
            logPath = [NSString stringWithFormat:@"%@/%@_%@_%@.txt",logFilePath,sn,datetime,uutName];
            [CSVLog saveLog:[NSString stringWithFormat:@"  %@",@"########## START ##########\n"] LogPath:logPath];
            
            if(_auditCheck)
            {
                [CSVLog saveLog:[NSString stringWithFormat:@"  %@",@"########## Audit Mode ##########"] LogPath:logPath];
            }
            else
            {
                [CSVLog saveLog:[NSString stringWithFormat:@"  %@",@"########## Normal Mode ##########"] LogPath:logPath];
            }
            [CSVLog saveLog:[NSString stringWithFormat:@"  BobCat Flag:  %ld",(long)_bobCatCheck] LogPath:logPath];
            [CSVLog saveLog:[NSString stringWithFormat:@"  Pudding Flag:  %ld\n",(long)_puddingCheck] LogPath:logPath];
            
            int i = 0;
            for (TestCommandModel *cmdModel in commandsArray)
            {
                [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Send:  %@",cmdModel.send] LogPath:logPath];
                [CSVLog saveLog:[NSString stringWithFormat:@"  DUT Get :  %@",[reponseArray objectAtIndex:i]] LogPath:logPath];
                 i++;
            }
        }
    }
    //end for
    
    
    time_t endTime;
    time(&endTime);
    double totalTime = [[NSDate date] timeIntervalSinceDate:overTime];
    NSDateFormatter *endTimeFormatter = [[NSDateFormatter alloc] init];
    [endTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* endTime_Str = [NSString stringWithFormat:@"%@",[endTimeFormatter stringFromDate:[NSDate date]]];
    
    
    //upload PDCA
    NSString *errorMes = [[NSString alloc] init];
    NSString * priority = @"0";   //No -2 is always nomarl model , -2 is always audit model.
    
    if(_auditCheck)
    {
        priority = @"-2";
    }
    PoolPDCA *pool = [[PoolPDCA alloc] init];
    if (![sn isEqualToString:@""]&&![sn isEqualToString:@"NULL"]&&![sn containsString:@"ERROR"]&&!errorBreak&&_puddingCheck)
    {
        NSString *PDCASoftwareVersion;
        if([stationTestItem containsString:@"NO"])
        {
            PDCASoftwareVersion = [softwareVersion stringByAppendingString:@"_NO_OTP"];
        }
        else
        {
            PDCASoftwareVersion = [softwareVersion stringByAppendingString:@"_OTP"];
        }
        if([pool AdjustPDCAData:[sn UTF8String] SWName:[PDCAStationID UTF8String]
                      SWVersion:[PDCASoftwareVersion UTF8String] StationSN:[PDCAStationSN UTF8String]
                       PDCAData:UUTTestData FailMes:[errorMes UTF8String] Priority:priority
                      StartTime:startTime EndTime:endTime file:(NSString*)logPath FixtureID:[fixtureID intValue] SiteID:uutNumber+1 CONTROL_BITS_TO_CHECK:CONTROL_BITS_TO_CHECK CONTROL_BITS_STATION_NAMES:CONTROL_BITS_STATION_NAMES STATION_FAIL_COUNT_ALLOWED:STATION_FAIL_COUNT_ALLOWED])
        {
            [ConfigDatas finishWordHandler:weakSelf.datasArray.count -1 UUTTestData:UUTTestData key:key PassOrFail:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollRowToVisible:weakSelf.datasArray.count -1];
                [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:weakSelf.datasArray.count -1] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
            });
        }
        else
        {
            isPass = NO;
            [ConfigDatas finishWordHandler:weakSelf.datasArray.count -1 UUTTestData:UUTTestData key:key PassOrFail:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollRowToVisible:weakSelf.datasArray.count -1];
                [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:weakSelf.datasArray.count -1] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
            });
        }
    }
    else
    {
        [ConfigDatas skip:itemNum UUTTestData:UUTTestData key:key];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView scrollRowToVisible:weakSelf.datasArray.count -1];
            [weakSelf.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:weakSelf.datasArray.count -1] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_uut1ColumnIndex+uutNumber, 1)]];
        });
    }
    
    if([uutName isEqualToString:key_uut1])
    {
        _uut1Result = isPass;
    }
    else if([uutName isEqualToString:key_uut2])
    {
        _uut2Result = isPass;
    }
    [Account saveAccountWithResult:isPass sn:sn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [timer invalidate];
        timer = nil;
        [weakSelf showInfo];
        [weakSelf showResult:isPass uutIndex:uutName];
    });
    // save CSV Data
    NSString *testPassFailStatus;
    if(isPass)
    {
        testPassFailStatus = @"PASS";
    }
    else
    {
        testPassFailStatus = @"FAIL";
    }
    if (![sn isEqualToString:@""]&&![sn isEqualToString:@"NULL"]&&![sn containsString:@"ERROR"])
    {
        NSString * filePath;
        if(_auditCheck&&[stationTestItem containsString:@"NO"])
        {
            filePath = CSVNOOTPAuditFilePath;
        }
        else if(_auditCheck)
        {
            filePath = CSVOTPAuditFilePath;
        }
        else if([stationTestItem containsString:@"NO"])
        {
            filePath = CSVNOOTPFilePath;
        }
        else
        {
            filePath = CSVOTPFilePath;
        }
        [CSVLog saveCSVData:sn StationID:[NSString stringWithFormat:@"%@/%@", PDCAStationID,productionName] FixtureID:fixtureID SiteID:uutName TestPassFailStatus:testPassFailStatus StartTime:startTime_Str EndTime:endTime_Str TotalTime:[NSString stringWithFormat:@"%.2f", totalTime] UUTTestData:UUTTestData CSVFilePath:filePath SoftwareVersion:softwareVersion StationTestItem:stationTestItem PDCAStationID:PDCAStationID ProductionName:productionName];
    }
    [CSVLog saveLog:[NSString stringWithFormat:@"  %@",@"########## TEST END ##########\n"] LogPath:logPath];
    
    [self.listenr ResetCylinder:uutNumber+1];
    [ConfigCommands closeCHPowerSupply:uutNumber+1];
}

-(void)testEnd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.uut1CheckButton setEnabled:YES];
        [self.uut2CheckButton setEnabled:YES];
        [self.clearBtn setEnabled:YES];
        [self.auditBtn setEnabled:YES];
    });
    [ConfigCommands closePowerSupply];
    NSLog(@"Finish Text! Seng the end command to the control broad!");
    usleep(150000);
    NSLog(@"Finish Text! Seng the end command to the control broad!");
    [self.listenr testEndWithUUT1Check:_uut1Check uut1Result:_uut1Result UUT2Check:_uut2Check uut2Result:_uut2Result];
    usleep(150000);
    [self.listenr testEndWithUUT1Check:_uut1Check uut1Result:_uut1Result UUT2Check:_uut2Check uut2Result:_uut2Result];
    usleep(200000);
    if(_uut1Check&&_uut2Check)
    {
        [self.listenr DUTSELECTED:1 DUT2Status:1];
    }
    else if(!_uut1Check&&_uut2Check)
    {
        [self.listenr DUTSELECTED:0 DUT2Status:1];
    }
    else if(_uut1Check&&!_uut2Check)
    {
        [self.listenr DUTSELECTED:1 DUT2Status:0];
    }
    else if(!_uut1Check&&!_uut2Check)
    {
        [self.listenr DUTSELECTED:0 DUT2Status:0];
    };
}

#pragma mark- NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.datasArray.count;
}


#pragma mark- NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //单元格数据
    id data = self.datasArray[row][tableColumn.identifier];
    
    //根据表格列的标识,创建单元视图
    NSView *view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSArray *subviews = [view subviews];
    
    NSTextField *textField = subviews[0];
    
    //更新单元格的文本
    if ([tableColumn.identifier isEqualToString:key_uut1]||[tableColumn.identifier isEqualToString:key_uut2]) {
        
        textField.stringValue = data[key_uut_vaule];
        if ([data[key_uut_result] isEqualToString:@"0"]) {
            textField.wantsLayer = YES;
            [textField.layer setBackgroundColor:[NSColor redColor].CGColor];
        }
        if ([data[key_uut_result] isEqualToString:@"1"]&&[data[key_uut_vaule] length]) {
            NSLog(@"row-%ld",(long)row);
            textField.wantsLayer = YES;
            [textField.layer setBackgroundColor:[NSColor greenColor].CGColor];
        }
        if ([data[key_uut_result] isEqualToString:@""]) {
            textField.wantsLayer = YES;
            [textField.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        }
    }else if ([tableColumn.identifier isEqualToString:key_name]) {
        [textField setTextColor:[NSColor blueColor]];
        textField.stringValue = data;
    }else if ([tableColumn.identifier isEqualToString:key_index]) {
        textField.stringValue = [NSString stringWithFormat:@"%ld",(long)row];
    }
    else{
        textField.stringValue = data;
    }
    return view;
}

#pragma mark- ListenerDelegate
-(void)FixtureStart
{
    _isStart = YES;
}

-(void)FixtureStop
{
    _isEmergencyStop = YES;
}

-(void)FixtureCloseStop
{
    //_isRun = NO;
    //_isEmergencyStop = NO;
    _isClearEmergencyStop = YES;
}

-(void)FixturRreset
{
    _isReset = YES;
}

#pragma mark SHOWRESULT
-(void)showResult:(BOOL)isPass uutIndex:(NSString*)uutIndex
{
    if ([uutIndex isEqualToString:key_uut2])
    {
        
        if (!isPass) {
            
            [self.uut2ResultLabel setStringValue:@"FAIL"];
            self.uut2BackgroudView.wantsLayer = YES;
            self.uut2BackgroudView.layer.backgroundColor = [NSColor redColor].CGColor;
            
        }else{
            [self.uut2ResultLabel setStringValue:@"PASS"];
            self.uut2BackgroudView.wantsLayer = YES;
            self.uut2BackgroudView.layer.backgroundColor = [NSColor greenColor].CGColor;
        }
    }else{
        
        if (!isPass) {
            
            [self.uut1ResultLabel setStringValue:@"FAIL"];
            self.uut2BackgroudView.wantsLayer = YES;
            self.uut1BackgroudView.layer.backgroundColor = [NSColor redColor].CGColor;
            
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *passCount = [defaults objectForKey:testPassCount];
            [defaults setObject:passCount forKey:testPassCount];
            //                [defaults synchronize];
            [self.uut1ResultLabel setStringValue:@"PASS"];
            self.uut2BackgroudView.wantsLayer = YES;
            self.uut1BackgroudView.layer.backgroundColor = [NSColor greenColor].CGColor;
        }
    }
    
}

#pragma mark SHOWINFO
-(void)showInfo
{
    [self.passCountView setStringValue:[NSString stringWithFormat:@"Pass:%@",[Account getAccountWithResult:YES]]];
    [self.failCountView setStringValue:[NSString stringWithFormat:@"Fail:%@",[Account getAccountWithResult:NO]]];
    [self.testCountView setStringValue:[NSString stringWithFormat:@"TotalCount:%@",[Account getTestTotalCount]]];
    [self.YieldView setStringValue:[NSString stringWithFormat:@"Yield:%%%.1f",[Account getTestYield]]];
}

#pragma mark - timer
-(void)startTimer:(NSTimer *)timer
{
    
    NSMutableDictionary *dict = timer.userInfo;
    int percens = [dict[time_percens] intValue];
    int seconds = [dict[time_seconds] intValue];
    //NSString *key = dict[time_key];
    percens++;
    
    if(percens==100){
        seconds++;
        percens = 0;
    }
    
    [dict setObject:[NSNumber numberWithInt:percens] forKey:time_percens];
    [dict setObject:[NSNumber numberWithInt:seconds] forKey:time_seconds];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dict[time_key] isEqualToString:key_uut2]) {
            [self.uut2TimeView setStringValue:[NSString stringWithFormat:@"%d.%ds",seconds,percens]];
        }else{
            [self.uut1TimeView setStringValue:[NSString stringWithFormat:@"%d.%ds",seconds,percens]];
        }
    });
}
#pragma mark - NSTextFieldDelegate
//- (void)controlTextDidChange:(NSNotification *)obj
//{
//    NSTextField *textField = obj.object;
//    if (textField.stringValue.length < snLength) return;
//    textField.enabled = NO;
//    if (textField == self.UUT1SNLabel) {
//        _sn1 = textField.stringValue;
//        if (self.uut2TextField.isEnabled) {
//            [self.uut2TextField becomeFirstResponder];
//        }
//        
//    }
//    if (textField == self.UUT2SNLabel) {
//        _sn2 = textField.stringValue;
//        if (self.uut1TextField.isEnabled) {
//            [self.uut1TextField becomeFirstResponder];
//        }
//        
//    }
//}



-(void)openSetting {
    
    NSString *prompt = @"PassWord Protected Function!!!";
    NSString *infoText = @"Please enter password to upload PDCA data:";
    NSString *defaultValue = @"Enter your password here";
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@",infoText];
    NSSecureTextField *input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    
    [input setPlaceholderString:defaultValue];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        if(![[input stringValue] isEqualToString:@"123"]){
            NSRunAlertPanel(@"Error",@"Password is not correct", @"OK", nil, nil);
        }
        else{
            
            [self presentViewControllerAsModalWindow:self.settingVC];
            //[NSApp runModalForWindow:_setwindow];
            //[NSApp stopModal];
            //[self.window beginSheet:_setwindow completionHandler:nil];
        }
        NSLog(@"User entered: %@", [input stringValue]);
    }
    else if (button == NSAlertAlternateReturn) {
        NSLog(@"User cancelled");
    }
    else{
        NSLog(@"Should never go here");
    }
    
}

- (IBAction)auditClick:(NSButton *)sender {
   
    NSString *prompt = @"PassWord Protected Function!!!";
    NSString *infoText = @"Please enter password to open Audit:";
    NSString *defaultValue = @"Enter your password here";
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@",infoText];
    NSSecureTextField *input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setPlaceholderString:defaultValue];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        
        [input validateEditing];
        if(![[input stringValue] isEqualToString:@"123"]){
         
            self.auditBtn.state = !self.auditBtn.state;
            NSRunAlertPanel(@"Error",@"Password is not correct", @"OK", nil, nil);
            
        }
        else{
            
            _auditCheck = sender.state;
            if (self.auditBtn.state) {
                self.view.wantsLayer = YES;//245 151,253//[NSColor colorWithRed:245 green:151 blue:253 alpha:0.7].CGColor;
                self.view.layer.backgroundColor = [NSColor colorWithRed:224.0/255.0 green:31.0/255.0 blue:225.0/255.0 alpha:0.6].CGColor;
            }else{
                self.view.wantsLayer = YES;//245 151,253//[NSColor colorWithRed:245 green:151 blue:253 alpha:0.7].CGColor;
                self.view.layer.backgroundColor = [NSColor clearColor].CGColor;
            }
            
        }
        NSLog(@"User entered: %@", [input stringValue]);
    }
    else if (button == NSAlertAlternateReturn) {
        NSLog(@"User cancelled");
        self.auditBtn.state = !self.auditBtn.state;
    }
    else{
        NSLog(@"Should never go here");
    }
    NSLog(@"11");
}

#pragma SettingViewControllerDelegate

-(void)settingViewControllerSave:(NSString *)title
{
    
    self.datasArray = [ConfigDatas getPlistDatas];
    //TestUnit
    UUT1TestData = [TestUnitData initalWithPlistName:title];
    UUT2TestData = [TestUnitData initalWithPlistName:title];
    [self.titleLabel setStringValue:title];
    fixtureID = [ConfigStation fixtureID];
    //    NSViewController *vc =self.parentViewController;
    //    self.parentViewController.title = title;
    [self.tableView reloadData];
}

-(void)settingViewControllerBobCatClick:(NSControlStateValue)checkState
{
    _bobCatCheck = checkState;
    NSLog(@"11");
}
-(void)settingViewControllerPuddingClick:(NSControlStateValue)puddingState
{
    _puddingCheck = puddingState;
    
    [self.PDCAIsShowView setHidden:puddingState];
    //[self.NOPDCA setHidden:puddingState];
    //puddingState ? [self endPDCATimer] : [self startPDCATimer] ;
    //
    if (!_puddingCheck) {
        _bobCatCheck = 0;
    }
    
}
//-(void)endPDCATimer
//{
//    [self.PDCAShowTimer invalidate];
//    self.PDCAShowTimer = nil;
//    timerScoend = 0;
//}
//-(void)startPDCATimer
//{
//    [self endPDCATimer];
//
//    self.PDCAShowTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startPDCATimer:) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.PDCAShowTimer forMode:NSRunLoopCommonModes];
//
//}
//
//-(void)startPDCATimer:(NSTimer *)timer
//{
//    timerScoend++;
//    if (timerScoend %3) {
//
//        [self.PDCAIsShowView setHidden:YES];
//        [NSThread sleepForTimeInterval:0.5];
//    }else{
//        [self.PDCAIsShowView setHidden:NO];
//    }
//
//   // NSMutableDictionary *dict = timer.userInfo;
//}
@end

