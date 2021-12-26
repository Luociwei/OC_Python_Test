//
//  Config.m
//  FDTIScanner
//
//  Created by chenzw on 15-6-28.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import "Config.h"

@implementation Config
@synthesize dataSpecDictionary=_dataSpecDictionary;

static Config *instance=nil;

+(Config *)Instance
{
    if (instance==nil)
    {
        instance=[[super allocWithZone:NULL] init];
        
    }
    return instance;
}

+(id):(NSZone *)zone
{
    return [Config Instance];
}

-(id) init
{
    if (self=[super init])
    {
        dataDictionary = [[NSMutableDictionary alloc] init];
        dataSpecDictionary=[[NSMutableDictionary alloc]init];
        
        fileManager = [[NSFileManager alloc] init];
        plistPath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
        strResultPlistSpecPath=[[NSBundle mainBundle]pathForResource:@"ResultSpec" ofType:@"plist"];
        [self loadAllParam];
    }
    
    return self;
}

-(void) setPath
{
    plistPath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
    
    if (plistPath == nil)
    {
        NSRunAlertPanel(@"Warning", @"Configure file have lost,",@"OK", nil, nil);
    }
    
    //strResultPlistSpecPath=[[NSBundle mainBundle]pathForResource:@"ResultSpec" ofType:@"plist"];
}

-(void) loadAllParam
{
    [self setPath];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ([dataDictionary count] > 0)
    {
        [dataDictionary removeAllObjects];
    }
    
    [dataDictionary addEntriesFromDictionary:dictionary];
    //[dictionary release];
    
    NSDictionary* dicSpecTemp=[[NSDictionary alloc] initWithContentsOfFile:strResultPlistSpecPath];
    
    if([ _dataSpecDictionary count]>0)
    {
        [_dataSpecDictionary removeAllObjects];
    }
    
    [_dataSpecDictionary addEntriesFromDictionary:dicSpecTemp];
    [self setDataSpecDictionary:_dataSpecDictionary];
    
    
}

-(NSDictionary*) readLogForKey
{
    NSDictionary *dict = [self readDictionaryForKey:@"Path"];
    return dict;
}

# pragma mark read plist file objects 读取plist文件参数
-(NSDictionary*) readDictionaryForKey:(NSString*) key
{
    NSDictionary *dict = [dataDictionary objectForKey:key];
    return dict;
}

-(void) writeDictionaryForParentKey:(NSString*) parentKey SubKey:(NSString*) subKey SubValue:(NSString*) subValue
{
    [self setPath];
    NSDictionary *allItem = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] initWithDictionary:allItem];
    NSMutableDictionary *dict = [itemDict objectForKey:parentKey];
    [dict setObject:subValue forKey:subKey];
    
    if ([itemDict writeToFile:plistPath atomically:YES] == NO)
        NSLog(@"fail");
    if (allItem!=nil) {
        //[allItem release];
    }
    if (itemDict !=nil) {
        //[itemDict release];
    }
}

-(void) writeDictionaryForParentKey:(NSString*) parentKey  SubValue:(NSArray*)value
{
    [self setPath];
    NSDictionary *allItem = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] initWithDictionary:allItem];
    NSMutableArray* arrayTemp=[[NSMutableArray alloc] initWithArray:[itemDict objectForKey:parentKey]];
    [arrayTemp addObject:value];
    
    [itemDict setObject:arrayTemp forKey:parentKey];
    
    if ([itemDict writeToFile:plistPath atomically:YES] == NO)
        NSLog(@"fail");
    if (allItem!=nil) {
        //[allItem release];
    }
    if (itemDict !=nil) {
        //[itemDict release];
    }
}

-(NSArray*) readTestItemForKey:(NSString*) key
{
    NSArray *array = [dataDictionary objectForKey:key];
    return array;
}

@end
