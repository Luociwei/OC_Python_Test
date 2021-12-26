//
//  ConfigPlist.h
//  LUXSHARE_B288_24
//
//  Created by 罗词威 on 04/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestUnitData.h"
@interface ConfigDatas : NSObject

+(NSString *)configPlistName;

+(void)loadWithPlist:(NSString *)plistName;
+(NSArray *)getUUTResultArray:(NSString *)key;
+(NSArray *)getNameArray;
+(NSInteger)getIndexWithItemName:(NSString *)name;
+(NSArray *)getPlistDatas;

+(void)initalPlistDatas;

+(NSArray *)getCommadsArrays;

+(NSString *)updatePlistDatasWithReponse:(NSArray *)reponses row:(NSInteger)row isPass:(BOOL *)isPass key:(NSString *)key UUTTestData:(NSMutableArray *) UUTTestData CBResult:(BOOL)CBResult CBFailCount:(int)CBFailCount bobCatCheck:(BOOL)bobCatCheck AuditMode:(BOOL)auditMode;
//radom data
+(void)updatePlistDatasWithReply:(NSString *)radomStr dict:(NSMutableDictionary *)data isPass:(BOOL *)isPass;

+(void)skip:(NSInteger)row UUTTestData:(NSMutableArray *) UUTTestData key:(NSString *)key;

+(void)finishWordHandler:(NSInteger)row UUTTestData:(NSMutableArray *) UUTTestData key:(NSString *)key PassOrFail:(BOOL)passOrFail;

@end

