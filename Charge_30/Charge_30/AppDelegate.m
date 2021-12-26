//
//  AppDelegate.m
//  B288
//
//  Created by 罗婷 on 16/2/23.
//  Copyright (c) 2016年 Vicky Luo. All rights reserved.
//

#import "AppDelegate.h"
#import "CutMesTool.h"
#define ConfigName @"ChargingRackConfig"
#define ConfigPath  @"/Applications/B288_SmartCharger_30ports_Packing.app/Contents/Resources/ChargingRackConfig.plist"
@implementation DataRecord

- (id)init {
    self = [super init];
    if (self){
        self.SN= @"";
        self.bPass=false;
        self.bFinished=false;
        //        self.StartTime=@"";
        //        self.EndTime=@"";
        self.product=@"B288";
        self.stationID=@"AE-3";
        self.index=0;
        for(int i=0;i<DATA_POINTS;i++){
            self->PDCAData[i].vCur=0;
            self->PDCAData[i].vVolt=0;
            self->PDCAData[i].vPercent=0;
            self->PDCAData[i].vLid=0;
        }
    }
    return self;
}
-(void)setValue:(PDCA_DATA)val forIdx:(int)idx
{
    if(idx>-1 && idx<DATA_POINTS)
        PDCAData[idx]=val;
}

-(PDCA_DATA *)getDataArray
{
    return PDCAData;
}



-(NSString *)getDataString:(int)index
{
    NSMutableString * s=[[NSMutableString alloc]init];
    if (index>DATA_POINTS) {
        index=DATA_POINTS;
    }
    
    //index=0, orderly save software version and hardware version and slot number and solt insert counter
    [s appendString:[NSString stringWithFormat:@"%.2f,",PDCAData[0].vCur]];
    [s appendString:[NSString stringWithFormat:@"%.2f,",PDCAData[0].vVolt]];
    [s appendString:[NSString stringWithFormat:@"%.ld,",(long)PDCAData[0].vPercent]];
    [s appendString:[NSString stringWithFormat:@"%.ld,",(long)PDCAData[0].vLid]];
    
    for(int i=1;i<index-1;i++)
    {
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vCur]];
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vVolt]];
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vPercent]];
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vLid]];
    }
    for(int i=index-1;i<index;i++)
    {
        [s appendString:[NSString stringWithFormat:@"%.2f,",PDCAData[i].vCur]];
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vVolt]];
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vPercent]];
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)PDCAData[i].vLid]];
    }
    
    //    NSLog(@"%lu",(unsigned long)[s length]);
    return [s substringToIndex:([s length])];
}

@end

@implementation AppDelegate
{
    NSArray *arrSNTextBoxs;
    NSArray *arrDUTResultTextBoxs;
    NSArray *arrCounter;
    NSMutableDictionary *m_dictRecord;
    NSString *sn[TEST_CHANNEL];
    int _specLower,_specUpper,_stopcharge,specfloat,restart;
    NSString *fSN;
    
    int _currentLimit,_voltLimit;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [_window setDelegate:self];
    NSLog(@"%@",[NSBundle mainBundle].bundlePath);
    m_PortNameArray = [[NSMutableArray alloc]init];
    m_dictRecord=[[NSMutableDictionary alloc]init];
    
    m_SavePortName = [[NSArray alloc]initWithObjects:
                      @"/dev/cu.usbserial-FIX-01",@"/dev/cu.usbserial-FIX-02",
                      @"/dev/cu.usbserial-FIX-03",
                      nil];
    
    [self setupDatas];
    
   // NSInteger ss= [ConfigPlist failNum];
   // NSInteger ss1 = [CSVLog2 getFailNumWithSN:@"1111111111"];
    scanPort = [[SerialNameScan alloc] init];
    for(int i=0;i<MAX_BOARD;i++){
        m_Board[i]=[[BoardController alloc]initWithIndex:i];
    }
    m_Log = [CSVLog Instance];
    START = false;
    
    [_Bobcat_check setState:1];
    [_PDCA_check setState:1];
    [_Audit_check setState:0];
    PDCA_flag=YES;
    Bobcat_flag=YES;
    Audit_flag=NO;
    
    _specLower = [ConfigPlist specLower];
    _specUpper = [ConfigPlist specUpper];
    _stopcharge = [ConfigPlist stopcharge];
    appSW = [ConfigPlist appSW];

    specfloat=2;
    [_ChargeYellow performSelectorOnMainThread:@selector(setStringValue:) withObject:[[NSString alloc]initWithFormat:@"<%d",_specLower] waitUntilDone:NO];
    [_ChargeGreen performSelectorOnMainThread:@selector(setStringValue:) withObject:[[NSString alloc]initWithFormat:@"%d%%~%d%%",_specLower,_specUpper] waitUntilDone:NO];
    [_ChargePurple performSelectorOnMainThread:@selector(setStringValue:) withObject:[[NSString alloc]initWithFormat:@">%d%%",_specUpper] waitUntilDone:NO];
    [_SWindication performSelectorOnMainThread:@selector(setStringValue:) withObject:appSW waitUntilDone:NO];
    NSString *fixtureSNPath = [[NSString alloc] initWithFormat:@"/vault/FixtureSN/FixtureSN.csv"];
    if (![m_Log IsExist:fixtureSNPath isFolder:YES]) {
        fSN=@"3001";
    }
    else{
        NSString *readFromFixtureSN = [m_Log ReadFile:fixtureSNPath];
        NSRange nsrFixturnSN = [readFromFixtureSN rangeOfString:@"FixtureSN:"];
        fSN = [readFromFixtureSN substringWithRange:NSMakeRange(nsrFixturnSN.length+nsrFixturnSN.location, readFromFixtureSN.length-nsrFixturnSN.length-nsrFixturnSN.location)];
        fSN = [@"3" stringByAppendingString:fSN];
    }
    [_FixtureNumberShows performSelectorOnMainThread:@selector(setStringValue:) withObject:[@"FixtureSN-" stringByAppendingString:fSN] waitUntilDone:NO];
    tunnel=2;
    
    startone=1;
    for(int loopCount=0;loopCount<TEST_CHANNEL;loopCount++){
        [[arrSNTextBoxs objectAtIndex:loopCount] setStringValue:@""];
        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor whiteColor]];
        ((NSTextField *)[arrSNTextBoxs objectAtIndex:loopCount]).editable=false;
        [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:0] setStringValue:@""];
        [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:1] setStringValue:@""];
        [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:2] setStringValue:@""];
        ((NSTextField *)[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:0]).editable=false;
        ((NSTextField *)[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:1]).editable=false;
        ((NSTextField *)[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:2]).editable=false;
    }
    
    //创建存储sn对应fail次数的文件
   
    [CSVLog2 createFile:@"/vault/H16_Slot_InsertNUM/Insertnum/" isDirectory:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:snFailRecordPath]) {
       
        NSString *timeString = [NSString stringWithFormat:@"[##start time:%@ ##]",[self CurrentTime]];
       // NSString data[str dataUsingEncoding:NSUTF8StringEncoding]
            [fileManager createFileAtPath:snFailRecordPath contents:[timeString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else{
        NSString *readString =[CSVLog2 readFromFile:snFailRecordPath];
        NSString *timeStr = [readString cw_getStringBetween:@"[##start time:" and:@" ##]"];
        NSDate *startDate = [self dateTimeWithString:timeStr];
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:startDate];
        if (time > 3600*24*7) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:snFailRecordPath error:nil];
            NSString *timeString = [NSString stringWithFormat:@"[##start time:%@ ##]",[self CurrentTime]];
            // NSString data[str dataUsingEncoding:NSUTF8StringEncoding]
            [fileManager createFileAtPath:snFailRecordPath contents:[timeString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    }

    
    for(int loopCount=0;loopCount<TEST_CHANNEL;loopCount++){
        NSString *insertFilePath = [[NSString alloc] initWithFormat:@"/vault/H16_Slot_InsertNUM/Insertnum/%d.csv",loopCount+1];
        NSString *insertOldNumber=@"0";
        if (![m_Log IsExist:insertFilePath isFolder:YES]) {
            NSString *string =[NSString stringWithFormat:@"SlotNumber:%d  InsertNumber:0",loopCount+1];
             [fileManager createFileAtPath:insertFilePath contents:[string dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            
        }
        else {
            NSString *strOldInsertNum=[NSString stringWithString:[m_Log ReadFile:insertFilePath]];
            NSRange narInsertTimes=[strOldInsertNum rangeOfString:@"InsertNumber:"];
            insertOldNumber = [strOldInsertNum substringWithRange: NSMakeRange(narInsertTimes.location+narInsertTimes.length,(strOldInsertNum.length-narInsertTimes.length-narInsertTimes.location))];
            
        }
        [[arrCounter objectAtIndex:loopCount] performSelectorOnMainThread:@selector(setStringValue:) withObject:insertOldNumber waitUntilDone:NO];
    }
    for(int i=0;i<MAX_BOARD;i++)
    {
        if([m_Board[i] Open:[m_SavePortName objectAtIndex:i] andBaudRate:230400]>0)
        {
            usleep(800);
            for (int j=1; j<=MAX_CHANNEL_PER_BOARD; j++){
                sn[i*MAX_CHANNEL_PER_BOARD+j-1]=@"";
                [[arrSNTextBoxs objectAtIndex:(i*MAX_CHANNEL_PER_BOARD+j-1)] setStringValue:@""];
                [m_Board[i] GetDutSETLED:6 Com:j]; //LED off
            }
            [NSThread detachNewThreadSelector:@selector(Thread_GG_B288_three:) toTarget:self withObject:m_Board[i]];
        }
        
    }
    
}

-(void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}


//get current time to show in the display window
- (NSString *)CurrentTime
{
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    //    [outputFormatter release]; //enable ARC,it will automatically insert release sentence in correct place
    return newDateString;
}
- (NSDate *)dateTimeWithString:(NSString *)string
{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *stringDate = [outputFormatter dateFromString:string];
    //    [outputFormatter release]; //enable ARC,it will automatically insert release sentence in correct place
    return stringDate;
}

-(void)Thread_GG_B288_three:(BoardController *)board
{
    
    //1.初始化
    BOOL bCharging[MAX_CHANNEL_PER_BOARD],
    bFirst[MAX_CHANNEL_PER_BOARD],
    bobcat[MAX_CHANNEL_PER_BOARD],
    dut[MAX_CHANNEL_PER_BOARD],
    bLogData[MAX_CHANNEL_PER_BOARD],
    isFinish[MAX_CHANNEL_PER_BOARD];
    
    int distimerflag[MAX_CHANNEL_PER_BOARD],
    errorcount[MAX_CHANNEL_PER_BOARD],
    temCur[MAX_CHANNEL_PER_BOARD],
    temVolt[MAX_CHANNEL_PER_BOARD],
    temPer[MAX_CHANNEL_PER_BOARD],
    temLid[MAX_CHANNEL_PER_BOARD],
    timeTenCur[MAX_CHANNEL_PER_BOARD],
    timeTenPer[MAX_CHANNEL_PER_BOARD],
    timeTenVolt[MAX_CHANNEL_PER_BOARD],
    srscan[MAX_CHANNEL_PER_BOARD],
    boutflag[MAX_CHANNEL_PER_BOARD];
    
    NSString *sv[MAX_CHANNEL_PER_BOARD],
    *hv[MAX_CHANNEL_PER_BOARD],
    *filePath[MAX_CHANNEL_PER_BOARD],
    *errorflag[MAX_CHANNEL_PER_BOARD];
    
    NSDate *distimer[MAX_CHANNEL_PER_BOARD],
    *load[MAX_CHANNEL_PER_BOARD],
    *StartTime[MAX_CHANNEL_PER_BOARD],
    *portscan[MAX_CHANNEL_PER_BOARD],
    *testTimeLog[MAX_CHANNEL_PER_BOARD][2];
    //,*bsrtimer[MAX_CHANNEL_PER_BOARD];bsrset[MAX_CHANNEL_PER_BOARD],
    
    
    for(int i=0;i<MAX_CHANNEL_PER_BOARD;i++){
        
        temCur[i]=0;
        temVolt[i]=0;
        temPer[i]=0;
        temLid[i]=0;
        timeTenCur[i]=0;
        timeTenPer[i]=0;
        timeTenVolt[i]=0;
        bCharging[i]=NO;
        
        bFirst[i]=YES;//?
        bLogData[i]=false;//?
        StartTime[i]=[NSDate date];
        distimer[i]=0;
        distimerflag[i]=0;
        dut[i]=YES;//?
        load[i]=0;
        //bsrset[i]=0;
        //bsrtimer[i]=0;
        portscan[i]=0;
        srscan[i]=0;//?
        sv[i]=@"";
        hv[i]=@"";
        filePath[i]=@"";
        testTimeLog[i][0]=0;
        testTimeLog[i][1]=0;
        errorflag[i]=@"";  //error flag: 1-value not match; 2-battery value not change when charge or discharge over 5min 3-overcurrent;
        errorcount[i]=0;
        bobcat[i]=true;//?
        boutflag[i]=0;//?
        
        isFinish[i]=NO;
    }
    
    for (int index =0 ; index < MAX_CHANNEL_PER_BOARD; index ++) {
        NSString *stringSR = [board GetDutSR:index +1];//send: SR"" 1\r
        usleep(200);
        NSLog(@"stringSR:%@",stringSR);
        
    }
    

    
LoopStart:
    
    while (!START) {//未点击开始时,退出执行下一次循环
        usleep(20);
        startone=1;
        continue;
        
    }
    
    while (START) {//当点击开始时
        
        int loopCount=0;
        
        for (int i = 0; i < MAX_CHANNEL_PER_BOARD; i++) {
            
            if (!START) {
                goto LoopStart;
            }
            //end of new discharge loop on 3/22
            
            //discharge every one min
            int timetunnel = [[NSDate date] timeIntervalSinceDate: distimer[i]];
            if (timetunnel>=62) {
                distimerflag[i]=0;
                distimer[i]=0;
            }
            
            //if discharge, within 5seconds can not enter tunnel to get batman
            if (distimerflag[i]==1 && timetunnel < 10) {
                loopCount++;
                continue;
            }
            
            //if discharge to 80%, restart b188, within 5seconds do nothing
            //            if (bsrset[i]==1 && ([[NSDate date] timeIntervalSinceDate: bsrtimer[i]]) < 15) {
            //                loopCount++;
            //                continue;
            //            }
            
            
            //if restart B235, within 8seconds do nothing, so as to get sn
            if (srscan[i]==1 && ([[NSDate date] timeIntervalSinceDate: portscan[i]]) < 8) {
                loopCount++;
                continue;
            }
            
            if (([[NSDate date] timeIntervalSinceDate:load[i]]) < 7 && load[i]!=0) {
                loopCount++;
                continue;
            }
            
            //if over 1min, still dont get sn, set restart B235 flag, make it have choose to restart
            if (srscan[i]==1 && ([[NSDate date] timeIntervalSinceDate: portscan[i]]) >= 5) {
                srscan[i]=0;
            }
            
            
            //link test
            NSString *sbls = @"";
            for (int x = 0; x<2; x++) {
                sbls=[board GetDutBLS:i+1];
                NSLog(@"innorev--sbls:%@,times:%d",sbls,x);
                if (![sbls containsString:@"0-0"]) {
                    break;
                }
            }
            
            if ([sbls isEqualToString:@""] || [sbls containsString:@"2-0"] || [sbls containsString:@"3-0"]|| [sbls containsString:@"0-2"] || [sbls containsString:@"0-3"]) {
                
                if (srscan[i]==0) {
                    [board resetDut:i];
                    portscan[i]=[NSDate date];
                    srscan[i]=1;
                }
                
                loopCount++;
                continue;
            }
            
            NSArray *linkstatus = [sbls componentsSeparatedByString:@"-"];//sbls = @"0-1","1-0","0-0"
            NSInteger indexx = board.boardIndex*MAX_CHANNEL_PER_BOARD+loopCount;
            
            if(tunnel==2){
                if ([[linkstatus objectAtIndex:0] intValue] == 1) {
                    tunnel = 0;
                }
                else if ([[linkstatus objectAtIndex:1] intValue]==1)
                {
                    tunnel = 1;
                }
                else
                {
                    [self cleanShowingUI:indexx];
                    [board GetDutSETLED:6 Com:i+1];
                    loopCount++;
                    continue;
                }
                
            }
            
            if ( (tunnel==0 && ([[linkstatus objectAtIndex:0] intValue]==0)) || (tunnel==1 && ([[linkstatus objectAtIndex:1] intValue]==0) ) || (([[linkstatus objectAtIndex:0] intValue]==0) && ([[linkstatus objectAtIndex:1] intValue]==0))) {
                //before link,then upload data to pdca
                if(![sn[indexx] isEqualTo:@""])
                {
                    //DUT just removed
                    NSLog(@"BOARD:%ld,COM:%d,sn:%@,just removed",(long)board.boardIndex,i,sn[indexx]);
                    //get the test time and write it into the log
                    NSTimeInterval testTime = [testTimeLog[loopCount][1] timeIntervalSinceDate:testTimeLog[loopCount][0]];
                    int minTime = 0;
                    int secondTime = 0;
                    if (testTime >= 60) {
                        minTime = (int)testTime/60;
                        secondTime = (int)testTime%60;
                    }
                    if (testTime > 0 && testTime < 60) {
                        
                        secondTime = (int)testTime;
                    }
                    NSString * strlog =  [NSString stringWithFormat:@"\nTest_Total_Time: %dMin %dSeconds\n",minTime,secondTime];
                    [self SaveResult2File:sn[indexx] DataToSave:strlog FilePath:filePath[loopCount]];
                    
                    NSString *uploadtesttime=[NSString stringWithFormat:@"%d.%d",minTime,secondTime];
                    
                    //upload DUT data
                    if (errorcount[loopCount]<=4) {
                        errorflag[loopCount]=@"";
                    }
                    @synchronized(m_dictRecord){
                        //last data
                        DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sn[indexx]];
                        if (dr!=nil) {
                            if(dr.index<DATA_POINTS)
                            {
                                PDCA_DATA pd={temCur[loopCount],temVolt[loopCount],temPer[loopCount],temLid[loopCount]};
                                dr.EndTime = [NSDate yn_Time_tSince1970];
                                [dr setValue:pd forIdx:dr.index];
                                dr.index++;
                            }
                            if (dr.index < DATA_POINTS) {
                                PDCA_DATA pd={[uploadtesttime floatValue],[fSN floatValue],0,0};
                                dr.EndTime = [NSDate yn_Time_tSince1970];
                                [dr setValue:pd forIdx:dr.index];
                                dr.index++;
                            }
                            [m_dictRecord setObject:dr forKey:sn[indexx]];
                            //dr=nil;
                            //last data upload ok
                            if([[m_dictRecord allKeys] containsObject:sn[indexx]]){
                                DataRecord *drOld=(DataRecord *)[m_dictRecord objectForKey:sn[indexx]];
                                drOld.EndTime = [NSDate yn_Time_tSince1970];
                               // if (isFinish[i]) {
                                    [self Upload_PDCA:drOld forSN:sn[indexx] dataPoint:dr.index ErrorFlag:errorflag[loopCount] isFinish:isFinish[i]];
                               // }
                                
                                [m_dictRecord removeObjectForKey:sn[indexx]];
                                [board.snArray replaceObjectAtIndex:i withObject:@""];
                                drOld=nil;
                                dr=nil;
                            }//uploaded then remove from dictionary
                        }
                        
                    }
                    
                    filePath[loopCount]=@"";
                    temCur[i]=0;
                    temVolt[i]=0;
                    temPer[i]=0;
                    temLid[i]=0;
                    timeTenCur[i]=0;
                    timeTenPer[i]=0;
                    timeTenVolt[i]=0;
                    bCharging[i]=NO;
                    bFirst[i]=YES;
                    bLogData[i]=false;
                    distimer[i]=0;
                    distimerflag[i]=0;
                    dut[i]=YES;
                    load[i]=0;
                    //bsrset[i]=0;
                    //bsrtimer[i]=0;
                    sv[i]=@"";
                    hv[i]=@"";
                    filePath[i]=@"";
                    testTimeLog[i][0]=0;
                    testTimeLog[i][1]=0;
                    errorflag[i]=@"";
                    //error flag: 1-value not match; 2-battery value not change when charge or discharge over 5min 3-overcurrent;
                    errorcount[i]=0;
                    bobcat[i]=true;
                    boutflag[i]=0;
                    sn[indexx]=@"";
                    isFinish[i]=NO;
                    
                    [board GetDutSETLED:6 Com:i+1];
                    [self cleanShowingUI:indexx];
                }
                if (srscan[i]==0 && ([[NSDate date] timeIntervalSinceDate: StartTime[i]]) > 10) {
                    [board resetDut:i];
                    portscan[i]=[NSDate date];
                    srscan[i]=1;
                }
                
                [board GetDutSETLED:6 Com:i+1];
                [self cleanShowingUI:indexx];
                
                loopCount++;
                continue;
            }
            
            NSString *sntemp=sn[indexx];
            
            timetunnel = [[NSDate date] timeIntervalSinceDate: distimer[i]];//负值
            
            //only normal charge can get sn, if discharge, then beyond 1min then get sn again.
            if ((distimerflag[i]==1 && timetunnel>=62) || distimerflag[i]==0) {
                
                NSString *sRead = [CutMesTool getSerialNumber:board channelIndex:i tempSN:sntemp tunnel:tunnel];
                
                if (!sRead.length) {
                    NSLog(@"lcw add to check get sn empty,reset dut");
                    [board resetDut:i];
                    loopCount++;
                    continue;
                }
                
                //更新界面 only normal charge
                sn[indexx] = sRead;
                
                if([sn[indexx] isEqualToString:@""]){
                    //Empty SN is not valid
                    NSLog(@"luocw add to check whether come here 1");
                    if(![sntemp isEqualToString:@""]){
                        //DUT just removed
                        NSLog(@"luocw add to check whether come here 2");
                        //get the test time and write it into the log
                        NSTimeInterval testTime = [testTimeLog[loopCount][1] timeIntervalSinceDate:testTimeLog[loopCount][0]];
                        int minTime = 0;
                        int secondTime = 0;
                        if (testTime >= 60) {
                            minTime = (int)testTime/60;
                            secondTime = (int)testTime%60;
                        }
                        if (testTime > 0 && testTime < 60) {
                            
                            secondTime = (int)testTime;
                        }
                        NSString * strlog =  [NSString stringWithFormat:@"\nTest_Total_Time: %dMin %dSeconds\n",minTime,secondTime];
                        [self SaveResult2File:sntemp DataToSave:strlog FilePath:filePath[loopCount]];
                        
                        NSString *uploadtesttime=[NSString stringWithFormat:@"%d.%d",minTime,secondTime];
                        //upload DUT data
                        if (errorcount[loopCount]<=4) {
                            errorflag[loopCount]=@"";
                        }
                        @synchronized(m_dictRecord){
                            //last data
                            DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sntemp];
                            if (dr!=nil) {
                                if(dr.index<DATA_POINTS)
                                {
                                    PDCA_DATA pd={temCur[loopCount],temVolt[loopCount],temPer[loopCount],temLid[loopCount]};
                                    
                                    dr.EndTime = [NSDate yn_Time_tSince1970];
                                    [dr setValue:pd forIdx:dr.index];
                                    dr.index++;
                                }
                                if (dr.index < DATA_POINTS) {
                                    PDCA_DATA pd={[uploadtesttime floatValue],[fSN floatValue],0,0};
                                    dr.EndTime = [NSDate yn_Time_tSince1970];
                                    [dr setValue:pd forIdx:dr.index];
                                    dr.index++;
                                }
                                [m_dictRecord setObject:dr forKey:sntemp];
                                //dr=nil;
                                //last data upload ok
                                if([[m_dictRecord allKeys] containsObject:sntemp]){
                                    DataRecord *drOld=(DataRecord *)[m_dictRecord objectForKey:sntemp];
                                    time_t endtime;
                                    time(&endtime);
                                    drOld.EndTime = endtime;
                                   // if (isFinish[i]) {
                                        [self Upload_PDCA:drOld forSN:sntemp dataPoint:dr.index ErrorFlag:errorflag[loopCount] isFinish:isFinish[i]];
                                   // }
                                    NSLog(@"lcw add to chcek Upload_PDCA 2,sn:%@,EndTime:%ld",sn[indexx],drOld.EndTime);
                                    [m_dictRecord removeObjectForKey:sn[indexx]];
                                    [board.snArray replaceObjectAtIndex:i withObject:@""];
                                    drOld=nil;
                                    dr=nil;
                                }//uploaded then remove from dictionary
                            }
                            
                        }
                        
                        filePath[loopCount]=@"";
                        temCur[i]=0;
                        temVolt[i]=0;
                        temPer[i]=0;
                        temLid[i]=0;
                        timeTenCur[i]=0;
                        timeTenPer[i]=0;
                        timeTenVolt[i]=0;
                        bCharging[i]=NO;
                        bFirst[i]=YES;
                        bLogData[i]=false;
                        distimer[i]=0;
                        distimerflag[i]=0;
                        dut[i]=YES;
                        load[i]=0;
                        //bsrset[i]=0;
                        //bsrtimer[i]=0;
                        sv[i]=@"";
                        hv[i]=@"";
                        filePath[i]=@"";
                        testTimeLog[i][0]=0;
                        testTimeLog[i][1]=0;
                        errorflag[i]=@"";  //error flag: 1-value not match; 2-battery value not change when charge or discharge over 5min 3-overcurrent;
                        errorcount[i]=0;
                        bobcat[i]=true;
                        boutflag[i]=0;
                        sn[indexx]=@"";
                        isFinish[i]=NO;
                        
                    }
                    if (srscan[i]==0 && ([[NSDate date] timeIntervalSinceDate: StartTime[i]]) > 10) {
                        [board resetDut:i];
                        portscan[i]=[NSDate date];
                        srscan[i]=1;
                    }
                    
                    [self cleanShowingUI:indexx];
                    [board GetDutSETLED:6 Com:i+1];
                    loopCount++;
                    continue;
                }
                
                else if(![sn[indexx] isEqualToString:sntemp] && ![sRead isEqualToString: @""]){
                    //SN changed SN IS NOT @""
                    //upload DUT data
                    if(![sntemp isEqualToString:@""]){
                        //DUT just removed
                        NSLog(@"luocw add to check whether come here 3");
                        //get the test time and write it into the log
                        NSTimeInterval testTime = [testTimeLog[loopCount][1] timeIntervalSinceDate:testTimeLog[loopCount][0]];
                        int minTime = 0;
                        int secondTime = 0;
                        if (testTime >= 60) {
                            minTime = (int)testTime/60;
                            secondTime = (int)testTime%60;
                        }
                        if (testTime > 0 && testTime < 60) {
                            
                            secondTime = (int)testTime;
                        }
                        NSString * strlog =  [NSString stringWithFormat:@"\nTest_Total_Time: %dMin %dSeconds\n",minTime,secondTime];
                        [self SaveResult2File:sntemp DataToSave:strlog FilePath:filePath[loopCount]];
                        
                        NSString *uploadtesttime=[NSString stringWithFormat:@"%d.%d",minTime,secondTime];
                        //upload DUT data
                        if (errorcount[loopCount]<=4) {
                            errorflag[loopCount]=@"";
                        }
                        @synchronized(m_dictRecord){
                            //last data
                            DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sntemp];
                            if (dr!=nil) {
                                if(dr.index<DATA_POINTS)
                                {
                                    PDCA_DATA pd={temCur[loopCount],temVolt[loopCount],temPer[loopCount],temLid[loopCount]};
                                    dr.EndTime = [NSDate yn_Time_tSince1970];
                                    [dr setValue:pd forIdx:dr.index];
                                    dr.index++;
                                }
                                if (dr.index < DATA_POINTS) {
                                    PDCA_DATA pd={[uploadtesttime floatValue],[fSN floatValue],0,0};
                                    dr.EndTime = [NSDate yn_Time_tSince1970];
                                    [dr setValue:pd forIdx:dr.index];
                                    dr.index++;
                                }
                                [m_dictRecord setObject:dr forKey:sntemp];
                                //dr=nil;
                                //last data upload ok
                                if([[m_dictRecord allKeys] containsObject:sntemp]){
                                    DataRecord *drOld=(DataRecord *)[m_dictRecord objectForKey:sntemp];
                                    drOld.EndTime = [NSDate yn_Time_tSince1970];
                                   // if (isFinish[i]) {
                                        
                                        [self Upload_PDCA:drOld forSN:sntemp dataPoint:dr.index ErrorFlag:errorflag[loopCount] isFinish:isFinish[i]];
                                    //}
                                    
                                    NSLog(@"lcw add--Upload_PDCA 3,sn:%@,EndTime:%ld",sn[indexx],drOld.EndTime);
                                    [m_dictRecord removeObjectForKey:sn[indexx]];
                                    
                                    [board.snArray replaceObjectAtIndex:i withObject:@""];
                                    
                                    drOld=nil;
                                    dr=nil;
                                    
                                }//uploaded then remove from dictionary
                            }
                        }
                    }
                    
                    
                    //new dut init
                    board.snArray[i] = sn[indexx];
                    
                    [board SetTUNNEL:tunnel Channel:i+1];
                    [board StopDisCharging:i+1];
                    [board CloseTunnel:i+1];
                    
                    DataRecord *dr=[[DataRecord alloc]init];
                    dr.SN=sn[indexx];
                    dr.StartTime = [NSDate yn_Time_tSince1970];
                    NSLog(@"lcw add--new dut init--sn:%@,StartTime:%ld",sn[indexx],dr.StartTime);
                    dr.index=0;
                    [m_dictRecord setObject:dr forKey:dr.SN];
                    
                    bFirst[loopCount]=YES;
                    bLogData[i]=true;
                    
                    //                    NSRange nsrttim;
                    //                    NSString *strttim;
                    //                    strttim =[NSString stringWithFormat:@"%@",[board SetTTIM:i+1]];
                    //                    nsrttim=[strttim rangeOfString:@"ttim"];
                    //                    if (nsrttim.location == NSNotFound) {
                    //                        [board SetTTIM:i+1];
                    //                    }
                    load[i]=[NSDate date];
                    temCur[i]=0;
                    temVolt[i]=0;
                    temPer[i]=0;
                    temLid[i]=0;
                    distimer[i]=0;
                    distimerflag[i]=0;
                    dut[i]=YES;
                    //bsrset[i]=0;
                    //bsrtimer[i]=0;
                    portscan[i]=0;
                    srscan[i]=0;
                    filePath[loopCount]=@"";
                    errorflag[loopCount]=@"";
                    timeTenCur[i]=0;
                    StartTime[i]=[NSDate date];
                    timeTenPer[i]=0;
                    timeTenVolt[i]=0;
                    errorcount[i]=0;
                    boutflag[i]=0;
                    testTimeLog[i][0]=0;
                    testTimeLog[i][1]=0;
                    isFinish[i]=NO;
                    
                    //Set insert number and showing in the UI
                    NSString *insertFilePath = [[NSString alloc] initWithFormat:@"/vault/H16_Slot_InsertNUM/Insertnum/%ld.csv",(indexx+1)];
                    NSString *insertOldNumber;
                    if (![m_Log IsExist:insertFilePath isFolder:YES]) {
                        insertOldNumber = @"0";
                    }
                    else {
                        NSString *strOldInsertNum=[NSString stringWithString:[m_Log ReadFile:insertFilePath]];
                        NSRange narInsertTimes=[strOldInsertNum rangeOfString:@"InsertNumber:"];
                        insertOldNumber = [strOldInsertNum substringWithRange: NSMakeRange(narInsertTimes.location+narInsertTimes.length,(strOldInsertNum.length-narInsertTimes.length-narInsertTimes.location))];
                    }
                    int insertvalue = [insertOldNumber intValue]+1;
                    NSString *strNewInsertNum=[[NSString alloc] initWithFormat:@"%d", insertvalue];
                    [self SaveResult2File:strNewInsertNum SlotNUM:indexx+1];
                    [[arrCounter objectAtIndex:indexx] performSelectorOnMainThread:@selector(setStringValue:) withObject:strNewInsertNum waitUntilDone:NO];
                    
                    //Bobcat check, if return is equal YES, continue test.
                    BOOL bobcatreturn = [self Bobcat:(DataRecord *)[m_dictRecord objectForKey:sn[indexx]] forSN:sn[indexx] SlotNUM:indexx+1];
                    
                    if (bobcatreturn == false) {
                        //if return NO
                        bobcat[loopCount]=false;
                        loopCount++;
                        continue;
                    }
                    else
                    {
                        bobcat[loopCount]=true;
                    }
                    //once put DUT get software version
                    /***add by luocw at 20/4/2018---start***/
                    NSString* software = [CutMesTool getSoftwareVersion:board channelIndex:i tunnel:tunnel];
                    
                    if (!software.length)
                    {
                        loopCount++;
                        continue;
                    }
                    sv[loopCount] = software;
                    hv[loopCount] = [CutMesTool getHardwareVersion:board channelIndex:i tunnel:tunnel];
                    
                    //save software version and hardware version and slot
                    //add one record point if not exceed index
                    dr=(DataRecord *)[m_dictRecord objectForKey:sn[indexx]];
                    //if bad data,
                    if (dr==nil || dr==NULL) {
                        sn[indexx]=@"";
                        [m_dictRecord removeObjectForKey:@""];
                        loopCount++;
                        continue;
                    }
                    PDCA_DATA pd={[sv[loopCount] floatValue],[hv[loopCount] floatValue],indexx+1,insertvalue};
                    dr.EndTime = [NSDate yn_Time_tSince1970];
                    [dr setValue:pd forIdx:dr.index];
                    dr.index++;
                    [m_dictRecord setObject:dr forKey:sn[indexx]];
                }
                
            }
            
            
            //bobcat check fail,then continue;
            if (bobcat[loopCount] == false) {
                loopCount++;
                continue;
            }
            
            
            NSMutableArray *strPerVoltCurrent = [CutMesTool getPerAndCurrentAndVolt:board channelIndex:i tunnel:tunnel];
            if (strPerVoltCurrent.count == 0) {
                NSLog(@"lcw add to check -- did not get right receive,exit loop.strVoltCurrent count:%lu",(unsigned long)strPerVoltCurrent.count);
                loopCount++;
                continue;
            }
            
            //NSString*str_per=@"";
            int intcurrent = [strPerVoltCurrent[0] intValue];
            int intvolt= [strPerVoltCurrent[1] intValue];
            int intper = [strPerVoltCurrent[2] intValue];
            
            //读取盖子状态
            NSString *str_lid = [CutMesTool getLidStatus:board channelIndex:i];
            
            //  此刻拿走产品
            if (intvolt==0) {
                NSString *sbls=[NSString stringWithFormat:@"%@",[board GetDutBLS:i+1]];
                if ([sbls isEqualToString:@""]) {
                    loopCount++;
                    continue;
                }
                NSArray *linkstatus;
                linkstatus = [sbls componentsSeparatedByString:@"-"];
                //buddy connect check
                //if still link
                if ( ([[linkstatus objectAtIndex:0] intValue]==1) || ([[linkstatus objectAtIndex:1] intValue]==1) ) {
                    loopCount++;
                    continue;
                }
                //if don't link
                if ( (tunnel==0 && ([[linkstatus objectAtIndex:0] intValue]==0)) || (tunnel==1 && ([[linkstatus objectAtIndex:1] intValue]==0) ) || (([[linkstatus objectAtIndex:0] intValue]==0) && ([[linkstatus objectAtIndex:1] intValue]==0))  ) {
                    //before link,then upload data to pdca
                    if(![sn[indexx] isEqualTo:@""])
                    {
                        //DUT just removed
                        NSLog(@"lcw add to check--intvolt=0,SN:%@,DUT just removed then upload",sn[indexx]);
                        //get the test time and write it into the log
                        NSTimeInterval testTime = [testTimeLog[loopCount][1] timeIntervalSinceDate:testTimeLog[loopCount][0]];
                        int minTime = 0;
                        int secondTime = 0;
                        if (testTime >= 60) {
                            minTime = (int)testTime/60;
                            secondTime = (int)testTime%60;
                            
                        }
                        if (testTime > 0 && testTime < 60) {
                            
                            secondTime = (int)testTime;
                        }
                        NSString * strlog =  [NSString stringWithFormat:@"\nTest_Total_Time: %dMin %dSeconds\n",minTime,secondTime];
                        [self SaveResult2File:sntemp DataToSave:strlog FilePath:filePath[loopCount]];
                        
                        NSString *uploadtesttime=[NSString stringWithFormat:@"%d.%d",minTime,secondTime];
                        //upload DUT data
                        if (errorcount[loopCount]<=4) {
                            errorflag[loopCount]=@"";
                        }
                        @synchronized(m_dictRecord){
                            //last data
                            DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sn[indexx]];
                            if (dr!=nil) {
                                if(dr.index<DATA_POINTS)
                                {
                                    PDCA_DATA pd={temCur[loopCount],temVolt[loopCount],temPer[loopCount],temLid[loopCount]};
                                    dr.EndTime = [NSDate yn_Time_tSince1970];
                                    [dr setValue:pd forIdx:dr.index];
                                    dr.index++;
                                }
                                if (dr.index < DATA_POINTS) {
                                    PDCA_DATA pd={[uploadtesttime floatValue],[fSN floatValue],0,0};
                                    dr.EndTime = [NSDate yn_Time_tSince1970];
                                    [dr setValue:pd forIdx:dr.index];
                                    dr.index++;
                                }
                                [m_dictRecord setObject:dr forKey:sn[indexx]];
                                //dr=nil;
                                //last data upload ok
                                if([[m_dictRecord allKeys] containsObject:sn[indexx]]){
                                    DataRecord *drOld=(DataRecord *)[m_dictRecord objectForKey:sn[indexx]];
                                    drOld.EndTime = [NSDate yn_Time_tSince1970];
                                   // if (isFinish[i]) {
                                        
                                        [self Upload_PDCA:drOld forSN:sn[indexx] dataPoint:dr.index ErrorFlag:errorflag[loopCount] isFinish:isFinish[i]];
                                    //}
                                    NSLog(@"lcw add to check--Upload_PDCA 4,sn:%@,EndTime:%ld",sn[indexx],drOld.EndTime);
                                    [m_dictRecord removeObjectForKey:sn[indexx]];
                                    [board.snArray replaceObjectAtIndex:i withObject:@""];
                                    drOld=nil;
                                    dr=nil;
                                }//uploaded then remove from dictionary
                            }
                            
                        }
                        
                        filePath[loopCount]=@"";
                        temCur[i]=0;
                        temVolt[i]=0;
                        temPer[i]=0;
                        temLid[i]=0;
                        timeTenCur[i]=0;
                        timeTenPer[i]=0;
                        timeTenVolt[i]=0;
                        bCharging[i]=NO;
                        bFirst[i]=YES;
                        bLogData[i]=false;
                        distimer[i]=0;
                        distimerflag[i]=0;
                        dut[i]=YES;
                        load[i]=0;
                        //bsrset[i]=0;
                        //bsrtimer[i]=0;
                        sv[i]=@"";
                        hv[i]=@"";
                        filePath[i]=@"";
                        testTimeLog[i][0]=0;
                        testTimeLog[i][1]=0;
                        errorflag[i]=@"";  //error flag: 1-value not match; 2-battery value not change when charge or discharge over 5min 3-overcurrent;
                        errorcount[i]=0;
                        bobcat[i]=true;
                        boutflag[i]=0;
                        sn[indexx]=@"";
                        isFinish[i]=NO;
                    }
                    if (srscan[i]==0 && ([[NSDate date] timeIntervalSinceDate: StartTime[i]]) > 10) {
                        [board resetDut:i];
                        portscan[i]=[NSDate date];
                        srscan[i]=1;
                    }
                    [board GetDutSETLED:6 Com:i+1];
                    [self cleanShowingUI:indexx];
                    
                    loopCount++;
                    continue;
                }
                
            }
            
            //update data
            temLid[loopCount]=[str_lid floatValue];
            temCur[loopCount]=intcurrent;
            temPer[loopCount]=intper;
            temVolt[loopCount]=intvolt;
            
            //if decrease to 80% but still discharge
            //            if ([str_current integerValue]<=10 && intper < (specLower+1) && distimerflag[i]==1) {
            //                //[board SetBHR:i+1];
            //                [board SetBOUT:1 Channel:i+1];
            //                //                bsrset[i]=1;
            //                //                bsrtimer[i]=[NSDate date];
            //
            //            }
            //            //if normal charge status but not charge dut, reset b188, within 2min when insert B188, not charge
            //            if ([str_current integerValue]<=10 && distimerflag[i]==0 && intper<(specLower+1)  && (([[NSDate date] timeIntervalSinceDate:load[i]]) > 30)) {
            //                //[board SetBHR:i+1];
            //                [board SetBOUT:1 Channel:i+1];
            //                //                bsrset[i]=1;
            //                //                bsrtimer[i]=[NSDate date];
            //            }
            
            //updata UI
            //[[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setStringValue:) withObject:sn[indexx] waitUntilDone:NO];
            [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setStringValue:) withObject:sn[indexx] waitUntilDone:NO];
            
            if ([sn[indexx] isEqualToString:@""]) {
                NSLog(@"ERROR SN");
            }
            NSString* strdata=@"";
            
            //充电放电控制，设置led状态灯
            if(bFirst[loopCount]==YES){
                [[[arrDUTResultTextBoxs objectAtIndex:indexx] objectAtIndex:0 ] performSelectorOnMainThread:@selector(setStringValue:) withObject:[NSString stringWithFormat:@"%5ld",(long)intcurrent] waitUntilDone:NO];
                [[[arrDUTResultTextBoxs objectAtIndex:indexx] objectAtIndex:1 ] performSelectorOnMainThread:@selector(setStringValue:) withObject:[NSString stringWithFormat:@"%5ld",(long)intvolt] waitUntilDone:NO];
                [[[arrDUTResultTextBoxs objectAtIndex:indexx] objectAtIndex:2 ] performSelectorOnMainThread:@selector(setStringValue:) withObject:[NSString stringWithFormat:@"%5ld",(long)intper] waitUntilDone:NO];
                
                
                
                if(intper < _stopcharge){
                    boutflag[i]=0;
                    
                }
                
                
                //                if (intcurrent <= _currentLimit && intvolt >= _voltLimit) {
                //                    //                    sleep(2);
                //                    [board GetDutSETLED:3 Com:i+1];
                //                    [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor greenColor] waitUntilDone:NO];
                //                }else{
                //                    //                    sleep(2);
                //                    [board SetBOUT:1 Channel:i+1];
                //                    [board GetDutSETLED:2 Com:i+1];
                //                    [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor yellowColor] waitUntilDone:NO];
                //                }
                
                //if %>=85
                if (intper > _specUpper) {
                    [board SetBOUT:0 Channel:i+1];
                    if (!boutflag[i]) {
                      //  StopDisCharging
                        [board SetTUNNEL:tunnel Channel:i+1];
                        [board setDischarge:i+1];
                        [board CloseTunnel:i+1];
                        boutflag[i]=1;
                    }
                    
                    if (errorcount[loopCount]<=4) {
                        [board GetDutSETLED:7 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor  purpleColor] waitUntilDone:NO];
                    }
                    else {
                        [board GetDutSETLED:1 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor  redColor] waitUntilDone:NO];
                        isFinish[i] = YES;
                    }
                }
                
                //if % winthin [82-85)
                else if(intper>=_specLower && intper<=_specUpper)
                {
                    isFinish[i]=YES;
                    // [board setResetSystem:i+1];
                    if(intper >= _stopcharge){
                        [board SetBOUT:0 Channel:i+1];
                       // boutflag[i]=1;
                        
                    }
                    
                    if (boutflag[i]) {
                        //[board SetTTIM:i+1];
                        [board SetTUNNEL:tunnel Channel:i+1];
                        //[board setResetSystem:i+1];
                        [board setUVP:i+1];
                       [board CloseTunnel:i+1];
                        boutflag[i] = 0;
                    }
                    
                    
                    if (errorcount[loopCount]<=4) {
                        if (distimerflag[loopCount]==1) {
                            [board GetDutSETLED:7 Com:i+1];
                            [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor  purpleColor] waitUntilDone:NO];
                        }
                        else
                        {
                            [board GetDutSETLED:3 Com:i+1];
                            [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor greenColor] waitUntilDone:NO];
                        }
                    }
                    else {
                        [board GetDutSETLED:1 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor redColor] waitUntilDone:NO];
                        isFinish[i] = YES;
                    }
                }
                else if(intper<_specLower)
                {
                    [board SetBOUT:1 Channel:i+1];
                    
                    //battery issue
                    if (bLogData[loopCount]==true && [[NSDate date] timeIntervalSinceDate:load[loopCount]]>3*60) {
                        if ( ((intvolt-timeTenVolt[loopCount])<=1) && ((intper-timeTenPer[loopCount])<=1) ) {
                            errorflag[loopCount]=@"2";
                            errorcount[loopCount]++;
                        }
                    }
                    if (errorcount[loopCount]<=4) {
                        [board GetDutSETLED:2 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor yellowColor] waitUntilDone:NO];
                    }
                    else {
                        [board GetDutSETLED:1 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor redColor] waitUntilDone:NO];
                    }
                    
                }
                
                
                if(intcurrent >= 150){
                    [board SetBOUT:0 Channel:i+1];
                    errorcount[loopCount]++;
                    errorflag[loopCount]=@"3";
                    if (errorcount[loopCount]>4 && [errorflag[loopCount] isEqualToString:@"3"]) {
                        [board GetDutSETLED:5 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor redColor]waitUntilDone:NO];
                    }
                    
                }
                
                //PDCA add
                if(bLogData[i] && (intvolt !=0))
                {
                    //add one record point if not exceed index
                    DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sn[indexx]];
                    if (dr==nil) {
                        loopCount++;
                        continue;
                    }
                    if(dr.index<DATA_POINTS)
                    {
                        PDCA_DATA pd={intcurrent,intvolt,intper,[str_lid integerValue]};
                        dr.EndTime = [NSDate yn_Time_tSince1970];
                        [dr setValue:pd forIdx:dr.index];
                        dr.index++;
                    }
                    [m_dictRecord setObject:dr forKey:sn[indexx]];
                    //[m_dictRecord setObject:dr forKey:sntemp];
                    dr=nil;
                    bLogData[i]=false;
                    StartTime[i]=[NSDate date];
                    //Every 5min load the value to the array
                    timeTenCur[loopCount]=intcurrent;
                    timeTenVolt[loopCount]=intvolt;
                    timeTenPer[loopCount]=intper;
                    NSLog(@"SN:%@,currentTime:%@,PDCA add every five mins",sn[indexx],StartTime[i]);
                }
                
                //Get the data to be prepared
                strdata =  [NSString stringWithFormat:@"%@,%@,%ld,%@,%@,%d,%d,%d,%@\n",sn[indexx],[NSDate yn_dateTimeWithMicrosecond],indexx+1,sv[loopCount],hv[loopCount],intcurrent,intvolt,intper,str_lid];
                NSLog(@"%@",strdata);
                //save data to log
                if ([filePath[loopCount] isEqualToString:@""]) {
                    filePath[loopCount]=[filePath[loopCount] stringByAppendingString:[self SaveResult2File:sn[indexx] DataToSave:strdata FilePath:@""]];
                    testTimeLog[loopCount][0]=[NSDate date];
                }
                if (![filePath[loopCount] isEqualToString:@""]) {
                    [self SaveResult2File:sn[indexx] DataToSave:strdata FilePath:filePath[loopCount]];
                    testTimeLog[loopCount][1]=[NSDate date];
                }
                
            }
            
            
            if([[NSDate date] timeIntervalSinceDate:StartTime[i]]>=5*60){
                bLogData[i]=true;
            }
            
            
            loopCount++;
        }
        
        TimeCount++;
        startone=0;
        
    }
    
    goto LoopStart;
    
}


- (IBAction)Start:(id)sender {
    //tunnel=1;
    //START = true;
    if (START) {
        return;
    }
    START = true;
    [self.startBtn setTitle:@"Testing"];
    [self.startBtn setEnabled:NO];
}


-(void)setupDatas
{
    arrSNTextBoxs=[[NSArray alloc]initWithObjects:_Board1Port1SN1,_Board1Port2SN2,_Board1Port3SN3,_Board1Port4SN4,
                   _Board1Port5SN5,_Board1Port6SN6,_Board1Port7SN7,_Board1Port8SN8,
                   _Board1Port9SN9,_Board1Port10SN10,_Board2Port1SN11,_Board2Port2SN12,
                   _Board2Port3SN13,_Board2Port4SN14,_Board2Port5SN15,_Board2Port6SN16,
                   _Board2Port7SN17,_Board2Port8SN18,_Board2Port9SN19,_Board2Port10SN20,
                   _Board3Port1SN21,_Board3Port2SN22,_Board3Port3SN23,_Board3Port4SN24,
                   _Board3Port5SN25,_Board3Port6SN26,_Board3Port7SN27,_Board3Port8SN28,
                   _Board3Port9SN29,_Board3Port10SN30,
                   nil];
    arrDUTResultTextBoxs=[[NSArray alloc]initWithObjects:
                          [[NSArray alloc]initWithObjects:_DUT1Current1,_DUT1Current2,_DUT1Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT2Current1,_DUT2Current2,_DUT2Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT3Current1,_DUT3Current2,_DUT3Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT4Current1,_DUT4Current2,_DUT4Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT5Current1,_DUT5Current2,_DUT5Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT6Current1,_DUT6Current2,_DUT6Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT7Current1,_DUT7Current2,_DUT7Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT8Current1,_DUT8Current2,_DUT8Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT9Current1,_DUT9Current2,_DUT9Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT10Current1,_DUT10Current2,_DUT10Current3,nil],
                          
                          [[NSArray alloc]initWithObjects:_DUT11Current1,_DUT11Current2,_DUT11Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT12Current1,_DUT12Current2,_DUT12Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT13Current1,_DUT13Current2,_DUT13Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT14Current1,_DUT14Current2,_DUT14Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT15Current1,_DUT15Current2,_DUT15Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT16Current1,_DUT16Current2,_DUT16Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT17Current1,_DUT17Current2,_DUT17Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT18Current1,_DUT18Current2,_DUT18Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT19Current1,_DUT19Current2,_DUT19Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT20Current1,_DUT20Current2,_DUT20Current3,nil],
                          
                          [[NSArray alloc]initWithObjects:_DUT21Current1,_DUT21Current2,_DUT21Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT22Current1,_DUT22Current2,_DUT22Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT23Current1,_DUT23Current2,_DUT23Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT24Current1,_DUT24Current2,_DUT24Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT25Current1,_DUT25Current2,_DUT25Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT26Current1,_DUT26Current2,_DUT26Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT27Current1,_DUT27Current2,_DUT27Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT28Current1,_DUT28Current2,_DUT28Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT29Current1,_DUT29Current2,_DUT29Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT30Current1,_DUT30Current2,_DUT30Current3,nil],
                          nil];
    arrCounter = [[NSArray alloc] initWithObjects:
                  _Counter1,_Counter2,_Counter3,_Counter4,_Counter5,
                  _Counter6,_Counter7,_Counter8,_Counter9,_Counter10,
                  _Counter11,_Counter12,_Counter13,_Counter14,_Counter15,
                  _Counter16,_Counter17,_Counter18,_Counter19,_Counter20,
                  _Counter21,_Counter22,_Counter23,_Counter24,_Counter25,
                  _Counter26,_Counter27,_Counter28,_Counter29,_Counter30,
                  nil];
}
- (IBAction)StartR:(id)sender {
    //    tunnel=1;
    if (START) {
        return;
    }
    START = true;
    
    //    for(int i=0;i<1;i++)
    //    {
    //        if([m_Board[i] Open:[m_SavePortName objectAtIndex:i] andBaudRate:230400]>0)
    //        {
    //            //usleep(800);
    //            for (int j=1; j<=2; j++){
    //                sn[i*MAX_CHANNEL_PER_BOARD+j-1]=@"";
    //                [m_Board[i]  SetBOUT:1];
    //                [m_Board[i] SetFATP:1 Channel:1];//
    //                [m_Board[i] GetDutHVSV:1 Channel:1];
    //                [m_Board[i] GetDutBATMAN:1];
    //                [m_Board[i]  GetLID:1];
    //                [m_Board[i]  SetBOUT:1];
    //                [m_Board[i]  SetTTIM:1];
    //            }
    //        }
    //
    //    }
    
    
}

- (IBAction)Stop:(id)sender {
    START = false;
}

-(void)cleanShowingUI:(NSInteger)indexx
{
    [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"" waitUntilDone:NO];
    [[arrSNTextBoxs objectAtIndex:indexx] performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[NSColor whiteColor] waitUntilDone:NO];
    [[[arrDUTResultTextBoxs objectAtIndex:indexx] objectAtIndex:0] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"" waitUntilDone:NO];
    [[[arrDUTResultTextBoxs objectAtIndex:indexx] objectAtIndex:1] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"" waitUntilDone:NO];
    [[[arrDUTResultTextBoxs objectAtIndex:indexx] objectAtIndex:2] performSelectorOnMainThread:@selector(setStringValue:) withObject:@"" waitUntilDone:NO];
}


- (IBAction)SaveSNNumber:(id)sender {
    NSString *fixtureSN= [_FixtureSNText stringValue];
    NSString *documentDirectory = @"/vault";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentDirectory stringByAppendingPathComponent:@"FixtureSN"];
    
    if (![m_Log IsExist:testDirectory isFolder:YES]) {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/FixtureSN.csv",testDirectory];
    if (![m_Log IsExist:filePath isFolder:NO]) {
        [fileManager createFileAtPath:filePath contents:[@""  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    NSString *string = [[NSString alloc] initWithFormat:@"FixtureSN:%@",fixtureSN];
    [m_Log WriteFile:testDirectory andFullPath:filePath andContent:string IsAppend:NO];
    fSN = [@"3" stringByAppendingString:[_FixtureSNText stringValue]];
    [_FixtureNumberShows performSelectorOnMainThread:@selector(setStringValue:) withObject:[@"FixtureSN-" stringByAppendingString:fSN] waitUntilDone:NO];
}

-(void)Upload_PDCA:(DataRecord *)data forSN:(NSString *)serialnumber dataPoint:(int)index ErrorFlag:(NSString *)flag isFinish:(BOOL)isFinish
{
    if (PDCA_flag==YES) {
        NSInteger failNum =[CSVLog2 getFailNumWithSN:serialnumber];
        if (failNum<[ConfigPlist failNum] || isFinish) {
        NSString *string=[NSString stringWithFormat:@"%@\n", [data getDataString:index]];
   
        struct structPDCA structtest;
        [[PoolPDCA Instance] setIsPDCAStart:NO];
        structtest.isNeedStart=YES;
        
        structtest.strSN = data.SN;
        structtest.strSN=serialnumber;
        
        NSRange nsrSW=[appSW rangeOfString:@"SV-"];
        NSString *strSW=[appSW substringWithRange:NSMakeRange(nsrSW.location+nsrSW.length,5)];
        structtest.strSoftName=strSW;
        structtest.strSoftVersion = @"B288";
        structtest.strTestPoint= string;
        
        [[PoolPDCA Instance] AdjustPDCA:serialnumber strSWName:"B288 Smart Charger 30ports Packing" str_SWVersion:[strSW UTF8String] str_StationSN:[data.stationID UTF8String] str_PDCAData:structtest.strTestPoint ErrorFlag:flag Priority:[[NSString alloc] initWithFormat:@"%d",Audit_flag] startTime:data.StartTime endTime:data.EndTime];
    }
    
    }
    
}


-(BOOL)Bobcat:(DataRecord *)data forSN:(NSString *)serialnumber SlotNUM:(long int)slot
{
    if (Bobcat_flag==YES) {
        struct structPDCA structtest;
        [[PoolPDCA Instance] setIsPDCAStart:NO];
        structtest.isNeedStart=YES;
        
        NSRange nsrSW=[appSW rangeOfString:@"SV-"];
        NSString *strSW=[appSW substringWithRange:NSMakeRange(nsrSW.location+nsrSW.length,5)];
        structtest.strSoftName=strSW;
        structtest.strSoftVersion = @"B288";
        return [[PoolPDCA Instance] Bobcat_Check:[serialnumber UTF8String] strSWName:"B288 Smart Charger 30ports Packing" str_SWVersion:[strSW UTF8String] str_StationSN:[data.stationID UTF8String] slot_Num:slot];
    }
    else{
        return YES;
    }
}


- (void) SaveResult2File:(NSString*)sdata SlotNUM:(long int)num
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
    NSString *documentsDirectory = @"/vault";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"H16_Slot_InsertNUM"];
    
    NSString* FilePath = @"Insertnum";
    if (![m_Log IsExist:testDirectory isFolder:YES]) {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[testDirectory stringByAppendingPathComponent:FilePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else{
        if(![m_Log IsExist:[testDirectory stringByAppendingPathComponent:FilePath] isFolder:YES]){
            [fileManager createDirectoryAtPath:[testDirectory stringByAppendingPathComponent:FilePath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    testDirectory=[testDirectory stringByAppendingPathComponent:FilePath];
    FilePath = [NSString stringWithFormat:@"%@/%ld.csv",testDirectory,num];//写log文件路径，文件夹B288/yyyy-MM-dd/serialNumber.csv
    
    
    if (![m_Log IsExist:FilePath isFolder:NO]) {
        [fileManager createFileAtPath:FilePath contents:[@""  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    NSString *string = [[NSString alloc] initWithFormat:@"SlotNumber:%ld  InsertNumber:%@",num,sdata];
    [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:NO];
    
    
    
    
}



- (NSString*) SaveResult2File:(NSString *)serialNumber DataToSave:(NSString*)sdata FilePath:(NSString *)filepath
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
    NSString *documentsDirectory = @"/vault";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B288_GG_Data"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
    
    if (![m_Log IsExist:testDirectory isFolder:YES]) {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[testDirectory stringByAppendingPathComponent:FilePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else{
        if(![m_Log IsExist:[testDirectory stringByAppendingPathComponent:FilePath] isFolder:YES]){
            [fileManager createDirectoryAtPath:[testDirectory stringByAppendingPathComponent:FilePath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    testDirectory=[testDirectory stringByAppendingPathComponent:FilePath];
    
    
    if ([filepath isEqualToString:@""]) {
        FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,serialNumber];//写log文件路径，文件夹B288/yyyy-MM-dd/serialNumber.csv
        NSString *SN;
        //add if sn is used again
        for (int j=0; j<1000; j++) {
            //if not creat the file before, then creat a new one
            if (![m_Log IsExist:FilePath isFolder:YES]) {
                NSString *string = @"SerialNumber,DateTime,Slot,Software_Version,Hardware_Version,Current,Voltage,Percentage,Lid\n";
                [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
                break;
            }
            // if the file has existed, then change sn,and check.
            if ([m_Log IsExist:FilePath isFolder:YES]) {
                SN=[serialNumber stringByAppendingString:[NSString stringWithFormat:@"-%d",j+1]];
                FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,SN];
            }
        }
    }
    else{
        FilePath = [NSString stringWithFormat:@"%@",filepath];
    }
    [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:sdata IsAppend:YES];
    NSLog(@"%@",FilePath);
    return FilePath;
}







- (IBAction)SetWindow:(id)sender {
    
    NSString *prompt = @"PassWord Protected Function!!!";
    NSString *infoText = @"Please enter password to upload PDCA data:";
    NSString *defaultValue = @"Enter your password here";
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@",infoText];
    NSSecureTextField *input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setPlaceholderString:defaultValue];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        if(![[input stringValue] isEqualToString:@"engineering"]){
            NSRunAlertPanel(@"Error",@"Password is not correct", @"OK", nil, nil);
        }
        else{
            //[NSApp runModalForWindow:_setwindow];
            //[NSApp stopModal];
            [self.window beginSheet:_setwindow completionHandler:nil];
        }
        NSLog(@"User entered: %@", [input stringValue]);
    }
    else if (button == NSAlertAlternateReturn) {
        NSLog(@"User cancelled");
    }
    else{
        NSLog(@"Should never go here");
    }
}

- (IBAction)Exit_setWindow:(id)sender {
    [_setwindow orderOut:nil];
}

- (IBAction)PDCA_Upload_Control:(id)sender
{
    PDCA_flag=_PDCA_check.state;
    
    if (!self.PDCA_check.state) {
        [_Bobcat_check setState:0];
    }
    
    NSLog(@"Audit Flag is %hhd",Audit_flag);
    NSLog(@"Bobcat Flag is %hhd",Bobcat_flag);
    NSLog(@"PDCA Flag is %hhd",PDCA_flag);
}

- (IBAction)Bobcat_Upload_Control:(id)sender {
    
    if (self.Audit_check.state||!self.PDCA_check.state) {
        [_Bobcat_check setState:0];
    }
    Bobcat_flag=_Bobcat_check.state;
    
    
    NSLog(@"Audit Flag is %hhd",Audit_flag);
    NSLog(@"Bobcat Flag is %hhd",Bobcat_flag);
    NSLog(@"PDCA Flag is %hhd",PDCA_flag);
}

- (IBAction)Audit_Control:(id)sender {
    //[self.window beginSheet:_setwindow completionHandler:nil];
    Audit_flag = self.Audit_check.state;
    if (self.Audit_check.state) {
        
        self.window.backgroundColor = [NSColor colorWithRed:224.0/255.0 green:56.0/255.0 blue:225.0/255.0 alpha:1];
    }else{
        self.window.backgroundColor = [NSColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    }
    
    
    
    if (Audit_flag==0) {
        
        [_Bobcat_check setState:1];
        Bobcat_flag=YES;
    }
    if (Audit_flag==1) {
        [_Bobcat_check setState:0];
        Bobcat_flag=NO;
    }
    NSLog(@"Audit Flag is %hhd",Audit_flag);
    NSLog(@"Bobcat Flag is %hhd",Bobcat_flag);
    NSLog(@"PDCA Flag is %hhd",PDCA_flag);
    
}


@end
