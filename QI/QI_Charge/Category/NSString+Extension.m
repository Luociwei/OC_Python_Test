//
//  NSString+Extension.m
//  LUXSHARE_B288_24
//
//  Created by 罗词威 on 04/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(NSString *)cw_deleteSpecialCharacter:(NSString *)chargcter
{
    return [self stringByReplacingOccurrencesOfString:chargcter withString:@""];
}

+(NSString *)cw_returnJoinStringWithArray:(NSArray *)array
{
    NSMutableString *mutStr = [NSMutableString string];
    int index = 0;
    for (NSString *str in array) {
        if (index == 0) {
            [mutStr appendString:[NSString stringWithFormat:@"%@",str]];
        }else{
            
            [mutStr appendString:[NSString stringWithFormat:@",%@",str]];
        }
        index++;
    }
    [mutStr appendString:@"\n"];
    return (NSString *)mutStr;
}


- (NSString *)cw_getNumString
{
    
  //  NSString *s = @"7e32tyrc7b0qr7eqr73odewpqru40387543qhrec8r5yn42543nvtyr7";
    
    NSMutableArray *characters = [NSMutableArray array];
    NSMutableString *mutStr = [NSMutableString string];
    
    
    // 分离出字符串中的所有字符，并存储到数组characters中
    for (int i = 0; i < self.length; i ++) {
        NSString *subString = [self substringToIndex:i + 1];
        
        subString = [subString substringFromIndex:i];
        
        [characters addObject:subString];
    }
    // @"<gg-v=3677, i=-012, t=249, c=012, h=002, hv=000>";
    // 利用正则表达式，匹配数组中的每个元素，判断是否是数字，将数字拼接在可变字符串mutStr中
    for (NSString *b in characters) {
        NSString *regex = @"^[0-9]|[-]*$";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];// 谓词
        BOOL isShu = [pre evaluateWithObject:b];// 对b进行谓词运算
        if (isShu) {
            [mutStr appendString:b];
        }
    }
    //NSLog(@"数字符串: %@", mutStr);
    return mutStr;
    
}

//返回随机大小写字母和数字
+(NSString *)cw_returnLetterAndNumber:(NSInteger)count
{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

@end

