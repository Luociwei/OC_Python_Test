//
//  ConfigPlist.m
//  LUXSHARE_B288_24
//
//  Created by 罗词威 on 04/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "ConfigDatas.h"
#import "TestCommandModel.h"
#import "CutResponseModel.h"
#import "CutReponse.h"
#import "PoolPDCA.h"
#import "ConfigStation.h"

static NSArray *_datasArray;
static NSArray *_testCommandsArray;
static NSArray *_cutResponseArray;
static NSArray *_nameArray;
static NSMutableArray *_uut1ResultArray;
static NSMutableArray *_uut2ResultArray;
static NSString *_configPlistName;


@implementation ConfigDatas

+(NSString *)configPlistName
{
    return _configPlistName;
}

+(void)loadWithPlist:(NSString *)plistName
{
    _configPlistName = plistName;
    NSString *configfile = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:configfile];
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *mArr = [NSMutableArray array];
    NSMutableArray *commandsMutArray = [NSMutableArray array];
    NSMutableArray *cutResponseArr = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
        for (id key in dict) {
            NSDictionary *vaule = dict[key];
            if ([key isEqualToString:key_uut1]||[key isEqualToString:key_uut1]) {
                NSMutableDictionary * uutMDict = [NSMutableDictionary dictionaryWithDictionary:vaule];
                [mDict setObject:uutMDict forKey:key];
            }else if ([key isEqualToString:key_testCommands]){
                NSArray *testCommandsModels = [TestCommandModel mj_objectArrayWithKeyValuesArray:dict[key]];
                [commandsMutArray addObject:testCommandsModels];
            }else if ([key isEqualToString:key_cutResponse]){
                
                NSArray *cutResponseModels = [CutResponseModel mj_objectArrayWithKeyValuesArray:dict[key]];
                
                [cutResponseArr addObject:cutResponseModels];
            }
            else{
                if([key isEqualToString:key_name]){
                    
                    [nameArr addObject:dict[key]];
                }
                [mDict setObject:dict[key] forKey:key];
            }
        }
        [mArr addObject:mDict];
    }
    _testCommandsArray = (NSArray *)commandsMutArray;
    _cutResponseArray = (NSArray *)cutResponseArr;
    _datasArray = (NSArray *)mArr;
    _nameArray = (NSArray *)nameArr;
}

+(void)initialize
{
    _uut1ResultArray = [NSMutableArray array];
    _uut2ResultArray = [NSMutableArray array];
}


+(NSArray *)getNameArray
{
    return _nameArray;
}

+(NSInteger)getIndexWithItemName:(NSString *)name
{
    return [_nameArray indexOfObject:name];
}

//+(void)communicationWithCommands:(NSArray *)commandsArray;
+(NSArray *)getCutResponseArrays
{
    return _cutResponseArray;
}
+(NSArray *)getUUTResultArray:(NSString *)key
{
    if ([key isEqualToString:key_uut1]) {
        return _uut1ResultArray;
    }else{
        return _uut2ResultArray;
    }
}
+(NSArray *)getCommadsArrays
{
    return _testCommandsArray;
}

+(NSArray *)getPlistDatas
{
    return _datasArray;
}

+(void)initalPlistDatas
{
    for (NSDictionary *dict in _datasArray) {
        for (id key in dict) {
            if ([key isEqualToString:key_uut1]||[key isEqualToString:key_uut2]) {
                @synchronized(self){
                    NSMutableDictionary *uutDict = dict[key];
                    [uutDict setValue:@"" forKey:key_uut_vaule];
                    [uutDict setValue:@"" forKey:key_uut_result];
                }
                
            }
        }
    }
    [_uut1ResultArray removeAllObjects];
    [_uut2ResultArray removeAllObjects];
}

+(void)skip:(NSInteger)row UUTTestData:(NSMutableArray *) UUTTestData key:(NSString *)key
{
    TestUnitData* testUnitData      = [TestUnitData new];
    testUnitData.testName       = [UUTTestData[row] getData:@"testName"];
    testUnitData.min            = [UUTTestData[row] getData:@"min"];
    testUnitData.max            = [UUTTestData[row] getData:@"max"];
    testUnitData.unit           = [UUTTestData[row] getData:@"unit"];
    
    NSMutableDictionary *mDict = _datasArray[row];
    if ([key isEqualToString:key_uut1]) {
        [_uut1ResultArray addObject:@""];
    }else{
        [_uut2ResultArray addObject:@""];
    }
    testUnitData.value = @"skip";
    testUnitData.result = @"Pass";
    [mDict[key] setObject:@"1" forKey:key_uut_result];
    [mDict[key] setObject:@"skip" forKey:key_uut_vaule];
    
    
}

+(void)finishWordHandler:(NSInteger)row UUTTestData:(NSMutableArray *) UUTTestData key:(NSString *)key PassOrFail:(BOOL)passOrFail
{
    TestUnitData* testUnitData      = [TestUnitData new];
    testUnitData.testName       = [UUTTestData[row] getData:@"testName"];
    testUnitData.min            = [UUTTestData[row] getData:@"min"];
    testUnitData.max            = [UUTTestData[row] getData:@"max"];
    testUnitData.unit           = [UUTTestData[row] getData:@"unit"];
    
    NSMutableDictionary *mDict = _datasArray[row];
    if ([key isEqualToString:key_uut1]) {
        [_uut1ResultArray addObject:@""];
    }else{
        [_uut2ResultArray addObject:@""];
    }
    if(passOrFail)
    {
        testUnitData.value = @"Pass";
        testUnitData.result = @"Pass";
        [mDict[key] setObject:@"1" forKey:key_uut_result];
        [mDict[key] setObject:@"Pass" forKey:key_uut_vaule];
    }
    else
    {
        testUnitData.value = @"Fail";
        testUnitData.result = @"Fail";
        [mDict[key] setObject:@"0" forKey:key_uut_result];
        [mDict[key] setObject:@"Fail" forKey:key_uut_vaule];
    }
    
}

+(NSString *)updatePlistDatasWithReponse:(NSArray *)reponses row:(NSInteger)row isPass:(BOOL *)isPass key:(NSString *)key UUTTestData:(NSMutableArray *) UUTTestData CBResult:(BOOL)CBResult CBFailCount:(int)CBFailCount bobCatCheck:(BOOL)bobCatCheck AuditMode:(BOOL)auditMode
{
    TestUnitData* testUnitData      = [TestUnitData new];
    testUnitData.testName       = [UUTTestData[row] getData:@"testName"];
    testUnitData.min            = [UUTTestData[row] getData:@"min"];
    testUnitData.max            = [UUTTestData[row] getData:@"max"];
    testUnitData.unit           = [UUTTestData[row] getData:@"unit"];
    
   NSMutableDictionary *mDict = _datasArray[row];
    if (reponses.count == 0)
    {
        if ([key isEqualToString:key_uut1]) {
            [_uut1ResultArray addObject:@""];
        }else{
            [_uut2ResultArray addObject:@""];
        }
        testUnitData.value = @"Empty";
        testUnitData.result = @"Fail";
        testUnitData.errormsg = @"reponses.count = 0";
        [mDict[key] setObject:@"0" forKey:key_uut_result];
        [mDict[key] setObject:@"Empty" forKey:key_uut_vaule];
        *isPass = NO;
        
        return @"Empty";
    }
    
    
    NSString *reply;
    for (CutResponseModel *model in _cutResponseArray[row]) {
        if (model.returnIndex != nil)
        {
            reply =[reponses objectAtIndex:[model.returnIndex intValue]];
        }
        else
        {
            reply = [reponses lastObject];
        }
        
    }
    
    
    testUnitData.reply = reply;
    NSString *cutReponse;
    cutReponse = [CutReponse cutReponse:reponses keywords:_cutResponseArray[row] UUTTestData:UUTTestData];
    testUnitData.cutResult = cutReponse;
//
//    //cwluo add
//    if ([reply containsString:@"BobCheck Fail"]) {
//
//        testUnitData.value = @"Fail";
//        testUnitData.result = @"Fail";
//        testUnitData.errormsg = @"BobCheck Fail";
//        [mDict[key] setObject:@"0" forKey:key_uut_result];
//        [mDict[key] setObject:@"BobCheck Fail" forKey:key_uut_vaule];
//        *isPass = NO;
//        return cutReponse;
//    }
    

    if([mDict[@"judgement_mode"] containsString:@"contain"])
    {
        if([cutReponse containsString:mDict[@"contain_str"]])
        {
            if([cutReponse containsString:@"Success"]||[cutReponse containsString:@"tm-43"])
            {
                cutReponse = @"Pass";
            }
            else if([mDict[@"contain_str"]isEqualToString:@"I"]||[mDict[@"contain_str"]isEqualToString:@"coil PWM was disabled"]||[mDict[@"contain_str"]isEqualToString:@"coil PWM was enabled"])
            {
                cutReponse = @"Pass";
            }
            else
            {
                cutReponse = mDict[@"contain_str"];
            }
            [mDict[key] setObject:@"1" forKey:key_uut_result];
            [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
            //cutReponse = @"Pass";
            testUnitData.value = cutReponse;
            testUnitData.result = @"Pass";
        }
        else
        {
            [mDict[key] setObject:@"0" forKey:key_uut_result];
            [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
            //cutReponse = @"Fail";
            testUnitData.value = cutReponse;
            testUnitData.result = @"Fail";
            testUnitData.errormsg = @"miss contain string";
            *isPass = NO;
        }
    }
    else if([mDict[@"judgement_mode"] containsString:@"cbResultWrite"])
    {
        if(CBResult)
        {
            if([cutReponse containsString:@"P"])
            {
                [mDict[key] setObject:@"1" forKey:key_uut_result];
                [mDict[key] setObject:@"Pass" forKey:key_uut_vaule];
                cutReponse = @"Pass";
                testUnitData.value = @"Pass";
                testUnitData.result = @"Pass";
            }
            else
            {
                [mDict[key] setObject:@"0" forKey:key_uut_result];
                [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
                //cutReponse = @"Fail";
                testUnitData.value = cutReponse;
                testUnitData.result = @"Fail";
                testUnitData.errormsg = @"write Pass CB error";
                *isPass = NO;
            }
        }
        else
        {
            NSLog([NSString stringWithFormat:@"##############CBResult = NO CutRepsonse : %@",cutReponse]);
            if([cutReponse containsString:@"F"])
            {
                [mDict[key] setObject:@"1" forKey:key_uut_result];
                [mDict[key] setObject:@"Pass" forKey:key_uut_vaule];
                cutReponse = @"Pass";
                testUnitData.value = @"Pass";
                testUnitData.result = @"Pass";
            }
            else
            {
                [mDict[key] setObject:@"0" forKey:key_uut_result];
                [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
                //cutReponse = @"Fail";
                testUnitData.value = @"Fail";
                testUnitData.result = @"Fail";
                testUnitData.errormsg = @"write Fail CB error";
                *isPass = NO;
            }
        }
    }
    else if([mDict[@"judgement_mode"] containsString:@"CBFailCount"])
    {
        int thisStationFailCount = [cutReponse intValue];
        if(auditMode)
        {
            [mDict[key] setObject:@"1" forKey:key_uut_result];
            [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
            testUnitData.value = cutReponse;
            testUnitData.result = @"Pass";
        }
        else if(thisStationFailCount < CBFailCount)
        {
            [mDict[key] setObject:@"1" forKey:key_uut_result];
            [mDict[key] setObject:@"Pass" forKey:key_uut_vaule];
            cutReponse = @"Pass";
            testUnitData.value = @"Pass";
            testUnitData.result = @"Pass";
        }
        else
        {
            [mDict[key] setObject:@"0" forKey:key_uut_result];
            [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
            //cutReponse = @"Fail";
            testUnitData.value = cutReponse;
            testUnitData.result = @"Fail";
            testUnitData.errormsg = @"out of spec limit";
            *isPass = NO;
        }
    }
    else if ([mDict[key_max] isNotEqualTo:@"N/A"])
    {
        int int_min = [mDict[key_min] intValue];
        int int_max = [mDict[key_max] intValue];
        float newReponse = [cutReponse floatValue];
        
        if([mDict[@"calculate"] isNotEqualTo:nil])
        {
            if([mDict[@"calculate"] containsString:@"*"])
            {
                newReponse = newReponse * [mDict[@"calculate_value"] floatValue];
            }
        }
        cutReponse = [NSString stringWithFormat:@"%.2f",newReponse];
        testUnitData.value = cutReponse;
        if ((newReponse < int_min) || (newReponse > int_max))
        {
            [mDict[key] setObject:@"0" forKey:key_uut_result];
            testUnitData.result = @"Fail";
            testUnitData.errormsg = @"out of spec limit";
            *isPass = NO;
            
        }else
        {
            [mDict[key] setObject:@"1" forKey:key_uut_result];
            testUnitData.result = @"Pass";
        }
        [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
    }
    else
    {
        if([cutReponse isEqualToString: @""] || [cutReponse isEqualToString:@"NULL"] || [cutReponse length] <= 0)
        {
            [mDict[key] setObject:@"0" forKey:key_uut_result];
            [mDict[key] setObject:@"NULL" forKey:key_uut_vaule];
            testUnitData.value = @"Fail";
            testUnitData.result = @"Fail";
            testUnitData.errormsg = @"cutReponse with nothing";
            *isPass = NO;
        }
        else if([cutReponse isEqualToString: @"ERROR 1"])
        {
            [mDict[key] setObject:@"0" forKey:key_uut_result];
            [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
            testUnitData.value = @"Fail";
            testUnitData.result = @"Fail";
            testUnitData.errormsg = @"ERROR 1";
            *isPass = NO;
        }
        else
        {
            [mDict[key] setObject:@"1" forKey:key_uut_result];
            [mDict[key] setObject:cutReponse forKey:key_uut_vaule];
            testUnitData.value = cutReponse;
            testUnitData.result = @"Pass";
        }
    }
    [cutReponse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([key isEqualToString:key_uut1]) {
        [_uut1ResultArray addObject:cutReponse];
    }else{
        [_uut2ResultArray addObject:cutReponse];
    }
    [UUTTestData replaceObjectAtIndex:row withObject:testUnitData];
    return cutReponse;
}


+(void)updatePlistDatasWithReply:(NSString *)radomStr dict:(NSMutableDictionary *)data isPass:(BOOL *)isPass
{
    
        if ([radomStr containsString:@"jp"]||[radomStr containsString:@"km"]||[radomStr containsString:@"j1"]||[radomStr containsString:@"k2"]) {
            [data setObject:@"0" forKey:key_uut_result];
            *isPass = NO;
        
        }else{
            [data setObject:@"1" forKey:key_uut_result];
        }
        [data setObject:radomStr forKey:key_uut_vaule];
}

@end

