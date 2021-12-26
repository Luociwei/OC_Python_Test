//
//  NSString+Cut.h
//  Callisto_Charge
//
//  Created by ciwei on 2018/3/25.
//  Copyright © 2019年 Louis Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Cut)

-(NSString *)cw_getSubstringFromIndex:(NSInteger)fromIndex toLength:(NSInteger)length;

-(NSString *)cw_deleteSpecialCharacter:(NSString *)chargcter;

+(NSString *)cw_returnJoinStringWithArray:(NSArray *)array;

-(NSString *)cw_getSubstringFromString:(NSString *)from toLength:(NSInteger)length;
-(NSString *)cw_getSubstringSeparate:(NSString *)separate index:(NSInteger)index;
-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from separate:(NSString *)separate index:(NSInteger)index;
-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to;

-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to separate:(NSString *)separate index:(NSInteger)index;
-(NSArray *)cw_componentsSeparatedByString:(NSString *)separate;
-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from;



@end

NS_ASSUME_NONNULL_END
