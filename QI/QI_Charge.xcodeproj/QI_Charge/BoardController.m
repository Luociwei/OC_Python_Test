//
//  BoardController.m
//  Electricity Recorder
//
//  Created by ydhuang on 15-9-2.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import "BoardController.h"

@implementation BoardController
- (id)init
{
    self = [super init];
    m_PortNameArray = [[NSMutableArray alloc]init];
    return self;
}
-(id)Open:(NSString *)path andBaudRate:(unsigned)baud_rate
{
    [theLock lock];
    port = [[UART alloc] initWithPath:path andBaudRate:baud_rate];
    [theLock unlock];
    return port;
}
-(NSString *)ReadDI:(NSInteger)index
{
    //NSString*Flag;
    NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"GetAdcValue %ld\r",(long)index];
    
    
    [port flush];
    [port write:WriteCommond];
    //usleep(250000);
    NSString* rece = [port read];
    [theLock unlock];
   // NSLog(@"GetADC");
    NSLog(@"%@",rece);
    if ([rece length]<5)
    {
        return @"read DI fail";
    }
    else{
      
//            NSRange Range=NSMakeRange(15,2);
//            szPos10 = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
        if([rece rangeOfString:@"OK"].location != NSNotFound)
        {
            NSScanner *scan = [NSScanner scannerWithString:rece];
            NSLog(@"response is %@", rece);
            
            [scan scanUpToString:@"\n" intoString:nil];
            [scan scanString:@"GetAdcValue" intoString:nil];
            [scan scanUpToString:@"OK" intoString:&szPos10];
        }
        NSLog(@"GetADC");
        NSLog(@"%@getadc",szPos10);
        return szPos10;

    }
}

//获取DUTSerialSN,读不到返回 FSN Failed
-(NSString *)GetDutSerialName:(NSInteger)index
{
    //NSString*Flag;
    NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"FSN %ld\r",(long)index];
    
    [port flush];
    [port write:WriteCommond];
    usleep(24000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(24000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    [theLock unlock];
    NSLog(@"%@",rece);
    if ([rece length]<24)
    {
        NSString * str1=[NSString stringWithFormat:@"COM %ld GetDutSerialName Failed,%@\r",(long)index,rece];
        NSLog(@"%@",str1);
        return @"";
    }
    else{
        //rece=@"[FSN]<fsn-CC4R90ZYG2RL-OK>";
        //rece=[NSMutableString stringWithString:[rece stringByReplacingOccurrencesOfString:@"\r\nOK\r\n" withString:@""]];
        NSRange nsr=[rece rangeOfString:@"<fsn-"];
        if(nsr.location!=NSNotFound){
            szPos10=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,12)];
        }
        else{
            szPos10=@"";
        }

        NSString * str1=[NSString stringWithFormat:@"COM %ld GetDutSerialName OK,%@\r",(long)index,rece];
        NSLog(@"%@",str1);
        return szPos10;
    }
}

-(NSString *)GetDutBATMAN_DirectDUT
{
    //NSString*Flag;
    NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"[BATMAN]\r"];
    
    [port flush];
    [port write:WriteCommond];
    usleep(24000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(24000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    [theLock unlock];
    //        rece=@"[BATMAN]<batman-028%-V:4323-CS:02-L-000%-CS:00-V:0000-I:0000-0-R-000%-CS:00-V:0000-I:0000-0>";
    NSLog(@"%@",rece);
    if ([rece length]<30)
    {
        NSString * str1=[NSString stringWithFormat:@"COM DUT BATMAN Failed\r"];
        NSLog(@"%@",str1);
        return @"BATMAN Failed";
    }
    else{
        NSString * str1=[NSString stringWithFormat:@"COM DUT BATMAN OK\r"];
        NSLog(@"%@",str1);
        return rece;
    }
}
//获取电池充电状态信息：电压、电流、电量百分比

-(NSString *)GetDutChargingStatus:(NSInteger)index
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"GG %ld\r",(long)index];
    
    [port flush];
    [port write:WriteCommond];
    usleep(24000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(24000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    //rece=@"0x0d0x0a[GG]<gg-v=3893,i=0271,t=24.7,c=019,h=002,hv=000>OK0x0D0x0A";
    [theLock unlock];
    NSLog(@"%@",rece);
    
    if ([rece length]<50)
    {
        NSString * str1=[NSString stringWithFormat:@"COM %ld GG Failed\r",(long)index];
        NSLog(@"%@",str1);
        return @"GG Failed";
    }
    else{
        NSString * str1=[NSString stringWithFormat:@"COM %ld GG OK\r",(long)index];
        NSLog(@"%@",str1);
        return rece;
    }

}

//获取BATMAN,读不到返回 Failed
-(NSString *)GetDutBATMAN:(NSInteger)index
{
    //NSString*Flag;
    //NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"BATMAN %ld\r",(long)index];

        [port flush];
        [port write:WriteCommond];
        usleep(24000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(24000);
        [rece appendString:recetmp];
         recetmp=[port read];
    }
//        rece=@"[BATMAN]<batman-028%-V:4323-CS:02-L-000%-CS:00-V:0000-I:0000-0-R-000%-CS:00-V:0000-I:0000-0>";
    [theLock unlock];
    NSLog(@"%@",rece);
    
        if ([rece length]<90)
        {
            NSString * str1=[NSString stringWithFormat:@"COM %ld BATMAN Failed\r",(long)index];
            NSLog(@"%@",str1);
            return @"BATMAN Failed";
        }
        else{
            NSString * str1=[NSString stringWithFormat:@"COM %ld BATMAN OK\r",(long)index];
            NSLog(@"%@",str1);
            return rece;
    }
}

//获取SETLED,读不到返回Failed
-(BOOL)GetDutSETLED:(NSInteger)indexColor Com:(NSInteger)indexCom
{
    //NSString*Flag;
    NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"SETLED %ld %ld\r",(long)indexColor,(long)indexCom];
    
    [port flush];
    [port write:WriteCommond];
    usleep(24000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(24000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    [theLock unlock];
    
    NSLog(@"%@",rece);
    return YES;
    /*
    if ([rece length]<5)
    {
        NSString * str1=[NSString stringWithFormat:@"COM %ld SETLED Failed\r",(long)indexCom];
        NSLog(@"%@",str1);
        return @"SETLED Failed";
    }
    else{
        NSRange Range=NSMakeRange(10,12);
        szPos10 = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
        NSString * str1=[NSString stringWithFormat:@"COM %ld SETLED OK\r",(long)index];
        NSLog(@"%@",str1);
        return szPos10;
    }
     */
}

-(NSString *)DisCharging:(NSInteger)index
{
    //NSString*Flag;
    NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"DISCHARGING %ld\r",(long)index];
    
    [port flush];
    [port write:WriteCommond];
    usleep(24000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(24000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    [theLock unlock];
    NSLog(@"%@",rece);
    if ([rece length]<5)
    {
        NSString * str1=[NSString stringWithFormat:@"COM %ld SETLED Failed\r",(long)index];
        NSLog(@"%@",str1);
        return @"SETLED Failed";
    }
    else{
        NSRange Range=NSMakeRange(10,12);
        szPos10 = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
        NSString * str1=[NSString stringWithFormat:@"COM %ld SETLED OK\r",(long)index];
        NSLog(@"%@",str1);
        return szPos10;
    }
}

//获取DUTSerialSN,直到读到为止
-(NSString *)GetDutSerialName_UntilGetResponse:(NSInteger)index
{
    //NSString*Flag;
    NSString*szPos10;
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"FSN %ld\r",(long)index];
    
    while(true)
    {
        [port flush];
        [port write:WriteCommond];
        usleep(2500);
        NSString* rece = [port read];
        [theLock unlock];
        
        NSLog(@"%@",rece);
        if ([rece length]<5)
        {
            NSString * str1=[NSString stringWithFormat:@"COM %ld GetDutSerialName Failed\r",(long)index];
            NSLog(@"%@",str1);
            szPos10 =@"FSN Failed";
            continue;
        }
        else{
            rece=@"[FSN]<fsn-CC4R90ZYG2RL-OK>";
            NSRange Range=NSMakeRange(10,12);
            szPos10 = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
            NSString * str1=[NSString stringWithFormat:@"COM %ld GetDutSerialName OK\r",(long)index];
            NSLog(@"%@",str1);
            break;
        }
        break;
    }
    return szPos10;
}




-(BOOL)Close
{
    [theLock lock];
    [port close];
    return YES;
}
@end
