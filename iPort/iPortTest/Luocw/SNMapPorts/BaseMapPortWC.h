//
//  SNMapPortsWC.h
//  iPort
//
//  Created by ciwei luo on 2019/4/29.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, BaseMapPortWCType) {
    BaseMapPortWCTypeSN = 1,
    BaseMapPortWCTypeEcode = 2,
    BaseMapPortWCTypeStation = 3,
    BaseMapPortWCTypeConfig = 4,
    
};
@protocol BaseMapPortWCProtocol <NSObject>

-(void)baseMapPortWCSaveClick;

@end
@interface BaseMapPortWC : NSWindowController
@property (unsafe_unretained) IBOutlet NSTextView *snMapTextView;
-(NSString *)getFileContentWithFileName:(NSString *)fileName;
@property  (nonatomic) BaseMapPortWCType type;
@property (weak) id<BaseMapPortWCProtocol>delegate;
+(instancetype)mapPortWC;
@property NSInteger loadTimes;
@end

NS_ASSUME_NONNULL_END
