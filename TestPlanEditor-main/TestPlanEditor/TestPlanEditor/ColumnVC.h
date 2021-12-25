//
//  ColumnVC.h
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/2/4.
//  Copyright © 2020 macdev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReloadColumnBlock)(NSArray *titles);


@interface ColumnVC : NSViewController

-(instancetype)initWithTitles:(NSArray *)titles;

@property (nonatomic,strong)NSArray *titles;

@property (nonatomic,copy)ReloadColumnBlock reloadColumnBlock;
@end

NS_ASSUME_NONNULL_END
