//
//  SearchListVC.h
//  ClientSocket
//
//  Created by ciwei luo on 2020/3/11.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchListVCDelegate <NSObject>
-(void)SearchListSignelClick:(NSString *)cmd;
-(void)SearchListDoubleClick:(NSString *)cmd;
@end


@interface SearchListVC : NSViewController
@property(nonatomic,weak)id<SearchListVCDelegate> delegate;
@property (copy)NSString *file;
@end

NS_ASSUME_NONNULL_END
