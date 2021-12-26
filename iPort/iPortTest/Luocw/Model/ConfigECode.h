//
//  ConfigECode.h
//  iPort
//
//  Created by ciwei luo on 2019/3/28.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSAlert.h>


NS_ASSUME_NONNULL_BEGIN

@interface Type : NSObject

@property NSInteger snLength;

@property NSInteger codeIndex;

@property NSInteger codeLength;

@end


@interface AllowCode : NSObject

@property (copy) NSString * code;

@property NSInteger fixSerialPortsCount;

@end

@interface ProductInfo : NSObject

@property (copy) NSArray * types;

@property (copy) NSArray *allowCodes;

@end

@interface ConfigECode : NSObject

+(NSDictionary *)getDatas;
+(BOOL)isRight;
+(void)ErrorWithInformation:(NSString *)information isExit:(BOOL)isExit;
@end

NS_ASSUME_NONNULL_END
