//
//  Config.h
//  FDTIScanner
//
//  Created by chenzw on 15-6-28.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
{
    NSString                     *plistPath;
    NSFileManager          *fileManager;
    NSString                     *strResultPlistSpecPath;
    NSMutableDictionary *dataDictionary;
    NSMutableDictionary *dataSpecDictionary;

}

@property(assign) NSMutableDictionary* dataSpecDictionary;


+(Config *)Instance;
-(void) loadAllParam;
-(NSDictionary*) readDictionaryForKey:(NSString*) key;
-(NSArray*) readTestItemForKey:(NSString*) key;
-(void) writeDictionaryForParentKey:(NSString*) parentKey SubKey:(NSString*) subKey SubValue:(NSString*) subValue;

@end
