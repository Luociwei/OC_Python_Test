//
//  CSVLog.m
//  FileOperate
//
//  Created by TOD on 5/6/14.
//  Copyright (c) 2014 DandeLion. All rights reserved.
//

#import "CSVLog.h"

static CSVLog* csvLog=nil;

@implementation CSVLog


+(CSVLog*) Instance
{
    @synchronized(self)
    {
        if(nil==csvLog)
            csvLog=[[CSVLog alloc]init];
    }
    
    return csvLog;
}

-(id)init
{
    if(self=[super init])
    {}
    return self;
}

//释放对象
-(void)dealloc
{

}

//设置文件路径
-(NSString*)GetFilePath:(NSString*)path fileName:(NSString*)name
{
    if(path.length<1||name.length<1)
    {
        NSRunAlertPanel(@"提示", @"请填写文件路径和名称!", @"提示", nil, nil);
    }
    
    return [NSString stringWithFormat:@"%@/%@",path,name];
}

//获取系统debug文件夹名称
-(NSString*)GetFolderPath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString* strFloder= [fileManager currentDirectoryPath];
    return strFloder;
}

//判断所给文件路径是否存在
-(BOOL) IsExist:(NSString*)strPath isFolder:(BOOL)flag
{
    if(strPath.length<1)
        return NO;
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:strPath isDirectory:&flag])
    {
        return YES;
    }
    return NO;
}

//删除文件及文件夹
-(void)RemoveFile:(NSString*)strFilePath
{
    if([self IsExist:strFilePath isFolder:NO])
    {
        NSFileManager* fileManager=[NSFileManager defaultManager];
        [fileManager removeItemAtPath:strFilePath error:NULL];
    }
}

//创建文件夹
-(void)CreateFolder:(NSString*)strFolder
{
    if(![self IsExist:strFolder isFolder:YES])
    {
        NSFileManager* fileManager=[NSFileManager defaultManager];
        
        [fileManager createDirectoryAtPath:strFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//创建文件
-(void)CreateLogFile:(NSString*)strFullPath
{
    if(![self IsExist:strFullPath isFolder:NO])
   {
       NSFileManager* fileManager=[NSFileManager defaultManager];
       
       [fileManager createFileAtPath:strFullPath contents:nil attributes:nil];
   }
}

//文件是否能够写
-(BOOL) FileCanWrite:(NSString*)strFullPath
{
    BOOL readFlag=NO;
    
    NSFileManager* file=[NSFileManager defaultManager];
    
    if([file isWritableFileAtPath:strFullPath])
        readFlag= YES;
    return readFlag;
}

//读取文件信息
-(NSString*) ReadFile:(NSString*)strFullPath
{
	NSString* fileContent = [NSString stringWithContentsOfFile:strFullPath usedEncoding:nil error:nil];
	return fileContent;
}

//写log文件，要注意log文件的格式，逗号表示下一格，\n表示换行
-(void) WriteFile:(NSString*)strFolderPath andFullPath:(NSString*)strFullPath andContent:(NSString*)contents IsAppend:(BOOL)isAppend
{
	NSMutableString* fileContents=[[NSMutableString alloc]init];
//    NSLog(@"%@",logFullPath);
    
    if([strFolderPath length]>0 && ![self IsExist:strFolderPath isFolder:YES])
        [self CreateFolder:strFolderPath];
	if (![self IsExist:strFullPath isFolder:NO])
		[self CreateLogFile:strFullPath];
    if(![self FileCanWrite:strFullPath])
    {
        return;
    }

    if (isAppend)
    {
        [fileContents setString:[self ReadFile:strFullPath]];
        [fileContents appendString:contents];
    }
    else
    {
        [fileContents setString:contents];
    }
    
	[fileContents writeToFile:strFullPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
