//
//  NSString+File.h
//  iPort
//
//  Created by ciwei luo on 2019/3/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (File)

+(NSString *)getDesktopPath;

+(NSString *)getUserPath;

+(NSString *)getResourcePath;
+(NSMutableArray *)getFileNameListInDirPath:(NSString *)filePath str1:(NSString *)str1;
+(NSMutableArray *)getFileNameListInDirPath:(NSString *)filePath str1:(NSString *)str1 str2:(NSString *)str2;
@end

NS_ASSUME_NONNULL_END
