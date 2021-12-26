//
//  SFHelper.m
//  SippyCup
//
//  Created by Kai Huang on 9/16/15.
//  Copyright (c) 2015 Apple Inc. All rights reserved.
//

#import "SFHelper.h"
#import "IPSFCPost_API.h"
#import "NSString+Cut.h"
#import "LogFile.h"
#import "GPUMode.h"
#import "CWFileManager.h"
#import "MyEexception.h"

@implementation SFHelper


+(NSString *)paramsToURLString:(NSDictionary *)dict
{
    NSMutableArray *kvstrs = [NSMutableArray array];
    
    for (NSString *key in [dict allKeys]) {
        NSString *val = [dict objectForKey:key];
        NSMutableString *str = [NSMutableString string];
        
        [str appendString:key];
        [str appendString:@"="];
        [str appendString:val];
        
        [kvstrs addObject:str];
    }
    
    return [kvstrs componentsJoinedByString:@"&"];
}

+ (bool) pairDUT:(NSString *)dut_sn toCarrier:(NSString *)carrier_sn result:(bool)result
{
    NSString *sfc_url = [SFHelper ghStationInfoForKey:@"SFC_URL"];
    NSString *st_name = [SFHelper ghStationInfoForKey:@"STATION_ID"];
    sfc_url = [sfc_url stringByAppendingString:@"?"];
    
    NSDictionary *q_param = @{ @"sn" : dut_sn,
                               @"c" : @"ADD_RECORD",
                               @"test_station_name" : st_name,
                               @"result" : result ? @"PASS" : @"FAIL",
                               @"fixture_id" : @"1",
                               @"test_head_id" : carrier_sn
                               };
    
    //    sfc_url = [sfc_url stringByAppendingString:paramsToURLString(q_param)];
    sfc_url = [sfc_url stringByAppendingString:[self paramsToURLString:q_param]];
    
    NSLog(@"Pair DUT Request (0x%p): %@", sfc_url, sfc_url);
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:sfc_url]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Pairing Response (0x%p): %@", sfc_url, return_str);
    
    return true;
}

+ (bool) checkCarrierSN_SFIS:(NSString *)carrier_sn
{
    NSString *q_sn = [NSString stringWithFormat:@"CR-%@", carrier_sn];
    return [SFHelper checkDUTSN_SFIS:q_sn];
}

//http://172.26.40.140/BobCat-iMac-V1808/sfc_response.aspx?p=GPUXCode&c=QUERY_RECORD&sn=SC02YG003ML04
+(NSString *)getGPUXCodeWithSN:(NSString *)dut_sn logFile:(NSString *)logFile{
    
    NSString *url =[SFHelper ghStationInfoForKey:@"SFC_URL"];
    NSMutableString *sfc_url = [NSMutableString stringWithFormat:@"%@",url];
    
    [sfc_url appendString:@"?"];//p=GPUXCode&c=QUERY_RECORD
    
    NSDictionary *q_param = @{@"p":@"GPUXCode",@"c":@"QUERY_RECORD",@"sn":dut_sn};
    NSString *q_paramString =[self paramsToURLString:q_param];
    [sfc_url appendString:q_paramString];
  
    [LogFile AddLog:logFile.stringByDeletingLastPathComponent FileName:logFile.lastPathComponent Content:sfc_url];
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:sfc_url]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *reponse = [NSString stringWithFormat:@"respone:%@",return_str];
    [LogFile AddLog:logFile.stringByDeletingLastPathComponent FileName:logFile.lastPathComponent Content:reponse];
   
    return return_str;
    //return YES;
}

//http://172.26.40.140/bobcat-iMac-V1808/sfc_response.aspx?sn=SC02YK006ML20&p=QueryConfig&c=QUERY_RECORD
+(NSString *)getNumberOfGPUsResponseWithSN:(NSString *)dut_sn logFile:(NSString *)logFile{
    
    NSString *url =[SFHelper ghStationInfoForKey:@"SFC_URL"];
    NSMutableString *sfc_url = [NSMutableString stringWithFormat:@"%@",url];
    [sfc_url appendString:@"?"];//p=GPUXCode&c=QUERY_RECORD
    
    NSDictionary *q_param = @{@"sn":dut_sn, @"p":@"QueryConfig",@"c":@"QUERY_RECORD"};
    NSString *q_paramString =[self paramsToURLString:q_param];
    [sfc_url appendString:q_paramString];

    [LogFile AddLog:logFile.stringByDeletingLastPathComponent FileName:logFile.lastPathComponent Content:sfc_url];
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:sfc_url]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", return_str);
    
    
    NSString *reponse = [NSString stringWithFormat:@"respone:%@",return_str];
    [LogFile AddLog:logFile.stringByDeletingLastPathComponent FileName:logFile.lastPathComponent Content:reponse];

    return return_str;
    //return YES;
}
//http://172.26.40.140/BobCat-iMac-V2021/sfc_response.aspx?p=product&c=QUERY_RECORD&sn=C02C9002PWK6
//reponse  0 SFC_OK \n product=J456
+(NSInteger)getPortNumbersOfProjectWithSN:(NSString *)dut_sn logFile:(NSString *)logFile{
    NSString *isConnect =[SFHelper ghStationInfoForKey:@"BOBCAT_DIRECT"];

    NSInteger port_num=-1;
    if (![isConnect isEqualToString:@"ON"]) {
       
        return port_num;
    }
//    NSString *queryConfig =@" 0 SFC_OK \n product=J456";
    NSString *queryConfig = [self getProjectInfoWithSN:dut_sn logFile:logFile];
    if (!([queryConfig containsString:@"SFC_OK"]&&[queryConfig containsString:@"product="])) {
        return port_num;
    }
    NSString *projectStirng = [queryConfig cw_getSubstringFromStringToEnd:@"product="];
    port_num = [self getPortNumbersOFromFileWithProject:projectStirng];
    
    return port_num;
    //return YES;
}

//http://172.26.40.140/BobCat-iMac-V2021/sfc_response.aspx?p=product&c=QUERY_RECORD&sn=C02C9002PWK6
//reponse  0 SFC_OK \n product=J456
+(NSString *)getProjectInfoWithSN:(NSString *)dut_sn logFile:(NSString *)logFile{
    
    NSString *url =[SFHelper ghStationInfoForKey:@"SFC_URL"];
    NSMutableString *sfc_url = [NSMutableString stringWithFormat:@"%@",url];
    [sfc_url appendString:@"?"];//p=GPUXCode&c=QUERY_RECORD
    
    NSDictionary *q_param = @{@"p":@"product",@"c":@"QUERY_RECORD",@"sn":dut_sn};
    NSString *q_paramString =[self paramsToURLString:q_param];
    [sfc_url appendString:q_paramString];
    
    [LogFile AddLog:logFile.stringByDeletingLastPathComponent FileName:logFile.lastPathComponent Content:sfc_url];
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:sfc_url]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", return_str);
    
    
    NSString *reponse = [NSString stringWithFormat:@"respone:%@",return_str];
    [LogFile AddLog:logFile.stringByDeletingLastPathComponent FileName:logFile.lastPathComponent Content:reponse];
    
    return return_str;
    //return YES;
}

+(NSInteger)getPortNumbersOFromFileWithProject:(NSString *)project{
    
    NSInteger num=-1;
    NSString *configfile = [[NSBundle mainBundle] pathForResource:@"ProjectMapPort" ofType:@".json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]) {
        
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in ProjectMapPort.json"];
        return -1;
        
    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in ProjectMapPort.json"];
        return -1;
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject==nil || !jsonObject.count) {

        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in ProjectMapPort.json"];
        return -1;
        // return;
    }
    
    
    for (NSString *key in jsonObject) {
        if ([project.uppercaseString containsString:key.uppercaseString]) {
            num=[jsonObject[key] integerValue];
        }

    }
    
    return num;
}



+(GpuResult *)test_getGPUNumWithSN_new:(NSString *)dut_sn logFile:(NSString *)logFile{
    
    NSArray *gpus = [GPUMode getGPUs];
//    NSString *isConnect =[SFHelper ghStationInfoForKey:@"BOBCAT_DIRECT"];
    GpuResult *gpuResult = [GpuResult new];
    gpuResult.num=0;
//    if (![isConnect isEqualToString:@"ON"]) {
//        gpuResult.num=-1;
//        return gpuResult;
//    }
    NSString *matchFrom = [GPUMode getMatchFrom];
    NSString *matchEnd = [GPUMode getMatchEnd];
    
//    NSString *queryConfig = [self getNumberOfGPUsResponseWithSN:dut_sn logFile:logFile];
    NSString *queryConfig = @"SpecificInfo><Specific><CPU_OPTION>3200</CPU_OPTION><STORAGE_OPTION>2048</STORAGE_OPTION><GPU_OPTION>A217:1</GPU_OPTION><RAM_OPTION>NA</RAM_OPTION><UUT_Config>TOWER</UUT_Config><MLB_VENDOR>NA</MLB_VENDOR><PSU_VENDOR>DELTA</PSU_VENDOR></Specific></SpecificInfo>";
    if (!([queryConfig containsString:matchEnd]&&[queryConfig containsString:matchFrom])) {//[queryConfig containsString:@"SFC_OK"]&&
        return gpuResult;
    }
    //    NSString *keyStirng = [queryConfig cw_getStringBetween:@"</CPU_OPTION><GPU_OPTION>" and:@"</GPU_OPTION><RAM_OPTION>"];
    NSString *keyStirng = [queryConfig cw_getStringBetween:matchFrom and:matchEnd];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"\n\r/r/n"];
    NSArray *mutArr = [keyStirng cw_componentsSeparatedByString:@":"];
    if (mutArr.count != 2) {
        return gpuResult;
    }
    
    NSString *mutType = mutArr[0];
    NSString *num_gpu = mutArr[1];
    NSString *type = [mutType stringByTrimmingCharactersInSet:set];
    if (!type.length || !num_gpu.length) {
        return gpuResult;//stringByTrimmingCharactersInSet
    }
    
    //BOOL isContainType = NO;
    for (GPUMode *mode in gpus) {
        if ([type isEqualToString:mode.type]) {
            // isContainType = YES;
            //NSString *reponse = [self getNumberOfGPUsWithSN:dut_sn logFile:logFile];
            if ([num_gpu isEqualToString:@"1"]) {
                gpuResult.num = [mode.GPU_1 intValue];
                gpuResult.GPU_type = @"Single GPU";
            }else if([num_gpu isEqualToString:@"2"]){
                gpuResult.num = [mode.GPU_2 intValue];
                gpuResult.GPU_type = @"Double GPU";
            }else{
                return gpuResult;
            }
        }
    }
    return gpuResult;
}


+(GpuResult *)getGPUNumWithSN_new:(NSString *)dut_sn logFile:(NSString *)logFile{
    
    NSArray *gpus = [GPUMode getGPUs];
    NSString *isConnect =[SFHelper ghStationInfoForKey:@"BOBCAT_DIRECT"];
    GpuResult *gpuResult = [GpuResult new];
    gpuResult.num=0;
    if (![isConnect isEqualToString:@"ON"]) {
        gpuResult.num=-1;
        return gpuResult;
    }
    NSString *matchFrom = [GPUMode getMatchFrom];
    NSString *matchEnd = [GPUMode getMatchEnd];
    //NSString *gpuXCode = [self getGPUXCodeWithSN:dut_sn logFile:logFile];
    NSString *queryConfig = [self getNumberOfGPUsResponseWithSN:dut_sn logFile:logFile];
    if (!([queryConfig containsString:@"SFC_OK"]&&[queryConfig containsString:matchEnd]&&[queryConfig containsString:matchFrom])) {
        return gpuResult;
    }
//    NSString *keyStirng = [queryConfig cw_getStringBetween:@"</CPU_OPTION><GPU_OPTION>" and:@"</GPU_OPTION><RAM_OPTION>"];
    NSString *keyStirng = [queryConfig cw_getStringBetween:matchFrom and:matchEnd];
   NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"\n\r/r/n"];
    NSArray *mutArr = [keyStirng cw_componentsSeparatedByString:@":"];
    if (mutArr.count != 2) {
        return gpuResult;
    }
    
    NSString *mutType = mutArr[0];
    NSString *num_gpu = mutArr[1];
    NSString *type = [mutType stringByTrimmingCharactersInSet:set];
    if (!type.length || !num_gpu.length) {
        return gpuResult;//stringByTrimmingCharactersInSet
    }

    //BOOL isContainType = NO;
    for (GPUMode *mode in gpus) {
        if ([type isEqualToString:mode.type]) {
           // isContainType = YES;
            //NSString *reponse = [self getNumberOfGPUsWithSN:dut_sn logFile:logFile];
            if ([num_gpu isEqualToString:@"1"]) {
                gpuResult.num = [mode.GPU_1 intValue];
                gpuResult.GPU_type = @"Single GPU";
            }else if([num_gpu isEqualToString:@"2"]){
                gpuResult.num = [mode.GPU_2 intValue];
                gpuResult.GPU_type = @"Double GPU";
            }else{
                return gpuResult;
            }
        }
    }
    return gpuResult;
}


+(GpuResult *)getGPUNumWithSN:(NSString *)dut_sn logFile:(NSString *)logFile{
    
    NSArray *gpus = [GPUMode getGPUs];
    NSString *isConnect =[SFHelper ghStationInfoForKey:@"BOBCAT_DIRECT"];
    GpuResult *gpuResult = [GpuResult new];
    gpuResult.num=0;
    if (![isConnect isEqualToString:@"ON"]) {
        gpuResult.num=-1;
        return gpuResult;
    }
    NSString *gpuXCode = [self getGPUXCodeWithSN:dut_sn logFile:logFile];
    NSString *queryConfig = [self getNumberOfGPUsResponseWithSN:dut_sn logFile:logFile];
    if (!([gpuXCode containsString:@"SFC_OK"]&&[gpuXCode containsString:@"GPUXCode="])) {
        return gpuResult;
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"\n\r/r/n"];
    NSString *mutType = [gpuXCode cw_getSubstringFromStringToEnd:@"GPUXCode="];
    NSString *type = [mutType stringByTrimmingCharactersInSet:set];
    if (!type.length) {
        return gpuResult;//stringByTrimmingCharactersInSet
    }
    
    BOOL isContainType = NO;
    for (GPUMode *mode in gpus) {
        if ([type isEqualToString:mode.type]) {
            isContainType = YES;
            //NSString *reponse = [self getNumberOfGPUsWithSN:dut_sn logFile:logFile];
            if ([queryConfig containsString:@":1</GPU_OPTION><RAM_OPTION>"]) {
                gpuResult.num = [mode.GPU_1 intValue];
                gpuResult.GPU_type = @"Single GPU";
            }else if([queryConfig containsString:@":2</GPU_OPTION><RAM_OPTION>"]){
                gpuResult.num = [mode.GPU_2 intValue];
                gpuResult.GPU_type = @"Double GPU";
            }else{
                isContainType=NO;
            } 
        }
    }
    
    return gpuResult;
}


+ (bool) checkDUTSN_SFIS:(NSString *)dut_sn
{
#define other_peoples_shits_broken
#ifdef other_peoples_shits_broken
    NSString *sfc_url = [SFHelper ghStationInfoForKey:@"SFC_URL"];
    NSString *st_name = [SFHelper ghStationInfoForKey:@"STATION_ID"];
    sfc_url = [sfc_url stringByAppendingString:@"?"];
    
    NSDictionary *q_param = @{ @"sn" : dut_sn, @"c" : @"QUERY_RECORD", @"p" : @"unit_process_check", @"tsid" : st_name };
    //    sfc_url = [sfc_url stringByAppendingString:paramsToURLString(q_param)];
    sfc_url = [sfc_url stringByAppendingString:[self paramsToURLString:q_param]];
    
    NSLog(@"Check SFC Request: %@", sfc_url);
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:sfc_url]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", return_str);
    
    NSString *find = @"unit_process_check";
    
    NSUInteger idx = [return_str rangeOfString:find].location;
    if (idx == NSNotFound) {
        return false;
    }
    
    return_str = [return_str substringFromIndex:idx + [find length]];
    if ([return_str rangeOfString:@"OK"].location == NSNotFound) {
        return false;
    }
    
    return true;
    
    
#else
    NSString *query = [NSString stringWithFormat:@"CR-%s", carrier_sn];
    
    char key[] = "unit_process_check";
    
    struct QRStruct q_struct;
    q_struct.Qkey = key;
    
    struct QRStruct *qrstruct_arr[] = { &q_struct };
    
    int rc = SFCQueryRecord([query UTF8String], qrstruct_arr, 1);
    
    NSLog(@"SFCQueryRecord returned %d", rc);
    NSLog(@"%s", qrstruct_arr[0]->Qval);
    
    return true;
#endif
}

+ (bool) checkDUTSN_SFIS:(NSString *)dut_sn result:(int *)isUOP
{
    NSString *sfc_url = [SFHelper ghStationInfoForKey:@"SFC_URL"];
    NSString *st_name = [SFHelper ghStationInfoForKey:@"STATION_ID"];
    sfc_url = [sfc_url stringByAppendingString:@"?"];
    
    NSDictionary *q_param = @{ @"sn" : dut_sn, @"c" : @"QUERY_RECORD", @"p" : @"unit_process_check", @"tsid" : st_name };
    sfc_url = [sfc_url stringByAppendingString:[self paramsToURLString:q_param]];
    
    NSLog(@"Check SFC Request: %@", sfc_url);
    
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:sfc_url]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *return_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", return_str);
    
    NSString *find = @"unit_process_check";
    
    NSUInteger idx = [return_str rangeOfString:find].location;
    if (idx == NSNotFound) {
        return false;
    }
    
    return_str = [return_str substringFromIndex:idx + [find length]];
    if ([return_str rangeOfString:@"OK"].location == NSNotFound) {
        *isUOP = 1; // set UOP flag enable
        return false;
    }
    
    return true;
}

+ (NSString *) ghStationInfoForKey:(NSString *)key
{
    NSString * stationType = nil;
    NSString * ghStationInfoContent = [NSString stringWithContentsOfFile:@"/vault/data_collection/test_station_config/gh_station_info.json"
                                                                encoding:NSUTF8StringEncoding error:nil];
    NSData * ghStationInfoData = [ghStationInfoContent dataUsingEncoding:NSUTF8StringEncoding];
    if (ghStationInfoData) {
        NSDictionary * ghStationInfo = [NSJSONSerialization JSONObjectWithData:ghStationInfoData
                                                                       options:0
                                                                         error:nil];
        NSDictionary * ghInfo = [ghStationInfo objectForKey:@"ghinfo"];
        if (ghInfo) {
            stationType = [ghInfo objectForKey:key];
        }
    }
    return stationType;
}


@end
