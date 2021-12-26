//
//  TestUnitData.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by gdadmin on 2018/6/30.
//  Copyright © 2018年 Vicky Luo. All rights reserved.
//

#import "TestUnitData.h"

@implementation TestUnitData
- (instancetype) init
{
    if (self = [super init]) {
        _testName    = @"";
        _min         = @"";
        _max         = @"";
        _unit        = @"";
        _value       = @"";
        _result      = @"";
        _startTime   = @"";
        _endTime     = @"";
        _time        = @"";
        _finalreult = @"";
        _errormsg    = @"";
        _reply       = @"";
        _cutResult   = @"";
    }
    
    return self;
}

+(NSMutableArray *)initalWithPlistName:(NSString *)plistName
{
    NSMutableArray *mutArray = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * configTestData = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *testItem in configTestData)
    {

        TestUnitData* testUnitData      = [TestUnitData new];
        testUnitData.testName       = ([testItem objectForKey:@"name"] ? : @"subTestName");
        testUnitData.min            = ([testItem objectForKey:@"min"] ? : @"NA");
        testUnitData.max            = ([testItem objectForKey:@"max"] ? : @"NA");
        testUnitData.unit           = ([testItem objectForKey:@"unit"] ? : @"NA");
        testUnitData.value          = @"";
        testUnitData.result         = @"";
        testUnitData.time           = @"";
        testUnitData.startTime   = @"";
        testUnitData.endTime     = @"";
        testUnitData.finalreult = @"";
        testUnitData.errormsg    = @"";
        testUnitData.reply       = @"";
        testUnitData.cutResult   = @"";
        [mutArray addObject:testUnitData];
        
    }
    return mutArray;
}
-(NSString*) getData:(NSString*) attribute
{
    if([attribute isEqualToString:@"testName"]||[attribute isEqualToString:@"name"])
    {
        return _testName;
    }
    else if([attribute isEqualToString:@"min"])
    {
        return _min;
    }
    else if([attribute isEqualToString:@"max"])
    {
        return _max;
    }
    else if([attribute isEqualToString:@"unit"])
    {
        return _unit;
    }
    else if([attribute isEqualToString:@"value"])
    {
        return _value;
    }
    else if([attribute isEqualToString:@"result"])
    {
        return _result;
    }
    else if([attribute isEqualToString:@"startTime"])
    {
        return _startTime;
    }
    else if([attribute isEqualToString:@"endTime"])
    {
        return _endTime;
    }
    else if([attribute isEqualToString:@"time"])
    {
        return _time;
    }
    else if([attribute isEqualToString:@"finalreult"])
    {
        return _finalreult;
    }
    else if([attribute isEqualToString:@"errormsg"])
    {
        return _errormsg;
    }
    else if([attribute isEqualToString:@"reply"])
    {
        return _reply;
    }
    else if([attribute isEqualToString:@"cutResult"])
    {
        return _cutResult;
    }
    return @"";
}

@end
