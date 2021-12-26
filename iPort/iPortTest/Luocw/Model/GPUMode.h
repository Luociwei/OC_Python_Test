//
//  GPUMode.h
//  iPort
//
//  Created by ciwei luo on 2019/5/18.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface GPUNum : NSObject

@end


@interface GPUMode : NSObject

@property (copy) NSString *GPU_1;
@property (copy) NSString *GPU_2;
@property (copy) NSString *type;

+(NSString *)getMatchFrom;
+(NSString *)getMatchEnd;

+(NSArray *)getGPUs;
@end

NS_ASSUME_NONNULL_END
