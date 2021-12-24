//
//  CWZMQ.h
//  Atlas2_Review_Tool
//
//  Created by ciwei luo on 2021/12/11.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWZMQ : NSObject
+(void)shutdown;
-(instancetype)initWithURL:(NSString *)url pythonFile:(NSString *)filePath;
-(instancetype)initWithURL:(NSString *)url pythonFile:(NSString *)filePath launchPath:(NSString *)launchPath;
//-(BOOL)sendString:(NSString *)msg;
-(BOOL)send:(id)msg;//NSString/NSArrar/NSDict
-(NSString *)read:(NSInteger)size;
-(NSString *)read;
//-(NSString *)sendRead:(NSString *)msg;
-(BOOL)sendMessage:(NSString *)name event:(NSString *)event params:(NSArray *)params;

@end

NS_ASSUME_NONNULL_END
