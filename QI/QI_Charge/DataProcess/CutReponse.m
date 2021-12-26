//
//  CutReponse.m
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 05/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import "CutReponse.h"
#import "CutResponseModel.h"

@implementation CutReponse

//componentsSeparatedByString
+(NSString *)cutReponse:(NSArray *)reponseArray keywords:(NSArray<CutResponseModel *> *)keywordArray UUTTestData:(NSMutableArray *) UUTTestData
{
    NSMutableString *mutString=[NSMutableString string];
    NSString *reponse = [reponseArray lastObject];
    for (CutResponseModel *model in keywordArray)
    {
        
        if (model.returnIndex != nil)
        {
            reponse =[reponseArray objectAtIndex:[model.returnIndex intValue]];
        }
        
        if ([model.cutModel isEqualToString:@"NO"]) {
            
            return reponse;
        }
        if(reponse == @""||reponse == nil||[reponse length] <= 0)
        {
            return @"NULL";
        }
        if (model.readDataFrom != nil)
        {
            int item_int = -1;
            for(int i = 0; i <[UUTTestData count];i++)//Vrect_Coil1_On_Duty_8.0
            {
                if([[UUTTestData[i] getData:@"name"] isEqualToString:model.readDataFrom])
                {
                    item_int = i;
                }
            }
            if(item_int<0)
            {
                return @"";
            }
            reponse = [UUTTestData[item_int] getData:@"reply"];
        }
        
        
        if (model.resultStr != nil)
        {
            if([model.resultStr containsString:@"pass 100"])
            {
                if(![reponse containsString:@"repeat count 1:"])
                {
                    return reponse;
                }
                NSRange range = [reponse rangeOfString:@"repeat count 1:"];
                NSString *string1 = [reponse substringFromIndex:range.location+range.length];
                if((![string1 containsString:@"pass "])||(![string1 containsString:@"\n"]))
                {
                    return string1;
                }
                NSRange range1 = [string1 rangeOfString:@"pass "];
                NSRange range2 = [string1 rangeOfString:@"\n"];
                int length = range2.location-range1.location - range1.length;
                if(length<=0)
                {
                    return string1;
                }
                NSString * string2 = [string1 substringWithRange:NSMakeRange(range1.location+ range1.length, length)];
                mutString = [NSMutableString stringWithFormat:@"%@", string2];
            }
            else if([model.resultStr containsString:@"only_to"])
            {
                if(![reponse containsString:model.to])
                {
                    return reponse;
                }
                NSRange range_to = [reponse rangeOfString:model.to];
                NSString * string_to = [reponse substringWithRange:NSMakeRange(0, range_to.location)];
                mutString = [NSMutableString stringWithFormat:@"%@", string_to];
            }
//            else if([reponse containsString:model.resultStr])
//            {
//                mutString = [NSMutableString stringWithFormat:@"PASS"];
//            }
        }
        else if(model.to != nil)
        {
            if((![reponse containsString:model.from])||(![reponse containsString:model.to]))
            {
                mutString = [NSMutableString stringWithFormat:@"ERROR 1"];
                return [NSString stringWithFormat:@"%@",mutString];
            }
            NSRange range1 = [reponse rangeOfString:model.from];
            NSRange range2 = [reponse rangeOfString:model.to];
            NSInteger tempLength =range2.location-range1.location-range1.length;
            if (tempLength <= 0)
            {
                mutString = [NSMutableString stringWithFormat:@"ERROR 1"];
                return [NSString stringWithFormat:@"%@",mutString];
            }
            NSRange range = {range1.location+range1.length,tempLength};
            mutString = [NSMutableString stringWithString:[reponse substringWithRange:range]];
            
            if (model.arrayIndex != nil)
           {
                NSString *symbol ;
                if ([mutString containsString:@"-"]) {
                    if ([mutString containsString:@","]) {
                        symbol = @"," ;
                    }else{
                        symbol = @"-" ;
                    }
                }
                if ([mutString containsString:@","]) {
                    symbol = @"," ;
                }
               if ([mutString containsString:@"\t\t"]) {
                   symbol = @"\t\t" ;
               }
                NSArray *array = [mutString componentsSeparatedByString:symbol];
               if ([model.arrayIndex intValue] < array.count) {
                   mutString = [array objectAtIndex:[model.arrayIndex intValue]];
                   //mutString = [NSMutableString stringWithString:[str cw_getNumString]];
               }else{
                   mutString = [NSMutableString stringWithFormat:@"ERROR 2"];
               }
         
            }
            
        }
        else
        {
            if (model.from == nil && model.to == nil) {
                if (model.arrayIndex != nil)
                {
                    NSString *symbol ;
                    if ([mutString containsString:@"-"]) {
                        if ([mutString containsString:@","]) {
                            symbol = @"," ;
                        }else{
                            symbol = @"-" ;
                        }
                    }
                    if ([mutString containsString:@","]) {
                        symbol = @"," ;
                    }
                    if ([mutString containsString:@"\t\t"]) {
                        symbol = @"\t\t" ;
                    }
                    NSArray *array = [mutString componentsSeparatedByString:symbol];
                    if ([model.arrayIndex intValue] < array.count) {
                        NSString *str = [array objectAtIndex:[model.arrayIndex intValue]];
                        mutString = [NSMutableString stringWithString:[str cw_getNumString]];
                    }else{
                        mutString = [NSMutableString stringWithFormat:@"ERROR 3"];
                    }
                    
                }
            }
        }
    }
    
    
    return [NSString stringWithFormat:@"%@",mutString];
}

@end
