//
//  AppDelegate.h
//  B288
//
//  Created by 罗婷 on 16/2/23.
//  Copyright (c) 2016年 Vicky Luo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSVLog.h"
#import "Config.h"
#import "BoardController.h"
#import "SerialNameScan.h"
#import "pudding.h"
#import "PoolPDCA.h"


float Softversion,Hardversion,Slot;



typedef struct{
    float vCur;
    float vVolt;
    float vPercent;
    float vLid;
}PDCA_DATA;

@interface DataRecord : NSObject
{
    PDCA_DATA PDCAData[DATA_POINTS];
}
@property int index;
@property NSString *SN;
@property NSString *product;
@property NSString *stationID;
@property bool bPass;
//@property NSString *StartTime;
//@property NSString *EndTime;
@property time_t StartTime;
@property time_t EndTime;
@property bool bFinished;




-(id)init;
-(void)setValue:(PDCA_DATA)val forIdx:(int)idx;
-(PDCA_DATA *)getDataArray;
-(NSString *)getDataString:(int)index;
@end

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>
{
    NSMutableArray* m_PortNameArray;
    NSArray* m_SavePortName;
    BoardController* m_Board[MAX_BOARD];
    CSVLog* m_Log;
    SerialNameScan	*scanPort;
    NSInteger PortIndex;
    NSInteger startone;
    NSInteger tunnel;
    BOOL START;
    BOOL PDCA_flag;
    BOOL Bobcat_flag;
    BOOL Audit_flag;
    NSString *appSW;
    NSInteger TimeCount;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *setwindow;
@property (weak) IBOutlet NSTextField *SWindication;
@property (weak) IBOutlet NSButton *Audit_check;
@property (weak) IBOutlet NSButton *PDCA_check;
@property (weak) IBOutlet NSButton *Bobcat_check;
@property (weak) IBOutlet NSTextField *ChargeYellow;
@property (weak) IBOutlet NSTextField *ChargeGreen;

@property (weak) IBOutlet NSTextField *ChargePurple;

@property (weak) IBOutlet NSTextField *Board1Port1SN1;
@property (weak) IBOutlet NSTextField *Board1Port2SN2;
@property (weak) IBOutlet NSTextField *Board1Port3SN3;
@property (weak) IBOutlet NSTextField *Board1Port4SN4;
@property (weak) IBOutlet NSTextField *Board1Port5SN5;
@property (weak) IBOutlet NSTextField *Board1Port6SN6;
@property (weak) IBOutlet NSTextField *Board1Port7SN7;
@property (weak) IBOutlet NSTextField *Board1Port8SN8;
@property (weak) IBOutlet NSTextField *Board1Port9SN9;
@property (weak) IBOutlet NSTextField *Board1Port10SN10;

@property (weak) IBOutlet NSTextField *Board2Port1SN11;
@property (weak) IBOutlet NSTextField *Board2Port2SN12;
@property (weak) IBOutlet NSTextField *Board2Port3SN13;
@property (weak) IBOutlet NSTextField *Board2Port4SN14;
@property (weak) IBOutlet NSTextField *Board2Port5SN15;
@property (weak) IBOutlet NSTextField *Board2Port6SN16;
@property (weak) IBOutlet NSTextField *Board2Port7SN17;
@property (weak) IBOutlet NSTextField *Board2Port8SN18;
@property (weak) IBOutlet NSTextField *Board2Port9SN19;
@property (weak) IBOutlet NSTextField *Board2Port10SN20;

@property (weak) IBOutlet NSTextField *Board3Port1SN21;
@property (weak) IBOutlet NSTextField *Board3Port2SN22;
@property (weak) IBOutlet NSTextField *Board3Port3SN23;
@property (weak) IBOutlet NSTextField *Board3Port4SN24;
@property (weak) IBOutlet NSTextField *Board3Port5SN25;
@property (weak) IBOutlet NSTextField *Board3Port6SN26;
@property (weak) IBOutlet NSTextField *Board3Port7SN27;
@property (weak) IBOutlet NSTextField *Board3Port8SN28;
@property (weak) IBOutlet NSTextField *Board3Port9SN29;
@property (weak) IBOutlet NSTextField *Board3Port10SN30;


@property (weak) IBOutlet NSTextField *DUT1Current1;
@property (weak) IBOutlet NSTextField *DUT1Current2;
@property (weak) IBOutlet NSTextField *DUT1Current3;

@property (weak) IBOutlet NSTextField *DUT2Current1;
@property (weak) IBOutlet NSTextField *DUT2Current2;
@property (weak) IBOutlet NSTextField *DUT2Current3;

@property (weak) IBOutlet NSTextField *DUT3Current1;
@property (weak) IBOutlet NSTextField *DUT3Current2;
@property (weak) IBOutlet NSTextField *DUT3Current3;

@property (weak) IBOutlet NSTextField *DUT4Current1;
@property (weak) IBOutlet NSTextField *DUT4Current2;
@property (weak) IBOutlet NSTextField *DUT4Current3;

@property (weak) IBOutlet NSTextField *DUT5Current1;
@property (weak) IBOutlet NSTextField *DUT5Current2;
@property (weak) IBOutlet NSTextField *DUT5Current3;

@property (weak) IBOutlet NSTextField *DUT6Current1;
@property (weak) IBOutlet NSTextField *DUT6Current2;
@property (weak) IBOutlet NSTextField *DUT6Current3;

@property (weak) IBOutlet NSTextField *DUT7Current1;
@property (weak) IBOutlet NSTextField *DUT7Current2;
@property (weak) IBOutlet NSTextField *DUT7Current3;

@property (weak) IBOutlet NSTextField *DUT8Current1;
@property (weak) IBOutlet NSTextField *DUT8Current2;
@property (weak) IBOutlet NSTextField *DUT8Current3;

@property (weak) IBOutlet NSTextField *DUT9Current1;
@property (weak) IBOutlet NSTextField *DUT9Current2;
@property (weak) IBOutlet NSTextField *DUT9Current3;

@property (weak) IBOutlet NSTextField *DUT10Current1;
@property (weak) IBOutlet NSTextField *DUT10Current2;
@property (weak) IBOutlet NSTextField *DUT10Current3;

@property (weak) IBOutlet NSTextField *DUT11Current1;
@property (weak) IBOutlet NSTextField *DUT11Current2;
@property (weak) IBOutlet NSTextField *DUT11Current3;

@property (weak) IBOutlet NSTextField *DUT12Current1;
@property (weak) IBOutlet NSTextField *DUT12Current2;
@property (weak) IBOutlet NSTextField *DUT12Current3;

@property (weak) IBOutlet NSTextField *DUT13Current1;
@property (weak) IBOutlet NSTextField *DUT13Current2;
@property (weak) IBOutlet NSTextField *DUT13Current3;

@property (weak) IBOutlet NSTextField *DUT14Current1;
@property (weak) IBOutlet NSTextField *DUT14Current2;
@property (weak) IBOutlet NSTextField *DUT14Current3;

@property (weak) IBOutlet NSTextField *DUT15Current1;
@property (weak) IBOutlet NSTextField *DUT15Current2;
@property (weak) IBOutlet NSTextField *DUT15Current3;

@property (weak) IBOutlet NSTextField *DUT16Current1;
@property (weak) IBOutlet NSTextField *DUT16Current2;
@property (weak) IBOutlet NSTextField *DUT16Current3;

@property (weak) IBOutlet NSTextField *DUT17Current1;
@property (weak) IBOutlet NSTextField *DUT17Current2;
@property (weak) IBOutlet NSTextField *DUT17Current3;

@property (weak) IBOutlet NSTextField *DUT18Current1;
@property (weak) IBOutlet NSTextField *DUT18Current2;
@property (weak) IBOutlet NSTextField *DUT18Current3;

@property (weak) IBOutlet NSTextField *DUT19Current1;
@property (weak) IBOutlet NSTextField *DUT19Current2;
@property (weak) IBOutlet NSTextField *DUT19Current3;

@property (weak) IBOutlet NSTextField *DUT20Current1;
@property (weak) IBOutlet NSTextField *DUT20Current2;
@property (weak) IBOutlet NSTextField *DUT20Current3;

@property (weak) IBOutlet NSTextField *DUT21Current1;
@property (weak) IBOutlet NSTextField *DUT21Current2;
@property (weak) IBOutlet NSTextField *DUT21Current3;

@property (weak) IBOutlet NSTextField *DUT22Current1;
@property (weak) IBOutlet NSTextField *DUT22Current2;
@property (weak) IBOutlet NSTextField *DUT22Current3;

@property (weak) IBOutlet NSTextField *DUT23Current1;
@property (weak) IBOutlet NSTextField *DUT23Current2;
@property (weak) IBOutlet NSTextField *DUT23Current3;

@property (weak) IBOutlet NSTextField *DUT24Current1;
@property (weak) IBOutlet NSTextField *DUT24Current2;
@property (weak) IBOutlet NSTextField *DUT24Current3;

@property (weak) IBOutlet NSTextField *DUT25Current1;
@property (weak) IBOutlet NSTextField *DUT25Current2;
@property (weak) IBOutlet NSTextField *DUT25Current3;

@property (weak) IBOutlet NSTextField *DUT26Current1;
@property (weak) IBOutlet NSTextField *DUT26Current2;
@property (weak) IBOutlet NSTextField *DUT26Current3;

@property (weak) IBOutlet NSTextField *DUT27Current1;
@property (weak) IBOutlet NSTextField *DUT27Current2;
@property (weak) IBOutlet NSTextField *DUT27Current3;

@property (weak) IBOutlet NSTextField *DUT28Current1;
@property (weak) IBOutlet NSTextField *DUT28Current2;
@property (weak) IBOutlet NSTextField *DUT28Current3;

@property (weak) IBOutlet NSTextField *DUT29Current1;
@property (weak) IBOutlet NSTextField *DUT29Current2;
@property (weak) IBOutlet NSTextField *DUT29Current3;

@property (weak) IBOutlet NSTextField *DUT30Current1;
@property (weak) IBOutlet NSTextField *DUT30Current2;
@property (weak) IBOutlet NSTextField *DUT30Current3;



@property (weak) IBOutlet NSTextField *Counter1;
@property (weak) IBOutlet NSTextField *Counter2;
@property (weak) IBOutlet NSTextField *Counter3;
@property (weak) IBOutlet NSTextField *Counter4;
@property (weak) IBOutlet NSTextField *Counter5;

@property (weak) IBOutlet NSTextField *Counter6;
@property (weak) IBOutlet NSTextField *Counter7;
@property (weak) IBOutlet NSTextField *Counter8;
@property (weak) IBOutlet NSTextField *Counter9;
@property (weak) IBOutlet NSTextField *Counter10;

@property (weak) IBOutlet NSTextField *Counter11;
@property (weak) IBOutlet NSTextField *Counter12;
@property (weak) IBOutlet NSTextField *Counter13;
@property (weak) IBOutlet NSTextField *Counter14;
@property (weak) IBOutlet NSTextField *Counter15;

@property (weak) IBOutlet NSTextField *Counter16;
@property (weak) IBOutlet NSTextField *Counter17;
@property (weak) IBOutlet NSTextField *Counter18;
@property (weak) IBOutlet NSTextField *Counter19;
@property (weak) IBOutlet NSTextField *Counter20;

@property (weak) IBOutlet NSTextField *Counter21;
@property (weak) IBOutlet NSTextField *Counter22;
@property (weak) IBOutlet NSTextField *Counter23;
@property (weak) IBOutlet NSTextField *Counter24;
@property (weak) IBOutlet NSTextField *Counter25;

@property (weak) IBOutlet NSTextField *Counter26;
@property (weak) IBOutlet NSTextField *Counter27;
@property (weak) IBOutlet NSTextField *Counter28;
@property (weak) IBOutlet NSTextField *Counter29;
@property (weak) IBOutlet NSTextField *Counter30;
@property (weak) IBOutlet NSTextField *FixtureSNText;
@property (weak) IBOutlet NSTextField *FixtureNumberShows;

@property (weak) IBOutlet NSButton *startBtn;


- (NSMutableArray*)ScanPort;

- (IBAction)Start:(id)sender;
- (IBAction)Stop:(id)sender;
- (IBAction)PDCA_Upload_Control:(id)sender;
- (IBAction)StartR:(id)sender;
- (IBAction)Bobcat_Upload_Control:(id)sender;
- (IBAction)SetWindow:(id)sender;
- (IBAction)Audit_Control:(id)sender;
- (IBAction)Exit_setWindow:(id)sender;
- (IBAction)SaveSNNumber:(id)sender;
@end
