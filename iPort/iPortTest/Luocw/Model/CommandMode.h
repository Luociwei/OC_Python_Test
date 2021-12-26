//
//  CommandMode.h
//  iPort
//
//  Created by ciwei luo on 2019/3/21.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommandMode : NSObject

@property (copy) NSString *name;
@property (copy) NSString *send;
@property (copy) NSString *response;
@property (copy) NSString *rowHeight;
+(NSArray *)getCommandModes;
@end

NS_ASSUME_NONNULL_END
