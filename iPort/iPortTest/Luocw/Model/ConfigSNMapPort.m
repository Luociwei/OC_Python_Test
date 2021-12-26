//
//  ConfigSNMapPort.m
//  iPort
//
//  Created by ciwei luo on 2019/4/22.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "ConfigSNMapPort.h"
#import "MyEexception.h"

static NSArray *snMapPorts;
static BOOL isExistFile= YES;

@interface ConfigSNMapPort ()
@property (copy) NSString * SN;
@property NSInteger FixPortsCount;

@end

@implementation ConfigSNMapPort


+(NSArray *)getSNMapPortArray{
    
//    if (!snMapPorts.count) {
//        if (isExistFile) {
//            [self dataProcess];
//        }
//    }
    [self dataProcess];
    return snMapPorts;
}


+(void)dataProcess
{
    
    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    NSString *eCodePath=[desktopPath stringByDeletingLastPathComponent];
    NSString *configfile=[eCodePath stringByAppendingPathComponent:@"snMapPort.json"];
    //NSString *configfile = [[NSBundle mainBundle] pathForResource:@"snMapPort.json" ofType:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]&&snMapPorts.count==0) {
        isExistFile = NO;
        BOOL isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"not found the file name in path:%@,continue?",configfile]];
        //[self ErrorWithInformation:@"not found the file name EEEECode.json in app resouce path" isExit:NO];
        if (isContinue) {
            return;
        }else{
            exit (EXIT_FAILURE);
        }
       // return;

    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        return;
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject==nil || !jsonObject.count) {
        
//        BOOL isContinue = [MyEexception messageBoxYesNo:@"please check the writing form is right in snMapPort.json file,continue?"];
//
//        if (isContinue) {
//            return;
//        }else{
//            exit (EXIT_FAILURE);
//        }
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in snMapPort.json"];
        exit (EXIT_FAILURE);
       // return;
    }
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dict in jsonObject) {
        ConfigSNMapPort *snMapPort = [[ConfigSNMapPort alloc] init];
        [snMapPort setValuesForKeysWithDictionary:dict];
        [mutArray addObject:snMapPort];
    }
    //dictDatas =(NSDictionary *)dictionary;
    snMapPorts=mutArray;
}


+(NSInteger)getSNMapPortsCountWithSN:(NSString *)sn{
    NSInteger portsCount=0;
    NSArray *array =[self getSNMapPortArray];
    if (!array.count) {
        return 0;
    }
    for (ConfigSNMapPort *snMap in array){
        if ([snMap.SN isEqualToString:sn]){
            portsCount = snMap.FixPortsCount;
            break;
        }
    }
    if (!(portsCount>=0 && portsCount<= 12)){
        [MyEexception RemindException:@"Check ERROR" Information:[NSString stringWithFormat:@"sn:%@,wrong config with FixPortsCount in snMapPort.json file",sn]];
        exit (EXIT_FAILURE);
    }
     return portsCount;
}

@end
