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

static Communication *uut2Console;
static Communication *uut1Console;
static CaiiltoCommunication *callisto2Console;
static CaiiltoCommunication *callisto1Console;

@implementation ConfigCommands

+(void)load
{
    NSMutableArray *m_PortNameArray = [SerialPort SearchSerialPorts];
    NSLog(@"m_PortNameArray:%@",m_PortNameArray);///dev/cu.usbmodem1441121
 
    callisto2Console=[CaiiltoCommunication communicationWithCaiiltoAndPath:@"/dev/cu.usbmodem14411"];
    //callisto2Console=[Communication communicationWithPath:@"/dev/cu.usbmodem14611" baudRate:1250000];
    uut1Console=[Communication communicationWithPath:@"/dev/cu.usbserial-FIX_04" baudRate:230400];
//
     uut2Console=[Communication communicationWithPath:@"/dev/cu.usbserial-FIX_05" baudRate:230400];
    
    NSLog(@"test111");

}



+(NSString *)communicationWithCommands:(NSArray *)testCommands key:(NSString *)key
{
    
    NSString *reply = nil;
    Communication *console;
    CaiiltoCommunication *caiiltoConsole;
    for (TestCommandModel *cmdModel in testCommands) {
        
        if ([key isEqualToString:key_uut1]) {
            if ([cmdModel.type isEqualToString:vaule_DUT]) {
                console = uut1Console;
            }
            if ([cmdModel.type isEqualToString:vaule_Callisto]) {
                //caiiltoConsole = wcbConsole;
            }
        }
        if ([key isEqualToString:key_uut2]) {
            if ([cmdModel.type isEqualToString:vaule_DUT]) {
                console = uut2Console;
            }
            if ([cmdModel.type isEqualToString:vaule_Callisto]) {
                caiiltoConsole = callisto2Console;
            }
        }
        
        //        if ([cmdModel.commandMode isEqualToString:vaule_onlySend]) {
        //            [console SendCmd:cmdModel.send];
        //        }
        
        if ([cmdModel.commandMode isEqualToString:vaule_sendReceive]){
            if ([cmdModel.type isEqualToString:vaule_DUT]) {
                reply = [console SendCmdAndGetOKReply:cmdModel.send TimeOut:1 ResponseSuffix:cmdModel.endStr];
            }
            if ([cmdModel.type isEqualToString:vaule_Callisto]) {
                reply = [caiiltoConsole SendCaiiltoCmdAndGetOKReply:cmdModel.send TimeOut:1 ResponseSuffix:cmdModel.endStr];
            }
            
            NSLog(@"lcw--reply:%@",reply);
        }
    }
    return reply;
}



+(NSString *)communicationWithCommands:(NSArray *)testCommands uutConsole:(Communication *)uutConsole wcbConsole:(Communication *)wcbConsole
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
        
        //        if ([cmdModel.commandMode isEqualToString:vaule_onlySend]) {
        //            [console SendCmd:cmdModel.send];
        //        }
        
        if ([cmdModel.commandMode isEqualToString:vaule_sendReceive]){
            reply = [console SendCmdAndGetOKReply:cmdModel.send TimeOut:1 ResponseSuffix:cmdModel.endStr];
            NSLog(@"lcw--reply:%@",reply);
        }
    }
    return reply;
}


@end
