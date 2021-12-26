//
//  NSString+Extension.h
//  LUXSHARE_B288_24
//
//  Created by 罗词威 on 04/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

-(NSString *)cw_deleteSpecialCharacter:(NSString *)chargcter;

+(NSString *)cw_returnJoinStringWithArray:(NSArray *)array;

+(NSString *)cw_returnLetterAndNumber:(NSInteger)count;

- (NSString *)cw_getNumString;

@end
