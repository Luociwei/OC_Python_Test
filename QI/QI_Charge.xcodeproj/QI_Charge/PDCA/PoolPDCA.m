//
//  PoolPDCA.m
//  PoolingTest
//
//  Created by tod on 6/16/14.
//  Copyright (c) 2014 MINI-007. All rights reserved.
//

#import "PoolPDCA.h"

static PoolPDCA* poolPDCA=nil;

@implementation PoolPDCA
@synthesize isPDCAStart;
@synthesize hasWritePDCAAtrribute;

#define testitem 14
unsigned char Test_name_Item[testitem][14]={"00","05","10","15","20","25","30","35","40","45","50","55","60","65"};

float Min[testitem]={ 0,0, 0,0,0, 0,  0,0,  0,0, 0,0,0,0,};

float Max[testitem]={ 0,0, 0,0,0, 0,  0,0,  0,0, 0,0,0,0,};

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

//
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
    NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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


static void addPDCAtoskunk(
                  IP_UUTHandle uut,
                  const char *test_name,
                  const char *sub_test_name,
                  const char *value,
                  const char *upper_limit,
                  const char *lower_limit,
                  const char *units
                  )
{
    IP_TestSpecHandle test_spec = IP_testSpec_create();
    
    IP_testSpec_setPriority   (test_spec, IP_PRIORITY_REALTIME_WITH_ALARMS);
    IP_testSpec_setTestName   (test_spec, test_name, strlen(test_name));
    IP_testSpec_setLimits     (test_spec, lower_limit, strlen(lower_limit), upper_limit, strlen(upper_limit));
    
    if (sub_test_name != NULL)  {
        IP_testSpec_setSubTestName(test_spec, sub_test_name, strlen(sub_test_name));
    }
    
    if (units != NULL) {
        IP_testSpec_setUnits (uut, units, strlen(units));
    }
    
    IP_TestResultHandle test_result = IP_testResult_create();
    
    /* assumes that the value, upper and lower limits can be converted to floats */
    float _value = atof(value);
    float _upper_limit = atof(upper_limit);
    float _lower_limit = atof(lower_limit);
    bool result = (_value <= _upper_limit && _value >= _lower_limit);
    
    IP_testResult_setResult (test_result, result ? IP_PASS : IP_FAIL);
    IP_testResult_setValue  (test_result, value, strlen(value));
    
    if (result == false) {
        char const *ERROR = "out of spec";
        IP_testResult_setMessage(test_result, ERROR, strlen(ERROR));
    }
    
    IP_addResult(uut, test_spec, test_result);
    
    IP_testResult_destroy(test_result);
    IP_testSpec_destroy(test_spec);
    
}


float test_data[20];

-(BOOL)AdjustPDCA:(const char *) strName
        strSWName:(const char *)strSWName
    str_SWVersion:(const char *)str_SWVersion
    str_PDCAData:(NSString *)str_PDCAData
{
    IP_UUTHandle UID;
    
    IP_reply_destroy(IP_UUTStart(&UID));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, strName));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, strSWName));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, str_SWVersion));
    //解析输出的数据
//    for (int j = 0; j < testitem; j++)
//    {
//        //    可以用上面的函数得到一个字符串数组：
//        NSArray *listItems = [str_PDCAData componentsSeparatedByString:@","];
//        //    这个数组就是把原来的字符串用","分割得到的多个字符串：
////        NSString *value = [listItems objectAtIndex:j]; // 取出第j个元素
////        const char * stringAsChar =[value UTF8String];
//    }

    //将标点符号解析出来，放入measured_value中
    NSArray *listItems = [str_PDCAData componentsSeparatedByString:@","];
    for (int j = 0; j < testitem; j++)
    {
//       char measured_value[16];
         NSString *value = [listItems objectAtIndex:j+7]; // 取出第j个元素
         const char * stringAsChar =[value UTF8String];
        
        float Min=0.0;
        float Max=300.0;
        
        char min_limit[16];
        char max_limit[16];
        
        sprintf(min_limit, "%.2f", Min);
        sprintf(max_limit, "%.2f", Max);
        
         //pssong
         addPDCAtoskunk(UID, (const char *)Test_name_Item[j], NULL, (const char *)stringAsChar, (const char *)max_limit, (const char *)min_limit, NULL);
    }
    IP_reply_destroy(IP_UUTDone(UID));
    IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    IP_UID_destroy(UID);
    return YES;
}
//pssong 测试使用
-(BOOL)AdjustPDCA
{
    IP_UUTHandle UID;
    const char *test_name="CC4RC2UUG2RL";
    IP_reply_destroy(IP_UUTStart(&UID));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, test_name));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, "InnorevSkunk-Test"));
    IP_reply_destroy(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, "1.4"));
    
    //The following is a Pass/Fail Test. P/F test only requires TestName and Test Result if test passes.
    //If test fails it also requires a test message.
    //Please Note: Pass-Fail test does not require setLimits, setUnits, and more importantly setValue.
    //If you call IP_testResult_setValue then the Pass/Fail test will change into Parametric Data test
    
    //Pass-Fail test passing ....
    {
        IP_TestSpecHandle   testSpec;
        IP_TestResultHandle testResult;
        
        testSpec = IP_testSpec_create();
        testResult = IP_testResult_create();
        
        IP_testSpec_setTestName(testSpec, "PassingTest", strlen("PassingTest"));
        IP_testResult_setResult(testResult, IP_PASS);
        
        IP_reply_destroy(IP_addResult(UID, testSpec, testResult));
        
        IP_testResult_destroy(testResult);
        IP_testSpec_destroy(testSpec);
    }
    
    //Pass-Fail test failing ....
    {
        IP_TestSpecHandle   testSpec;
        IP_TestResultHandle testResult;
        
        testSpec = IP_testSpec_create();
        testResult = IP_testResult_create();
        
        IP_testSpec_setTestName(testSpec, "FailingTest", strlen("FailingTest"));
        IP_testResult_setResult(testResult, IP_FAIL);
        IP_testResult_setMessage(testResult,"This test failed",strlen("This test failed"));
        
        IP_reply_destroy(IP_addResult(UID, testSpec, testResult));
        
        IP_testResult_destroy(testResult);
        IP_testSpec_destroy(testSpec);
    }
    
    // The following is a Parametric Data Test.
    // Please note here we are setting upperlimits, lowerlimits, units and
    // most importantly test values by calling IP_testResult_setValue
    
    
    {
        IP_TestSpecHandle   testSpec;
        IP_TestResultHandle testResult;
        
        testSpec = IP_testSpec_create();
        testResult = IP_testResult_create();
        
        IP_testSpec_setTestName(testSpec, "ParemetricDataTest", strlen("ParemetricDataTest"));
        IP_testSpec_setLimits(testSpec, "0", strlen("0"),  "9", strlen("9"));
        IP_testSpec_setUnits(testSpec, "ly", strlen("ly"));
        IP_testSpec_setPriority(testSpec, IP_PRIORITY_REALTIME);
        
        IP_testResult_setValue(testResult, "4", strlen("4"));
        IP_testResult_setResult(testResult, IP_PASS);
        
        IP_reply_destroy(IP_addResult(UID, testSpec, testResult));
        
        IP_testResult_destroy(testResult);
        IP_testSpec_destroy(testSpec);
    }
    
    size_t length;
    IP_API_Reply attribRep = IP_getGHStationInfo(UID,IP_PRODUCT,NULL,&length);//make sure first time you pass NULL for buffer
    if ( !IP_success( attribRep ) )
    {
//        std::cout << "Error from First call IP_getGHStationInfo(): " << IP_reply_getError(attribRep) << std::endl;
        exit(-1);
    }
//    IP_reply_destroy(attribRep);
    
    char *cpProduct[length+1];
//    attribRep=IP_getGHStationInfo(UID, IP_PRODUCT,&cpProduct,&length);
    if ( !IP_success( attribRep ) )
    {
//        std::cout << "Error from second call IP_getGHStationInfo(): " << IP_reply_getError(attribRep) << std::endl;
        exit(-1);
    }
    IP_reply_destroy(attribRep);
    
//    std::cout<<length<<":";
//    if(cpProduct!=NULL)
//    {
////        std::cout<< cpProduct <<std::endl;
////        delete[] cpProduct;
//        cpProduct = NULL; 		//not necessary
//        length =0;
//        
//    }
    
    IP_reply_destroy(IP_UUTDone(UID));
    
    IP_reply_destroy(IP_UUTCommit(UID, IP_PASS));
    
    IP_UID_destroy(UID);

    
    return YES;
}


@end
