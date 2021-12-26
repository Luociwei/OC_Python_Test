//
//  PoolPDCA.m
//  PoolingTest
//
//  Created by tod on 6/16/14.
//  Copyright (c) 2014 MINI-007. All rights reserved.
//

#import "PoolPDCA.h"

static PoolPDCA* poolPDCA=nil;

@implementation PoolPDCA
@synthesize isPDCAStart;
@synthesize hasWritePDCAAtrribute;

-(id)init
{
   if(self=[super init])
   {
       PDCA=[[pudding alloc] init];
       [self setIsPDCAStart:NO];
       [self setHasWritePDCAAtrribute:NO];
   }
    
    return self;
}

+(PoolPDCA*)Instance
{
   if(poolPDCA==nil)
   {
       poolPDCA=[[PoolPDCA alloc]init];
   }
    
    return poolPDCA;
}

-(void)dealloc
{
    
//    [PDCA release];
//    [super dealloc];
}

-(void)PDCAStart
{
    static int countPDCA=0;
    
    if(![self isPDCAStart])
    {
        [PDCA UUTStartTest];
        [self setIsPDCAStart:YES];
        NSLog(@"------PDCAStart:%d",countPDCA);
        countPDCA++;
    }
}

-(void)PDCARelease
{
    if([self isPDCAStart])
    {
        [PDCA UUTRelease];
        [self setIsPDCAStart:NO];
    }
}

-(void)PDCAStart:(struct structPDCA)structPDCAAtrribute
{
    static int countPDCA=0;
    
    @autoreleasepool//自动Release
    {
        struct structPDCA PACD=structPDCAAtrribute;
        
        if(!isPDCAStart && PACD.isNeedStart)
        {
            [PDCA UUTStartTest];
            [self setIsPDCAStart:YES];
            NSLog(@"------PDCAStart:%d",countPDCA);
            
            [PDCA ValidateSerialNumber:PACD.strSN];
            [PDCA AddAttribute:@"serialnumber" AttributeValue:PACD.strSN];
            [PDCA AddAttribute:@"softwarename" AttributeValue:PACD.strSoftName];
            [PDCA AddAttribute:@"softwareversion" AttributeValue:PACD.strSoftVersion];
            
            countPDCA++;
        }
    }
}

-(void)PDCARelease:(struct structPDCA)structPDCAAtrribute
{
    static int countPDCA=0;
    
    @autoreleasepool
    {
        struct structPDCA PACD=structPDCAAtrribute;
        
        if([self isPDCAStart]&& PACD.isNeedRelease)
        {
            [PDCA UUTRelease];
            [self setIsPDCAStart:NO];
             NSLog(@"------PDCAStop:%d",countPDCA);
            
            countPDCA++;
        }
    }
}

//
-(void)WritePDCAAttribute:(struct structPDCA)structPDCAAtrribute
{
    if([self isPDCAStart] && ![self hasWritePDCAAtrribute])
    {
        [self setHasWritePDCAAtrribute:YES];
        [PDCA ValidateSerialNumber:structPDCAAtrribute.strSN];
        [PDCA AddAttribute:@"serialnumber" AttributeValue:structPDCAAtrribute.strSN];
        [PDCA AddAttribute:@"softwarename" AttributeValue:structPDCAAtrribute.strSoftName];
        [PDCA AddAttribute:@"softwareversion" AttributeValue:structPDCAAtrribute.strSoftVersion];
    }
}

//
-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue andLowerSpec:(NSString*)strLowerSpec andUpperSpec:(NSString*)strUpperSpec andUnit:(NSString*)strUnit andIsPass:(NSString*)isPass andPointNum:(uint8)pointIndex
{
    NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* strValueTemp=[strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* strTemp=[NSString stringWithFormat:@"P%d_%@",pointIndex,strNameTemp];
    
    if([self isNumber:strValueTemp])
    {
        [PDCA AddTestItem:strTemp LowerSpec:strLowerSpec UpperSpec:strUpperSpec Unit:strUnit TestValue:strValueTemp TestResult:isPass ErrorInfo:@"" Priority:@""];
    }
    else
    {
        [PDCA AddTestItem:strTemp TestValue:strValueTemp TestResult:isPass ErrorInfo:@"" Priority:@""];
    }
}

//
-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue andPointNum:(uint8)pointIndex
{
    NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* strValueTemp=[strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* strTemp=[NSString stringWithFormat:@"P%d_%@",pointIndex,strNameTemp];
    
    if([self isNumber:strValueTemp])
    {
        [PDCA AddTestItem:strTemp LowerSpec:@"N/A" UpperSpec:@"N/A" Unit:@"N/A" TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
    else
    {
        [PDCA AddTestItem:strTemp TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
}

-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue str_PDCA:(NSString*)str_PDCA
{
    NSString* strNameTemp=[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* strValueTemp=[strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* strTemp=str_PDCA;
    
    if([self isNumber:strValueTemp])
    {
        [PDCA AddTestItem:strTemp LowerSpec:@"N/A" UpperSpec:@"N/A" Unit:@"N/A" TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
    else
    {
        [PDCA AddTestItem:strTemp TestValue:strValueTemp TestResult:@"PASS" ErrorInfo:@"" Priority:@""];
    }
}

//judge the number wheter is a number
-(BOOL)isNumber:(NSString*)strValue
{
    if ([strValue length]>0)
    {
        if([strValue characterAtIndex:0]> '9' || [strValue characterAtIndex:0] < '0')
        {
            return  NO;
        }
    }
    
    return YES;
}
-(NSString*)PDCA_GetStationID
{
    NSString * str=@"";
    str=[PDCA GetStationID];

    return str;
}


@end
