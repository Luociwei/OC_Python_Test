//
//  CWLog.h
//  Callisto_Charge
//
//  Created by ttttttt on 2019/2/25.
//  Copyright © 2019年 Vicky Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWFileManager : NSObject

+(void)cw_createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory;

//文件是否能够写
+(BOOL)cw_fileCanWrite:(NSString*)filePath;

+(NSString *)cw_readFromFile:(NSString *)filePath;

+(void)cw_writeToFile:(NSString*)filePath content:(NSString*)content;
+(void)cw_removeItemAtPath:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
