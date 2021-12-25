//
//  ColumnVC.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/2/4.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "ColumnVC.h"

@interface ColumnVC ()

@property (nonatomic,strong)NSMutableArray *btns;

@end

@implementation ColumnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.btns = [NSMutableArray array];
    if (self.titles.count) {
        NSInteger h = 27*self.titles.count;
        self.view.frame=CGRectMake(0, 0, 130, h);
        for (int i =0; i<self.titles.count; i++) {
            NSButton *btn = [NSButton buttonWithTitle:self.titles[i] target:self action:@selector(btnClick:)];
            [btn setButtonType:NSButtonTypeSwitch];
            btn.state=NSOnState;
            btn.frame =CGRectMake(5, 5+26*i, 120, 25);
            [self.view addSubview:btn];
            [self.btns addObject:btn];
        }
        

    }
}

-(void)btnClick:(NSButton *)btn{
    NSLog(@"%@",btn.title);
    NSMutableArray *enableTitles = [NSMutableArray array];
    for (NSButton *btn in self.btns) {
        if (btn.state) {
            [enableTitles addObject:btn.title];
        }
    }
    
    self.reloadColumnBlock(enableTitles);
}

-(instancetype)initWithTitles:(NSArray *)titles
{
    if (self = [super init]) {
        self.titles = titles;
    }
    return self;
}


//-(void)setTitles:(NSArray *)titles{
//    _titles = titles;
//}

@end
