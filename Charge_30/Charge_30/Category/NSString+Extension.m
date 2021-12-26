//
//  NSString+Extension.m
//  LUXSHARE_B288_24
//
//  Created by 罗词威 on 04/05/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(NSString *)cw_getSubstringFromString:(NSString *)from toLength:(NSInteger)length
{
    
    NSString *returnString = nil;
    
    if ([self containsString:from]) {
        NSRange range1 = [self rangeOfString:from];
        NSRange range2 = NSMakeRange(range1.location+range1.length, length);
        if (range1.location+range1.length+length<=self.length) {
            returnString = [self substringWithRange:range2];
        }else{
            NSLog(@"length beyond bounds");
        }
        
    }else{
        NSLog(@"%@ not found %@",self,from);
    }
    
    return returnString;
    
}

-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from
{
    NSString *returnString = nil;
    
    if ([self containsString:from]) {
        NSRange range = [self rangeOfString:from];
        returnString = [self substringFromIndex:range.location+range.length];
    }else{
        NSLog(@"%@ not found %@",self,from);
    }
    
    return returnString;
}

-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to
{
    NSString *mutString = nil;
    if([self containsString:from]&&[self containsString:to])
    {
        
        NSRange range1 = [self rangeOfString:from];
        NSRange range2 = [self rangeOfString:to];
        
        NSInteger tempLength =range2.location-range1.location-range1.length;
        NSRange range = {range1.location+range1.length,tempLength};
        mutString = [self substringWithRange:range];
        
    }
    return mutString;
}

-(NSString *)cw_getStringBetween:(NSString *)from toLength:(NSInteger)legth separate:(NSString *)separate index:(NSInteger)index
{
    NSString *tempString = nil;
    tempString = [self cw_getSubstringFromString:from toLength:legth];
    NSString *returnString = [tempString cw_getSubstringSeparate:separate index:index];
    return returnString;
}
//cw_getSubstringFromStringToEnd

-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from separate:(NSString *)separate index:(NSInteger)index
{
    NSString *tempString = [self cw_getSubstringFromStringToEnd:from];
    NSString *returnString = [tempString cw_getSubstringSeparate:separate index:index];
    return returnString;
}

-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to separate:(NSString *)separate index:(NSInteger)index
{
    NSString *tempString = nil;
    if (to==nil) {
        tempString = [self cw_getSubstringFromStringToEnd:from];
    }else{
        tempString = [self cw_getStringBetween:from and:to];
    }

    NSString *returnString = [tempString cw_getSubstringSeparate:separate index:index];
    return returnString;
}

-(NSString *)cw_getSubstringSeparate:(NSString *)separate index:(NSInteger)index
{
    NSMutableString *mutString = [NSMutableString stringWithString:self];
    NSArray *mutArray;
    if([mutString containsString:separate])
    {
        mutArray = [mutString componentsSeparatedByString:separate];
    }else{
        NSLog(@"%@ not found %@",mutString,separate);
    }
    NSString *returnString;
    if (mutArray.count>index) {
        returnString = [mutArray objectAtIndex:index];
    }else{
        NSLog(@"index %ld beyond bounds,NSArray:%@",index,self);
    }
    return returnString;
}


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

- (NSInteger)from16NumberTo10Number
{
    
    /// NSString *hexString = @"0008d478";
    //NSLog(@"hexString2 is %@", hexString);
    NSString * string = [self stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    
    double to10Number = 0;
    for(int i=0;i<[string length];i++)
    {
        //int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [string characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        
        //int int_ch1;
        double base = 1;
        for (int j = 0; j < [string length] -1 -i; j++)
        {
            base = base * 16;
        }
        if(hex_char1 >= '0' && hex_char1 <='9')
            
            to10Number = to10Number + (hex_char1-48)*base;   //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            to10Number = to10Number + (hex_char1-55)*base; //// A 的Ascll - 65
        else
            to10Number = to10Number + (hex_char1-87)*base; //// a 的Ascll - 97
        
        
        // NSLog(@"int_ch=%f",to10Number);
        
        
    }
    //NSLog(@"int_ch=%f",to10Number);
    
    
    return (NSInteger)to10Number;
}
@end

