#import "PoolPDCA.h"
#define ConfigName @"ChargingRackConfig"
static PoolPDCA* poolPDCA=nil;

@implementation PoolPDCA
@synthesize isPDCAStart;
@synthesize hasWritePDCAAtrribute;

#define testitem 120
char Test_name_Item[testitem][30];


-(id)init
{
    return self;
}

-(void)dealloc
{
    
    //    [PDCA release];
    //    [super dealloc];
}


-(BOOL) puddingCheck
{
    BOOL flag = NO;
    reply = IP_UUTStart(&UID);
    
    if(IP_success(reply))
    {
        [self setErrorInfo:@""];
        flag = YES;
    }
    else
    {
        [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
        flag = NO;
    }
    
    if (reply)
    {
        IP_reply_destroy(reply);
        reply = NULL;
    }
    
    if (!flag)
    {
        if(UID)
        {
            IP_UID_destroy(UID);
            UID = NULL;
        }
    }
    
    return flag;
}


-(NSString*)GetStationID
{
    BOOL flag = NO;
    size_t length = 0;
    char *stationID;
    NSString *strstationID=@"";
    IP_UUTHandle uut;
    IP_UUTStart(&uut);
    reply = IP_getGHStationInfo(UID, IP_STATION_ID, NULL,&length);
    
    if (IP_success(reply))
    {
        IP_reply_destroy(reply);
        
        //stationID = new char[length + 1];
        stationID = malloc(length+1);
        
        reply = IP_getGHStationInfo(UID, IP_STATION_ID, &stationID ,&length);
        
        if(IP_success(reply))
        {
            [self setErrorInfo:@""];
            reply = IP_getGHStationInfo(UID, IP_STATION_ID, &stationID ,&length);
            flag = YES;
        }
        else
        {
            [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
            flag = NO;
        }
        
        if (reply)
        {
            IP_reply_destroy(reply);
            reply = NULL;
        }
        
        strstationID = [NSString stringWithUTF8String:(const char *)stationID];
        
        //delete[] stationID;
        free(stationID);
        stationID = NULL;
        length=0;
    }
    
    if(!flag)
    {
        [self UUTRelease];
    }
    
    
    NSLog(@"Station ID is %@", strstationID);
    return strstationID;
    
}
-(void) UUTRelease
{
    IP_reply_destroy(IP_UUTDone(UID));
    IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    IP_UID_destroy(UID);

}



static bool addCBtoskunk(
                         IP_UUTHandle uut,
                         const char *test_name,
                         const char *sub_test_name,
                         const char *value,
                         const char *msg,
                         const char *upper_limit,
                         const char *lower_limit,
                         const char *units,
                         NSString   *priority,
                         int      isCheckPass,
                         bool      finalFlag
                         )
{
    bool addPDCAtoskunnkSuccess = true;
    IP_TestSpecHandle test_spec = IP_testSpec_create();
    if ([priority integerValue]!= -2) {
        //NORMAL
        IP_testSpec_setPriority(test_spec, IP_PRIORITY_REALTIME_WITH_ALARMS);
    }
    else
    {
        //AUDIT
        IP_testSpec_setPriority(test_spec, IP_PRIORITY_STATION_CALIBRATION_AUDIT);
    }
    
    IP_testSpec_setTestName(test_spec, test_name, strlen(test_name));
    
    if (sub_test_name != NULL){
        IP_testSpec_setSubTestName(test_spec, sub_test_name, strlen(sub_test_name));
    }
    
    if (sub_test_name != NULL){
        IP_testSpec_setSubSubTestName(test_spec, sub_test_name, strlen(sub_test_name));
    }
    
    if (units != NULL) {
        IP_testSpec_setUnits(uut, units, strlen(units));
    }
    
    IP_TestResultHandle test_result = IP_testResult_create();
    
    /* assumes that the value, upper and lower limits can be converted to floats */
    NSLog(@"*****addPDCAtoskunk value is %s******",value);
    float _value = atof(value);
    float _upper_limit = atof(upper_limit);
    float _lower_limit = atof(lower_limit);
    
    bool result = false;
    
    if (isCheckPass == 1){
        result = true;
    }else if(isCheckPass == 2){
        result = false;
    }else{
        result = (_value <= _upper_limit && _value >= _lower_limit);
    }
    
//    if (finalFlag)
//    {
//        result = true;
//    }
    
    IP_testSpec_setLimits(test_spec, lower_limit, strlen(lower_limit), upper_limit, strlen(upper_limit));
    
    printf("setTest(%s) test result is %d,-- value(%f),upperlimit(%f),lower(%f)\n",test_name,result,_value,_upper_limit,_lower_limit);
    
    IP_testResult_setResult (test_result, result ? IP_PASS : IP_FAIL);
    
    if(!IP_testResult_setValue(test_result, value, strlen(value)))
    {
        NSLog(@"IP_testResult_setValue fail");
        addPDCAtoskunnkSuccess = false;
    }
    if(!IP_testResult_setMessage(test_result, msg, strlen(msg)))
    {
        NSLog(@"IP_testResult_setValue fail");
        addPDCAtoskunnkSuccess = false;
    }
    
    IP_API_Reply  addResultreply = IP_addResult(uut, test_spec, test_result);
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
    return addPDCAtoskunnkSuccess;
}

static bool addPDCAtoskunk(
                           IP_UUTHandle uut,
                           const char *test_name,
                           const char *sub_test_name,
                           const char *value,
                           const char *upper_limit,
                           const char *lower_limit,
                           const char *units,
                           NSString   *priority,
                           int      isCheckPass,
                           bool      finalFlag
                           )
{
    bool addPDCAtoskunnkSuccess = true;
    IP_TestSpecHandle test_spec = IP_testSpec_create();
    if ([priority integerValue]!= -2) {
        //NORMAL
        IP_testSpec_setPriority(test_spec, IP_PRIORITY_REALTIME_WITH_ALARMS);
    }
    else
    {
        //AUDIT
        IP_testSpec_setPriority(test_spec, IP_PRIORITY_STATION_CALIBRATION_AUDIT);
    }
    
    IP_testSpec_setTestName(test_spec, test_name, strlen(test_name));
    
    if (sub_test_name != NULL){
        IP_testSpec_setSubTestName(test_spec, sub_test_name, strlen(sub_test_name));
    }
    
    if (units != NULL) {
        IP_testSpec_setUnits(uut, units, strlen(units));
    }
    
    IP_TestResultHandle test_result = IP_testResult_create();
    
    /* assumes that the value, upper and lower limits can be converted to floats */
    NSLog(@"*****addPDCAtoskunk value is %s******",value);
    float _value = atof(value);
    float _upper_limit = atof(upper_limit);
    float _lower_limit = atof(lower_limit);
    
    bool result = false;
    
    if (isCheckPass == 1){
        result = true;
    }else if(isCheckPass == 2){
        result = false;
    }else{
        result = (_value <= _upper_limit && _value >= _lower_limit);
    }
    
//    if (finalFlag)
//    {
//        result = true;
//    }
    
    IP_testSpec_setLimits(test_spec, lower_limit, strlen(lower_limit), upper_limit, strlen(upper_limit));
    
    printf("setTest(%s) test result is %d,-- value(%f),upperlimit(%f),lower(%f)\n",test_name,result,_value,_upper_limit,_lower_limit);
    
    IP_testResult_setResult (test_result, result ? IP_PASS : IP_FAIL);
    
    if(!IP_testResult_setValue(test_result, value, strlen(value)))
    {
        NSLog(@"IP_testResult_setValue fail");
        addPDCAtoskunnkSuccess = false;
    }

    
    IP_API_Reply  addResultreply = IP_addResult(uut, test_spec, test_result);
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
    return addPDCAtoskunnkSuccess;
}

-(bool)uploadBobcatFailPDCAData:(const char *)unitSN SWName:(const char *)swName SWVersion:(const char *)swVersion StationSN:(const char *)stationSN PDCAData:(NSArray *)pdcaData FailMes:(const char *)failMes Priority:(NSString *)priority StartTime:(time_t)starttime EndTime:(time_t)endtime file:(NSString*)logPath FixtureID:(int)fixtureID SiteID:(int)siteID
{
    reply = IP_UUTStart(&UID);
    NSString* ret=@"FAIL,";
    
    if ( !IP_success(reply) )
    {
        if (IP_MSG_CLASS_PROCESS_CONTROL==IP_reply_getClass(reply))
        {
            const char* DoneError = IP_reply_getError(reply);
            NSString* nsstrError = [NSString stringWithUTF8String:DoneError];
            ret = [ret stringByAppendingString:nsstrError];
            IP_API_Reply cancelreply = IP_UUTCancel(UID);
            IP_reply_destroy(cancelreply);
            IP_reply_destroy(reply);
            IP_UID_destroy(UID);
            NSLog(@"Pudding IP_UUTStart Fail %@",ret);
            
        }
        return false;
    }
    NSLog(@"Pudding IP_UUTStart Pass");
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, unitSN));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, swName));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, swVersion));
    //    IP_reply_destroy(IP_addAttribute(UID,IP_ATTRIBUTE_STATIONIDENTIFIER,stationSN));
    //    IP_reply_destroy(IP_addAttribute(UID,IP_ATTRIBUTE_STATIONIDENTIFIER,stationSN)); //No need upload data to PDCA.
    if(siteID == 1 && fixtureID == 1)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_1,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 1)
    {
        
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_1,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID == 2)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_2,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 2)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_2,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID == 3)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_3,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 3)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_3,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID > 4)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,fixtureID,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID > 4)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,fixtureID,IP_FIXTURE_HEAD_ID_2));
    }
    
    if(!addPDCAtoskunk(UID, (const char *)[@"DUT_SN" UTF8String], NULL, (const char *)[@"N/A" UTF8String], (const char *)[@"N/A" UTF8String], (const char *)[@"N/A" UTF8String], (const char *)[@"N/A" UTF8String],priority,2,true))
    {
        NSLog(@"addPDCAtoskunk is false");
    }
    
    IP_reply_destroy(IP_setStartTime(UID, starttime));
    IP_reply_destroy(IP_UUTDone(UID));
    IP_reply_destroy(IP_setStopTime(UID, endtime));
    IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    IP_UID_destroy(UID);
    return true;
}

-(bool)AdjustPDCAData:(const char *)unitSN SWName:(const char *)swName SWVersion:(const char *)swVersion StationSN:(const char *)stationSN PDCAData:(NSArray *)pdcaData FailMes:(const char *)failMes Priority:(NSString *)priority StartTime:(time_t)starttime EndTime:(time_t)endtime file:(NSString*)logPath FixtureID:(int)fixtureID SiteID:(int)siteID CONTROL_BITS_TO_CHECK:(NSString*)CONTROL_BITS_TO_CHECK CONTROL_BITS_STATION_NAMES:(NSString*)CONTROL_BITS_STATION_NAMES STATION_FAIL_COUNT_ALLOWED:(int)STATION_FAIL_COUNT_ALLOWED
{
    //IP_reply_destroy(IP_UUTStart(&UID));
    reply = IP_UUTStart(&UID);
    NSString* ret=@"FAIL";
    
    if ( !IP_success(reply) )
    {
        if (IP_MSG_CLASS_PROCESS_CONTROL==IP_reply_getClass(reply))
        {
            const char* DoneError = IP_reply_getError(reply);
            NSString* nsstrError = [NSString stringWithUTF8String:DoneError];
            ret = [ret stringByAppendingString:nsstrError];
            IP_API_Reply cancelreply = IP_UUTCancel(UID);
            IP_reply_destroy(cancelreply);
            IP_reply_destroy(reply);
            IP_UID_destroy(UID);
            NSLog(@"Pudding IP_UUTStart Fail %@",ret);
            
        }
        return false;
    }
    NSLog(@"Pudding IP_UUTStart Pass");
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, unitSN));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, swName));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, swVersion));
    //    IP_reply_destroy(IP_addAttribute(UID,IP_ATTRIBUTE_STATIONIDENTIFIER,stationSN));
    //    IP_reply_destroy(IP_addAttribute(UID,IP_ATTRIBUTE_STATIONIDENTIFIER,stationSN)); //No need upload data to PDCA.
    if(siteID == 1 && fixtureID == 1)
    {
    IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_1,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 1)
    {
    
    IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_1,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID == 2)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_2,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 2)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_2,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID == 3)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_3,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 3)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,IP_FIXTURE_ID_3,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID > 4)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,fixtureID,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID > 4)
    {
        IP_reply_destroy(IP_setDUTPosition(UID,fixtureID,IP_FIXTURE_HEAD_ID_2));
    }
    IP_reply_destroy(IP_setStartTime(UID, starttime));
    
    
    
    NSString* file = [[NSString alloc] initWithUTF8String:swName];
    NSString* pass = @"N/A";
    NSString* fail = @"N/A";
    NSString* limit = @"N/A";
    bool AdjuestPDCADataSuccess = true;
    for(int i=0; i < pdcaData.count-1; i++)
    {
        bool finalFlag =false;
        char min_limit[16];
        char max_limit[16];
        char unitcell[6];
        int isCheckPass = 0;
        const char * stringAsChar;
        TestUnitData* testUnitData      = [pdcaData objectAtIndex:i];
        
        sprintf(Test_name_Item[i],  "%s", [[testUnitData getData:@"name"] UTF8String]);

        if (([[testUnitData getData:@"min"] isEqualToString:@"N/A"]||[[testUnitData getData:@"min"] isEqualToString:@"1.2.9"]||[[testUnitData getData:@"min"] isEqualToString:@"hv-2"]||[[testUnitData getData:@"min"] isEqualToString:@"Pass"]||[[testUnitData getData:@"min"] isEqualToString:@"N/A"])&& [[testUnitData getData:@"result"] isEqualToString:@"Pass"])
        {
            isCheckPass = 1;
            stringAsChar = [pass UTF8String];
        }
        else if (([[testUnitData getData:@"min"] isEqualToString:@"N/A"]||[[testUnitData getData:@"min"] isEqualToString:@"1.2.9"]||[[testUnitData getData:@"min"] isEqualToString:@"hv-2"]||[[testUnitData getData:@"min"] isEqualToString:@"Pass"]||[[testUnitData getData:@"min"] isEqualToString:@"N/A"])&&[[testUnitData getData:@"result"] isEqualToString:@"Fail"])
        {
                isCheckPass = 2;
                stringAsChar = [fail UTF8String];
        }
        else
        {
                stringAsChar = [[testUnitData getData:@"value"] UTF8String];
        }
        
        NSLog(@"isCheck pass item(%d)",isCheckPass);

        if ([[testUnitData getData:@"min"] isNotEqualTo:@"N/A"]&&[[testUnitData getData:@"min"] isNotEqualTo:@"1.2.9"]&&[[testUnitData getData:@"min"] isNotEqualTo:@"hv-2"]&&[[testUnitData getData:@"min"] isNotEqualTo:@"Pass"]&&[[testUnitData getData:@"min"] isNotEqualTo:@"N/A"])
        {
            float min = [[testUnitData getData:@"min"] floatValue];
            sprintf(min_limit, "%.2f", min);
        }
        else
        {
            sprintf(min_limit, "%s",[limit UTF8String]);
        }
        
        if ([[testUnitData getData:@"max"] isNotEqualTo:@"N/A"]&&[[testUnitData getData:@"max"] isNotEqualTo:@"1.2.9"]&&[[testUnitData getData:@"max"] isNotEqualTo:@"hv-2"]&&[[testUnitData getData:@"max"] isNotEqualTo:@"Pass"]&&[[testUnitData getData:@"max"] isNotEqualTo:@"N/A"])
        {
            float max = [[testUnitData getData:@"max"] floatValue];
            sprintf(max_limit, "%.2f",max);
        }
        else
        {
            sprintf(max_limit, "%s",[limit UTF8String]);
        }
        
        sprintf(unitcell,  "%s",   [[testUnitData getData:@"unit"] UTF8String]);
        
        
//        //For the last one test step use, finishWorkHandler.
//        if(i ==  pdcaData.count-2)
//        {
//            finalFlag = true;
//        }
        
        if(priority == -2&&([[testUnitData getData:@"name"] isEqualToString:@"Check_LastStation_CB_Result"]||[[testUnitData getData:@"name"] isEqualToString:@"Check_CB_FailCount"]||[[testUnitData getData:@"name"] isEqualToString:@"Write_CB_Str_I"]||[[testUnitData getData:@"name"] isEqualToString:@"Write_CB"]))
        {
            continue;
        }
        
        //For CB Fail upload PDCA
        if([[testUnitData getData:@"name"] isEqualToString:@"Check_LastStation_CB_Result"]&&[[testUnitData getData:@"result"] isEqualToString:@"Fail"])
        {
            NSString* ErrorValue = [NSString stringWithFormat:@"%@ %@ not PASS",CONTROL_BITS_TO_CHECK,CONTROL_BITS_STATION_NAMES];
            NSAlert *alert = [NSAlert alertWithMessageText:@"CB Error"
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@"CB not PASS : %@",ErrorValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert runModal];
            });
            
            if(!addCBtoskunk(UID, (const char *)[@"CB Error" UTF8String], (const char *)[@"CB not PASS" UTF8String], (const char *)[@"0" UTF8String], (const char *)[ErrorValue UTF8String], (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,priority,isCheckPass,finalFlag))
            {
                NSLog(@"addPDCAtoskunk is false");
                AdjuestPDCADataSuccess = false;
            }
            continue;
        }
        else if([[testUnitData getData:@"name"] isEqualToString:@"Check_LastStation_CB_Result"]&&[[testUnitData getData:@"result"] isEqualToString:@"Pass"])
        {
            continue;
        }
        
        if([[testUnitData getData:@"name"] isEqualToString:@"Check_CB_FailCount"]&&[[testUnitData getData:@"result"] isEqualToString:@"Fail"])
        {
            NSString* ErrorValue = [NSString stringWithFormat:@"Relative Fail Count: %d %d",[[testUnitData getData:@"value"] intValue],STATION_FAIL_COUNT_ALLOWED];
            NSAlert *alert = [NSAlert alertWithMessageText:@"CB Error"
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@"Over Allowed Relative Fail Count : %@",ErrorValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert runModal];
            });
            if(!addCBtoskunk(UID, (const char *)[@"CB Error" UTF8String], (const char *)[@"Over Allowed Relative Fail Count" UTF8String], (const char *)[@"0" UTF8String], (const char *)[ErrorValue UTF8String], (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,priority,isCheckPass,finalFlag))
            {
                NSLog(@"addPDCAtoskunk is false");
                AdjuestPDCADataSuccess = false;
            }
            continue;
        }
        else if([[testUnitData getData:@"name"] isEqualToString:@"Check_CB_FailCount"]&&[[testUnitData getData:@"result"] isEqualToString:@"Pass"])
        {
            continue;
        }
        
        if([[testUnitData getData:@"name"] isEqualToString:@"Write_CB_Str_I"]&&[[testUnitData getData:@"result"] isEqualToString:@"Fail"])
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"CB Error"
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@"Could not set INCOMPLETE CB : Setting CB to INCOMPLETE failed."];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert runModal];
            });
            if(!addCBtoskunk(UID, (const char *)[@"CB Error" UTF8String], (const char *)[@"Could not set INCOMPLETE CB" UTF8String], (const char *)[@"0" UTF8String], (const char *)[@"Setting CB to INCOMPLETE failed." UTF8String], (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,priority,isCheckPass,finalFlag))
            {
                NSLog(@"addPDCAtoskunk is false");
                AdjuestPDCADataSuccess = false;
            }
            continue;
        }
        else if([[testUnitData getData:@"name"] isEqualToString:@"Write_CB_Str_I"]&&[[testUnitData getData:@"result"] isEqualToString:@"Pass"])
        {
            continue;
        }
        
        if([[testUnitData getData:@"name"] isEqualToString:@"Write_CB"]&&[[testUnitData getData:@"result"] isEqualToString:@"Fail"])
        {
            if([[testUnitData getData:@"errormsg"] isEqualToString:@"write Pass CB error"])
            {
                NSAlert *alert = [NSAlert alertWithMessageText:@"CB Error"
                                                 defaultButton:@"OK"
                                               alternateButton:@"Cancel"
                                                   otherButton:nil
                                     informativeTextWithFormat:@"Could not set PASS CB : Setting CB to PASS failed."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert runModal];
                });
                if(!addCBtoskunk(UID, (const char *)[@"CB Error" UTF8String], (const char *)[@"Could not set PASS CB" UTF8String], (const char *)[@"0" UTF8String], (const char *)[@"Setting CB to PASS failed." UTF8String], (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,priority,isCheckPass,finalFlag))
                {
                    NSLog(@"addPDCAtoskunk is false");
                    AdjuestPDCADataSuccess = false;
                }
                continue;
            }
            else
            {
                NSAlert *alert = [NSAlert alertWithMessageText:@"CB Error"
                                                 defaultButton:@"OK"
                                               alternateButton:@"Cancel"
                                                   otherButton:nil
                                     informativeTextWithFormat:@"Could not set FAIL CB : Setting CB to FAIL failed."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert runModal];
                });
                if(!addCBtoskunk(UID, (const char *)[@"CB Error" UTF8String], (const char *)[@"Could not set FAIL CB" UTF8String], (const char *)[@"0" UTF8String], (const char *)[@"Setting CB to FAIL failed." UTF8String], (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,priority,isCheckPass,finalFlag))
                {
                    NSLog(@"addPDCAtoskunk is false");
                    AdjuestPDCADataSuccess = false;
                }
                continue;
            }
        }
        else if([[testUnitData getData:@"name"] isEqualToString:@"Write_CB"]&&[[testUnitData getData:@"result"] isEqualToString:@"Pass"])
        {
            continue;
        }
        
        //audit mode priority = -2
        if(!addPDCAtoskunk(UID, (const char *)Test_name_Item[i], NULL, (const char *)stringAsChar, (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,priority,isCheckPass,finalFlag))
        {
            NSLog(@"addPDCAtoskunk is false");
            AdjuestPDCADataSuccess = false;
        }
//        NSLog(@"%d testname: %s, testvalue: %s,maxlimit: %s, minlimit:%s, unit:%s, priority:%@, isCheckPass:%d, finalFlag:%d",i,(const char *)Test_name_Item[i],stringAsChar,max_limit,min_limit,unitcell,priority,isCheckPass,finalFlag);
        
//        //上传attribute信息。
//        if(finalFlag && [priority intValue] !=1)
//        {
//            NSLog(@"************Starting attribute **********");
//            if(![self addAttributeUpload:[testUnitData getData:@"value"]  station:[NSString stringWithUTF8String:swName]])
//            {
//                NSLog(@"************attribute false**********");
//            }
//        }
    }
    

    NSLog(@"send log file to PDCA %@------%@",file,logPath);
    if ([self AddBlob:file FilePath:logPath])
    {
        NSLog(@"Blob to PDCA ok");
    }
    else
    {
        AdjuestPDCADataSuccess = false;
    }
    IP_reply_destroy(IP_UUTDone(UID));
    IP_reply_destroy(IP_setStopTime(UID, endtime));
    
    IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    
    IP_UID_destroy(UID);
    
    return AdjuestPDCADataSuccess;
}

-(NSString*)Bobcat_Check_B435:(const char *)str_SN strSWName:(const char *)strSWName str_SWVersion:(const char *)str_SWVersion FixtureID:(int)fixtureID SiteID:(int)siteID
{
    BOOL flag = NO;
    NSString * BobCatMsg = [[NSString alloc] init];
    IP_UUTHandle uut;
    // Start IP uut and add test station parameters
    reply = IP_UUTStart(&uut);
    IP_addAttribute(uut, IP_ATTRIBUTE_SERIALNUMBER, str_SN);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName);
    if(siteID == 1 && fixtureID == 1)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,IP_FIXTURE_ID_1,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 1)
    {
        
        IP_reply_destroy(IP_setDUTPosition(uut,IP_FIXTURE_ID_1,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID == 2)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,IP_FIXTURE_ID_2,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 2)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,IP_FIXTURE_ID_2,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID == 3)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,IP_FIXTURE_ID_3,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID == 3)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,IP_FIXTURE_ID_3,IP_FIXTURE_HEAD_ID_2));
    }
    if(siteID == 1 && fixtureID > 4)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,fixtureID,IP_FIXTURE_HEAD_ID_1));
    }
    else if(siteID == 2 && fixtureID > 4)
    {
        IP_reply_destroy(IP_setDUTPosition(uut,fixtureID,IP_FIXTURE_HEAD_ID_2));
    }
    IP_validateSerialNumber(uut, str_SN);
    
    if(IP_success(reply))
    {
        [self setErrorInfo:@""];
        flag = YES;
    }
    else
    {
        NSString *errormsg = [NSString stringWithUTF8String:IP_reply_getError(reply)];
        BobCatMsg = [BobCatMsg stringByAppendingString:errormsg];
        [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
        flag = NO;
    }
    
//        if (reply)
//        {
//            IP_reply_destroy(reply);
//            reply = NULL;
//        }
    
    if (!flag)
    {
        if(uut)
        {
            IP_UID_destroy(uut);
            uut = NULL;
        }
        NSLog(@"***********BobCat check fail cause IP connection failed ********");
        return false;
    }
    
    NSLog(@"BobCAT DEBUG IP connection PASS");
    
    int i = 0;
    while (i<10)
    {
        BOOL flag = NO;
        reply = IP_amIOkay( uut, str_SN );
        if(IP_success(reply))
        {
            [self setErrorInfo:@""];
            flag = YES;
        }
        else
        {
            NSString * errormsg = [NSString stringWithUTF8String:IP_reply_getError(reply)];
            BobCatMsg = [BobCatMsg stringByAppendingString:errormsg];
            [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
            flag = NO;
            IP_UUTDone(uut);
            IP_UUTCommit(uut, IP_FAIL);
            IP_UID_destroy(uut);
            return BobCatMsg;
        }
        if (reply)
        {
            IP_reply_destroy(reply);
            reply = NULL;
        }
        if(!flag)
        {
            [self UUTRelease];
        }
        usleep(1000*100);
        i++;
        NSLog(@"Print in BobCat loop");
    }
    IP_UUTDone(uut);
    IP_UUTCommit(uut, IP_PASS);
    IP_UID_destroy(uut);
    
    return BobCatMsg;
}

-(BOOL)Bobcat_Check:(const char *)str_SN
          strSWName:(const char *)strSWName
      str_SWVersion:(const char *)str_SWVersion
           colorKey:(const char *)colorKey

{
    NSString * errormsg;
    BOOL flag = NO;
    
    IP_UUTHandle uut;
    // Start IP uut and add test station parameters
    reply = IP_UUTStart(&uut);
    IP_addAttribute(uut, IP_ATTRIBUTE_SERIALNUMBER, str_SN);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONLIMITSVERSION, "1");
    
    //    IP_addAttribute(uut, "CLCG", colorKey);
    //    IP_addAttribute(uut, "CLHS", colorKey);
    
    IP_validateSerialNumber(uut, str_SN);
    
    if(IP_success(reply))
    {
        [self setErrorInfo:@""];
        flag = YES;
    }
    else
    {
        NSString * errormsg = [NSString stringWithUTF8String:IP_reply_getError(reply)];
        [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
        flag = NO;
    }
    
//    if (reply)
//    {
//        IP_reply_destroy(reply);
//        reply = NULL;
//    }
    
    if (!flag)
    {
        if(UID)
        {
            IP_UID_destroy(UID);
            UID = NULL;
        }
        NSLog(@"***********BobCat check fail cause IP connection failed ********");
        return false;
    }
    
    NSLog(@"BobCAT DEBUG IP connection PASS");
    //    NSDate *checkdate= [NSDate date];
    //    // ------Check Bobcat -------
    //    while ([[NSDate date] timeIntervalSinceDate:checkdate]<=1){
    //        if ((IP_success(IP_amIOkay(uut,str_SN)))) {
    //
    //                NSLog(@"BobCAT DEBUG AMIOK PASS and the NSDate is %@",checkdate);
    //
    //            break;
    //        }
    //    }
    
    int i = 0;
    while (i<10){
        BOOL flag = NO;
        reply = IP_amIOkay( uut, str_SN );
        if(IP_success(reply)) {
            [self setErrorInfo:@""];
            flag = YES;
        }
        else
        {
            NSString * errormsg = [NSString stringWithUTF8String:IP_reply_getError(reply)];
            [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
            flag = NO;
        }
        if (reply) {
            IP_reply_destroy(reply);
            reply = NULL;
        }
        if(!flag) {
            [self UUTRelease];
        }
        usleep(1000*300);
        i++;
        NSLog(@"Print in BobCat loop");
    }
    
    
    //Alert if check fail
    if (!(IP_success(IP_amIOkay(uut,str_SN)))) {
        //        NSAlert* alert = [[NSAlert alloc] init];
        //        [alert setMessageText:@"Bobcat check Fail"];
        //        [alert setInformativeText:@"Bobcat Check Fail"];
        //        [alert runModal];
        //--- Send bobat FATAL ERROR ------
        char Test_name[20],measured_value[16],min_limit[16],max_limit[16];
        strcpy(Test_name, "Bobcat_Check");
        sprintf(measured_value, "%d",0);
        sprintf(min_limit, "%d",1);
        sprintf(max_limit, "%d",1);
        
        addPDCAtoskunk(uut, (const char *)Test_name, NULL, (const char *)measured_value, (const char *)max_limit, (const char *)min_limit, NULL,@"0",false,false);
        //write pass or fail
        IP_UUTDone(uut);
        IP_UUTCommit(uut, IP_FAIL);
        IP_UID_destroy(uut);
        return false;
    }
    else{
        //write pass or fail
        
        NSLog(@"***********BobCat check Passed ********");
        IP_UUTDone(uut);
        IP_UUTCommit(uut, IP_FAIL);
        IP_UID_destroy(uut);
        return true;
    }
}

-(BOOL)Bobcat_Check:(const char *)str_SN
          strSWName:(const char *)strSWName
      str_SWVersion:(const char *)str_SWVersion
{
    BOOL flag = NO;
    
    IP_UUTHandle uut;
    // Start IP uut and add test station parameters
    reply = IP_UUTStart(&uut);
    IP_addAttribute(uut, IP_ATTRIBUTE_SERIALNUMBER, str_SN);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONLIMITSVERSION, "1");
    
//    IP_addAttribute(uut, "CLCG", colorKey);
//    IP_addAttribute(uut, "CLHS", colorKey);
    
    IP_validateSerialNumber(uut, str_SN);
    
    if(IP_success(reply))
    {
        [self setErrorInfo:@""];
        flag = YES;
    }
    else
    {
        [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
        flag = NO;
    }
    
    if (reply)
    {
        IP_reply_destroy(reply);
        reply = NULL;
    }
    
    if (!flag)
    {
        if(UID)
        {
            IP_UID_destroy(UID);
            UID = NULL;
        }
        NSLog(@"***********BobCat check fail cause IP connection failed ********");
        return false;
    }
    
    NSLog(@"BobCAT DEBUG IP connection PASS");
//    NSDate *checkdate= [NSDate date];
//    // ------Check Bobcat -------
//    while ([[NSDate date] timeIntervalSinceDate:checkdate]<=1){
//        if ((IP_success(IP_amIOkay(uut,str_SN)))) {
//            
//                NSLog(@"BobCAT DEBUG AMIOK PASS and the NSDate is %@",checkdate);
//            
//            break;
//        }
//    }

    int i = 0;
    while (i<10){
        BOOL flag = NO;
        reply = IP_amIOkay( UID, str_SN );
        if(IP_success(reply)) {
            [self setErrorInfo:@""];
            flag = YES;
        }
        else {
            [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
            flag = NO;
        }
        if (reply) {
            IP_reply_destroy(reply);
            reply = NULL;
        }
        if(!flag) {
            [self UUTRelease];
        }
        usleep(1000*300);
        i++;
        NSLog(@"Print in BobCat loop");
    }
    
    
    //Alert if check fail
    if (!(IP_success(IP_amIOkay(uut,str_SN)))) {
//        NSAlert* alert = [[NSAlert alloc] init];
//        [alert setMessageText:@"Bobcat check Fail"];
//        [alert setInformativeText:@"Bobcat Check Fail"];
//        [alert runModal];
        //--- Send bobat FATAL ERROR ------
        char Test_name[20],measured_value[16],min_limit[16],max_limit[16];
        strcpy(Test_name, "Bobcat_Check");
        sprintf(measured_value, "%d",0);
        sprintf(min_limit, "%d",1);
        sprintf(max_limit, "%d",1);
        
        addPDCAtoskunk(uut, (const char *)Test_name, NULL, (const char *)measured_value, (const char *)max_limit, (const char *)min_limit, NULL,@"0",false,false);
        //write pass or fail
        IP_UUTDone(uut);
        IP_UUTCommit(uut, IP_FAIL);
        IP_UID_destroy(uut);
        return false;
    }
    else{
        //write pass or fail
        
        NSLog(@"***********BobCat check Passed ********");
        IP_UUTDone(uut);
        IP_UUTCommit(uut, IP_FAIL);
        IP_UID_destroy(uut);
        return true;
    }
}

-(BOOL)addAttributeUpload:(NSString*)string
            station:(NSString*)station

{
    BOOL att = YES;
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    
//    IP_API_Reply reply_att1 = IP_addAttribute(uut, IP_ATTRIBUTE_SERIALNUMBER, str_SN);
//    IP_API_Reply reply_att2 = IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion);
//    IP_API_Reply reply_att3 = IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName);
//    IP_API_Reply reply_att4 = IP_addAttribute(uut, IP_ATTRIBUTE_STATIONLIMITSVERSION, "1");
//    IP_API_Reply reply_att5 = IP_addAttribute(uut, "CLCG", colorKey);
//    IP_API_Reply reply_att6 = IP_addAttribute(uut, "CLHS", colorKey);
    if ([string isEqualToString:@""])
    {
        NSLog(@"string is empty");
        return false;
    
    }
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSArray *tmpArray = [string componentsSeparatedByString:@"*"];
//    if ([station isEqualToString:@"QT1"])
//    {
//        @try {
//            [tmpDict setValue:[tmpArray objectAtIndex:2] forKey:@"WIFI_SN"];
//            [tmpDict setValue:[tmpArray objectAtIndex:4] forKey:@"NANDID"];
//            [tmpDict setValue:[tmpArray objectAtIndex:5] forKey:@"NANDCS"];
//            [tmpDict setValue:[tmpArray objectAtIndex:6] forKey:@"MPN"];
//            [tmpDict setValue:[tmpArray objectAtIndex:7] forKey:@"MLBSN"];
//            [tmpDict setValue:[tmpArray objectAtIndex:8] forKey:@"Chip_ID"];
//            [tmpDict setValue:[tmpArray objectAtIndex:9] forKey:@"CHIPVER"];
//            [tmpDict setValue:[tmpArray objectAtIndex:10] forKey:@"DIEID"];
//            [tmpDict setValue:[tmpArray objectAtIndex:11] forKey:@"LUXORSN"];
//        } @catch (NSException *exception) {
//            NSLog(@"Got issue when split array");
//            return false;
//        }
//    }
    
    if ([station isEqualToString:@"QT1"])
    {
        @try {
        
            [tmpDict setValue:[tmpArray objectAtIndex:1] forKey:@"AMPSN"];
        } @catch (NSException *exception) {
            NSLog(@"Got issue when split array");
            return false;
        }
    }
    
    if ([station isEqualToString:@"QT2"])
    {
        @try {
            [tmpDict setValue:[tmpArray objectAtIndex:2] forKey:@"WIFI_SN"];
            [tmpDict setValue:[tmpArray objectAtIndex:4] forKey:@"NANDID"];
            [tmpDict setValue:[tmpArray objectAtIndex:5] forKey:@"NANDCS"];
            [tmpDict setValue:[tmpArray objectAtIndex:6] forKey:@"MPN"];
            [tmpDict setValue:[tmpArray objectAtIndex:7] forKey:@"MLBSN"];
            [tmpDict setValue:[tmpArray objectAtIndex:8] forKey:@"Chip_ID"];
            [tmpDict setValue:[tmpArray objectAtIndex:9] forKey:@"CHIPVER"];
            [tmpDict setValue:[tmpArray objectAtIndex:10] forKey:@"DIEID"];
            [tmpDict setValue:[tmpArray objectAtIndex:11] forKey:@"AMPSN"];
        } @catch (NSException *exception) {
            NSLog(@"Got issue when split array");
            return false;
        }
    }
    
    if ([station isEqualToString:@"QT3"])
    {
        @try {
            [tmpDict setValue:[tmpArray objectAtIndex:1] forKey:@"MoPED"];
            [tmpDict setValue:[tmpArray objectAtIndex:2] forKey:@"Peppy_SN"];
            [tmpDict setValue:[tmpArray objectAtIndex:3] forKey:@"CLCG"];
            [tmpDict setValue:[tmpArray objectAtIndex:4] forKey:@"CLHS"];
        } @catch (NSException *exception) {
            NSLog(@"Got issue when split array");
            return false;
        }
    }
    
        
    for (NSString* key in tmpDict) {
        
        IP_API_Reply att_reply = IP_addAttribute(UID, [key UTF8String],[[tmpDict objectForKey:key] UTF8String]);
        
        if ( !IP_success( att_reply ) )
        {
            
            if ( IP_reply_isOfClass( att_reply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
            {
                // this is a fatal error
                att = NO;
                const char *msg = IP_reply_getError(reply);
                NSLog(@"error: %s", (msg?msg:"IP_addAttribute"));
            }
        }else{
            NSLog(@"[Attribution :] %@----%@",key,[tmpDict objectForKey:key]);
        }
        IP_reply_destroy(att_reply);
        
        if (!att)
        {
            IP_UUTCommit(UID, IP_FAIL);
        }
    }
    
//    IP_UUTDone(UID);
//    IP_UID_destroy(UID);
    return att;
}

-(BOOL) AddBlob:(NSString*) fileName FilePath:(NSString*) filePath
{
    BOOL flag = NO;
    reply = IP_addBlob(UID, [fileName UTF8String], [filePath UTF8String]);
    
    if(IP_success(reply))
    {
        NSLog(@"----upload to pdca success------");
        [self setErrorInfo:@""];
        flag = YES;
    }
    else
    {
        NSLog(@"----upload to pdca fail------");
        [self setErrorInfo:[NSString stringWithUTF8String:IP_reply_getError(reply)]];
        flag = NO;
    }
    
    if (reply)
    {   
        IP_reply_destroy(reply);
        reply = NULL;
    }
    
    if(!flag)
    {
        //[self UIDCancel];
    }
    
    return flag;
}

-(void) UIDCancel
{
    if(UID)
    {
        IP_UUTCancel(UID);
        UID = NULL;
    }
}


@end
