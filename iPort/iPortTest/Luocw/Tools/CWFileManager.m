//
//  CWLog.m
//  Callisto_Charge
//
//  Created by ttttttt on 2019/2/25.
//  Copyright © 2019年 Vicky Luo. All rights reserved.
//

#import "CWFileManager.h"

@implementation CWFileManager

+(void)cw_createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        if (isDirectory) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
    }
}

+(void)cw_removeItemAtPath:(NSString *)filePath
{
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
    
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
}


//文件是否能够写
+(BOOL)cw_fileCanWrite:(NSString*)filePath
{
    BOOL readFlag=NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager isWritableFileAtPath:filePath]) readFlag= YES;
    
    return readFlag;
}

+(NSString *)cw_readFromFile:(NSString *)filePath
{
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+(void)cw_writeToFile:(NSString*)filePath content:(NSString*)content
{
    if (![self cw_fileCanWrite:filePath]) {
        NSLog(@"the file was not able to be wrote");
        return;
    }
    @synchronized(self) {
        NSMutableData *writer = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        [writer appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [writer writeToFile:filePath atomically:YES];
    }
}


@end
