//
//  AppDelegate.h
//  iPortTest
//
//  Created by Zaffer.yang on 3/12/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TestEngine.h"
#import "QuickPudding.h"
#import "MapView.h"
#import "SettingWC.h"
#import "BaseMapPortWC.h"
#import "SNMapPortWC.h"
#import "ECodeMapPortWC.h"
#import "StationMapPortWC.h"
#import "ConfigWC.h"
#import "LoopTestViewController.h"
enum TestStatus
{
    UNREADY = -2,
    INIT = -1,
    READY = 0,
    TESTING = 1,
    CANCEL = 2,
    FINISH = 3,
    ERROR = 4,
    UPGRADE = 5,
    CONFIG = 6
};


@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate>
{
   // NSMutableArray *fwPath_Version;
    
    
    NSString* currentFWName;
    struct timeval startTime;
    NSTimer *cycleTimer,*detectTimer,*txtEditorTimer;
    NSMutableArray *TeEngArr;
    NSArray * debugSNs;
    TestEngine *testEng;
    bool isLatest;
    bool isStartTest;
    bool isUpdateFW;
    //    bool leftTest;
    //    bool rightTest;
    bool need_ccpintest;
    bool need_vbusest;
    bool allow_Ecode;
    int deviceCount;

    bool flushingFlag;

    dispatch_queue_t _queue;
    NSString *snOnLeft;
    NSString *snOnRight;

    NSTextField *leftTestedView;
    NSTextField *rightTestedView;
    NSTextField *leftScanView;
    NSTextField *rightScaniew;
    NSButton *leftEnableBtn;
    NSButton *rightEnableBtn;
    NSFileHandle *filehandler;
    NSTask *Task;

    // NSInteger itemCount;
    // NSInteger leftFailCount;
    // NSInteger rightFailCount;

    //NSInteger testItemcCount;
    
    enum TestStatus testStatus;
    //NSMutableDictionary<NSString *, QuickPudding *> * quickPuddingLefts;
    //NSMutableDictionary<NSString *, QuickPudding *> * quickPuddingRights;
    BOOL mytest;
    QuickPudding * quickPuddingLeft;
    QuickPudding * quickPuddingRight;

    NSDictionary *configDic;
    NSMutableArray* threadArr;
    NSMutableArray*
    allowedECode;
    NSArray *deviceArr;
    NSArray *snArr;
    

    NSMutableDictionary * extFlags;
    NSMutableDictionary * extItems;
    NSMutableSet * extNames;
    
    NSDate* startDate;
    NSDate* endDate;
    
    NSMutableArray *testItems;
    NSMutableArray *testLeftItems;
    NSMutableArray *testRightItems;
    NSMutableArray *failedItems;
    NSMutableArray *failedLeftItems;
    NSMutableArray *failedRightItems;
    
    NSArray *_commands;
   
    NSMutableArray *_tableItems;

    
    NSMutableArray *testCounts;

    // NSMutableArray *posArr;
    // NSMutableArray *netNameArr;
    // NSMutableArray *unitArr;
    
    // NSMutableArray *groupNameArr;
    // NSMutableArray *pinNumberArr;
    // NSMutableArray *typeArr;
    // NSMutableArray *openLimitArr;
    // NSMutableArray *shorLimitArr;
    // NSMutableArray *valueArr;
    // NSMutableArray *resultArr;

    // NSMutableArray *failItemArr;
    //    NSMutableArray *failonlyItemArr;
    //    NSMutableArray *failPosArr;
    //    NSMutableArray *failGroupNmeArr;
    //    NSMutableArray *failPinNumberArr;
    //    NSMutableArray *failNetNameArr;
    //    NSMutableArray *failTypeArr;
    //    NSMutableArray *failOpenLimitArr;
    //    NSMutableArray *failShortLimitArr;
    //    NSMutableArray *failValueArr;
    //    NSMutableArray *failUnitArr;
    //    NSMutableArray *failResultArr;

    BOOL _isTesting;
    BOOL _isInit;
//    BOOL _singPort;
    BOOL _queryProject;
    BOOL _checkGPU;
    BOOL _auditMode;
    BOOL _officeMode;
    BOOL _isA218;
    BOOL _isChangeBackGroudColorWithDefferentMode;
    BOOL _isQueryProject;//isCheckSum
//    BOOL _isCheckSum;//isCheckSum
    BOOL _isCheckEcode;
    NSInteger _testCount;
    NSInteger loopTimes;
    NSInteger delay;
    bool idVisible;
    bool looping;
    NSInteger testTimesForAudit;

    bool isUploadWithAllFail;
    bool isSignPort;
    bool isTestWithCapAndCap2;
    
    
    NSString* updateFWName;
    
    NSInteger allTestTimes;

    //    NSInteger leftPassCount;
    //    NSInteger leftFailCount;
    //
    //    NSInteger rightPassCount;
    //    NSInteger rightFailCount;

    NSString *product;
    NSString *stationID;
    NSString *siteID;
    NSString *stationName;
    NSString *displaName;
    NSString *buildStage;
    NSString *SFCQuerySwitch;
    NSString *SFC_URL;
    NSString *SFC_QUERY;
    
    NSDate *startdate;
    NSString *StartTestTime;
    NSString *EndTestTime;
    
    NSTimeInterval testTime;
    
    NSString *debugFileName;

    BOOL showMapView;
    BOOL showCardView;
    BOOL showCommandsView;
    
    BOOL showingMapView;
    BOOL showingCardView;
    BOOL showingCommandsView;
    BOOL isRootPwd;

//    NSString *_updateFWPath;
//    NSString *_configPath;
    bool firstMap2Right;
    bool posCheck;
    bool combineTest;
    bool singleDUT;
    bool testing1;
    bool testing2;
    bool testingLeft;
    bool testingRight;
}

@property (weak) IBOutlet NSView *groudView;
@property (weak) IBOutlet NSTextField *updateFWTitle;
@property (strong,nonatomic)ConfigWC *configWC;
@property (strong,nonatomic)StationMapPortWC *stationMapPortWC;
@property (strong,nonatomic)SNMapPortWC *mapPortWC;
@property (strong,nonatomic)ECodeMapPortWC *ecodeMapPortWC;
@property (strong,nonatomic)SettingWC *settingWC;
@property (strong,nonatomic)LoopTestViewController *loopWC;
@property (weak) IBOutlet NSTableView *commandsView;
@property (weak) IBOutlet NSTextField *lbTestStatus;
@property (weak) IBOutlet NSTextField *lbMode;
@property (weak) IBOutlet NSTextField *lbTimes;

@property (weak) IBOutlet NSTableView *testView;
@property (weak) IBOutlet NSTableView *failOnlyView;
@property (weak) IBOutlet NSTextField *testedSN1;
@property (weak) IBOutlet NSTextField *testedSN2;

@property (weak) IBOutlet NSTextField *countView;
@property (weak) IBOutlet NSTextField *lbTestTime;
@property (weak) IBOutlet NSTextField *txtScanSN1;
@property (weak) IBOutlet NSTextField *txtScanSN2;
@property (weak) IBOutlet NSTextField *labelSN1;
@property (weak) IBOutlet NSTextField *labelSN2;

@property (weak) IBOutlet NSWindow *LoginWindow;
@property (weak) IBOutlet NSWindow *MainWindow;
@property (weak) IBOutlet NSSecureTextField *txtPassword;
@property (weak) IBOutlet NSTextField *txtWarningInfo;

@property (weak) IBOutlet NSMenuItem *menueLogin;
@property (weak) IBOutlet NSMenuItem *menueLoadConfig;
@property (weak) IBOutlet NSMenuItem *menuUpdateFW;
@property (weak) IBOutlet NSMenuItem *menuSetting;
@property (weak) IBOutlet NSMenuItem *menuSNMap;
@property (weak) IBOutlet NSMenuItem *menuECodeMap;
@property (weak) IBOutlet NSMenuItem *menuStationMap;
@property (weak) IBOutlet NSMenuItem *menuLoopTest;

@property (weak) IBOutlet NSMenuItem *menueLogout;
@property (weak) IBOutlet NSTextField *lbSNwarningInfo;

@property (weak) IBOutlet NSButton *btnStart;

@property (weak) IBOutlet NSTabView *myTabView;
@property (weak) IBOutlet NSTextField *winTitle;

@property (weak) IBOutlet NSButton *debugBtn;

@property (weak) IBOutlet NSWindow *updateFWWindow;
@property (weak) IBOutlet NSProgressIndicator *fwProgressIndicator;
@property (weak) IBOutlet NSButton *configBtn;
@property (weak) IBOutlet NSTextField *lbFWUpdateStatus;
@property (weak) IBOutlet NSTextField *lbVersion;
@property (weak) IBOutlet NSTextField *lbBuildTime;

@property (weak) IBOutlet NSTextField *lbStatusTitle;
// @property (weak) IBOutlet NSTextField *lbUpdateFW;
@property (weak) IBOutlet NSMenuItem *menuFunction;
@property (weak) IBOutlet NSMenuItem *menuAdmin;
@property (weak) IBOutlet NSTableColumn *devIdColumn;
@property (weak) IBOutlet NSTableColumn *itemIdColumn;
@property (weak) IBOutlet NSTableColumn *failedDevIdColumn;
@property (weak) IBOutlet NSTableColumn *failedItemIdColumn;

//for mapView.
@property (weak) IBOutlet MapView *mapView;
@property (weak) IBOutlet NSTabViewItem *mapViewTabViewItem;
@property (weak) IBOutlet NSTabViewItem *commandsTabViewItem;
@property (weak) IBOutlet NSTabViewItem *cardTabViewItem;

@property (weak) IBOutlet NSBox *leftBox;
@property (weak) IBOutlet NSBox *rightBox;

@property (weak) IBOutlet NSTextField *lblfpos;
@property (weak) IBOutlet NSTextField *lbRtpos;

@property (weak) IBOutlet NSTextField *lbleftResult;
@property (weak) IBOutlet NSTextField *lbRightResult;

@property (weak) IBOutlet NSTextField *lbAdjShort;
@property (weak) IBOutlet NSTextField *titleSN2;
@property (weak) IBOutlet NSTextField *titleTestedSN2;

@property (weak) IBOutlet NSTextField *lbLefta1_2;
@property (weak) IBOutlet NSTextField *lbLefta2_3;
@property (weak) IBOutlet NSTextField *lbLefta3_4;
@property (weak) IBOutlet NSTextField *lbLefta4_5;
@property (weak) IBOutlet NSTextField *lbLefta5_6;
@property (weak) IBOutlet NSTextField *lbLefta6_7;
@property (weak) IBOutlet NSTextField *lbLefta7_8;
@property (weak) IBOutlet NSTextField *lbLefta8_9;
@property (weak) IBOutlet NSTextField *lbLefta9_10;
@property (weak) IBOutlet NSTextField *lbLefta10_11;
@property (weak) IBOutlet NSTextField *lbLefta11_12;
@property (weak) IBOutlet NSTextField *lbLeftb1_2;
@property (weak) IBOutlet NSTextField *lbLeftb2_3;
@property (weak) IBOutlet NSTextField *lbLeftb3_4;
@property (weak) IBOutlet NSTextField *lbLeftb4_5;
@property (weak) IBOutlet NSTextField *lbLeftb5_6;
@property (weak) IBOutlet NSTextField *lbLeftb6_7;
@property (weak) IBOutlet NSTextField *lbLeftb7_8;
@property (weak) IBOutlet NSTextField *lbLeftb8_9;
@property (weak) IBOutlet NSTextField *lbLeftb9_10;
@property (weak) IBOutlet NSTextField *lbLeftb10_11;
@property (weak) IBOutlet NSTextField *lbLeftb11_12;

@property (weak) IBOutlet NSButton *btLefta1;
@property (weak) IBOutlet NSButton *btLefta2;
@property (weak) IBOutlet NSButton *btLefta3;
@property (weak) IBOutlet NSButton *btLefta4;
@property (weak) IBOutlet NSButton *btLefta5;
@property (weak) IBOutlet NSButton *btLefta6;
@property (weak) IBOutlet NSButton *btLefta7;
@property (weak) IBOutlet NSButton *btLefta8;
@property (weak) IBOutlet NSButton *btLefta9;
@property (weak) IBOutlet NSButton *btLefta10;
@property (weak) IBOutlet NSButton *btLefta11;
@property (weak) IBOutlet NSButton *btLefta12;
@property (weak) IBOutlet NSButton *btLeftb1;
@property (weak) IBOutlet NSButton *btLeftb2;
@property (weak) IBOutlet NSButton *btLeftb3;
@property (weak) IBOutlet NSButton *btLeftb4;
@property (weak) IBOutlet NSButton *btLeftb5;
@property (weak) IBOutlet NSButton *btLeftb6;
@property (weak) IBOutlet NSButton *btLeftb7;
@property (weak) IBOutlet NSButton *btLeftb8;
@property (weak) IBOutlet NSButton *btLeftb9;
@property (weak) IBOutlet NSButton *btLeftb10;
@property (weak) IBOutlet NSButton *btLeftb11;
@property (weak) IBOutlet NSButton *btLeftb12;

@property (weak) IBOutlet NSTextField *lbRighta1_2;
@property (weak) IBOutlet NSTextField *lbRighta2_3;
@property (weak) IBOutlet NSTextField *lbRighta3_4;
@property (weak) IBOutlet NSTextField *lbRighta4_5;
@property (weak) IBOutlet NSTextField *lbRighta5_6;
@property (weak) IBOutlet NSTextField *lbRighta6_7;
@property (weak) IBOutlet NSTextField *lbRighta7_8;
@property (weak) IBOutlet NSTextField *lbRighta8_9;
@property (weak) IBOutlet NSTextField *lbRighta9_10;
@property (weak) IBOutlet NSTextField *lbRighta10_11;
@property (weak) IBOutlet NSTextField *lbRighta11_12;
@property (weak) IBOutlet NSTextField *lbRightb1_2;
@property (weak) IBOutlet NSTextField *lbRightb2_3;
@property (weak) IBOutlet NSTextField *lbRightb3_4;
@property (weak) IBOutlet NSTextField *lbRightb4_5;
@property (weak) IBOutlet NSTextField *lbRightb5_6;
@property (weak) IBOutlet NSTextField *lbRightb6_7;
@property (weak) IBOutlet NSTextField *lbRightb7_8;
@property (weak) IBOutlet NSTextField *lbRightb8_9;
@property (weak) IBOutlet NSTextField *lbRightb9_10;
@property (weak) IBOutlet NSTextField *lbRightb10_11;
@property (weak) IBOutlet NSTextField *lbRightb11_12;

@property (weak) IBOutlet NSButton *btRighta1;
@property (weak) IBOutlet NSButton *btRighta2;
@property (weak) IBOutlet NSButton *btRighta3;
@property (weak) IBOutlet NSButton *btRighta4;
@property (weak) IBOutlet NSButton *btRighta5;
@property (weak) IBOutlet NSButton *btRighta6;
@property (weak) IBOutlet NSButton *btRighta7;
@property (weak) IBOutlet NSButton *btRighta8;
@property (weak) IBOutlet NSButton *btRighta9;
@property (weak) IBOutlet NSButton *btRighta10;
@property (weak) IBOutlet NSButton *btRighta11;
@property (weak) IBOutlet NSButton *btRighta12;
@property (weak) IBOutlet NSButton *btRightb1;
@property (weak) IBOutlet NSButton *btRightb2;
@property (weak) IBOutlet NSButton *btRightb3;
@property (weak) IBOutlet NSButton *btRightb4;
@property (weak) IBOutlet NSButton *btRightb5;
@property (weak) IBOutlet NSButton *btRightb6;
@property (weak) IBOutlet NSButton *btRightb7;
@property (weak) IBOutlet NSButton *btRightb8;
@property (weak) IBOutlet NSButton *btRightb9;
@property (weak) IBOutlet NSButton *btRightb10;
@property (weak) IBOutlet NSButton *btRightb11;
@property (weak) IBOutlet NSButton *btRightb12;
@property (weak) IBOutlet NSButton *EnableSN1;
@property (weak) IBOutlet NSButton *EnableSN2;
- (IBAction)SwitchClick:(id)sender;

//for test view table
//@property(readwrite) NSString *Number;
//@property(readwrite) NSString *Pos;
//@property(readwrite) NSString *GroupNme;
//@property(readwrite) NSString *ItemName;
//@property(readwrite) NSString *Type;
//@property(readwrite) NSString *OpenLimit;
//@property(readwrite) NSString *ShortLimit;
//@property(readwrite) NSString *Value;
//@property(readwrite) NSString *Unit;
//@property(readwrite) NSString *Result;

@end

