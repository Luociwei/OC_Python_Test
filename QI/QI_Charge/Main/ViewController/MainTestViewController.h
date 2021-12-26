//
//  MainTestViewController.h
//  B435_WirelessCharge
//
//  Created by 罗词威 on 25/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Listener.h"
#import "Communication.h"
#import "SerialPort.h"
#import "TestCommandModel.h"
#import "ConfigCommands.h"
#import "Account.h"
#import "CSVLog.h"
#include "PowerSupply.h"
#import "PoolPDCA.h"
#import "TestUnitData.h"
#import "CSVLog.h"

@interface MainTestViewController : NSViewController
{
    NSMutableArray *UUT1TestData;
    NSMutableArray *UUT2TestData;
    NSArray *configTestData;
    NSString *stationMode;
    NSString *stationTestItem;
    NSString *PDCAStationID;
    NSString *PDCAStationSN;
    NSString *softwareVersion;
    NSString *productionName;
    NSString *fixtureID;
    NSString *CSVOTPFilePath;
    NSString *CSVOTPAuditFilePath;
    NSString *CSVNOOTPFilePath;
    NSString *CSVNOOTPAuditFilePath;
    NSString *pythonOpenCommand;
    NSString *QI1PortName;
    NSString *QI2PortName;
    NSString *UUT1PortName;
    NSString *UUT2PortName;
    NSString *OverlayVersion;
    NSString *CONTROL_BITS_TO_CHECK;
    NSString *CONTROL_BITS_STATION_NAMES;
    int STATION_FAIL_COUNT_ALLOWED;
    NSString *lastCBStation;
    NSString *thisCBStation;
    BOOL STATION_SET_CONTROL_BIT_ON_OFF;
    BOOL CONTROL_BITS_TO_CHECK_ON_OFF;
    BOOL SFC_QUERY_UNIT_ON_OFF;
}
-(void)openSetting ;
@end
