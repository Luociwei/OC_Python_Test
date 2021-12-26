//
//  PDCA.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by luocw on 11/06/18.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import "PDCA.h"
#import "ConfigDatas.h"

static IP_UUTHandle UID;
static IP_API_Reply reply;

@implementation PDCA

+(BOOL)uploadDatasToPDCA:(NSString *)sn SWName:(NSString *)swName SWVersion:(NSString *)swVersion startTime:(time_t)startTime priority:(NSString *)priority key:(NSString *)uut
{
    BOOL addPDCAtoskunnkSuccess = YES;
    reply = IP_UUTStart(&UID);
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, [sn UTF8String]));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, [swName UTF8String]));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, [swVersion UTF8String]));
    NSArray *datasArray = [ConfigDatas getPlistDatas];
   // pConstChar = [strNSString UTF8String];
    for (NSDictionary *dict in datasArray) {
        const char *test_name = [dict[key_name] UTF8String];
        const char *unit = [dict[key_unit] UTF8String];
        const char *upperLimit = [dict[key_max] UTF8String];
        const char *lowerLimit = [dict[key_min] UTF8String];
        const char *vaule =[dict[uut][key_uut_vaule] UTF8String];
        int result =[dict[uut][key_uut_result] intValue];
        IP_TestSpecHandle test_spec = IP_testSpec_create();
        if ([priority integerValue]!=1) {
            //NORMAL
            IP_testSpec_setPriority(test_spec, IP_PRIORITY_REALTIME_WITH_ALARMS);
        }
        else
        {
            //AUDIT
            IP_testSpec_setPriority(test_spec, IP_PRIORITY_STATION_CALIBRATION_AUDIT);
        }
        IP_testSpec_setUnits(UID, unit, strlen(unit));
        IP_testSpec_setTestName(test_spec, test_name, strlen(test_name));
        IP_TestResultHandle test_result = IP_testResult_create();
        IP_testSpec_setLimits(test_spec, lowerLimit, strlen(lowerLimit), upperLimit, strlen(upperLimit));
        printf("setTest(%s) test result is %d,-- value(%f),upperlimit(%s),lower(%s)\n",test_name,result,atof(vaule),upperLimit,lowerLimit);
        IP_testResult_setResult (test_result, result ? IP_PASS : IP_FAIL);
        if(!IP_testResult_setValue(test_result, vaule, strlen(vaule)))
        {
            NSLog(@"IP_testResult_setValue fail");
            addPDCAtoskunnkSuccess = false;
        }
        IP_API_Reply  addResultreply = IP_addResult(UID, test_spec, test_result);
        if (!IP_success(addResultreply))
        {
            //NSLog(@"IP_success(addResultreply) is false");
            //addPDCAtoskunnkSuccess = false;
            
            //if (IP_MSG_CLASS_PROCESS_CONTROL==IP_reply_getClass(addResultreply))
            //SCRID:93 added end
            //{
            NSLog(@"Pudding addResultreply fail");
            //            IP_API_Reply cancelreply = IP_UUTCancel(uut);
            //            IP_reply_destroy(cancelreply);
            //            IP_reply_destroy(addResultreply);
            //            IP_UID_destroy(uut);
            //    addPDCAtoskunnkSuccess = false;
            //}
            
        }
        NSLog(@"Pudding addResultreply pass");
        IP_reply_destroy(addResultreply);
        IP_testResult_destroy(test_result);
        IP_testSpec_destroy(test_spec);
        NSLog(@"addPDCAtoskunk:testname:%s is sucess",test_name);
        
    }
    IP_reply_destroy(IP_UUTDone(UID));
    IP_reply_destroy(IP_setStopTime(UID, [NSDate cw_Time_tSince1970]));
    IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    IP_UID_destroy(UID);
    return addPDCAtoskunnkSuccess;
}



@end
