//
//  TextView.h
//  MyBase
//
//  Created by Louis Luo on 2021/12/24.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextView : NSTextView
//+(instancetype)cw_allocInitWithFrame:(NSRect)frame;
-(void)showLog:(NSString *)log;
-(void)setPingIpAddress:(NSString *)ip;
-(void)clean;
- (void)saveLog;
-(void)searchIpFrom:(NSString *)ip to:(NSInteger)ipRangeCount;

@end

NS_ASSUME_NONNULL_END
