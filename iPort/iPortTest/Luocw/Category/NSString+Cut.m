//
//  NSString+Cut.m
//  Callisto_Charge
//
//  Created by ciwei on 2018/3/25.
//  Copyright © 2019年 Louis Luo. All rights reserved.
//

#import "NSString+Cut.h"

@implementation NSString (Cut)

-(NSString *)cw_getSubstringFromIndex:(NSInteger)fromIndex toLength:(NSInteger)length
{
    if (self.length<(fromIndex+length)) {
        NSLog(@"length beyond bounds");
        return @"";
    }
    NSString *mutStr = [self substringFromIndex:fromIndex];
    NSString *returnString = [mutStr substringToIndex:length];
    return returnString;
}

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
    NSString *mutString = @"";
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

-(NSArray *)cw_componentsSeparatedByString:(NSString *)separate
{
    NSArray *mutArray=nil;
    if([self containsString:separate])
    {
        mutArray = [self componentsSeparatedByString:separate];
    }else{
        NSLog(@"%@ not found %@",self,separate);
    }
    return mutArray;
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



@end
