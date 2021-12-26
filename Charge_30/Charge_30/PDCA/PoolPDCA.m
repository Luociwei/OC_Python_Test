#import "PoolPDCA.h"

static PoolPDCA* poolPDCA=nil;

@implementation PoolPDCA
@synthesize isPDCAStart;
@synthesize hasWritePDCAAtrribute;

#define testitem 120
char Test_name_Item[testitem][30];//"Current_Time_05"/"Voltage_Time_05"/"LID_Time_05"/"Percentage_Time_05"..............


-(id)init
{
    if(self=[super init])
    {
        PDCA=[[pudding alloc] init];
        [self setIsPDCAStart:NO];
        [self setHasWritePDCAAtrribute:NO];
    }
    
    return self;
}

+(PoolPDCA*)Instance
{
    if(poolPDCA==nil)
    {
        poolPDCA=[[PoolPDCA alloc]init];
    }
    
    return poolPDCA;
}

-(void)dealloc
{
    
    //    [PDCA release];
    //    [super dealloc];
}

-(void)PDCAStart
{
    static int countPDCA=0;
    
    if(![self isPDCAStart])
    {
        [PDCA UUTStartTest];
        [self setIsPDCAStart:YES];
        NSLog(@"------PDCAStart:%d",countPDCA);
        countPDCA++;
    }
}

-(void)PDCARelease
{
    if([self isPDCAStart])
    {
        [PDCA UUTRelease];
        [self setIsPDCAStart:NO];
    }
}

-(void)PDCAStart:(struct structPDCA)structPDCAAtrribute
{
    static int countPDCA=0;
    
    @autoreleasepool//自动Release
    {
        struct structPDCA PACD=structPDCAAtrribute;
        
        //        if(!isPDCAStart && PACD.isNeedStart)
        //        {
        [PDCA UUTStartTest];
        [self setIsPDCAStart:YES];
        NSLog(@"------PDCAStart:%d",countPDCA);
        
        [PDCA ValidateSerialNumber:PACD.strSN];
        [PDCA AddAttribute:@"serialnumber" AttributeValue:PACD.strSN];
        [PDCA AddAttribute:@"softwarename" AttributeValue:PACD.strSoftName];
        [PDCA AddAttribute:@"softwareversion" AttributeValue:PACD.strSoftVersion];
        
        
        [PDCA ValidateAMIOK:PACD.strSN];
        
        countPDCA++;
        //        }
    }
}

-(void)PDCARelease:(struct structPDCA)structPDCAAtrribute
{
    static int countPDCA=0;
    
    @autoreleasepool
    {
        struct structPDCA PACD=structPDCAAtrribute;
        
        if([self isPDCAStart]&& PACD.isNeedRelease)
        {
            [PDCA UUTRelease];
            [self setIsPDCAStart:NO];
            NSLog(@"------PDCAStop:%d",countPDCA);
            
            countPDCA++;
        }
    }
}

//
-(void)WritePDCAAttribute:(struct structPDCA)structPDCAAtrribute
{
    if([self isPDCAStart] && ![self hasWritePDCAAtrribute])
    {
        [self setHasWritePDCAAtrribute:YES];
        [PDCA ValidateSerialNumber:structPDCAAtrribute.strSN];
        [PDCA AddAttribute:@"serialnumber" AttributeValue:structPDCAAtrribute.strSN];
        [PDCA AddAttribute:@"softwarename" AttributeValue:structPDCAAtrribute.strSoftName];
        [PDCA AddAttribute:@"softwareversion" AttributeValue:structPDCAAtrribute.strSoftVersion];
    }
}

//
-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue andLowerSpec:(NSString*)strLowerSpec andUpperSpec:(NSString*)strUpperSpec andUnit:(NSString*)strUnit andIsPass:(NSString*)isPass andPointNum:(uint8)pointIndex
{
    NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* strValueTemp=[strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* strTemp=[NSString stringWithFormat:@"P%d_%@",pointIndex,strNameTemp];
    
    if([self isNumber:strValueTemp])
    {
        [PDCA AddTestItem:strTemp LowerSpec:strLowerSpec UpperSpec:strUpperSpec Unit:strUnit TestValue:strValueTemp TestResult:isPass ErrorInfo:@"" Priority:@""];
    }
    else
    {
        [PDCA AddTestItem:strTemp TestValue:strValueTemp TestResult:isPass ErrorInfo:@"" Priority:@""];
    }
}


-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue andPointNum:(uint8)pointIndex
{
    NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* strValueTemp=[strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* strTemp=[NSString stringWithFormat:@"P%d_%@",pointIndex,strNameTemp];
    
    if([self isNumber:strValueTemp])
    {
        [PDCA AddTestItem:strTemp LowerSpec:@"N/A" UpperSpec:@"N/A" Unit:@"N/A" TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
    else
    {
        [PDCA AddTestItem:strTemp TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
}

-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue str_PDCA:(NSString*)str_PDCA
{
    //NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* strValueTemp=[strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* strTemp=str_PDCA;
    
    if([self isNumber:strValueTemp])
    {
        [PDCA AddTestItem:strTemp LowerSpec:@"N/A" UpperSpec:@"N/A" Unit:@"N/A" TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
    else
    {
        [PDCA AddTestItem:strTemp TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
}

//judge the number wheter is a number
-(BOOL)isNumber:(NSString*)strValue
{
    if ([strValue length]>0)
    {
        if([strValue characterAtIndex:0]> '9' || [strValue characterAtIndex:0] < '0')
        {
            return  NO;
        }
    }
    
    return YES;
}
-(NSString*)PDCA_GetStationID
{
    NSString * str=@"";
    str=[PDCA GetStationID];
    
    return str;
}


bool addPDCAtoskunk(
                           IP_UUTHandle uut,
                           const char *test_name,
                           const char *sub_test_name,
                           const char *value,
                           const char *upper_limit,
                           const char *lower_limit,
                           const char *units,
                           NSString   *errorflag,
                           NSString   *priority
                           )
{
    IP_TestSpecHandle test_spec = IP_testSpec_create();
    if ([priority integerValue]!=1) {
        //NORMAL
        IP_testSpec_setPriority   (test_spec, IP_PRIORITY_REALTIME_WITH_ALARMS);
    }
    else
    {
        //AUDIT
        IP_testSpec_setPriority   (test_spec, IP_PRIORITY_STATION_CALIBRATION_AUDIT);
    }
    
    IP_testSpec_setTestName   (test_spec, test_name, strlen(test_name));
    IP_testSpec_setLimits     (test_spec, lower_limit, strlen(lower_limit), upper_limit, strlen(upper_limit));
    
    if (sub_test_name != NULL)  {
        IP_testSpec_setSubTestName(test_spec, sub_test_name, strlen(sub_test_name));
    }
    
    if (units != NULL) {
        IP_testSpec_setUnits(uut, units, strlen(units));
    }
    
    IP_TestResultHandle test_result = IP_testResult_create();
    
    /* assumes that the value, upper and lower limits can be converted to floats */
    float _value = atof(value);
    float _upper_limit = atof(upper_limit);
    float _lower_limit = atof(lower_limit);
    bool result = (_value <= _upper_limit && _value >= _lower_limit);
    
    if ([errorflag isEqualToString:@""]) {
        IP_testResult_setResult (test_result, result ? IP_PASS : IP_FAIL);
    }
    else {
        result=false;
        IP_testResult_setResult (test_result, IP_FAIL);
    }
    IP_testResult_setValue  (test_result, value, strlen(value));
    
    if (result == false) {
        char const *ERROR = "Above spec";
        IP_testResult_setMessage(test_result, ERROR, strlen(ERROR));
    }
    if ([errorflag isEqualToString:@"1"]) {
        char const *ERROR = "Below spec";
        IP_testResult_setMessage(test_result, ERROR, strlen(ERROR));
    }
    if ([errorflag isEqualToString:@"2"]) {
        char const *ERROR = "Below spec";
        IP_testResult_setMessage(test_result, ERROR, strlen(ERROR));
    }
    if ([errorflag isEqualToString:@"3"]) {
        char const *ERROR = "Above spec";
        IP_testResult_setMessage(test_result, ERROR, strlen(ERROR));
    }
    
    IP_addResult(uut, test_spec, test_result);
    IP_testResult_destroy(test_result);
    IP_testSpec_destroy(test_spec);
    return result;
    
}

-(BOOL)AdjustPDCA:(NSString *) strName
        strSWName:(const char *)strSWName
    str_SWVersion:(const char *)str_SWVersion
    str_StationSN:(const char *)str_StationSN
     str_PDCAData:(NSString *)str_PDCAData
        ErrorFlag:(NSString *)flag
         Priority:(NSString *)priority
        startTime:(time_t)start
        endTime:(time_t)end
{
    IP_UUTHandle UID;
    IP_reply_destroy(IP_UUTStart(&UID));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, [strName UTF8String]));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion));
    IP_reply_destroy(IP_addAttribute(UID,IP_ATTRIBUTE_STATIONIDENTIFIER,str_StationSN));
    IP_setStartTime(UID, start);
    IP_setStopTime(UID, end);
    
    //将标点符号解析出来，放入measured_value中
    NSArray *listItems = [str_PDCAData componentsSeparatedByString:@","]; //because use , to seperate the string, so every member will add,this will cause the count member will add one, for example: only have init value and end test value, the counter number is 13 instead of 12.
    
    char Test_name_Item[testitem][30];//"Current_Time_05"/"Voltage_Time_05"/"LID_Time_05"/"Percentage_Time_05"..............
    sprintf(Test_name_Item[0],"Software_Version");
    sprintf(Test_name_Item[1],"Hardware_Version");
    sprintf(Test_name_Item[2],"Slot_Number");
    sprintf(Test_name_Item[3],"Slot_Counter");
    sprintf(Test_name_Item[4],"Test_Time");
    sprintf(Test_name_Item[5],"FixtureSN");
    sprintf(Test_name_Item[6],"Current_End_Test");
    sprintf(Test_name_Item[7],"Voltage_End_Test");
    sprintf(Test_name_Item[8],"Percentage_End_Test");
    sprintf(Test_name_Item[9],"Lid_End_Test");
    for(int i=10;i<(listItems.count-6);i+=4)
    {
        sprintf(Test_name_Item[i],  "Current_Time_%02d"   ,(i-10)/4*5);
        sprintf(Test_name_Item[i+1],"Voltage_Time_%02d"   ,(i-10)/4*5);
        sprintf(Test_name_Item[i+2],"Percentage_Time_%02d",(i-10)/4*5);
        sprintf(Test_name_Item[i+3],"Lid_Time_%02d"       ,(i-10)/4*5);
        
    }
    
    
    //upload data
    float Max[4]={100,4800,200,1};
    float Min[4]={0,0,0,0};
    char units[4][10]={"mA","mV","%","NA"};
    
    int specLower = [ConfigPlist specLower];
    int specUpper = [ConfigPlist specUpper];
    float endMax[4]={300,4800,specUpper,1};
    float endMin[4]={0,  2500,specLower,0};
    
    BOOL isPass = YES;
    for (int j = 0; j < 4; j++)
    {
        NSString *value = [listItems objectAtIndex:j]; // 取出第j个元素
        const char * stringAsChar =[value UTF8String];
        if (j<=2) {
           BOOL result1 = addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)"100.00", (const char *)"0.00", (const char *)"NA",flag,priority);
            if (!result1) {
                isPass = NO;
            }
        }
        if (j==3) {
           BOOL result1 =  addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)"99999999", (const char *)"0.00", (const char *)"NA",flag,priority);
            if (!result1) {
                isPass = NO;
            }
        }
        
        //        NSLog(@"%d testname: %s, testvalue: %s",j,(const char *)Test_name_Item[j],stringAsChar);
        
    }
    for (int j = 4; j<10; j++) {
        if (j==4) {
            NSString *value = [listItems objectAtIndex:(listItems.count-9+j)]; // 取出第list.count-5个元素
            const char * stringAsChar =[value UTF8String];
            BOOL result1 = addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)"150.00", (const char *)"0.00", (const char *)"NA",flag,priority);
            if (!result1) {
                isPass = NO;
            }
            //            NSLog(@"%d testname: %s, testvalue: %s",j,(const char *)Test_name_Item[j],stringAsChar);
        }
        else if (j==5)
        {
            NSString *value = [listItems objectAtIndex:(listItems.count-9+j)]; // 取出第list.count-5个元素
            const char * stringAsChar =[value UTF8String];
           BOOL result1 =  addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)"99999999.00", (const char *)"0.00", (const char *)"NA",flag,priority);
            if (!result1) {
                isPass = NO;
            }
            //            NSLog(@"%d testname: %s, testvalue: %s",j,(const char *)Test_name_Item[j],stringAsChar);
        }
        else
        {
            NSString *value = [listItems objectAtIndex:(listItems.count-15+j)]; // 取出第j个元素
            const char * stringAsChar =[value UTF8String];
            
            char min_limit[16];
            char max_limit[16];
            char unitcell[4];
            
//            sprintf(min_limit, "%.2f", Min[(j-6)%4]);
//            sprintf(max_limit, "%.2f", Max[(j-6)%4]);
//            sprintf(unitcell, "%s",units[(j-6)%4]);
            sprintf(min_limit, "%.2f", endMin[(j-6)%4]);
            sprintf(max_limit, "%.2f", endMax[(j-6)%4]);
            sprintf(unitcell, "%s",units[(j-6)%4]);
            
            BOOL result1 = addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,flag,priority);
            if (!result1) {
                isPass = NO;
            }
            //            NSLog(@"%d testname: %s, testvalue: %s,maxlimit: %s, minlimit:%s",j,(const char *)Test_name_Item[j],stringAsChar,max_limit,min_limit);
        }
    }
    
    for (int j = 10; j < (listItems.count-3); j++)
    {
        NSString *value = [listItems objectAtIndex:(j-6)]; // 取出第j个元素
        const char * stringAsChar =[value UTF8String];
        
        char min_limit[16];
        char max_limit[16];
        char unitcell[4];
        
        sprintf(min_limit, "%.2f", Min[(j-10)%4]);
        sprintf(max_limit, "%.2f", Max[(j-10)%4]);
        sprintf(unitcell, "%s",units[(j-10)%4]);
        
        BOOL result1 = addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)max_limit, (const char *)min_limit, (const char *)unitcell,flag,priority);
        if (!result1) {
            isPass = NO;
        }
        //        NSLog(@"%d testname: %s, testvalue: %s,maxlimit: %s, minlimit:%s",j,(const char *)Test_name_Item[j],stringAsChar,max_limit,min_limit);
    }
    
    IP_reply_destroy(IP_UUTDone(UID));
    if (![flag isEqualTo:@""]) {
        IP_reply_destroy(IP_UUTCommit(UID, IP_FAIL));
        isPass = NO;
    }
    else
    {
        IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    }
    IP_UID_destroy(UID);
    
    if (isPass == NO) {
        
        NSLog(@"cwluo%%%%%%%%%%%%%%%%%@:upload pdca, data fai-----%%%%%%%%%%%%%%%%",strName);
        NSString *readString =[CSVLog2 readFromFile:snFailRecordPath];
        //NSLog(@"cwluo%%%%sn:%@,readString:%@",strName,readString);
        NSRange range = [readString rangeOfString:strName];
        if (range.length) {
            NSString *str1 = [NSString stringWithFormat:@"%@ fail num:",strName];
            //NSLog(@"cwluo%%%%sn:%@,str1:%@",strName,str1);
            NSString *oldNum = [readString cw_getSubstringFromString:str1 toLength:1];
            //NSLog(@"cwluo%%%%sn:%@,oldNum:%@",strName,oldNum);
            NSString *oldString = [NSString stringWithFormat:@"%@%@",str1,oldNum];
            NSString *newString = [NSString stringWithFormat:@"%@%d",str1,[oldNum intValue]+1];
            //NSLog(@"cwluo%%%%sn:%@,newString:%@",strName,newString);
            NSString *newReadString = [readString stringByReplacingOccurrencesOfString:oldString withString:newString];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSLog(@"cwluo%%%%sn:%@,newReadString:%@",strName,newReadString);
            // @synchronized(self) {
            // [fileManager removeItemAtPath:snFailRecordPath error:nil];
            [fileManager createFileAtPath:snFailRecordPath contents:[newReadString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            //
            // }
            
            
        }else{
            NSString *content = [NSString stringWithFormat:@"\n%@ fail num:1",strName];
            [CSVLog2 WriteToFile:snFailRecordPath content:content];
        }
        
    }
    
    return isPass;
}

-(BOOL)Bobcat_Check:(const char *)str_SN
          strSWName:(const char *)strSWName
      str_SWVersion:(const char *)str_SWVersion
      str_StationSN:(const char *)str_StationSN
           slot_Num:(long int)slot
{
    IP_UUTHandle uut;
    // Start IP uut and add test station parameters
    IP_UUTStart(&uut);
    IP_addAttribute(uut, IP_ATTRIBUTE_SERIALNUMBER, str_SN);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName);
    IP_addAttribute(uut, IP_ATTRIBUTE_STATIONLIMITSVERSION, "1");
    IP_addAttribute(uut,IP_ATTRIBUTE_STATIONIDENTIFIER,str_StationSN);
    IP_validateSerialNumber(uut, str_SN);
    
    NSDate *checkdate= [NSDate date];
    // ------Check Bobcat -------
    while ([[NSDate date] timeIntervalSinceDate:checkdate]<=1){
        
        //NSLog(@"IP_amIOkay:%@",IP_amIOkay(uut,str_SN));
        if ((IP_success(IP_amIOkay(uut,str_SN)))) {
            
            ;
        }
    }
    
   // NSLog(@"lcw bobcat check sn:%s IP_success:%d,IP_amIOkay:%@",str_SN,IP_success(IP_amIOkay(uut,str_SN)),IP_amIOkay(uut, str_SN));
    
    //Alert if check fail
    if (!(IP_success(IP_amIOkay(uut,str_SN)))) {
        const char *IPreply = IP_reply_getError(IP_amIOkay(uut,str_SN));
        NSString *bobcatReturn = [[NSString alloc] initWithFormat:@"Bobcat check Fail in slot number:%ld",slot];
  
            NSAlert *alert = [NSAlert alertWithMessageText:bobcatReturn
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@"%s",IPreply];
            [alert runModal];
        
        //--- Send bobat FATAL ERROR ------
        char Test_name[20],measured_value[16],min_limit[16],max_limit[16];
        strcpy(Test_name, "Bobcat_Check");
        sprintf(measured_value, "%d",0);
        sprintf(min_limit, "%d",0);  sprintf(max_limit, "%d",1);
        addPDCAtoskunk(uut, (const char *)Test_name, NULL, (const char *)measured_value, (const char *)max_limit, (const char *)min_limit, NULL,@"",@"0");
        
        //write pass or fail
        IP_UUTDone(uut);
        IP_UUTCommit(uut, IP_FAIL);
        IP_UID_destroy(uut);
        return false;
    }
    else{
        NSLog(@"lcw bobcat chec 222");
        //write pass or fail
        IP_UUTDone(uut);
        IP_UUTCommit(uut, IP_FAIL);
        IP_UID_destroy(uut);
        return true;
    }
}




@end
