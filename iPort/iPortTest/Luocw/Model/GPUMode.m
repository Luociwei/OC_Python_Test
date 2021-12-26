//
//  GPUMode.m
//  iPort
//
//  Created by ciwei luo on 2019/5/18.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "GPUMode.h"
#import "MyEexception.h"
static NSArray *GPUArr;
static BOOL isClickContinue;
@implementation GPUMode

//+(void)load{
//    [self dataProcess];
//}

+(NSDictionary*)getGpuDict{
    NSString *configfile = [[NSBundle mainBundle] pathForResource:@"GPU" ofType:@".json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]&&!isClickContinue) {
        
        BOOL isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"not found the file name in path:%@,continue?",configfile]];
        //[self ErrorWithInformation:@"not found the file name EEEECode.json in app resouce path" isExit:NO];
        if (isContinue) {
            isClickContinue = YES;
            return nil;
        }else{
            exit (EXIT_FAILURE);
        }
        // return;
        
    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in GPU.json"];
        return nil;
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject==nil || !jsonObject.count) {
        
        //        BOOL isContinue = [MyEexception messageBoxYesNo:@"please check the writing form is right in snMapPort.json file,continue?"];
        //
        //        if (isContinue) {
        //            return;
        //        }else{
        //            exit (EXIT_FAILURE);
        //        }
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in GPU.json"];
        exit (EXIT_FAILURE);
        // return;
    }
    
    return jsonObject;

}

+(NSString *)getMatchFrom{
    NSDictionary *dict = [self getGpuDict];
    
    NSDictionary *sub_dict = dict[@"MatchGpuAcodeAndNums"];
    NSString *from = [sub_dict objectForKey:@"from"];
    if (!from.length) {
        return @"_OPTION><GPU_OPTION>";
    }

    return from;
}
+(NSString *)getMatchEnd{
    NSDictionary *dict = [self getGpuDict];
    
    NSDictionary *sub_dict = dict[@"MatchGpuAcodeAndNums"];
    NSString *end = [sub_dict objectForKey:@"end"];
    if (!end.length) {
        return @"</GPU_OPTION><RAM_OPTION>";
    }
    
    return end;
}


+(NSArray *)getGPUs{
    [self dataProcess];
    return GPUArr;
}




+(void)dataProcess
{
    
//    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *eCodePath=[desktopPath stringByDeletingLastPathComponent];
//    NSString *configfile=[eCodePath stringByAppendingPathComponent:@"GPU.json"];
    NSString *configfile = [[NSBundle mainBundle] pathForResource:@"GPU" ofType:@".json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]&&!isClickContinue) {
      
        BOOL isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"not found the file name in path:%@,continue?",configfile]];
        //[self ErrorWithInformation:@"not found the file name EEEECode.json in app resouce path" isExit:NO];
        if (isContinue) {
            isClickContinue = YES;
            return;
        }else{
            exit (EXIT_FAILURE);
        }
        // return;
        
    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in GPU.json"];
        return;
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject==nil || !jsonObject.count) {
        
        //        BOOL isContinue = [MyEexception messageBoxYesNo:@"please check the writing form is right in snMapPort.json file,continue?"];
        //
        //        if (isContinue) {
        //            return;
        //        }else{
        //            exit (EXIT_FAILURE);
        //        }
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in GPU.json"];
        exit (EXIT_FAILURE);
        // return;
    }


    NSMutableArray *mutArr = [NSMutableArray array];
    for (NSString *key in jsonObject) {
        if ([key.lowercaseString containsString:@"match"]) {
            continue;
        }
        GPUMode *mode = [[self alloc] init];
        NSDictionary *dict1 = jsonObject[key];
        mode.type = key;
        mode.GPU_1 = dict1[@"GPU_1"];
        mode.GPU_2 = dict1[@"GPU_2"];
        [mutArr addObject:mode];
    }

    GPUArr = (NSArray *)mutArr;

    //GPUDic = jsonObject;

}
@end
