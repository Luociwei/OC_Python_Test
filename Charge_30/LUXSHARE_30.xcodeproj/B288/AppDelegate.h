//
//  AppDelegate.h
//  B235
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

@interface DataRecord : NSObject 
{
    NSInteger vCurrent[14];
}
@property int index;
@property NSString *SN;
@property NSString *product;
@property NSString *stationID;
@property bool bPass;
@property NSString *StartTime;
@property NSString *EndTime;
@property bool bFinished;

-(id)init;
-(void)setValue:(NSInteger)val forIdx:(int)idx;
-(NSInteger *)getDataArray;
-(NSString *)getDataString;
@end

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>
{
NSMutableArray* m_PortNameArray;
NSArray* m_SavePortName;
BoardController* m_Board;
CSVLog* m_Log;
SerialNameScan	*scanPort;
NSInteger TimeCount;
NSInteger PortIndex;
NSInteger CurrentOfBlueUpper;
NSInteger CurrentOfGreenUpper;
NSInteger CurrentOfGreenLower;
NSInteger CurrentOfOrangeUpper;
NSInteger CurrentOfOrangeLower;
NSInteger CurrentOfWriteUpper;
NSInteger DUTCurrentCount;
NSInteger startone;
BOOL START;
IBOutlet NSTextField* BoardIndex;
}

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *Board1Port1SN1;
@property (weak) IBOutlet NSTextField *Board1Port2SN2;
@property (weak) IBOutlet NSTextField *Board1Port3SN3;
@property (weak) IBOutlet NSTextField *Board1Port4SN4;
@property (weak) IBOutlet NSTextField *Board1Port5SN5;
@property (weak) IBOutlet NSTextField *Board1Port6SN6;
@property (weak) IBOutlet NSTextField *Board1Port7SN7;
@property (weak) IBOutlet NSTextField *Board1Port8SN8;

@property (weak) IBOutlet NSTextField *Board2Port1SN9;
@property (weak) IBOutlet NSTextField *Board2Port2SN10;
@property (weak) IBOutlet NSTextField *Board2Port3SN11;
@property (weak) IBOutlet NSTextField *Board2Port4SN12;
@property (weak) IBOutlet NSTextField *Board2Port5SN13;
@property (weak) IBOutlet NSTextField *Board2Port6SN14;
@property (weak) IBOutlet NSTextField *Board2Port7SN15;
@property (weak) IBOutlet NSTextField *Board2Port8SN16;

@property (weak) IBOutlet NSTextField *Board3Port1SN17;
@property (weak) IBOutlet NSTextField *Board3Port2SN18;
@property (weak) IBOutlet NSTextField *Board3Port3SN19;
@property (weak) IBOutlet NSTextField *Board3Port4SN20;


@property (weak) IBOutlet NSTextField *Board4Port1SN21;
@property (weak) IBOutlet NSTextField *Board4Port2SN22;
@property (weak) IBOutlet NSTextField *Board4Port3SN23;
@property (weak) IBOutlet NSTextField *Board4Port4SN24;
@property (weak) IBOutlet NSTextField *Board4Port5SN25;
@property (weak) IBOutlet NSTextField *Board4Port6SN26;
@property (weak) IBOutlet NSTextField *Board4Port7SN27;
@property (weak) IBOutlet NSTextField *Board4Port8SN28;

@property (weak) IBOutlet NSTextField *Board5Port1SN29;
@property (weak) IBOutlet NSTextField *Board5Port2SN30;
@property (weak) IBOutlet NSTextField *Board5Port3SN31;
@property (weak) IBOutlet NSTextField *Board5Port4SN32;
@property (weak) IBOutlet NSTextField *Board5Port5SN33;
@property (weak) IBOutlet NSTextField *Board5Port6SN34;
@property (weak) IBOutlet NSTextField *Board5Port7SN35;
@property (weak) IBOutlet NSTextField *Board5Port8SN36;

@property (weak) IBOutlet NSTextField *Board6Port1SN37;
@property (weak) IBOutlet NSTextField *Board6Port2SN38;
@property (weak) IBOutlet NSTextField *Board6Port3SN39;
@property (weak) IBOutlet NSTextField *Board6Port4SN40;


@property (weak) IBOutlet NSTextField *Board7Port1SN41;
@property (weak) IBOutlet NSTextField *Board7Port2SN42;
@property (weak) IBOutlet NSTextField *Board7Port3SN43;
@property (weak) IBOutlet NSTextField *Board7Port4SN44;
@property (weak) IBOutlet NSTextField *Board7Port5SN45;
@property (weak) IBOutlet NSTextField *Board7Port6SN46;
@property (weak) IBOutlet NSTextField *Board7Port7SN47;
@property (weak) IBOutlet NSTextField *Board7Port8SN48;

@property (weak) IBOutlet NSTextField *Board8Port1SN49;
@property (weak) IBOutlet NSTextField *Board8Port2SN50;
@property (weak) IBOutlet NSTextField *Board8Port3SN51;
@property (weak) IBOutlet NSTextField *Board8Port4SN52;
@property (weak) IBOutlet NSTextField *Board8Port5SN53;
@property (weak) IBOutlet NSTextField *Board8Port6SN54;
@property (weak) IBOutlet NSTextField *Board8Port7SN55;
@property (weak) IBOutlet NSTextField *Board8Port8SN56;

@property (weak) IBOutlet NSTextField *Board9Port1SN57;
@property (weak) IBOutlet NSTextField *Board9Port2SN58;
@property (weak) IBOutlet NSTextField *Board9Port3SN59;
@property (weak) IBOutlet NSTextField *Board9Port4SN60;

@property (weak) IBOutlet NSTextField *Board10Port1SN61;
@property (weak) IBOutlet NSTextField *Board10Port2SN62;
@property (weak) IBOutlet NSTextField *Board10Port3SN63;
@property (weak) IBOutlet NSTextField *Board10Port4SN64;
@property (weak) IBOutlet NSTextField *Board10Port5SN65;
@property (weak) IBOutlet NSTextField *Board10Port6SN66;
@property (weak) IBOutlet NSTextField *Board10Port7SN67;
@property (weak) IBOutlet NSTextField *Board10Port8SN68;

@property (weak) IBOutlet NSTextField *Board11Port1SN69;
@property (weak) IBOutlet NSTextField *Board11Port2SN70;
@property (weak) IBOutlet NSTextField *Board11Port3SN71;
@property (weak) IBOutlet NSTextField *Board11Port4SN72;
@property (weak) IBOutlet NSTextField *Board11Port5SN73;
@property (weak) IBOutlet NSTextField *Board11Port6SN74;
@property (weak) IBOutlet NSTextField *Board11Port7SN75;
@property (weak) IBOutlet NSTextField *Board11Port8SN76;

@property (weak) IBOutlet NSTextField *Board12Port1SN77;
@property (weak) IBOutlet NSTextField *Board12Port2SN78;
@property (weak) IBOutlet NSTextField *Board12Port3SN79;
@property (weak) IBOutlet NSTextField *Board12Port4SN80;

@property (weak) IBOutlet NSTextField *Board13Port1SN81;
@property (weak) IBOutlet NSTextField *Board13Port2SN82;
@property (weak) IBOutlet NSTextField *Board13Port3SN83;
@property (weak) IBOutlet NSTextField *Board13Port4SN84;
@property (weak) IBOutlet NSTextField *Board13Port5SN85;
@property (weak) IBOutlet NSTextField *Board13Port6SN86;
@property (weak) IBOutlet NSTextField *Board13Port7SN87;
@property (weak) IBOutlet NSTextField *Board13Port8SN88;

@property (weak) IBOutlet NSTextField *Board14Port1SN89;
@property (weak) IBOutlet NSTextField *Board14Port2SN90;
@property (weak) IBOutlet NSTextField *Board14Port3SN91;
@property (weak) IBOutlet NSTextField *Board14Port4SN92;
@property (weak) IBOutlet NSTextField *Board14Port5SN93;
@property (weak) IBOutlet NSTextField *Board14Port6SN94;
@property (weak) IBOutlet NSTextField *Board14Port7SN95;
@property (weak) IBOutlet NSTextField *Board14Port8SN96;

@property (weak) IBOutlet NSTextField *Board15Port1SN97;
@property (weak) IBOutlet NSTextField *Board15Port2SN98;
@property (weak) IBOutlet NSTextField *Board15Port3SN99;
@property (weak) IBOutlet NSTextField *Board15Port4SN100;



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

@property (weak) IBOutlet NSTextField *DUT31Current1;
@property (weak) IBOutlet NSTextField *DUT31Current2;
@property (weak) IBOutlet NSTextField *DUT31Current3;

@property (weak) IBOutlet NSTextField *DUT32Current1;
@property (weak) IBOutlet NSTextField *DUT32Current2;
@property (weak) IBOutlet NSTextField *DUT32Current3;

@property (weak) IBOutlet NSTextField *DUT33Current1;
@property (weak) IBOutlet NSTextField *DUT33Current2;
@property (weak) IBOutlet NSTextField *DUT33Current3;

@property (weak) IBOutlet NSTextField *DUT34Current1;
@property (weak) IBOutlet NSTextField *DUT34Current2;
@property (weak) IBOutlet NSTextField *DUT34Current3;

@property (weak) IBOutlet NSTextField *DUT35Current1;
@property (weak) IBOutlet NSTextField *DUT35Current2;
@property (weak) IBOutlet NSTextField *DUT35Current3;

@property (weak) IBOutlet NSTextField *DUT36Current1;
@property (weak) IBOutlet NSTextField *DUT36Current2;
@property (weak) IBOutlet NSTextField *DUT36Current3;

@property (weak) IBOutlet NSTextField *DUT37Current1;
@property (weak) IBOutlet NSTextField *DUT37Current2;
@property (weak) IBOutlet NSTextField *DUT37Current3;

@property (weak) IBOutlet NSTextField *DUT38Current1;
@property (weak) IBOutlet NSTextField *DUT38Current2;
@property (weak) IBOutlet NSTextField *DUT38Current3;

@property (weak) IBOutlet NSTextField *DUT39Current1;
@property (weak) IBOutlet NSTextField *DUT39Current2;
@property (weak) IBOutlet NSTextField *DUT39Current3;

@property (weak) IBOutlet NSTextField *DUT40Current1;
@property (weak) IBOutlet NSTextField *DUT40Current2;
@property (weak) IBOutlet NSTextField *DUT40Current3;

@property (weak) IBOutlet NSTextField *DUT41Current1;
@property (weak) IBOutlet NSTextField *DUT41Current2;
@property (weak) IBOutlet NSTextField *DUT41Current3;

@property (weak) IBOutlet NSTextField *DUT42Current1;
@property (weak) IBOutlet NSTextField *DUT42Current2;
@property (weak) IBOutlet NSTextField *DUT42Current3;

@property (weak) IBOutlet NSTextField *DUT43Current1;
@property (weak) IBOutlet NSTextField *DUT43Current2;
@property (weak) IBOutlet NSTextField *DUT43Current3;

@property (weak) IBOutlet NSTextField *DUT44Current1;
@property (weak) IBOutlet NSTextField *DUT44Current2;
@property (weak) IBOutlet NSTextField *DUT44Current3;

@property (weak) IBOutlet NSTextField *DUT45Current1;
@property (weak) IBOutlet NSTextField *DUT45Current2;
@property (weak) IBOutlet NSTextField *DUT45Current3;

@property (weak) IBOutlet NSTextField *DUT46Current1;
@property (weak) IBOutlet NSTextField *DUT46Current2;
@property (weak) IBOutlet NSTextField *DUT46Current3;

@property (weak) IBOutlet NSTextField *DUT47Current1;
@property (weak) IBOutlet NSTextField *DUT47Current2;
@property (weak) IBOutlet NSTextField *DUT47Current3;

@property (weak) IBOutlet NSTextField *DUT48Current1;
@property (weak) IBOutlet NSTextField *DUT48Current2;
@property (weak) IBOutlet NSTextField *DUT48Current3;

@property (weak) IBOutlet NSTextField *DUT49Current1;
@property (weak) IBOutlet NSTextField *DUT49Current2;
@property (weak) IBOutlet NSTextField *DUT49Current3;

@property (weak) IBOutlet NSTextField *DUT50Current1;
@property (weak) IBOutlet NSTextField *DUT50Current2;
@property (weak) IBOutlet NSTextField *DUT50Current3;

@property (weak) IBOutlet NSTextField *DUT51Current1;
@property (weak) IBOutlet NSTextField *DUT51Current2;
@property (weak) IBOutlet NSTextField *DUT51Current3;

@property (weak) IBOutlet NSTextField *DUT52Current1;
@property (weak) IBOutlet NSTextField *DUT52Current2;
@property (weak) IBOutlet NSTextField *DUT52Current3;

@property (weak) IBOutlet NSTextField *DUT53Current1;
@property (weak) IBOutlet NSTextField *DUT53Current2;
@property (weak) IBOutlet NSTextField *DUT53Current3;

@property (weak) IBOutlet NSTextField *DUT54Current1;
@property (weak) IBOutlet NSTextField *DUT54Current2;
@property (weak) IBOutlet NSTextField *DUT54Current3;

@property (weak) IBOutlet NSTextField *DUT55Current1;
@property (weak) IBOutlet NSTextField *DUT55Current2;
@property (weak) IBOutlet NSTextField *DUT55Current3;

@property (weak) IBOutlet NSTextField *DUT56Current1;
@property (weak) IBOutlet NSTextField *DUT56Current2;
@property (weak) IBOutlet NSTextField *DUT56Current3;

@property (weak) IBOutlet NSTextField *DUT57Current1;
@property (weak) IBOutlet NSTextField *DUT57Current2;
@property (weak) IBOutlet NSTextField *DUT57Current3;

@property (weak) IBOutlet NSTextField *DUT58Current1;
@property (weak) IBOutlet NSTextField *DUT58Current2;
@property (weak) IBOutlet NSTextField *DUT58Current3;

@property (weak) IBOutlet NSTextField *DUT59Current1;
@property (weak) IBOutlet NSTextField *DUT59Current2;
@property (weak) IBOutlet NSTextField *DUT59Current3;

@property (weak) IBOutlet NSTextField *DUT60Current1;
@property (weak) IBOutlet NSTextField *DUT60Current2;
@property (weak) IBOutlet NSTextField *DUT60Current3;

@property (weak) IBOutlet NSTextField *DUT61Current1;
@property (weak) IBOutlet NSTextField *DUT61Current2;
@property (weak) IBOutlet NSTextField *DUT61Current3;

@property (weak) IBOutlet NSTextField *DUT62Current1;
@property (weak) IBOutlet NSTextField *DUT62Current2;
@property (weak) IBOutlet NSTextField *DUT62Current3;

@property (weak) IBOutlet NSTextField *DUT63Current1;
@property (weak) IBOutlet NSTextField *DUT63Current2;
@property (weak) IBOutlet NSTextField *DUT63Current3;

@property (weak) IBOutlet NSTextField *DUT64Current1;
@property (weak) IBOutlet NSTextField *DUT64Current2;
@property (weak) IBOutlet NSTextField *DUT64Current3;

@property (weak) IBOutlet NSTextField *DUT65Current1;
@property (weak) IBOutlet NSTextField *DUT65Current2;
@property (weak) IBOutlet NSTextField *DUT65Current3;

@property (weak) IBOutlet NSTextField *DUT66Current1;
@property (weak) IBOutlet NSTextField *DUT66Current2;
@property (weak) IBOutlet NSTextField *DUT66Current3;

@property (weak) IBOutlet NSTextField *DUT67Current1;
@property (weak) IBOutlet NSTextField *DUT67Current2;
@property (weak) IBOutlet NSTextField *DUT67Current3;

@property (weak) IBOutlet NSTextField *DUT68Current1;
@property (weak) IBOutlet NSTextField *DUT68Current2;
@property (weak) IBOutlet NSTextField *DUT68Current3;

@property (weak) IBOutlet NSTextField *DUT69Current1;
@property (weak) IBOutlet NSTextField *DUT69Current2;
@property (weak) IBOutlet NSTextField *DUT69Current3;

@property (weak) IBOutlet NSTextField *DUT70Current1;
@property (weak) IBOutlet NSTextField *DUT70Current2;
@property (weak) IBOutlet NSTextField *DUT70Current3;

@property (weak) IBOutlet NSTextField *DUT71Current1;
@property (weak) IBOutlet NSTextField *DUT71Current2;
@property (weak) IBOutlet NSTextField *DUT71Current3;

@property (weak) IBOutlet NSTextField *DUT72Current1;
@property (weak) IBOutlet NSTextField *DUT72Current2;
@property (weak) IBOutlet NSTextField *DUT72Current3;

@property (weak) IBOutlet NSTextField *DUT73Current1;
@property (weak) IBOutlet NSTextField *DUT73Current2;
@property (weak) IBOutlet NSTextField *DUT73Current3;

@property (weak) IBOutlet NSTextField *DUT74Current1;
@property (weak) IBOutlet NSTextField *DUT74Current2;
@property (weak) IBOutlet NSTextField *DUT74Current3;

@property (weak) IBOutlet NSTextField *DUT75Current1;
@property (weak) IBOutlet NSTextField *DUT75Current2;
@property (weak) IBOutlet NSTextField *DUT75Current3;

@property (weak) IBOutlet NSTextField *DUT76Current1;
@property (weak) IBOutlet NSTextField *DUT76Current2;
@property (weak) IBOutlet NSTextField *DUT76Current3;

@property (weak) IBOutlet NSTextField *DUT77Current1;
@property (weak) IBOutlet NSTextField *DUT77Current2;
@property (weak) IBOutlet NSTextField *DUT77Current3;

@property (weak) IBOutlet NSTextField *DUT78Current1;
@property (weak) IBOutlet NSTextField *DUT78Current2;
@property (weak) IBOutlet NSTextField *DUT78Current3;

@property (weak) IBOutlet NSTextField *DUT79Current1;
@property (weak) IBOutlet NSTextField *DUT79Current2;
@property (weak) IBOutlet NSTextField *DUT79Current3;

@property (weak) IBOutlet NSTextField *DUT80Current1;
@property (weak) IBOutlet NSTextField *DUT80Current2;
@property (weak) IBOutlet NSTextField *DUT80Current3;

@property (weak) IBOutlet NSTextField *DUT81Current1;
@property (weak) IBOutlet NSTextField *DUT81Current2;
@property (weak) IBOutlet NSTextField *DUT81Current3;

@property (weak) IBOutlet NSTextField *DUT82Current1;
@property (weak) IBOutlet NSTextField *DUT82Current2;
@property (weak) IBOutlet NSTextField *DUT82Current3;

@property (weak) IBOutlet NSTextField *DUT83Current1;
@property (weak) IBOutlet NSTextField *DUT83Current2;
@property (weak) IBOutlet NSTextField *DUT83Current3;

@property (weak) IBOutlet NSTextField *DUT84Current1;
@property (weak) IBOutlet NSTextField *DUT84Current2;
@property (weak) IBOutlet NSTextField *DUT84Current3;

@property (weak) IBOutlet NSTextField *DUT85Current1;
@property (weak) IBOutlet NSTextField *DUT85Current2;
@property (weak) IBOutlet NSTextField *DUT85Current3;

@property (weak) IBOutlet NSTextField *DUT86Current1;
@property (weak) IBOutlet NSTextField *DUT86Current2;
@property (weak) IBOutlet NSTextField *DUT86Current3;

@property (weak) IBOutlet NSTextField *DUT87Current1;
@property (weak) IBOutlet NSTextField *DUT87Current2;
@property (weak) IBOutlet NSTextField *DUT87Current3;

@property (weak) IBOutlet NSTextField *DUT88Current1;
@property (weak) IBOutlet NSTextField *DUT88Current2;
@property (weak) IBOutlet NSTextField *DUT88Current3;

@property (weak) IBOutlet NSTextField *DUT89Current1;
@property (weak) IBOutlet NSTextField *DUT89Current2;
@property (weak) IBOutlet NSTextField *DUT89Current3;

@property (weak) IBOutlet NSTextField *DUT90Current1;
@property (weak) IBOutlet NSTextField *DUT90Current2;
@property (weak) IBOutlet NSTextField *DUT90Current3;

@property (weak) IBOutlet NSTextField *DUT91Current1;
@property (weak) IBOutlet NSTextField *DUT91Current2;
@property (weak) IBOutlet NSTextField *DUT91Current3;

@property (weak) IBOutlet NSTextField *DUT92Current1;
@property (weak) IBOutlet NSTextField *DUT92Current2;
@property (weak) IBOutlet NSTextField *DUT92Current3;

@property (weak) IBOutlet NSTextField *DUT93Current1;
@property (weak) IBOutlet NSTextField *DUT93Current2;
@property (weak) IBOutlet NSTextField *DUT93Current3;

@property (weak) IBOutlet NSTextField *DUT94Current1;
@property (weak) IBOutlet NSTextField *DUT94Current2;
@property (weak) IBOutlet NSTextField *DUT94Current3;

@property (weak) IBOutlet NSTextField *DUT95Current1;
@property (weak) IBOutlet NSTextField *DUT95Current2;
@property (weak) IBOutlet NSTextField *DUT95Current3;

@property (weak) IBOutlet NSTextField *DUT96Current1;
@property (weak) IBOutlet NSTextField *DUT96Current2;
@property (weak) IBOutlet NSTextField *DUT96Current3;

@property (weak) IBOutlet NSTextField *DUT97Current1;
@property (weak) IBOutlet NSTextField *DUT97Current2;
@property (weak) IBOutlet NSTextField *DUT97Current3;

@property (weak) IBOutlet NSTextField *DUT98Current1;
@property (weak) IBOutlet NSTextField *DUT98Current2;
@property (weak) IBOutlet NSTextField *DUT98Current3;

@property (weak) IBOutlet NSTextField *DUT99Current1;
@property (weak) IBOutlet NSTextField *DUT99Current2;
@property (weak) IBOutlet NSTextField *DUT99Current3;

@property (weak) IBOutlet NSTextField *DUT100Current1;
@property (weak) IBOutlet NSTextField *DUT100Current2;
@property (weak) IBOutlet NSTextField *DUT100Current3;

- (NSMutableArray*)ScanPort;
- (IBAction)Start:(id)sender;
- (IBAction)Stop:(id)sender;

@end
