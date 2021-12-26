//
//  CutMesTool.m
//  ChargerHost_B288
//
//  Created by luocw on 21/04/18.
//  Copyright © 2018年 ciwei Luo. All rights reserved.
//

#import "CutMesTool.h"
#import "BoardController.h"

@implementation CutMesTool


+(NSString *)getSoftwareVersion:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel
{
    NSString *rece;
    NSMutableString *version=nil;
    for (int j=0; j<10; j++) {
        //rece    __NSCFString *    @"BSV 2\rft version\n> ft:ok 0 6 11 (Aug  8 2018, 18:20:12)\n] \n] "    0x000060000025ca70
  
        rece = [board GetDutHVSV:tunnel Channel:i+1];
        NSLog(@"rece:%lu",(unsigned long)rece.length);
        //rece = [board GetDutHVSV:tunnel Channel:i+1];
        [board CloseTunnel:i+1];
        NSLog(@"rece length:%lu,--%@",(unsigned long)rece.length,rece);
        /***add by luocw at 3/26/2018---start***/
        
        if (rece.length >= 60) {//109为rece完整长度
            // NSString *version;
            
            NSString *tempStr = [rece cw_getStringBetween:@"ft:ok " and:@" ("];
            if (!tempStr.length) {
                continue;
            }
            NSString *tempVersion = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            version = [[NSMutableString alloc]initWithString:tempVersion];
            
            [version insertString:@"." atIndex:1];
            break;
            //NSRange nsrtunnel2=[rece rangeOfString:@"version"];
            
            // if(nsrtunnel2.location!=NSNotFound && [rece containsString:@"ft:ok"])
            //            {
            //                NSString * rece1=[rece substringWithRange: NSMakeRange(nsrtunnel2.location+nsrtunnel2.length,15)];
            //                NSRange range=NSMakeRange(9,5);
            //
            //                NSString *tempString = [[rece1 substringWithRange:range] stringByReplacingOccurrencesOfString:@" " withString:@""];
            //                NSMutableString *tempVersion = [[NSMutableString alloc]initWithString:tempString];
            //                [tempVersion insertString:@"." atIndex:1];
            //                //sv[loopCount] = tempVersion;
            //                version = (NSString *)tempVersion;
            //
            //                break;
            //            }
            
        }
        
    }
    
    
    return version;
    
    // return @"0.2.7";
    
}


+(NSString *)getHardwareVersion:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel
{
    return @"0.00";
}


//+(NSMutableArray *)getCurrentAndVolt1:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel
//{
//    //现在是用BATMAN读出电压、电流和电量百分比值
//    NSMutableArray *tempArray = [NSMutableArray array];
//    //NSString*str_per=@"";
//    NSString*str_v=@"";
//    NSString*str_current=@"";
//    NSString *rece;
//
//    for (int j=0; j<10; j++) {//> beryl:ok 4.147
//
//       // NSString *string = [board CloseTunnel:i+1];
//
//        rece=[board GetDutBATMAN:i+1];
//
//        NSLog(@"%lu",(unsigned long)rece.length);
//        //        rece    __NSCFString *    @"BATMAN 1\r[SR]\nB235 HW EVT FW ver 1.7.7 Application\n[BOUT-0]<bout-0>\n\r\n[BATMAN]<batman-100%-V:4370-CS:01-L-000%-CS:00-V:0000-I:0000-0-R-086%-CS:02-V:4076-I:0000-1>\n\r\n"    0x000060000024fab0
//        /***add by luocw at 3/26/2018---start***/
//        if (rece.length >= 165 && [rece containsString:@"-1>\n\r\n"]) {//114为rece完整长度
//            NSLog(@"board:%ld,batmanlength:%lu",(long)board.boardIndex+1,(unsigned long)rece.length);
//
//
//            /***截取电压、电流、百分比、版本***/
//            NSRange nsrtunnel,nsrtunnel1;//nsrtunnel2;
//            if (tunnel==0 || tunnel == 1) {
//
//                nsrtunnel=[rece rangeOfString:@"a1 31"];
//                if(nsrtunnel.location!=NSNotFound && [rece containsString:@"beryl:ok"])
//                {
//                    NSString * rece1=[rece substringWithRange: NSMakeRange(nsrtunnel.location+nsrtunnel.length,17)];
//                    NSRange Range5=NSMakeRange(12,5);
//                    str_current = [NSString stringWithFormat:@"%@",[rece1 substringWithRange:Range5]];
//                    [tempArray addObject:str_current];
//                    //NSLog(@"-----");
//                }
//
//                nsrtunnel1=[rece rangeOfString:@"a1 5"];
//                if(nsrtunnel1.location!=NSNotFound && [rece containsString:@"beryl:ok"]){
//                    rece=[rece substringWithRange: NSMakeRange(nsrtunnel1.location+nsrtunnel1.length,17)];
//
//                    NSRange Range4=NSMakeRange(12,5);
//                    str_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range4]];
//
//                    [tempArray addObject:str_v];
//                }
//            }
//            if (tempArray.count != 2) {//闪退问题
//                NSLog(@"lcw add tempArray:%@,rece:%@",tempArray,rece);
//                [tempArray removeAllObjects];
//                continue;
//            }
//            break;
//        }else{
//            if (j%2) {
//                NSLog(@"lcw add board:%ld,com:%ld,loopCount:%d,length:%lu,rece:%@",(long)board.boardIndex+1,(long)i,j,(unsigned long)rece.length,rece);
//            }
//        }
//    }
//
//    return tempArray;
//
//}


+(NSMutableArray *)getPerAndCurrentAndVolt:(BoardController *)board channelIndex:(NSInteger)i tunnel:(NSInteger)tunnel
{
    //现在是用BATMAN读出电压、电流和电量百分比值
    NSMutableArray *tempArray = [NSMutableArray array];
    //NSString*str_per=@"";
    NSString*str_v=@"";
    NSString*str_current=@"";
    NSString*str_per=@"";
    NSString *rece;

    for (int j=0; j<10; j++) {//> beryl:ok 4.147
       
        rece=[board GetDutBATMAN:i+1];
        NSLog(@"lcwbatman---times:%d---rece:%@",j,rece);
        //        rece    __NSCFString *    @"BATMAN 1\r[SR]\nB235 HW EVT FW ver 1.7.7 Application\n[BOUT-0]<bout-0>\n\r\n[BATMAN]<batman-100%-V:4370-CS:01-L-000%-CS:00-V:0000-I:0000-0-R-086%-CS:02-V:4076-I:0000-1>\n\r\n"    0x000060000024fab0
        /***add by luocw at 3/26/2018---start***/
        if (rece.length >= 104) {//114为rece完整长度
            
            NSLog(@"####board:%ld,batmanlength:%lu",(long)board.boardIndex+1,(unsigned long)rece.length);
            NSString *string;
            if (tunnel == 0) {
                string = [rece cw_getStringBetween:@"-L" and:@"1-R-"];
            }else if (tunnel == 1)
            {
                string= [rece cw_getStringBetween:@"-R" and:@"-1>\n\r\n"];
            }
            
            if (!string.length) {
                NSLog(@"#######error:%@",rece);
                continue;
            }
            //NSString *strL = [rece cw_getStringBetween:@"-L" and:@"-R"];
            str_per = [string cw_getStringBetween:@"-" and:@"%-CS:"];
            str_v= [string cw_getSubstringFromString:@"V:" toLength:4];
            str_current = [string cw_getSubstringFromString:@"-I:" toLength:4];
            
            if ([str_v integerValue] == 0 || [str_per integerValue] == 255) {
                
                if (j>2) {
                    
                    NSLog(@"lcwbatman---str_v:%ld---str_per:%ld",(long)[str_v integerValue],(long)[str_per integerValue]);
                    NSString *replySR = [board GetDutSR:i+1];
                    NSLog(@"######replySR--%@",replySR);
                    [NSThread sleepForTimeInterval:2];
                    //                NSString *replyBHR = [board SetBHR:i+1];
                    //                NSLog(@"######replyBHR--%@",replyBHR);
                    //                [NSThread sleepForTimeInterval:5];
                    continue;
                }
            }
            
            if (str_current.length) {
                [tempArray addObject:str_current];
            }
            
            if (str_v.length) {

                [tempArray addObject:str_v];
            }
            
            if (str_per.length) {
                [tempArray addObject:str_per];
            }
            
            if (tempArray.count != 3) {//闪退问题
                NSLog(@"lcw add tempArray:%@,rece:%@",tempArray,rece);
                [tempArray removeAllObjects];
                continue;
            }
            
             break;
        }
    }
    return tempArray;
}


+(NSString *)getLidStatus:(BoardController *)board channelIndex:(NSInteger)i
{
//    NSString*str_lid=@"";
//    NSString*lidstr;
//    NSRange nsrlid;
//    lidstr=[NSString stringWithFormat:@"%@",[board GetLID:i+1]];
//    nsrlid=[lidstr rangeOfString:@"lid-"];
//    if( ((nsrlid.length+nsrlid.location+1)<[lidstr length]) && (nsrlid.location!=NSNotFound) ){
//        str_lid=[lidstr substringWithRange: NSMakeRange(nsrlid.location+nsrlid.length,1)];
//    }
    NSString *str_lid = @"1";
    return str_lid;
}


//cwluo sn
+(NSString *)getSerialNumber:(BoardController *)board channelIndex:(NSInteger)i tempSN:(NSString *)sntemp tunnel:(NSInteger)tunnel
{
//    sRead    __NSCFString *    @"MLB 1 1\r[TUNNEL-R-0]<tunnel-R-0>\n\r\n[00008910] TUNNEL: OPEN\n] syscfg print MLB#\n> syscfg:ok \"GFH8146F0F0JCD30M\"\n] \n] "    0x0000600000108e50
    NSString *cutReply=nil;
    for (int x = 0; x<3; x++) {
    
        NSString *sRead = [board SetFATP:tunnel Channel:i+1];
         [board CloseTunnel:i+1];
       
        NSLog(@"sread length:%lu",(unsigned long)sRead.length);
        if ([sRead containsString:@"syscfg:ok \""]&&[sRead containsString:@"\"\n] \n]"]) {
            cutReply = [sRead cw_getStringBetween:@"syscfg:ok \"" and:@"\"\n] \n]"];
            if (!cutReply.length) {
                continue;
            }
           
            break;
        }
        
    }
    return cutReply;
}
//+(NSString *)getSerialNumber:(BoardController *)board channelIndex:(NSInteger)i tempSN:(NSString *)sntemp tunnel:(NSInteger)tunnel
//{
//    NSString *sRead=@"";
//    NSRange nsrfatp;
//    NSRange nsrfatperror;
//    NSString * temsRead ;
//    NSInteger receiveLength;
//    for(int x=0;x<3;x++){
//        [board SetTTIM:i+1];
//        sRead=[NSString stringWithFormat:@"%@",[board SetFATP:tunnel Channel:i+1]];
//        nsrfatperror=[sRead rangeOfString:@"fail"];
//        nsrfatp=[sRead rangeOfString:@"ok \"" options:NSLiteralSearch];
//
//        if(nsrfatp.length > 0)
//        {
//            if( (nsrfatp.length+nsrfatp.location+17)<=[sRead length]){
//
//                receiveLength = [sRead length];
//                if (receiveLength - (nsrfatp.location+(nsrfatp.length+1)) < 17) {
//                    continue;
//                }
//                temsRead=[sRead substringWithRange: NSMakeRange(nsrfatp.location+nsrfatp.length,17)];
//                //sRead=@"ADSD        "; in this case, sRead length is also 12, it is a bad SN.
//                if ([temsRead scriptingContains:@" "]) {
//                    temsRead=@"";
//                }
//                if(temsRead.length <17)
//                {
//                    temsRead=@"";
//                }
//                if (temsRead.length >=17) {
//                    break;
//                }
//
//            }
//            else
//            {
//                temsRead=@"";
//            }
//        }
//        //dut insert but don't link already
//        if (nsrfatperror.location != NSNotFound)
//        {
//            temsRead=@"fail";
//        }
//        //no dut
//        else if((nsrfatperror.location == NSNotFound) && (nsrfatp.location == NSNotFound))
//        {
//            temsRead=@"";
//        }
//        //never insert dut or sn not fully get loop twice after pick dut out
//        if([sntemp isEqualToString:@""] && [temsRead isEqualToString:@""])
//        {
//            break;
//        }
//    }
//    return temsRead;
//}


@end
