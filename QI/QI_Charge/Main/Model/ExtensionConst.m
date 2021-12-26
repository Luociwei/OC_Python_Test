//
//  ExtensionConst.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 04/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "ExtensionConst.h"

@implementation ExtensionConst
int const snLength = 12;
NSString *const plistName = @"datas";//@"N/A"
NSString *const NA = @"N/A";
//key
NSString *const key_index = @"index";
NSString *const key_name = @"name";
NSString *const key_max = @"max";
NSString *const key_min = @"min";
NSString *const key_unit = @"unit";
NSString *const key_uut1 = @"uut1";
NSString *const key_uut2 = @"uut2";
//NSString *const key_communication = @"communication";
NSString *const key_testCommands = @"testCommands";
NSString *const key_cutResponse = @"cutResponse";

//uut key
NSString *const key_uut_vaule = @"vaule";
NSString *const key_uut_result = @"result";
//NSString *const vaule_pass = @"pass";
//commandMode vaule
NSString *const vaule_noSend = @"noSend";
NSString *const vaule_readItemData = @"readItemData";
NSString *const vaule_onlySend = @"onlySend";
//NSString *const vaule_cut = @"cut";
NSString *const vaule_sendReceive = @"sendReceive";

NSString *const vaule_Prect = @"Prect";
NSString *const vaule_Efficiency = @"Efficiency";
//NSString *const vaule_endStr = @":)";
//NSString *const key_response = @"response";

NSString *const vaule_Callisto = @"Callisto";
NSString *const vaule_DUT = @"DUT";
NSString *const vaule_Power = @"Power";
//NSString *const vaule_WCB = @"WCB";
//
NSString *const testPassCount = @"testPassCount";
NSString *const testFailCount = @"testFailCount";

NSString *const time_percens = @"percens";
NSString *const time_seconds = @"seconds";
NSString *const time_key = @"time_key";
//@{@"percens":percens,@"seconds":seconds};

NSString *const titleWCOTPCallisto = @"WC_OTP_Callisto";
NSString *const titleWCNOOTPCallisto = @"WC_NOOTP_Callisto";
NSString *const titleWCNOOTPArcas = @"WC_NO_OTP_Arcas";
NSString *const titleWCOTPArcas = @"WC_OTP_Arcas";
@end
