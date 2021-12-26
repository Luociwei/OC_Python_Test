//
//  ConfigCommands.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 02/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "ConfigCommands.h"
#import "TestCommandModel.h"
#import "Communication.h"
#import "ConfigDatas.h"
#import "SerialPort.h"
#import "CaiiltoCommunication.h"
#import "CSVLog.h"
#import "PowerCommuioncation.h"
#import "ArcasCommunication.h"
#import "PowerSupply.h"
#import "PythonClass.h"
#import "PoolPDCA.h"
#import "ConfigStation.h"


#define DIAGS_CB_KEY_RAW_LENGTH 20
static const char cDiagsFlag[2] = ">";
static NSString *diagsFlag = @">";

static PythonClass *pythonClass_uut1;
static PythonClass *pythonClass_uut2;

static Communication *uut2Console;
static Communication *uut1Console;
static CaiiltoCommunication *callisto2Console;
static CaiiltoCommunication *callisto1Console;

static PowerCommuioncation *power2Console;
static PowerSupply *powerConsole;

static ArcasCommunication *arcas2Console;
static ArcasCommunication *arcas1Console;
static NSString* QI1PortName;
static NSString* QI2PortName;
static NSString* UUT1PortName;
static NSString* UUT2PortName;
static NSString* pythonOpenCommand;
static NSString* OverlayVersion;
static NSString* lastCBStation;
static NSString* thisCBStation;
static int STATION_FAIL_COUNT_ALLOWED;
static BOOL STATION_SET_CONTROL_BIT_ON_OFF;
static BOOL CONTROL_BITS_TO_CHECK_ON_OFF;
static BOOL auditMode;
struct ControlBitTrans
{
    unsigned char nonsense[DIAGS_CB_KEY_RAW_LENGTH];
    unsigned char digest[DIAGS_CB_KEY_RAW_LENGTH];
};

@implementation ConfigCommands

+(void)setCBInfo:(NSString*)lastCBStation_in thisCBStation:(NSString*)thisCBStation_in STATION_FAIL_COUNT_ALLOWED:(int)STATION_FAIL_COUNT_ALLOWED_in STATION_SET_CONTROL_BIT_ON_OFF:(BOOL)STATION_SET_CONTROL_BIT_ON_OFF_in CONTROL_BITS_TO_CHECK_ON_OFF:(BOOL)CONTROL_BITS_TO_CHECK_ON_OFF_in AuditMode:(BOOL)auditMode_in
{
    lastCBStation = lastCBStation_in;
    thisCBStation = thisCBStation_in;
    STATION_FAIL_COUNT_ALLOWED = STATION_FAIL_COUNT_ALLOWED_in;
    STATION_SET_CONTROL_BIT_ON_OFF = STATION_SET_CONTROL_BIT_ON_OFF_in;
    CONTROL_BITS_TO_CHECK_ON_OFF = CONTROL_BITS_TO_CHECK_ON_OFF_in;
    auditMode = auditMode_in;
}


+(void)configCommands_init:(NSString *)QI1PortName_in QI2PortName:(NSString*)QI2PortName_in UUT1PortName:(NSString*)UUT1PortName_in UUT2PortName:(NSString*)UUT2PortName_in PythonOpenCommand:(NSString*)pythonOpenCommand_in OverlayVersion:(NSString*)OverlayVersion_in
{
    QI1PortName = QI1PortName_in;
    QI2PortName = QI2PortName_in;
    UUT1PortName = UUT1PortName_in;
    UUT2PortName = UUT2PortName_in;
    pythonOpenCommand = pythonOpenCommand_in;
    OverlayVersion = OverlayVersion_in;
    NSMutableArray *m_PortNameArray = [SerialPort SearchSerialPorts];
    NSLog(@"m_PortNameArray:%@",m_PortNameArray);
    if([[ConfigDatas configPlistName] containsString:@"Arcas"]) {
        
        PowerSupply *ps= [[PowerSupply alloc] init];
        // build the SYSTem:REMote
        [ps Init:@"USB0::0x05E6::0x2220::9201905::INSTR" andBaudRate:115200];
        [ps write:@"OUTPut 1\n"];
//        [ps write:@"INSTrument:NSELect 1\n"];//change the channel CH1
//        [ps write:@"VOLTage 19.0\n"];//set the val value
//        [ps write:@"INSTrument:NSELect 2\n"];//change the channel CH2
//        [ps write:@"VOLTage 19.0\n"];//set the val value
        powerConsole = ps;
        pythonClass_uut1 = [[PythonClass alloc]init];
        pythonClass_uut2 = [[PythonClass alloc]init];
    }
    for (NSString *string in m_PortNameArray) {
        if ([string containsString:UUT1PortName]) {//uut1
            uut1Console=[Communication communicationWithPath:string baudRate:230400];
        }
        if ([string containsString:UUT2PortName]) {//uut2
            uut2Console=[Communication communicationWithPath:string baudRate:230400];
        }
    }
}

+(void)unnormalStop:(NSString *)key  LogPath:(NSString*)logPath
{
    if ([key isEqualToString:key_uut1])
    {
        [pythonClass_uut1 close];
    }
    else if ([key isEqualToString:key_uut2])
    {
        [pythonClass_uut2 close];
    }
}

+(NSArray *)communicationWithCommands:(NSArray *)testCommands key:(NSString *)key LogPath:(NSString*)logPath ResultForWitreCB:(BOOL*)resultForWitreCB UUTTestData:(NSMutableArray *) UUTTestData bobCatCheck:(BOOL)bobCatCheck
{
    NSMutableArray *replyArray = [NSMutableArray array];
    NSString *reply;
    Communication *console;
    CaiiltoCommunication *caiiltoConsole;
    
    int index = 0;
    for (TestCommandModel *cmdModel in testCommands)
    {
        if ([cmdModel.commandMode isEqualToString:vaule_noSend])
        {//calculate
            reply = [self calculate:cmdModel key:key UUTTestData:UUTTestData];
            if (reply.length)
            {
                [replyArray addObject:reply];
            }
        }
        else if([cmdModel.commandMode isEqualToString:vaule_readItemData])
        {
            [replyArray addObject:@"readItemData"];
        }
        else
        {
            if ([key isEqualToString:key_uut1])
            {
                if ([cmdModel.type isEqualToString:vaule_DUT])
                {
                    console = uut1Console;
                }
                if ([cmdModel.type isEqualToString:@"Arcas"])
                {
                    if(![pythonClass_uut1 isOpen])
                    {
                        [pythonClass_uut1 Init:pythonOpenCommand port:QI1PortName];
                    }
                    NSString *command = [NSString stringWithFormat:@"%@\n",cmdModel.send];
                    if([command containsString:@"enterDbg"])
                    {
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                        reply = [pythonClass_uut1 send:command];
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        if([reply containsString:@"Timeout"])
                        {
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                            reply = [pythonClass_uut1 send:command];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        }
                        if([reply containsString:@"Timeout"])
                        {
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                            reply = [pythonClass_uut1 send:command];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        }
                    }
                    else
                    {
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                        NSString *command = [NSString stringWithFormat:@"%@\n",cmdModel.send];
                        reply = [pythonClass_uut1 send:command];
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        
                    }
                    if([command containsString:@"readRailCur"])
                    {
                        [pythonClass_uut1 close];
                    }
                }
            }
            else if ([key isEqualToString:key_uut2])
            {
                if ([cmdModel.type isEqualToString:vaule_DUT])
                {
                    console = uut2Console;
                }
                if ([cmdModel.type isEqualToString:@"Arcas"])
                {
                    if(![pythonClass_uut2 isOpen])
                    {
                       [pythonClass_uut2 Init:pythonOpenCommand port:QI2PortName];
                    }
                    NSString *command = [NSString stringWithFormat:@"%@\n",cmdModel.send];
                    if([command containsString:@"enterDbg"])
                    {
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                        reply = [pythonClass_uut2 send:command];
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        if([reply containsString:@"Timeout"])
                        {
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                            reply = [pythonClass_uut2 send:command];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        }
                        if([reply containsString:@"Timeout"])
                        {
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                            reply = [pythonClass_uut2 send:command];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];
                        }
                    }
                    else
                    {
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Send:  %@",cmdModel.send] LogPath:logPath];
                        
                        reply = [pythonClass_uut2 send:command];
                        [CSVLog saveLog:[NSString stringWithFormat:@"  QI Get :  %@",reply] LogPath:logPath];

                    }
                    if([command containsString:@"readRailCur"])
                    {
                        [pythonClass_uut2 close];
                    }
                }
            }
            if ([cmdModel.commandMode isEqualToString:vaule_sendReceive])
            {
                
                if ([cmdModel.type isEqualToString:vaule_Power])
                {
                    NSString *OUT =[NSString alloc];
                    NSString *send;
                    if([cmdModel.send isEqualToString:@"PowerOpen"])//PowerOff
                    {
                        if ([key isEqualToString:key_uut1])
                        {
                            //[powerConsole write:@"SYSTem:REMote\n"];
                            [powerConsole write:@"INSTrument:NSELect 1\n"];//change the channel CH1
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",@"INSTrument:NSELect 1\n"] LogPath:logPath];
                            [powerConsole write:@"CHANNEL:OUTPut ON\n"];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",@"CHANNEL:OUTPut ON\n"] LogPath:logPath];
                            [powerConsole write:@"VOLTage 19.0\n"];//set the val value
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",@"VOLTage 19.0\n"] LogPath:logPath];
//                            send= @"INSTrument:NSELect 1\n";
//                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
//                            [powerConsole write:@"INSTrument:NSELect 1\n"];//set the val value
//                            [powerConsole write:@"CHANNCEL:OUTPut ON\n"];
//                            send= @"VOLTage 19.0\n";
//                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
//                            [powerConsole write:@"VOLTage 19.0\n"];//set the val value
                        }
                        else
                        {
                            usleep(1000000);
                            //[powerConsole write:@"SYSTem:REMote\n"];
                            [powerConsole write:@"INSTrument:NSELect 2\n"];//change the channel CH1
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",@"INSTrument:NSELect 2\n"] LogPath:logPath];
                            [powerConsole write:@"CHANNEL:OUTPut ON\n"];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",@"CHANNEL:OUTPut ON\n"] LogPath:logPath];
                            [powerConsole write:@"VOLTage 19.0\n"];//set the val value
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",@"VOLTage 19.0\n"] LogPath:logPath];
//                            send= @"INSTrument:NSELect 2\n";
//                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
//                            [powerConsole write:@"INSTrument:NSELect 2\n"];//change the channel CH2
//                            [powerConsole write:@"CHANNEL:OUTPut ON\n"];
//                            send= @"VOLTage 19.0\n";
//                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
//                            [powerConsole write:@"VOLTage 19.0\n"];//set the val value
                        }
                    }
                    else if([cmdModel.send isEqualToString:@"PowerOff"])
                    {
                        if ([key isEqualToString:key_uut1])
                        {
                            send= @"INSTrument:NSELect 1\n";
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
                            [powerConsole write:@"INSTrument:NSELect 1\n"];//change
                            send= @"VOLTage 0.0\n";
                            [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
                            //[powerConsole write:@"VOLTage 0.0\n"];//set the val value
                        }
                        else
                        {
                            send= @"INSTrument:NSELect 2\n";
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
                            [powerConsole write:@"INSTrument:NSELect 2\n"];//change
                            [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
                            send= @"VOLTage 0.0\n";
                            [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
                            //[powerConsole write:@"VOLTage 0.0\n"];//set the val value
                        }
                    }
                    else
                    {
                        if ([key isEqualToString:key_uut1])
                        {
                            send= [NSString stringWithFormat:@"%@ CH1\n",cmdModel.send];
                        }
                        else
                        {
                            send= [NSString stringWithFormat:@"%@ CH2\n",cmdModel.send];
                        }
                        [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Send:  %@",send] LogPath:logPath];
                        reply = [powerConsole query:send output:&OUT];
                        [CSVLog saveLog:[NSString stringWithFormat:@"  PowerSupply Get :  %@",reply] LogPath:logPath];
                    }
                }
                if ([cmdModel.type isEqualToString:vaule_DUT])
                {
                    if([cmdModel.send containsString:@"cbread"]||[cmdModel.send containsString:@"cbwrite"])
                    {
                        reply = [self readWriteCB:console Command:cmdModel.send EndStr:cmdModel.endStr LogPath:logPath ResultForWitreCB:resultForWitreCB];
                    }
                    else if([cmdModel.send containsString:@"[irrw-39-0368]"])
                    {
                        int PassNumber = 0;
                        for(int i = 0; i<100; i++)
                        {
                            NSLog([NSString stringWithFormat:@"********** DUT send cmd : %@ **********",cmdModel.send]);
                            reply = [console SendCmdAndGetReply2:cmdModel.send TimeOut:0.1 ResponseSuffix:@">" LogPath:logPath];
                            if([reply containsString:@"irrw-39-0368-00000001"])
                            {
                                PassNumber++;
                            }
                        }
                        reply = [NSString stringWithFormat:@"<%d>",PassNumber];
                    }
                    else if([cmdModel.send containsString:@"[mread]"])
                    {
                        reply = [console SendCmdAndGetReply:cmdModel.send TimeOut:6 ResponseSuffix:cmdModel.endStr LogPath:logPath];
                    }
                    else
                    {
                        reply = [console SendCmdAndGetReply:cmdModel.send TimeOut:1 ResponseSuffix:cmdModel.endStr LogPath:logPath];
                    }
                }
                if ([cmdModel.type isEqualToString:vaule_Callisto])
                {
                    reply = [caiiltoConsole SendCaiiltoCmdAndGetOKReply:cmdModel.send TimeOut:1 ResponseSuffix:cmdModel.endStr LogPath:logPath];
                    if([cmdModel.send isEqualToString:@"dev ping 1 i 1"])
                    {
                        reply = [console GetReply:4 ResponseSuffix:@"Application" LogPath:logPath];
                    }
                }
                if (reply != nil)
                {
                    [replyArray addObject:reply];
                }
            }
        }
        //加延时
        if (cmdModel.delay != nil)
        {
            int delayTime = [cmdModel.delay intValue];
            usleep(delayTime*1000);
            [CSVLog saveLog:[NSString stringWithFormat:@"  Delay %dms",delayTime] LogPath:logPath];
        }
    }
    
    index++;
    
    return replyArray;
}

+(NSString *)readWriteCB:(Communication*)port Command:(NSString *)command EndStr:(NSString*)endStr LogPath:(NSString*)logPath ResultForWitreCB:(BOOL*)resultForWitreCB
{
    NSString* reply;
    if([command containsString:@"lastCBStation"])
    {
        command = [command stringByReplacingOccurrencesOfString:@"lastCBStation" withString:lastCBStation];
    }
    else if([command containsString:@"thisCBStation"])
    {
        command =[command stringByReplacingOccurrencesOfString:@"thisCBStation" withString:thisCBStation];
    }
    
    if([command containsString:@"cbread"])
    {
        if(CONTROL_BITS_TO_CHECK_ON_OFF)
        {
            reply = [port SendCmdAndGetReply:command TimeOut:1 ResponseSuffix:endStr LogPath:logPath];
            if(auditMode)
            {
                if((![reply containsString:@":"])||(![reply containsString:@">"]))
                {
                    return @"";
                }
                NSRange range1 = [reply rangeOfString:@":"];
                NSRange range2 = [reply rangeOfString:@">"];
                NSInteger tempLength =range2.location-range1.location-range1.length;
                if (tempLength <= 0)
                {
                    return @"";
                }
                NSRange range = {range1.location+range1.length,tempLength};
                NSString* mutString = [NSMutableString stringWithString:[reply substringWithRange:range]];
                NSArray *array = [mutString componentsSeparatedByString:@"-"];
                NSString * thisStationCBResult = [array objectAtIndex:5];
                NSString * failCount_str = [array objectAtIndex:4];
                int failCount = [failCount_str intValue];
                if(failCount>=STATION_FAIL_COUNT_ALLOWED+1)
                {
                    return reply;
                }
                else
                {
                    if(STATION_SET_CONTROL_BIT_ON_OFF)
                    {
                        for(int i = 0;i<STATION_FAIL_COUNT_ALLOWED+1 - failCount;i++)
                        {
                            //[cbwrite-07-0000000000000000000000000000000000000000-Timestamp-OverlayVersion-F]
                            NSString *Timestamp = [self GetTimestamp];
                            reply = [port SendCmdAndGetReply:[NSString stringWithFormat:@"[cbwrite-%@-0000000000000000000000000000000000000000-%@-%@-F]",thisCBStation,Timestamp,OverlayVersion] TimeOut:1 ResponseSuffix:endStr LogPath:logPath];
                        }
                        reply = [port SendCmdAndGetReply:command TimeOut:1 ResponseSuffix:endStr LogPath:logPath];
                    }
                }
            }
        }
    }
    else if([command containsString:@"cbwrite"]&&[command containsString:@"0000000000000000000000000000000000000000"])
    {
        if(STATION_SET_CONTROL_BIT_ON_OFF)
        {
        NSString *CBCommand =[command stringByReplacingOccurrencesOfString:@"OverlayVersion" withString:OverlayVersion];
        NSString *Timestamp = [self GetTimestamp];
        CBCommand =[CBCommand stringByReplacingOccurrencesOfString:@"Timestamp" withString:Timestamp];
        reply = [port SendCmdAndGetReply:CBCommand TimeOut:1 ResponseSuffix:endStr LogPath:logPath];
        }
    }
    else if([command containsString:@"cbwrite"]&&[command containsString:@"hashpasskey"])
    {
        if(STATION_SET_CONTROL_BIT_ON_OFF)
        {
            NSString *CBCommand =[command stringByReplacingOccurrencesOfString:@"OverlayVersion" withString:OverlayVersion];
            NSString *Timestamp = [self GetTimestamp];
            CBCommand =[CBCommand stringByReplacingOccurrencesOfString:@"Timestamp" withString:Timestamp];
            if(resultForWitreCB == NO)
            {
                CBCommand =[CBCommand stringByReplacingOccurrencesOfString:@"Result" withString:@"F"];
                CBCommand =[CBCommand stringByReplacingOccurrencesOfString:@"hashpasskey" withString:@"0000000000000000000000000000000000000000"];
                reply = [port SendCmdAndGetReply:CBCommand TimeOut:1 ResponseSuffix:endStr LogPath:logPath];
            }
            else
            {
                CBCommand =[CBCommand stringByReplacingOccurrencesOfString:@"Result" withString:@"P"];
                NSString *CBKey = [self getPassCBKey:port LogPath:logPath];
                CBCommand =[CBCommand stringByReplacingOccurrencesOfString:@"hashpasskey" withString:CBKey];
                reply = [port SendCmdAndGetReply:CBCommand TimeOut:1 ResponseSuffix:endStr LogPath:logPath];
            }
        }
    }
    return reply;
}

+(NSString*)GetTimestamp
{
    NSDate* datenow = [NSDate date];
    NSTimeZone* zone = [NSTimeZone systemTimeZone];
    NSInteger interval =[zone secondsFromGMTForDate:datenow];
    NSDate* localeDate = [datenow dateByAddingTimeInterval:interval];
    NSString * timesp = [NSString stringWithFormat:@"%d",(long)[localeDate timeIntervalSince1970]];
    return timesp;
}

+(NSString*)getPassCBKey:(Communication*)port LogPath:(NSString*)logPath
{
    struct ControlBitTrans transcript;
    NSString *response = nil;
    NSString *nonsenseResult = [[NSString alloc] init];
        //CDAB1992A7F9B2AB559D903FA023346C1288F4D6
    if (![self getNonsense: transcript.nonsense error:@"" Port:port LogPath:logPath Result:&nonsenseResult])
    {
            NSLog(@"[CBwreite model]DUT ERROR - Could not get the nonce on 2nd try either");
            return false;
    }

    for(int i=0;i<[nonsenseResult length];i++)
    {
        unichar hex_char1 = [nonsenseResult characterAtIndex:i];
        int int_ch;
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            
            int_ch1 = (hex_char1-48)*16;
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        
        i++;
        unichar hex_char2 = [nonsenseResult characterAtIndex:i];
        
        int int_ch2;
        
        if(hex_char2 >= '0' && hex_char2 <='9')
            
            int_ch2 = (hex_char2-48);
        
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        unsigned char ch_char = int_ch;
        transcript.nonsense[(i-1)/2] = ch_char;
    }
    //QI Charge Control Bit Key :0599779462319d6e163d9967043c99b9fca11457
    //Callisto Charge Control Bit Key :9fd9eeb11a113bef9a14b4be8fb233fb6562794a
    static unsigned char specialCBKey[DIAGS_CB_KEY_RAW_LENGTH] =
    {
        0x05,0x99,0x77,0x94,0x62,0x31,0x9d,0x6e,0x16,0x3d,0x99,0x67,0x04,0x3c,0x99,0xb9,0xfc,0xa1,0x14,0x57
    };
    //0e 3e fa ce 81 dc c5 e7 4b 96 32 19 83 26 50 65 8e 4c c1 36
    createSHA1DigestFromKey(specialCBKey, transcript.nonsense,
                            transcript.digest, DIAGS_CB_KEY_RAW_LENGTH);
    NSString *CBKey = @"";
    for(int i = 0; i < DIAGS_CB_KEY_RAW_LENGTH; ++i)
    {
        unsigned char ch = transcript.digest[i];
        int ch_int = (int)ch;
        int high = ch_int / 16;
        int low = ch_int % 16;
        CBKey = [CBKey stringByAppendingString:[NSString stringWithFormat:@"%@%@",[self intToHEXString:high],[self intToHEXString:low]]];
    }
    return CBKey;

}

void createSHA1DigestFromKey(unsigned char *key, unsigned char *nonsense, unsigned char *passKey, int n)
{
    CC_SHA1_CTX cntx;
    
    CC_SHA1_Init(&cntx);
    NSString* CBKey1 = [NSString stringWithUTF8String:key];
    CC_SHA1_Update(&cntx, key, n);
    NSString* CBKey2 = [NSString stringWithUTF8String:nonsense];
    CC_SHA1_Update(&cntx, nonsense, n);
    CC_SHA1_Final(passKey, &cntx);
    NSString* CBKey = [NSString stringWithUTF8String:passKey];
}

+(NSString*) intToHEXString:(int)str_int
{
    if(str_int>=0&&str_int<=9)
    {
        return [NSString stringWithFormat:@"%d",str_int];
    }
    else if(str_int == 10)
    {
        return @"a";
    }
    else if(str_int == 11)
    {
        return @"b";
    }
    else if(str_int == 12)
    {
        return @"c";
    }
    else if(str_int == 13)
    {
        return @"d";
    }
    else if(str_int == 14)
    {
        return @"e";
    }
    else if(str_int == 15)
    {
        return @"f";
    }
    return @"";
}

+(BOOL)getNonsense:(unsigned char *)nonsense error:(NSString *)error Port:(Communication*)unitPort LogPath:(NSString*)logPath Result:(NSString**)nonsense
{
    BOOL retval = NO;
    
    NSString* reply = [unitPort SendCmdAndGetReply:@"[CBNONCE]" TimeOut:1 ResponseSuffix:@">" LogPath:logPath];
    if((![reply containsString:@"<cbnonce:"])||(![reply containsString:@">"]))
    {
        reply = @"ERROR 1";
        return false;
    }
    NSRange range1 = [reply rangeOfString:@"<cbnonce:"];
    NSRange range2 = [reply rangeOfString:@">"];
    NSInteger tempLength =range2.location-range1.location-range1.length;
    if (tempLength <= 0)
    {
        reply = @"ERROR 1";
        return false;
    }
    NSRange range = {range1.location+range1.length,tempLength};
    reply = [NSMutableString stringWithString:[reply substringWithRange:range]];
    *nonsense = reply;
    retval = YES;
    return retval;
}

+(NSString *)communicationWithCommands:(NSArray *)testCommands uutConsole:(Communication *)uutConsole wcbConsole:(Communication *)wcbConsole  LogPath:(NSString*)logPath
{
    
    NSString *reply = nil;
    Communication *console;
    for (TestCommandModel *cmdModel in testCommands) {
        
        
        if ([cmdModel.type isEqualToString:vaule_DUT]) {
            console = uutConsole;
        }
        if ([cmdModel.type isEqualToString:vaule_Callisto]) {
            console = wcbConsole;
        }
        
        if ([cmdModel.commandMode isEqualToString:vaule_sendReceive]){
            reply = [console SendCmdAndGetReply:cmdModel.send TimeOut:1 ResponseSuffix:cmdModel.endStr LogPath:logPath];
            //NSLog(@"lcw--reply:%@",reply);
        }
    }
    return reply;
}

+(NSString *)calculate:(TestCommandModel *)cmdModel key:(NSString *)key UUTTestData:UUTTestData
{
    NSString *reply=nil;
    if (cmdModel.calculateMode != nil)
    {

        if ([cmdModel.calculateMode isEqualToString:vaule_Prect]) {//Prect = (Vrect*Irect)
            int param1_int = -1;
            int param2_int = -1;
            //UUTTestData count
            for(int i = 0; i <[UUTTestData count];i++)
            {
                if([[UUTTestData[i] getData:@"name"] isEqualToString:cmdModel.param1_num])
                {
                    param1_int = i;
                }
                if([[UUTTestData[i] getData:@"name"] isEqualToString:cmdModel.param2_num])
                {
                    param2_int = i;
                }
            }
            //NSArray *results = [ConfigDatas getUUTResultArray:key];
//            NSString * Vrect_str = [results objectAtIndex:[cmdModel.param1_num intValue]];
//            NSString * Irect_str = [results objectAtIndex:[cmdModel.param2_num intValue]];
            //int param1_int = [ConfigDatas getIndexWithItemName:cmdModel.param1_num];
            //int param2_int = [ConfigDatas getIndexWithItemName:cmdModel.param2_num];
            //int resultslenght = results.count;
            if(param1_int<0||param2_int<0)
            {
                return @"";
            }
            float Vrect =[[UUTTestData[param1_int] getData:@"value"] floatValue];
            float Irect =[[UUTTestData[param2_int] getData:@"value"] floatValue];
            float result = Vrect*Irect*0.001;
            reply = [NSString stringWithFormat:@"%f",result];
            return reply;
        }
        if ([cmdModel.calculateMode isEqualToString:vaule_Efficiency]) {//Efficiency = (Vrect*Irect)/(Vin*Iin)
            int param1_int = -1;
            int param2_int = -1;
            int param3_int = -1;
            int param4_int = -1;
            for(int i = 0; i <[UUTTestData count];i++)
            {
                if([[UUTTestData[i] getData:@"name"] isEqualToString:cmdModel.param1_num])
                {
                    param1_int = i;
                }
                if([[UUTTestData[i] getData:@"name"] isEqualToString:cmdModel.param2_num])
                {
                    param2_int = i;
                }
                if([[UUTTestData[i] getData:@"name"] isEqualToString:cmdModel.param3_num])
                {
                    param3_int = i;
                }
                if([[UUTTestData[i] getData:@"name"] isEqualToString:cmdModel.param4_num])
                {
                    param4_int = i;
                }
            }
            
//            NSArray *results = [ConfigDatas getUUTResultArray:key];
////            NSString * Vrect_str = [results objectAtIndex:[cmdModel.param1_num intValue]];
////            NSString * Irect_str = [results objectAtIndex:[cmdModel.param2_num intValue]];
//            int param1_int = [ConfigDatas getIndexWithItemName:cmdModel.param1_num];
//            int param2_int = [ConfigDatas getIndexWithItemName:cmdModel.param2_num];
//            int param3_int = [ConfigDatas getIndexWithItemName:cmdModel.param3_num];
//            int param4_int = [ConfigDatas getIndexWithItemName:cmdModel.param4_num];
//            int resultslenght = results.count;
            if(param1_int<0||param2_int<0||param3_int<0||param4_int<0)
            {
                return @"";
            }
            float Vrect =[[UUTTestData[param1_int] getData:@"value"] floatValue];
            float Irect =[[UUTTestData[param2_int] getData:@"value"] floatValue];
            float VrectIrect = Vrect*Irect;
//            NSString * Vin_str = [results objectAtIndex:[cmdModel.param3_num intValue]];
//            NSString * Iin_str = [results objectAtIndex:[cmdModel.param4_num intValue]];
            float Vin =[[UUTTestData[param3_int] getData:@"value"] floatValue];
            float Iin =[[UUTTestData[param4_int] getData:@"value"] floatValue];
            float VinIin = Vin*Iin;
            float result =(float)VrectIrect/VinIin*100;
            reply = [NSString stringWithFormat:@"%f",result];
        }
    }
    return reply;
}

+(void)openPowerSupply:(NSString*)NOOTPorOTP uut1Check:(BOOL)uut1Check uut2Check:(BOOL)uut2Check
{
    [powerConsole write:@"SYSTem:REMote\n"];
    //[powerConsole write:@"OUTPut 0\n"];
    //usleep(100000);
    //[powerConsole write:@"OUTPut 1\n"];
    if([NOOTPorOTP containsString:@"NO"])
    {
        if(uut1Check)
        {
        [powerConsole write:@"INSTrument:NSELect 1\n"];//change the channel CH1
        [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
        //[powerConsole write:@"VOLTage 0\n"];//set the val value
        }
        else
        {
            
        }
        
        [powerConsole write:@"INSTrument:NSELect 2\n"];//change the channel CH2
        [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
        //[powerConsole write:@"VOLTage 0\n"];//set the val value
            
    }
    else
    {
        if(uut1Check)
        {
            [powerConsole write:@"INSTrument:NSELect 1\n"];//change the channel CH1
            [powerConsole write:@"CHANNEL:OUTPut ON\n"];
            [powerConsole write:@"VOLTage 19.0\n"];//set the val value
        }
        else
        {
            [powerConsole write:@"INSTrument:NSELect 1\n"];//change the channel CH1
            [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
        }
        if(uut2Check)
        {
            [powerConsole write:@"INSTrument:NSELect 2\n"];//change the channel CH2
            [powerConsole write:@"CHANNEL:OUTPut ON\n"];
            [powerConsole write:@"VOLTage 19.0\n"];//set the val value
        }
        else
        {
            [powerConsole write:@"INSTrument:NSELect 2\n"];//change the channel CH2
            [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
        }
    }
}

+(void)closeCHPowerSupply:(int)uutNum
{
    if(uutNum == 1)
    {
        [powerConsole write:@"INSTrument:NSELect 1\n"];//change the channel CH1
        [powerConsole write:@"VOLTage 0.0\n"];//set the val value
        [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
    }
    else if(uutNum == 2)
    {
        [powerConsole write:@"INSTrument:NSELect 2\n"];//change the channel CH2
        [powerConsole write:@"VOLTage 0.0\n"];//set the val value
        [powerConsole write:@"CHANNEL:OUTPut OFF\n"];
    }
}

+(void)closePowerSupply
{
    [powerConsole write:@"OUTPut 0\n"];
}
@end
