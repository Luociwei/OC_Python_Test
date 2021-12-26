//
//  NSString+File.m
//  iPort
//
//  Created by ciwei luo on 2019/3/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

+(id)cw_getDataWithJosnFile:(NSString *)configfile
{
    //NSString *configfile = [[NSBundle mainBundle] pathForResource:@"EEEECode" ofType:@"json"];
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return jsonObject;
}

+(id)cw_getDataWithPathForResource:(NSString *)fileName
{
    
    NSArray *array = nil;
    if ([fileName containsString:@"."]) {
        array = [fileName componentsSeparatedByString:@"."];
        if (array.count!=2) {
            NSLog(@"wrong file name");
            return @"";
        }
    }else{
        NSLog(@"wrong file name");
        return @"";
    }
    NSString *name = array[0];
    NSString *type = array[1];
    id data=nil;
    NSString *configfile = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if ([type isEqualToString:@".txt"]|| [type containsString:@".plist"] || [type containsString:@".csv"]) {
        
    }else if ([type containsString:@".json"]){
        data=[self cw_getDataWithJosnFile:configfile];
    }
    
    return data;
}

+(NSString *)getResourcePath{
   return [[NSBundle mainBundle] resourcePath];
}

+(NSString *)getDesktopPath
{
    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    return desktopPath;
//     NSString *eCodePath=[desktopPath stringByDeletingLastPathComponent];
}
+(NSString *)getUserPath
{
    NSString *desktopPath = [self getDesktopPath];

    NSString *userPath=[desktopPath stringByDeletingLastPathComponent];
    return userPath;
}


+(NSMutableArray *)getFileNameListInDirPath:(NSString *)filePath str1:(NSString *)str1 {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *de = [fm enumeratorAtPath:filePath];
    NSString *f;
    NSMutableArray *fileNameList = [NSMutableArray array];
    
    while ((f = [de nextObject]))
    {
        if ([f containsString:str1]||[f containsString:str1.lowercaseString]) {
            // fqn = [filePath stringByAppendingPathComponent:f];
            
            [fileNameList addObject:f];
            
        }
    }
    
    
    return fileNameList;
}


+(NSMutableArray *)getFileNameListInDirPath:(NSString *)filePath str1:(NSString *)str1 str2:(NSString *)str2{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *de = [fm enumeratorAtPath:filePath];
    NSString *f;
    NSMutableArray *fileNameList = [NSMutableArray array];
    
    while ((f = [de nextObject]))
    {
        if (([f containsString:str1]||[f containsString:str1.lowercaseString])&&([f containsString:str2]||[f containsString:str2.lowercaseString])) {
            // fqn = [filePath stringByAppendingPathComponent:f];
            
            [fileNameList addObject:f];
            
        }
    }
    
 
    return fileNameList;
}



@end
