//
//  Configuration.m
//  iPortTest
//
//  Created by Zaffer.yang on 3/16/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "Configuration.h"
#import "PlistUtilities.h"

@implementation Configuration
//-(void)awakeFromNib
//{
//    NSLog(@"===========load configuration===============");
//    totalItem = 0;
//    groupNameMutArr = [[NSMutableArray alloc] init];
//    needTestMutArr = [[NSMutableArray alloc] init];
//    
//    itemNameArr = [[NSMutableArray alloc] init];
//    typeNameArr = [[NSMutableArray alloc] init];
//    openLimitArr = [[NSMutableArray alloc] init];
//    shortLimitArr= [[NSMutableArray alloc] init];
//    
//    configArr  = (NSArray *)[PlistUtilities loadFile:@"config" forProduct:@"iPort"];
//    NSLog(@"%lu",(unsigned long)[configArr count]);
//    
//    for (int i=0; i<[configArr count]; i++) {
//        for (NSString *key in [configArr[i] allKeys]) {
//            
//            if ([key isEqualToString:@"GroupName"]) {
//                NSString *groupName=[configArr[i] valueForKey:@"GroupName"];
//                bool needTestFlag=[(NSNumber*)[configArr[i] objectForKey:@"NeedTest"] boolValue];
////                NSLog(@"needTestFlag = %@",needTestFlag);
//                NSArray *itemArr=[configArr[i] valueForKey:@"Itemes"];
//                
//                totalItem += [itemArr count];//caculate all the test item
//                for (int i=0; i<[itemArr count]; i++) {
//                    [groupNameMutArr addObject:groupName];
//                    if(needTestFlag){
//                        [needTestMutArr addObject:@"YES"];
//                    }
//                    else{
//                        [needTestMutArr addObject:@"NO"];
//                    }
//                    [itemNameArr addObject:[itemArr[i] objectForKey:@"TestItemName"]];
//                    [typeNameArr addObject:[itemArr[i] objectForKey:@"Type"]];
//                    [openLimitArr addObject:[itemArr[i] objectForKey:@"OpenLimit"]];
//                    [shortLimitArr addObject:[itemArr[i] objectForKey:@"ShortLimit"]];
//                }
////                    [needTestMutArr addObject:needTestFlag];
////                NSLog(@"yzy===groupName = %@",groupName);
//            }
////            else if ([key isEqualToString:@"Itemes"]) {
////                NSArray *itemArr=[configArr[i] valueForKey:@"Itemes"];
////                [itemArr count];
////                
////            }
//
//        }
//    }
//}
//#pragma table view datasource
//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
//{   
////    for (int i=0; i<[configArr count]; i++) {
////        for (NSString *key in [configArr[i] allKeys]) {
////            if ([key isEqualToString:@"Itemes"]) {
////                NSArray *itemArr=[configArr[i] valueForKey:@"Itemes"];
////                totalItem += [itemArr count];
////            }
////        }
////    }
//    return totalItem;
//}
//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
////    for (int i=0; i<[configArr count]; i++) {
////        for (NSString *key in [configArr[i] allKeys]) {
////            if ([key isEqualToString:@"Itemes"]) {
////                NSArray *itemArr=[configArr[i] valueForKey:@"Itemes"];
////
////            }
////        }
////    }
//    
//    if ([[tableColumn identifier] isEqualToString:@"Number"]) {
//        return [NSNumber numberWithInteger:row+1];
//    }
//    else if([[tableColumn identifier] isEqualToString:@"GroupName"]){
//        return groupNameMutArr[row];
//    }
//    else if([[tableColumn identifier] isEqualToString:@"ItemName"]){
//        return itemNameArr[row];
//    }
//    else if([[tableColumn identifier] isEqualToString:@"Type"]){
//        return typeNameArr[row];
//    }
//    else if([[tableColumn identifier] isEqualToString:@"OpenLimit"]){
//        return openLimitArr[row];
//    }
//    else if([[tableColumn identifier] isEqualToString:@"ShortLimit"]){
//        return shortLimitArr[row];
//    }
//    else if([[tableColumn identifier] isEqualToString:@"NeedTest"]){
//        return needTestMutArr[row];
//    }
////    if ([[tableColumn identifier] isEqualToString:@"index"])
////    {
////        //        return [NSNumber numberWithLong:row+1];
////        return [dicTableView allKeys][row];
////    }
////    else
////    {
//        //        id v = [dicTableView valueForKey:[NSString stringWithFormat:@"%@%ld",[tableColumn identifier],row]];
////        id v = [dicTableView valueForKey:[dicTableView allKeys][row]];
////        if (!v) {
////            v=@"None";
////        }
////        return v;
////    }
//    NSString* a =@"test";
//    return a;
//}

@end
