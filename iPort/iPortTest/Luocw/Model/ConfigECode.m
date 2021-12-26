//
//  ConfigECode.m
//  iPort
//
//  Created by ciwei luo on 2019/3/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "ConfigECode.h"
#import "MyEexception.h"

@implementation Type

+(instancetype)typeWithDict:(NSDictionary *)dict
{
    NSArray *arr = @[@"snLength",@"codeIndex",@"codeLength"];
    for (NSString *key in dict.allKeys) {
        if (![arr containsObject:key] || dict.allKeys.count != arr.count) {
           
            [ConfigECode ErrorWithInformation:@"please check the writing form is right under types in EEEE_Code.json" isExit:YES];
        }
    }
    Type *type = [[self alloc] init];

    [type setValuesForKeysWithDictionary:dict];
    
    return type;
}



@end

@implementation AllowCode

+(instancetype)allowCodeWithDict:(NSDictionary *)dict
{
    
    NSArray *arr = @[@"code",@"fixSerialPortsCount"];
    for (NSString *key in dict.allKeys) {
        if (![arr containsObject:key] || dict.allKeys.count > arr.count) {
            [MyEexception RemindException:@"ERROR" Information:@"please check the writing form is right under AllowCodes in EEEE_Code.json"];
            exit (EXIT_FAILURE);
            
        }
    }
    
    AllowCode *allowCode = [[self alloc] init];
    
    [allowCode setValuesForKeysWithDictionary:dict];
    return allowCode;
}

@end

@implementation ProductInfo

+(instancetype)productInfoWithDict:(NSDictionary *)dictProduct
{
    ProductInfo *productInfo = [[ProductInfo alloc] init];
    NSMutableArray *typeArr = [NSMutableArray array];
   
    for (NSDictionary *dict in dictProduct[@"types"]) {
        Type *type = [Type typeWithDict:dict];
        [typeArr addObject:type];
    }
    
    productInfo.types = (NSArray *)typeArr;
    
    NSMutableArray *allowCodeArr = [NSMutableArray array];
    for (NSDictionary *dict in dictProduct[@"allowCodes"]) {
        AllowCode *allowCode = [AllowCode allowCodeWithDict:dict];
        [allowCodeArr addObject:allowCode];
    }
    productInfo.allowCodes = (NSArray *)allowCodeArr;
 
    return productInfo;
}
@end

static NSDictionary *dictDatas = nil;
static BOOL isExistFile= YES;
static BOOL isClickContinue;
@implementation ConfigECode

+(NSDictionary *)getDatas
{
//    if (dictDatas == nil) {
//        if (isExistFile) {
//            [self dataProcess];
//        }
//    }
    [self dataProcess];
    return dictDatas;
}

+(BOOL)isRight
{
    if (dictDatas!=nil && dictDatas.allKeys.count) {
        return YES;
    }else{
        return NO;
    }
    
}

+(void)dataProcess
{
   // NSString *configfile = [[NSBundle mainBundle] pathForResource:@"EEEE_Code" ofType:@"json"];
    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    NSString *eCodePath=[desktopPath stringByDeletingLastPathComponent];
    NSString *configfile=[eCodePath stringByAppendingPathComponent:@"EEEE_Code.json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile] && !isClickContinue) {

        isExistFile = NO;
        BOOL isContinue = [MyEexception messageBoxYesNo:[NSString stringWithFormat:@"No file in path:%@,if not need,click yes.",configfile]];
        if (isContinue) {
            isClickContinue=YES;
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
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    if (jsonObject==nil) {
        
//        BOOL isContinue = [MyEexception messageBoxYesNo:@"please check the writing form is right in EEEE_Code.json file,continue?"];
//
//        if (isContinue) {
//            return;
//        }else{
//            exit (EXIT_FAILURE);
//        }
        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form in EEEE_Code.json"];
        exit (EXIT_FAILURE);
    }
        
    NSMutableDictionary *dictionary =[NSMutableDictionary dictionary];
    //check josn form
 
    for (NSString *key in jsonObject.allKeys) {
        
        id value = jsonObject[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictValue = (NSDictionary *)value;
            
            for (NSString *key1 in dictValue.allKeys) {
                NSArray *arr = @[@"types",@"allowCodes"];
                if ([arr containsObject:key1]) {
                    if (![dictValue[key1] isKindOfClass:[NSArray class]]) {
                        
                         [self ErrorWithInformation:[NSString stringWithFormat:@"please check the writing form is right under %@ in EEEE_Code.json",key1] isExit:YES];
                    }
                }else{
                
                     [self ErrorWithInformation:[NSString stringWithFormat:@"please check %@ is right in EEEE_Code.json",key1] isExit:YES];
                }
                
            }

        }else{
            [self ErrorWithInformation:@"please check the writing form in EEEE_Code.json" isExit:YES];
            
        }
        
        ProductInfo *productInfo = [ProductInfo productInfoWithDict:jsonObject[key]];
        [dictionary setValue:productInfo forKey:key];
        
    }
    dictDatas =(NSDictionary *)dictionary;
}


+(void)ErrorWithInformation:(NSString *)information isExit:(BOOL)isExit
{
    [MyEexception RemindException:@"ERROR" Information:information];
    if (isExit) {
        
        exit (EXIT_FAILURE);
    }
    
}


@end
