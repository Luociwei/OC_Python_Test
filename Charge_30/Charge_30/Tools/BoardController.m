//
//  BoardController.m
//  Electricity Recorder
//
//  Created by ydhuang on 15-9-2.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import "BoardController.h"

@implementation BoardController
@synthesize boardIndex;
- (id)initWithIndex:(NSInteger)index
{
    if(self = [super init]){
        port=nil;
        boardIndex=index;
        _snArray = [NSMutableArray arrayWithCapacity:MAX_CHANNEL_PER_BOARD];
        for (int i =0; i<MAX_CHANNEL_PER_BOARD; i++) {
            [_snArray addObject:@""];
        }
    }
    return self;
}
-(int)Open:(NSString *)path andBaudRate:(unsigned)baud_rate
{
    [theLock lock];
    port = [[UART alloc] initWithPath:path andBaudRate:baud_rate];
    [theLock unlock];
#warning change
    //NSLog(@"%d",port.uart_handle);
    return port.uart_handle;
}


//-(NSString *)Sendstr:(NSInteger)channelindex Commandstr:(NSString *)commandstr Delay:(unsigned int)delaytime Getstr:(NSInteger)getstrlength Findstr:(NSString *)findstr Findlength:(unsigned int)findlength
//{
//    [theLock lock];
//    NSString* WriteCommond = [NSString stringWithFormat:@"%@"" %ld\r",commandstr,(long)channelindex];
//
//    [port flush];
//    [port write:WriteCommond];
//    usleep(delaytime);
//    NSMutableString *rece=[[NSMutableString alloc]init];
//    NSString* recetmp=[port read];
//
//    while(![recetmp isEqualToString:@""]){
//        usleep(5000);
//        [rece appendString:recetmp];
//        recetmp=[port read];
//    }
//    [theLock unlock];
//
//
//    if ([rece length]<getstrlength)
//    {
//        NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" Failed,%@\r",(long)channelindex,commandstr,rece];
//        NSLog(@"%@",str1);
//        return @"";
//    }
//    else{
//        NSRange nsr=[rece rangeOfString:findstr];
//        if ((nsr.length+nsr.location+findlength)>[rece length]) {
//            return @"";
//        }
//        else
//        {
//            if(nsr.location!=NSNotFound){
//                NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" OK,%@\r",(long)channelindex,commandstr,rece];
//                NSLog(@"%@",str1);
//                return [rece substringWithRange: NSMakeRange(nsr.location+nsr.length,findlength)];
//            }
//            else{
//                return @"";
//            }
//        }
//    }
//
//}

-(NSString *)Sendstr:(NSInteger)channelindex Commandstr:(NSString *)commandstr Delay:(unsigned int)delaytime Findstr:(NSString *)findstr Findlength:(unsigned int)findlength
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"%@"" %ld\r",commandstr,(long)channelindex];
    
    [port flush];//清除端口
    [port write:WriteCommond];
    usleep(delaytime);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    
    while(![recetmp isEqualToString:@""]){
        usleep(5000);
        [rece appendString:recetmp];
        recetmp=[port read];
        //NSLog(@"recetmp:%@",recetmp);
        [CSVLog2 saveSendCommand:rece sn:self.snArray[channelindex-1]];
    }
    [theLock unlock];
    
    
    //    if ([rece length]<getstrlength)
    //    {
    //        NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" Failed,%@\r",(long)channelindex,commandstr,rece];
    //        NSLog(@"%@",str1);
    //        return @"";
    //    }
    //    else{
    NSRange nsr = [rece rangeOfString:findstr];
    
    if ((nsr.length+nsr.location+findlength)>[rece length]) {
        return @"";
    }
    else
    {
        if(nsr.location!=NSNotFound){
            //NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" OK,%@\r",(long)channelindex,commandstr,rece];
            //NSLog(@"%@",str1);
            return [rece substringWithRange: NSMakeRange(nsr.location+nsr.length,findlength)];
        }
        else{
            return @"";
        }
    }
    //    }
    
}


//-(NSString *)Sendstr:(NSInteger)channelindex Commandstr:(NSString *)commandstr Delay:(unsigned int)delaytime Getstr:(NSInteger)getstrlength
//{
//    [theLock lock];
//    NSString* WriteCommond = [NSString stringWithFormat:@"%@"" %ld\r",commandstr,(long)channelindex];
//
//    [port flush];
//    [port write:WriteCommond];
//    usleep(delaytime);
//    NSMutableString *rece=[[NSMutableString alloc]init];
//    NSString* recetmp=[port read];
//
//    while(![recetmp isEqualToString:@""]){
//        usleep(5000);
//        [rece appendString:recetmp];
//        recetmp=[port read];
//    }
//    [theLock unlock];
//
//
//    if ([rece length]<getstrlength)
//    {
//        NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" Failed,%@\r",(long)channelindex,commandstr,rece];
//        NSLog(@"%@",str1);
//        return @"";
//    }
//    else{
//        NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" OK,%@\r",(long)channelindex,commandstr,rece];
//        NSLog(@"%@",str1);
//        return rece;
//    }
//}

//TTIM 1
//[TTIM-03]<ttim-03>

-(NSString *)Sendstr:(NSInteger)channelindex Commandstr:(NSString *)commandstr Delay:(unsigned int)delaytime
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"%@"" %ld\r",commandstr,(long)channelindex];
    
    [port flush];
    [port write:WriteCommond];
    usleep(delaytime);
    
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];

    while(![recetmp isEqualToString:@""]){
       
        usleep(5000);
        [rece appendString:recetmp];
        NSString * str1=[NSString stringWithFormat:@"COM %ld %@"" OK,%@\r",(long)channelindex,commandstr,rece];
        NSLog(@"%@",str1);
        recetmp=[port read];
    }
    
    [CSVLog2 saveSendCommand:rece sn:self.snArray[channelindex-1]];
    [theLock unlock];
 
    return rece;
}


//获取DUTSerialSN,读不到返回 FSN Failed
-(NSString *)GetDutSerialName:(NSInteger)index
{
    //rece=@"\r\n[FSN]<fsn-CC4R90ZYG2RL-OK>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"FSN" Delay:40000  Findstr:@"<fsn-" Findlength:12];
    
}


//获取DUTSerialSN,读不到返回 FSN Failed
-(NSString *)GetDutMSN:(NSInteger)index
{
    //rece=@"\r\n[FSN]<fsn-CC4R90ZYG2RL-OK>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"MSN" Delay:55000  Findstr:@"<msn-" Findlength:17];
    
}




//获取电池充电状态信息：电压、电流、电量百分比
-(NSString *)GetDutChargingStatus:(NSInteger)index
{
    //rece=@"0x0d0x0a[GG]<gg-v=3893,i=0271,t=24.7,c=019,h=002,hv=000>OK0x0D0x0A";
    return [self Sendstr:(NSInteger)index Commandstr:@"GG" Delay:120000 ];
    
}

//获取BATMAN,读不到返回 Failed
//            BATMAN 1
//            beryl gpadc a1 31
//            > beryl:ok 0.001
//            ]
//            ] beryl gpadc a1 5

-(NSString *)GetDutBATMAN:(NSInteger)index
{
    //rece=@"\r\n[BATMAN]<batman-028%-V:4323-CS:02-L-000%-CS:00-V:0000-I:0000-0-R-000%-CS:00-V:0000-I:0000-0>ok\r\n";
    return [self Sendstr:(NSInteger)index Commandstr:@"BATMAN" Delay:800000];
}

//获取SETLED,读不到返回Failed
-(BOOL)GetDutSETLED:(NSInteger)indexColor Com:(NSInteger)indexCom
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"SETLED %ld %ld\r",(long)indexColor,(long)indexCom];
    
    [port flush];
    [port write:WriteCommond];
    usleep(30000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(1000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
     [CSVLog2 saveSendCommand:rece sn:self.snArray[indexCom-1]];
    [theLock unlock];
    //NSLog(@"%@",rece);
    return YES;
    
}



//set pwm i j; i=0~2;j=1~50;
-(NSString *)SetPWM:(NSInteger)indexmode Channel:(NSInteger)indexchannel
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"PWM %ld %ld\r",(long)indexmode,(long)indexchannel];
    
    [port flush];
    [port write:WriteCommond];
    usleep(20000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(5000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    //rece=@"0x0d0x0a[PWM-0-100]<PWM-0-100-000>OK0x0D0x0A";
      [CSVLog2 saveSendCommand:rece sn:self.snArray[indexchannel-1]];
    [theLock unlock];
    //NSLog(@"%@",rece);
    
    if ([rece length]<30)
    {
        NSString * str1=[NSString stringWithFormat:@"COM %ld PWM Failed\r",(long)indexchannel];
        //NSLog(@"%@",str1);
        return @"PWM Failed";
    }
    else{
        NSString * str1=[NSString stringWithFormat:@"COM %ld PWM OK\r",(long)indexchannel];
        //NSLog(@"%@",str1);
        return rece;
    }
}


//get lid
-(NSString *)GetLID:(NSInteger)indexchannel
{
    [theLock lock];
    NSString* WriteCommond = [NSString stringWithFormat:@"LID %ld\r",(long)indexchannel];
    
    [port flush];
    [port write:WriteCommond];
    usleep(30000);
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp=[port read];
    while(![recetmp isEqualToString:@""]){
        usleep(1000);
        [rece appendString:recetmp];
        recetmp=[port read];
    }
    //rece=@"0x0d0x0a[LID]<lid-0>OK0x0D0x0A";
    [theLock unlock];
    //NSLog(@"%@",rece);
    
    if ([rece length]<13)
    {
        NSString * str1=[NSString stringWithFormat:@"COM %ld LID Failed\r",(long)indexchannel];
        //NSLog(@"%@",str1);
        return @"LID Failed";
    }
    else{
        NSString * str1=[NSString stringWithFormat:@"COM %ld LID OK\r",(long)indexchannel];
        //NSLog(@"%@",str1);
        return rece;
    }
}


//B235 Software Version
-(NSString *)GetDutSV:(NSInteger)index
{
    return [self Sendstr:(NSInteger)index Commandstr:@"SV" Delay:40000  Findstr:@"<sv-" Findlength:5];
}


//B235 Hardware Version
-(NSString *)GetDutHV:(NSInteger)index
{
    return [self Sendstr:(NSInteger)index Commandstr:@"HV" Delay:40000  Findstr:@"<hv-" Findlength:1];
}



//get TUNNEL
-(NSString *)SetTUNNEL:(NSInteger)indextunnel Channel:(NSInteger)indexchannel
{
    return [self SendCmdAndGetOKReply:[NSString stringWithFormat:@"TUNNEL %ld",(long)indextunnel] TimeOut:1.0 ResponseSuffix:@"OPEN" index:indexchannel];
}
//{
//    //return nil;
//    NSString *string = [NSString stringWithFormat:@"TUNNEL %ld",(long)indextunnel];
//    return [self SendCmdAndGetOKReply:string TimeOut:2.0 ResponseSuffix:@"OPENOK\r\n" index:indexchannel];
//}
//{
//    [theLock lock];
//    NSString* WriteCommond = [NSString stringWithFormat:@"TUNNEL %ld %ld\r",(long)indextunnel,(long)indexchannel];
//
//    [port flush];
//    [port write:WriteCommond];
//    usleep(23000);
//    NSMutableString *rece=[[NSMutableString alloc]init];
//    NSString* recetmp=[port read];
//    while(![recetmp isEqualToString:@""]){
//        usleep(5000);
//        [rece appendString:recetmp];
//        recetmp=[port read];
//    }
//    [CSVLog2 saveSendCommand:rece sn:self.snArray[indexchannel-1]];
//    [theLock unlock];
//    //NSLog(@"%@",rece);
//
//    //4.10
//    //    rece=@"\r\n[TUNNEL-R-0]<tunnel-r-0>TUNNEL: OPENOK\r\n";
//    //rece=@"\r\n[TUNNEL-R-0] not connected";
//
//    if ([rece length]<25)
//    {
//        NSString * str1=[NSString stringWithFormat:@"COM %ld TUNNEL Failed\r",(long)indexchannel];
//        //NSLog(@"%@",str1);
//        return @"";
//    }
//    else{
//        NSString * str1=[NSString stringWithFormat:@"COM %ld TUNNEL OK\r",(long)indexchannel];
//        //NSLog(@"%@",str1);
//        return rece;
//    }
//}

//get MLB
-(NSString *)GetMLB:(NSInteger)index Channel:(NSInteger)indexchannel
{
    //    rece=@"\r\n[SNRD-MLB] <snrd-mlb:CC461010NXPH3HM11>OK\r\n";
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"MLB" Delay:20000 Getstr:43 Findstr:@"mlb:" Findlength:17];
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"MLB" Delay:40000 Getstr:43];
    if (index==0) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"MLB 0" Delay:300000 ];
    }
    if (index==1) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"MLB 1" Delay:300000 ];
    }
    else
    {
        return @"";
    }
}


//get BYE
-(NSString *)SetBYE:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";25MS
    return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BYE" Delay:30000 ];
}


//get BOUT
-(NSString *)SetBOUT:(NSInteger)outchannel Channel:(NSInteger)indexchannel
{
    //40000
    if (outchannel==0) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BOUT 0" Delay:30000 ];
    }
    if (outchannel==1) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BOUT 1" Delay:30000 ];
    }
    else
    {
        return @"";
    }
    
}

//get BYE
-(NSString *)SetPLSN:(NSInteger)index Channel:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BYE" Delay:200000 Getstr:10];
    if (index==1) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"PLSN 1" Delay:350000 ];
    }
    if (index==2) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"PLSN 2" Delay:350000 ];
    }
    if (index==3) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"PLSN 3" Delay:350000 ];
    }
    else
    {
        return @"";
    }
}


//get BYE
-(NSString *)SetFATP:(NSInteger)index Channel:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";250ms
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BYE" Delay:200000 Getstr:10];
    if (index==0) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"FATP 0" Delay:300000 ];
    }
    if (index==1) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"FATP 1" Delay:300000 ];
    }
    else
    {
        return @"";
    }
}

//get BYE
-(NSString *)SetBSR:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";
    return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BSR" Delay:30000 ];
    
}



//get BYE
-(NSString *)SetBHR:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";
    
    return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BHR" Delay:60000 ];
    
}


//get BYE
-(NSString *)SetTTIM:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BYE" Delay:200000 Getstr:10];
    
    return [self Sendstr:(NSInteger)indexchannel Commandstr:@"TTIM" Delay:30000 ];
    
}
//gfhx70sujjnv

//B235 restart,读不到返回 Failed
-(NSString *)GetDutSR:(NSInteger)index
{
    //rece=@"\r\n[BATMAN]<batman-028%-V:4323-CS:02-L-000%-CS:00-V:0000-I:0000-0-R-000%-CS:00-V:0000-I:0000-0>ok\r\n";
    
   return [self SendCmdAndGetOKReply:@"SR" TimeOut:2.0 ResponseSuffix:@"Application" index:index];
    
   // return [self Sendstr:(NSInteger)index Commandstr:@"SR" Delay:30000 ];
}



-(NSString *)GetDutHVSV:(NSInteger)index Channel:(NSInteger)indexchannel
{
    
    if (index==0) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BSV 0" Delay:300000 ];
    }
    if (index==1) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BSV 1" Delay:300000 ];
    }
    else
    {
        return @"";
    }
}


//获取DUTSerialSN,读不到返回 FSN Failed
-(NSString *)GetDutBLS:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"BLS" Delay:40000  Findstr:@"<bls-" Findlength:3];
    
}


//get dcdc
-(NSString *)SetDCDC:(NSInteger)index Channel:(NSInteger)indexchannel
{
    //[DCDC-1]<dcdc-1>
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BYE" Delay:200000 Getstr:10];
    if (index==0) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"DCDC 0" Delay:1600000 ];
    }
    if (index==1) {
        return [self Sendstr:(NSInteger)indexchannel Commandstr:@"DCDC 1" Delay:1600000 ];
    }
    else
    {
        return @"";
    }
}



-(NSString *)setChargeMode:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    
    return [self Sendstr:(NSInteger)index Commandstr:@"CHARGERMODE 0" Delay:240000];
    
}
//TM 测试模式
//-(NSString *)SetTM:(NSInteger)index
//{
//
//    return [self Sendstr:index Commandstr:@"TESTMODE" Delay:300000];
//}


-(NSString *)SendCmdAndGetOKReply:(NSString *)cmd TimeOut:(int)timeOut ResponseSuffix:(NSString *)responseSuffix index:(NSInteger)channel
{
    [theLock lock];
//    if ([cmd isEqualToString:@"SR"]) {
//        int a = 1;
//    }
    NSString* WriteCommond = [NSString stringWithFormat:@"%@"" %ld\r", cmd,channel];
    [port flush];
    [port write:WriteCommond];
    //    usleep(500000);//wait 0.5s to get command response
    [NSThread sleepForTimeInterval:0.5];
    NSMutableString *rece=[[NSMutableString alloc]init];
    NSString* recetmp= [NSString stringWithString:[port read]];
    NSDate *overTime = [NSDate date];
    while (1)
    {
        [rece appendString:recetmp];
        recetmp=[port read];
        if ([[NSDate date] timeIntervalSinceDate:overTime] > timeOut)
        {
            break;
        }
        if ([rece containsString:responseSuffix])
        {
            break;
        }
        //        usleep(200000);//wait 0.2s to get command response
        [NSThread sleepForTimeInterval:0.2];
    }
    [CSVLog2 saveSendCommand:rece sn:self.snArray[channel-1]];
    [theLock unlock];
//    NSString* rece2 = [rece stringByReplacingOccurrencesOfString:@"\r\n" withString:@"-"];
//    NSString * str1=[NSString stringWithFormat:@"Command %@ OK   , Reply is: %s  ", cmd, [rece2 UTF8String]];
//    str1 = [str1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    NSLog(@"%@",str1);
    return rece;
}

-(NSString *)CloseTunnel:(NSInteger)indexchannel
{
    //    rece=@"\r\n[BYE] <bye>OK []TUNNEL: CLOSE\r\n";
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"BYE" Delay:200000 Getstr:10];
    return [self SendCmdAndGetOKReply:@"CLOSE" TimeOut:2.0 ResponseSuffix:@"TUNNEL: CLOSED" index:indexchannel];
    //return [self Sendstr:(NSInteger)indexchannel Commandstr:@"CLOSE" Delay:60000 ];
}

-(void)resetDut:(NSInteger)i
{
    [self GetDutSR:i+1];
    [NSThread sleepForTimeInterval:0.1f];
    //[self SetTM:i+1];
//    [NSThread sleepForTimeInterval:0.1f];
}

-(void)resetAllDuts:(NSInteger)boardDutsCount
{
    for (int index =0 ; index < boardDutsCount; index ++) {
        [self GetDutSR:index +1];
        usleep(200);
        
    }
    
//    for (int index =0 ; index < boardDutsCount; index ++) {
//        [self SetTM:index + 1];
//        usleep(200);
//        
//    }
}
/////add new function
-(NSString *)setChargeDisable:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"CHARGERMODE 2" Delay:240000];
}
-(NSString *)setChargeFast:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"CHARGERMODE 0" Delay:240000];
    
}
-(NSString *)setChargeSlow:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    
    return [self Sendstr:(NSInteger)index Commandstr:@"CHARGERMODE 1" Delay:240000];
    
}
-(NSString *)setTimestampCharge:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"COULOMBCOUNTER" Delay:240000];
    
}

-(NSString *)setGPDAC:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    return [self Sendstr:(NSInteger)index Commandstr:@"VOLCHGIN" Delay:240000];
}
-(NSString *)StopDisCharging:(NSInteger)index
{
    return [self Sendstr:(NSInteger)index Commandstr:@"STOPAUDIO" Delay:240000];
    
}
-(NSString *)setDischarge:(NSInteger)index
{
    //rece=@"\r\n[BLS]<bls-l-r>"ok\r\n;// 26字符
    //[self SetBOUT:0 Channel:index];
    [self Sendstr:(NSInteger)index Commandstr:@"INITAUDIO" Delay:240000];
    [self Sendstr:(NSInteger)index Commandstr:@"BYPASSAUDIO" Delay:240000];
    return [self Sendstr:(NSInteger)index Commandstr:@"STARTAUDIO" Delay:360000];
}

-(void)setResetSystem:(NSInteger)index
{
    
    [self Sendstr:(NSInteger)index Commandstr:@"RESETSYS" Delay:240000];
}

-(void)setUVP:(NSInteger)index
{
    
    [self Sendstr:(NSInteger)index Commandstr:@"STOPAUDIO" Delay:240000];
    [self Sendstr:(NSInteger)index Commandstr:@"ENUVP" Delay:240000];
    
}
-(BOOL)Close
{
    [theLock lock];
    [port close];
    return YES;
}


@end
