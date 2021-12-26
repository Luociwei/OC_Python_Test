//
//  Configuration.h
//  iPortTest
//
//  Created by Zaffer.yang on 3/16/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Configuration : NSObject<NSTableViewDataSource,NSTableViewDelegate>
{
    NSArray *configArr;
    NSInteger totalItem;
    NSMutableArray *groupNameMutArr;
    NSMutableArray *needTestMutArr;
    NSMutableArray *itemNameArr;
    NSMutableArray *typeNameArr;
    NSMutableArray *openLimitArr;
    NSMutableArray *shortLimitArr;
}
@property(readwrite) NSString *number;
@property(readwrite) NSString *groupNme;
@property(readwrite) NSString *itemName;
@property(readwrite) NSString *type;
@property(readwrite) NSString *openLimit;
@property(readwrite) NSString *shortLimit;
@property(readwrite) NSString *needTest;

@end
