//
//  CommandMode.m
//  iPort
//
//  Created by ciwei luo on 2019/3/21.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "CommandMode.h"


static NSArray *commands;
@implementation CommandMode


+(void)load
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CommandList" ofType:@"plist"];
    if (!filePath.length) {
        return;
    }
   
  
    NSArray *configDic = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dict in configDic) {
        CommandMode *command = [self new];
        command.name = dict[@"name"];
        command.send = dict[@"send"];
        command.response = dict[@"response"];
        command.rowHeight = dict[@"rowHeight"];
       
        [mutArray addObject:command];
    }
    
    commands =(NSArray *)mutArray;

}

+(NSArray *)getCommandModes
{
    return commands;
}



@end
