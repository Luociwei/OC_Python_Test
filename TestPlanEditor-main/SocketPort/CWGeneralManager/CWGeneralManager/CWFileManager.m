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

+(BOOL)cw_isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
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



+ (id)cw_serializationWithJsonFilePath:(NSString *)filePath
{
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:filePath]) {
        
        // 保存 json 文件中的信息，即那些字符串
        NSString * jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        return [self cw_serializationWithJsonString:jsonStr];
    }else{
        NSLog(@"not found the file");
        return nil;
    }
    
    
}

//+ (id)cw_serializationWithJsonFileInMainBundle:(NSString *)fileName
//{
//    NSLog(@"1");
//    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//    return [self cw_serializationWithJsonFilePath:path];
//}


// JSON字符串转化为字典
+ (id)cw_serializationWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (id)cw_serializationInMainBundleFile:(NSString *)fileName
{
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    return [self cw_serializationWithJsonFilePath:path];
    
}

//+ (id)cw_serializationWithPlistFilePath:(NSString *)path
//{
//
//    NSFileManager * fileMgr = [NSFileManager defaultManager];
//    if (![fileMgr fileExistsAtPath:path]) {
//        NSLog(@"not found the file");
//        return nil;
//    }
//
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
//    if (dic) {
//        return dic;
//    }else{
//        NSArray *arr=[[NSArray alloc]initWithContentsOfFile:path];
//        return arr;
//    }
//
//}


+(void)cw_openFileWithPath:(NSString *)path{
    system([[NSString stringWithFormat:@"open %@",path] UTF8String]);
}

+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self cw_isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}


+(void)cw_copyBundleFileToDestPath:(NSString *)fullName destDir:(NSString *)destDir{
    NSString *file = [[NSBundle mainBundle] pathForResource:fullName ofType:nil];
    [self cw_copySourceFileToDestPath:file destDir:destDir];
    
}
+(void)cw_copySourceFileToDestPath:(NSString *)sourcePath destDir:(NSString *)destDir{
   
    NSString *localFile =[destDir stringByAppendingPathComponent:sourcePath.lastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:localFile error:nil];
    }
    
}

@end
