//
//  NSString+Extension.h
//  LUXSHARE_B288_24
//
//  Created by 罗词威 on 04/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

-(NSString *)cw_getSubstringFromString:(NSString *)from toLength:(NSInteger)length;
-(NSString *)cw_getSubstringSeparate:(NSString *)separate index:(NSInteger)index;
-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from separate:(NSString *)separate index:(NSInteger)index;
-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to;

-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to separate:(NSString *)separate index:(NSInteger)index;

-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from;

-(NSString *)cw_deleteSpecialCharacter:(NSString *)chargcter;

+(NSString *)cw_returnJoinStringWithArray:(NSArray *)array;

+(NSString *)cw_returnLetterAndNumber:(NSInteger)count;

- (NSString *)cw_getNumString;
- (NSInteger)from16NumberTo10Number;
@end
