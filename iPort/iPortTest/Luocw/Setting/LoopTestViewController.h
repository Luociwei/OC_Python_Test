//
//  LoopTestViewController.h
//  iPort
//
//  Created by ciwei luo on 2020/6/10.
//  Copyright © 2020 Zaffer.yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@protocol LoopTestProtocol <NSObject>

-(void)loopOutClick;
-(void)loopInClick:(NSInteger)count timeInterval:(float)timeInterval;

@end

//@interface LoopTestMode : NSObject
//
//@property (nonatomic)NSInteger loopCount;
//@property (nonatomic)float timeInterval;
//
//@end




@interface LoopTestViewController : NSWindowController
@property (weak) id<LoopTestProtocol>delegate;
-(void)stopLoop;
@property (nonatomic) NSInteger currentLoop;
@property (nonatomic,readonly) NSInteger timeInterval;
@end

NS_ASSUME_NONNULL_END
