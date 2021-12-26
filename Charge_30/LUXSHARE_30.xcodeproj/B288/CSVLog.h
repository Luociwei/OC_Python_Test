//
//  CSVLog.h
//  FileOperate
//
//  Created by TOD on 5/6/14.
//  Copyright (c) 2014 DandeLion. All rights reserved.
//

#import <Foundation/Foundation.h>

//此类一般用来作为基类
@interface CSVLog : NSObject


//定义一个静态实例
+(CSVLog*) Instance;

//得到文件路径
-(NSString*)GetFolderPath;

//设置文件路径
-(NSString*)GetFilePath:(NSString*)Path fileName:(NSString*)name;

//判断文化是否存在
-(BOOL) IsExist:(NSString*)strPath isFolder:(BOOL)flag;

//判断文件是否可写
-(BOOL) FileCanWrite:(NSString*)strFullPath;

//删除文件
-(void)RemoveFile:(NSString*)strFilePath;

//创建文件夹
-(void)CreateFolder:(NSString*)strFolder;

//创建文件
-(void)CreateLogFile:(NSString*)strFullPath;

//读取log文件，这个函数一般不会用到，在调试时可以检测是否正确
-(NSString*) ReadFile:(NSString*)strFullPath;

////写log文件，要注意log文件的格式，逗号表示下一格，\n表示换行
-(void) WriteFile:(NSString*)strFolderPath andFullPath:(NSString*)strFullPath andContent:(NSString*)contents IsAppend:(BOOL)isAppend;

@end
