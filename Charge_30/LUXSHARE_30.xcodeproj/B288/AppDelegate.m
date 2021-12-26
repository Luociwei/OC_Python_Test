//
//  AppDelegate.m
//  B235
//
//  Created by 罗婷 on 16/2/23.
//  Copyright (c) 2016年 Vicky Luo. All rights reserved.
//

#import "AppDelegate.h"

@implementation DataRecord

- (id)init {
    self = [super init];
    if (self){
        self.SN= @"";
        self.bPass=false;
        self.bFinished=false;
        self.StartTime=@"";
        self.EndTime=@"";
        self.product=@"B235";
        self.stationID=@"DEVELOPMENT17"; //aaron provided stationID
        self.index=0;
        for(int i=0;i<14;i++){
            self->vCurrent[i]=0;
        }
    }
    return self;
}
-(void)setValue:(NSInteger)val forIdx:(int)idx
{
    if(idx>-1 && idx<14)
        vCurrent[idx]=val;
}

-(NSInteger *)getDataArray
{
    return vCurrent;
}

-(NSString *)getDataString{
    NSMutableString * s=[[NSMutableString alloc]init];
    [s appendFormat:@"%@,",self.product];
    [s appendFormat:@"%@,",self.SN];
    [s appendFormat:@"%@,",self.stationID];
    [s appendFormat:@"%@,",self.bPass?@"Pass":@"Fail"];
    [s appendFormat:@"%@,",self.StartTime];
    [s appendFormat:@"%@,",self.EndTime];
    [s appendFormat:@"%@,",@""];
    for(int i=0;i<14;i++)
    {
        [s appendString:[NSString stringWithFormat:@"%ld,",(long)vCurrent[i]]];
    }
    return [s substringToIndex:([s length]-1)];
}

@end

@implementation AppDelegate
{
    NSArray *arrSNTextBoxs;
    NSArray *arrDUTResultTextBoxs;
    NSMutableDictionary *m_dictRecord;
    NSString *sn[100];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [_window setDelegate:self];
    m_PortNameArray = [[NSMutableArray alloc]init];
    m_dictRecord=[[NSMutableDictionary alloc]init];
    m_SavePortName = [[NSArray alloc]initWithObjects:
                      @"/dev/cu.usbserial-FIX-01",@"/dev/cu.usbserial-FIX-02",
                      @"/dev/cu.usbserial-FIX-03",@"/dev/cu.usbserial-FIX-04",
                      @"/dev/cu.usbserial-FIX-05",@"/dev/cu.usbserial-FIX-06",
                      @"/dev/cu.usbserial-FIX-07",@"/dev/cu.usbserial-FIX-08",
                      // nil];
                      @"/dev/cu.usbserial-FIX-09",@"/dev/cu.usbserial-FIX-10",
                      @"/dev/cu.usbserial-FIX-11",@"/dev/cu.usbserial-FIX-12",
                      @"/dev/cu.usbserial-FIX-13",@"/dev/cu.usbserial-FIX-14",
                      @"/dev/cu.usbserial-FIX-15",@"/dev/cu.usbserial-AI034AVV",nil];
     
    
    arrSNTextBoxs=[[NSArray alloc]initWithObjects:_Board1Port1SN1,_Board1Port2SN2,_Board1Port3SN3,_Board1Port4SN4,
                   _Board1Port5SN5,_Board1Port6SN6,_Board1Port7SN7,_Board1Port8SN8,
                   _Board2Port1SN9,_Board2Port2SN10,_Board2Port3SN11,_Board2Port4SN12,
                   _Board2Port5SN13,_Board2Port6SN14,_Board2Port7SN15,_Board2Port8SN16,
                   _Board3Port1SN17,_Board3Port2SN18,_Board3Port3SN19,_Board3Port4SN20,
                   _Board4Port1SN21,_Board4Port2SN22,_Board4Port3SN23,_Board4Port4SN24,
                   _Board4Port5SN25,_Board4Port6SN26,_Board4Port7SN27,_Board4Port8SN28,
                   _Board5Port1SN29,_Board5Port2SN30,_Board5Port3SN31,_Board5Port4SN32,
                   _Board5Port5SN33,_Board5Port6SN34,_Board5Port7SN35,_Board5Port8SN36,
                   _Board6Port1SN37,_Board6Port2SN38,_Board6Port3SN39,_Board6Port4SN40,
                   _Board7Port1SN41,_Board7Port2SN42,_Board7Port3SN43,_Board7Port4SN44,
                   _Board7Port5SN45,_Board7Port6SN46,_Board7Port7SN47,_Board7Port8SN48,
                   _Board8Port1SN49,_Board8Port2SN50,_Board8Port3SN51,_Board8Port4SN52,
                   _Board8Port5SN53,_Board8Port6SN54,_Board8Port7SN55,_Board8Port8SN56,
                   _Board9Port1SN57,_Board9Port2SN58,_Board9Port3SN59,_Board9Port4SN60,
                   _Board10Port1SN61,_Board10Port2SN62,_Board10Port3SN63,_Board10Port4SN64,
                   _Board10Port5SN65,_Board10Port6SN66,_Board10Port7SN67,_Board10Port8SN68,
                   _Board11Port1SN69,_Board11Port2SN70,_Board11Port3SN71,_Board11Port4SN72,
                   _Board11Port5SN73,_Board11Port6SN74,_Board11Port7SN75,_Board11Port8SN76,
                   _Board12Port1SN77,_Board12Port2SN78,_Board12Port3SN79,_Board12Port4SN80,
                   _Board13Port1SN81,_Board13Port2SN82,_Board13Port3SN83,_Board13Port4SN84,
                   _Board13Port5SN85,_Board13Port6SN86,_Board13Port7SN87,_Board13Port8SN88,
                   _Board14Port1SN89,_Board14Port2SN90,_Board14Port3SN91,_Board14Port4SN92,
                   _Board14Port5SN93,_Board14Port6SN94,_Board14Port7SN95,_Board14Port8SN96,
                   _Board15Port1SN97,_Board15Port2SN98,_Board15Port3SN99,_Board15Port4SN100,
                   nil];
    arrDUTResultTextBoxs=[[NSArray alloc]initWithObjects:[[NSArray alloc]initWithObjects:_DUT1Current1,_DUT1Current2,_DUT1Current3,nil], [[NSArray alloc]initWithObjects:_DUT2Current1,_DUT2Current2,_DUT2Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT3Current1,_DUT3Current2,_DUT3Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT4Current1,_DUT4Current2,_DUT4Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT5Current1,_DUT5Current2,_DUT5Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT6Current1,_DUT6Current2,_DUT6Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT7Current1,_DUT7Current2,_DUT7Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT8Current1,_DUT8Current2,_DUT8Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT9Current1,_DUT9Current2,_DUT9Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT10Current1,_DUT10Current2,_DUT10Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT11Current1,_DUT11Current2,_DUT11Current3,nil], [[NSArray alloc]initWithObjects:_DUT12Current1,_DUT12Current2,_DUT12Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT13Current1,_DUT13Current2,_DUT13Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT14Current1,_DUT14Current2,_DUT14Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT15Current1,_DUT15Current2,_DUT15Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT16Current1,_DUT16Current2,_DUT16Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT17Current1,_DUT17Current2,_DUT17Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT18Current1,_DUT18Current2,_DUT18Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT19Current1,_DUT19Current2,_DUT19Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT20Current1,_DUT20Current2,_DUT20Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT21Current1,_DUT21Current2,_DUT21Current3,nil], [[NSArray alloc]initWithObjects:_DUT22Current1,_DUT22Current2,_DUT22Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT23Current1,_DUT23Current2,_DUT23Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT24Current1,_DUT24Current2,_DUT24Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT25Current1,_DUT25Current2,_DUT25Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT26Current1,_DUT26Current2,_DUT26Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT27Current1,_DUT27Current2,_DUT27Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT28Current1,_DUT28Current2,_DUT28Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT29Current1,_DUT29Current2,_DUT29Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT30Current1,_DUT30Current2,_DUT30Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT31Current1,_DUT31Current2,_DUT31Current3,nil], [[NSArray alloc]initWithObjects:_DUT32Current1,_DUT32Current2,_DUT32Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT33Current1,_DUT33Current2,_DUT33Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT34Current1,_DUT34Current2,_DUT34Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT35Current1,_DUT35Current2,_DUT35Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT36Current1,_DUT36Current2,_DUT36Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT37Current1,_DUT37Current2,_DUT37Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT38Current1,_DUT38Current2,_DUT38Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT39Current1,_DUT39Current2,_DUT39Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT40Current1,_DUT40Current2,_DUT40Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT41Current1,_DUT41Current2,_DUT41Current3,nil], [[NSArray alloc]initWithObjects:_DUT42Current1,_DUT42Current2,_DUT42Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT43Current1,_DUT43Current2,_DUT43Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT44Current1,_DUT44Current2,_DUT44Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT45Current1,_DUT45Current2,_DUT45Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT46Current1,_DUT46Current2,_DUT46Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT47Current1,_DUT47Current2,_DUT47Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT48Current1,_DUT48Current2,_DUT48Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT49Current1,_DUT49Current2,_DUT49Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT50Current1,_DUT50Current2,_DUT50Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT51Current1,_DUT51Current2,_DUT51Current3,nil], [[NSArray alloc]initWithObjects:_DUT52Current1,_DUT52Current2,_DUT52Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT53Current1,_DUT53Current2,_DUT53Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT54Current1,_DUT54Current2,_DUT54Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT55Current1,_DUT55Current2,_DUT55Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT56Current1,_DUT56Current2,_DUT56Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT57Current1,_DUT57Current2,_DUT57Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT58Current1,_DUT58Current2,_DUT58Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT59Current1,_DUT59Current2,_DUT59Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT60Current1,_DUT60Current2,_DUT60Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT61Current1,_DUT61Current2,_DUT61Current3,nil], [[NSArray alloc]initWithObjects:_DUT62Current1,_DUT62Current2,_DUT62Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT63Current1,_DUT63Current2,_DUT63Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT64Current1,_DUT64Current2,_DUT64Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT65Current1,_DUT65Current2,_DUT65Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT66Current1,_DUT66Current2,_DUT66Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT67Current1,_DUT67Current2,_DUT67Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT68Current1,_DUT68Current2,_DUT68Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT69Current1,_DUT69Current2,_DUT69Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT70Current1,_DUT70Current2,_DUT70Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT71Current1,_DUT71Current2,_DUT71Current3,nil], [[NSArray alloc]initWithObjects:_DUT72Current1,_DUT72Current2,_DUT72Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT73Current1,_DUT73Current2,_DUT73Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT74Current1,_DUT74Current2,_DUT74Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT75Current1,_DUT75Current2,_DUT75Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT76Current1,_DUT76Current2,_DUT76Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT77Current1,_DUT77Current2,_DUT77Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT78Current1,_DUT78Current2,_DUT78Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT79Current1,_DUT79Current2,_DUT79Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT80Current1,_DUT80Current2,_DUT80Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT81Current1,_DUT81Current2,_DUT81Current3,nil], [[NSArray alloc]initWithObjects:_DUT82Current1,_DUT82Current2,_DUT82Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT83Current1,_DUT83Current2,_DUT83Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT84Current1,_DUT84Current2,_DUT84Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT85Current1,_DUT85Current2,_DUT85Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT86Current1,_DUT86Current2,_DUT86Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT87Current1,_DUT87Current2,_DUT87Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT88Current1,_DUT88Current2,_DUT88Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT89Current1,_DUT89Current2,_DUT89Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT90Current1,_DUT90Current2,_DUT90Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT91Current1,_DUT91Current2,_DUT91Current3,nil], [[NSArray alloc]initWithObjects:_DUT92Current1,_DUT92Current2,_DUT92Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT93Current1,_DUT93Current2,_DUT93Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT94Current1,_DUT94Current2,_DUT94Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT95Current1,_DUT95Current2,_DUT95Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT96Current1,_DUT96Current2,_DUT96Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT97Current1,_DUT97Current2,_DUT97Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT98Current1,_DUT98Current2,_DUT98Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT99Current1,_DUT99Current2,_DUT99Current3,nil],
                          [[NSArray alloc]initWithObjects:_DUT100Current1,_DUT100Current2,_DUT100Current3,nil],
                          nil];
    scanPort = [[SerialNameScan alloc] init];
    m_Board = [[BoardController alloc]init];
    m_Log = [CSVLog Instance];
    PortIndex = 0;
    START = false;
    [self ScanPort];
    CurrentOfBlueUpper =2;
    CurrentOfGreenLower=2;
    CurrentOfGreenUpper=8;
    CurrentOfOrangeLower=8;
    CurrentOfOrangeUpper=100;
    CurrentOfWriteUpper =100;
    DUTCurrentCount=0;
    startone=1;
    for(int loopCount=0;loopCount<100;loopCount++){
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

   // [NSThread detachNewThreadSelector:@selector(AutoProcess) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(AutoProcess_GG) toTarget:self withObject:nil];
}

-(void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}

- (NSMutableArray*)ScanPort
{
    [scanPort scanPortName:@"/dev/cu.usbserial" needName:m_PortNameArray];
    usleep(500);
   //[BoardNum setStringValue:[NSString stringWithFormat:@"%lu",(unsigned long)m_PortNameArray.count]];
    return m_PortNameArray;
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
//For get the current

-(void)AutoProcess
{
LoopStart:
    while (!START) {
        usleep(20);
        startone=1;
        continue;
        
    }
    //NSString *sn[100];
    while (START) {
        
        
            if (!START) {
                goto LoopStart;
            }
            //NSString* string =@"";
            //现在是测试电压值了
            
            NSString*str_per=@"";
            NSString*str_v=@"";
            NSString*str_cs=@"";
            NSString*str_left_current=@"";
            NSString*str_left_per=@"";
            NSString*str_left_v=@"";
            
            NSString*str_right_current=@"";
            NSString*str_right_per=@"";
            NSString*str_right_v=@"";
            
            NSString*rece= [m_Board GetDutBATMAN:1 ];
            //NSString*rece= [m_Board GetDutBATMAN_DirectDUT];
            if([rece length]>90)
            {
                NSRange Range=NSMakeRange(18,3);
                str_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
                
                NSRange Range1=NSMakeRange(25,4);
                str_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range1]];
                
                NSRange Range2=NSMakeRange(33,2);
                str_cs = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range2]];
                
                NSRange Range3=NSMakeRange(38,3);
                str_left_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range3]];
                
                NSRange Range4=NSMakeRange(51,4);
                str_left_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range4]];
                
                NSRange Range5=NSMakeRange(58,4);
                str_left_current = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range5]];
                
                NSRange Range6=NSMakeRange(67,3);
                str_right_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range6]];
                
                NSRange Range7=NSMakeRange(80,4);
                str_right_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range7]];
                
                NSRange Range8=NSMakeRange(87,4);
                str_right_current = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range8]];
                
                NSString * strTime = [self CurrentTime];
                NSString *strdata =  [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",str_per,str_v,str_cs,str_left_v,str_left_per,str_left_current,str_right_per,str_right_v,str_right_current,strTime];
                [self SaveResult2File:strdata];
                
            }
            else {
                str_per = @"0";
                str_v = @"0";
                str_cs = @"0";
                
            }
            
            //              NSString *string =[NSString stringWithFormat:@"%@",[m_Board GetDutBATMAN:i]];
            
            //读取，显示SN
            sn[0] = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:1]];
            //usleep(200);
            
            [[[arrDUTResultTextBoxs objectAtIndex:0] objectAtIndex:0 ] setStringValue:@""];
            
            [[[arrDUTResultTextBoxs objectAtIndex:0] objectAtIndex:1 ] setStringValue:str_v];
            
            [[[arrDUTResultTextBoxs objectAtIndex:0] objectAtIndex:2 ] setStringValue:str_per];
            
            //usleep(200);
            [[arrSNTextBoxs objectAtIndex:0] setStringValue:sn[0]];
        //sleep(5);

    }
    goto LoopStart;
    
}


-(void)AutoProcess_work_OK20160317
{
LoopStart:
    while (!START) {
        usleep(20);
        startone=1;
        continue;
        
    }
    NSDate *StartTime=[NSDate date];
    while (START) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B235"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
        FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,FilePath];//写log文件路径，文件夹B235/yyyy-MM-dd.csv
        if (![m_Log IsExist:testDirectory isFolder:YES]) {
            [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![m_Log IsExist:FilePath isFolder:NO]) {
            NSString *string = @"Force Engine to GT AOI,Version: 9.1l20150930_1.5.1V-FGT-AOI-2\n";
            string=[string stringByAppendingString:@"Product,SerialNumber,Station ID,Test Pass/Fail Status,StartTime,EndTime,List Of Failing Tests,0,5,10,15,20,25,30,35,40,45,50,55,60,65\n"];
            string=[string stringByAppendingString:@"Display Name ----->\n"];
            string=[string stringByAppendingString:@"PDCA Priority ----->,,,,,,,0,0,0,0,0,0,0,0,0\n"];
            string=[string stringByAppendingString:@"Upper Limit ----->\n"];
            string=[string stringByAppendingString:@"Lower Limit ----->\n"];
            string=[string stringByAppendingString:@"Measurement Unit ----->,,,,,,,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA\n"];
            
            [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
        
        //获取SN值 一张板上有50个通道
        /*if(startone==1){
            for(int m=0;m<50;m++)
            {
                sn[m]=[NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:m+1]];//[[arrSNTextBoxs objectAtIndex:m] stringValue];
                [[arrSNTextBoxs objectAtIndex:m] setStringValue:sn[m]];
                if([sn[m] isEqualToString:@""]){
                    [m_Board GetDutSETLED:4 Com:m+1];
                }
            }
            startone=0;
        }*/
        bool bLogData=true; //false
        int loopCount=0;
        int xxx = [[NSDate date] timeIntervalSinceDate:StartTime];
        if(xxx>=5){
            bLogData=true;
            StartTime=[NSDate date];
            //data need be saved
            //continue;
        }
        
        //Open Com
        for (int j=0; j < 1;j++) //m_PortNameArray.count; j++)
        {
            //[m_Board Close];
            //usleep(2500);
            
            /*if([m_Board Open:[m_SavePortName objectAtIndex:j] andBaudRate:230400]){
                //[btnStart setEnabled:false];
            }*/
            [BoardIndex setStringValue:[NSString stringWithFormat:@"%d",j+1]];  //给控制板号为当前串口号
            int nport=50;//50个通道
//            if((j+1)%3==0){
//                nport=4;
//            }
            for (int i = 0; i < nport; i++) {
                if (!START) {
                    goto LoopStart;
                }
                NSString *sntemp=sn[loopCount];
                sn[loopCount] = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:i+1]];
                [[arrSNTextBoxs objectAtIndex:loopCount] setStringValue:sn[loopCount]];
                if([sn[loopCount] isEqualToString:@""]&&(![sntemp isEqualToString:sn[loopCount]])){
                    //Empty SN is not valid
                   [m_Board GetDutSETLED:6 Com:loopCount+1];
                    loopCount++;
                    continue;
                }
                NSString* string =@"";
//                NSString *str_current = [NSString stringWithFormat:@"%@",[m_Board ReadDI:i]];
//                usleep(200);
                
                //现在是测试电压值了
                
                NSString*str_per=@"";
                NSString*str_v=@"";
                NSString*str_cs=@"";
                NSString*str_left_current=@"";
                NSString*str_left_per=@"";
                NSString*str_left_v=@"";
                
                NSString*str_right_current=@"";
                NSString*str_right_per=@"";
                NSString*str_right_v=@"";
                
                
                
                NSString*rece= [m_Board GetDutBATMAN:i+1 ];
                if([rece length]>30)
                {
                    NSRange Range=NSMakeRange(18,3);
                    str_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
                    
                    NSRange Range1=NSMakeRange(25,4);
                    str_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range1]];
                    
                    NSRange Range2=NSMakeRange(33,2);
                    str_cs = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range2]];
                    
                    NSRange Range3=NSMakeRange(38,3);
                    str_left_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range3]];
                    
                    NSRange Range4=NSMakeRange(51,4);
                    str_left_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range4]];

                    NSRange Range5=NSMakeRange(58,4);
                    str_left_current = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range5]];

                    NSRange Range6=NSMakeRange(67,3);
                    str_right_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range6]];
                    
                    NSRange Range7=NSMakeRange(80,4);
                    str_right_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range7]];
                    
                    NSRange Range8=NSMakeRange(87,4);
                    str_right_current = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range8]];
                    
                    NSString * strTime = [self CurrentTime];
                    NSString *strdata =  [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",str_per,str_v,str_cs,str_left_v,str_left_per,str_left_current,str_right_per,str_right_v,str_right_current,strTime];
                    [self SaveResult2File:strdata];
                    //sleep(58);
                    
                }
                else {
                    str_per = @"0";
                    str_v = @"0";
                    str_cs = @"0";

                }
                
//              NSString *string =[NSString stringWithFormat:@"%@",[m_Board GetDutBATMAN:i]];
                
                //读取，显示SN already read out of loop
                //sn[loopCount] = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:i+1]];
                //usleep(200);
                
                [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:0 ] setStringValue:@""];
                
                [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:1 ] setStringValue:str_v];
                
                [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:2 ] setStringValue:str_per];
                
                //usleep(200);
                //[[arrSNTextBoxs objectAtIndex:loopCount] setStringValue:sn[loopCount]];
                
                if ([str_cs integerValue] == 2) {
                    
                    if ([str_per integerValue] <= 80 ) {
                        
                        [m_Board GetDutSETLED:2 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor orangeColor]];
                    }
                    if ([str_per integerValue] > 80&&[str_per integerValue] < 85 ) {
                        
                        [m_Board GetDutSETLED:3 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor greenColor]];

                    }
                    if ([str_per integerValue] >= 85) {
                        [m_Board DisCharging:i+1 ];
                        [m_Board GetDutSETLED:7 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor  yellowColor]];
                    }
                }
                else if ([str_cs integerValue] == 1) {
                    if ([str_per integerValue] == 100) {
                        [m_Board DisCharging:i+1 ];
                        [m_Board GetDutSETLED:7 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor  redColor]];
                    }
                    if ([str_per integerValue] > 80&&[str_per integerValue] < 85 ) {
                        
                        [m_Board GetDutSETLED:3 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor greenColor]];
                        
                    }
                    if ([str_per integerValue] <= 80 ) {
                        
                        [m_Board GetDutSETLED:0 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor brownColor]];
                    }
                }
                else if( ([str_cs integerValue] == 0) || ([str_cs integerValue] > 2) ) //不为充电状态
                {
                    [m_Board GetDutSETLED:0 Com:i+1];
                    str_per = @"0";
                    str_v = @"0";
                    str_cs = @"0";
                }
                
                if(![sn[loopCount] isEqualToString:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]])
                {
                    NSLog(@"Serial number in DUT%d changed!",loopCount+1);
                    if([[m_dictRecord allKeys] containsObject:sn[loopCount]]){
                        [m_dictRecord removeObjectForKey:sn[loopCount]];
                    }
                    if([[m_dictRecord allKeys] containsObject:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]]){
                        [m_dictRecord removeObjectForKey:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]];
                    }
                    sn[loopCount]=[[arrSNTextBoxs objectAtIndex:loopCount] stringValue];
                    
                }
                
                if([[m_dictRecord allKeys] containsObject:sn[loopCount]])
                {
                    if(bLogData){//only log data every 5 minutes
                    DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sn[loopCount]];
                    dr.index++;
                    if(dr.index<14 && dr.bFinished==false)
                    {//in a 5 minute loop, record data
                        [dr setValue:[str_per integerValue] forIdx:dr.index];
                        dr.EndTime=[self CurrentTime];
                    }
                    else if(dr.bFinished){
                        //already finished, do nothing
                    }
                    else{
                        //save result to csv log file
                        //string = [NSString stringWithFormat:@"%@,DUT%d,%@\n",[self CurrentTime],loopCount+1,string];
                        dr.EndTime=[self CurrentTime];
                        string=[NSString stringWithFormat:@"%@\n",[dr getDataString]];
                        
                        const char * serialname =[sn[loopCount] UTF8String];
                        
                        //PDCA add
                        NSLog(@"执行PDCA上传数据");
                        [[PoolPDCA Instance] AdjustPDCA:serialname strSWName:"InnorevSkunk-Test" str_SWVersion:"1.0.2" str_PDCAData:string];
                        
                        [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
                        dr.bFinished=true;
                    }
                    }
                }
                else{ //first time record
                    DataRecord *dr=[[DataRecord alloc]init];
                    dr.index=0;
                    dr.StartTime=[self CurrentTime];
                    dr.SN=sn[loopCount];
                    dr.product=@"B235";
                    dr.stationID=@"DEVELOPMENT17";
                    dr.bPass=false;
                    dr.bFinished=false;
                    dr.EndTime=@"";
                    [dr setValue:[string integerValue] forIdx:dr.index];
                    [m_dictRecord setObject:dr forKey:sn[loopCount]];
                    
                }
                //if (startone==1) {
                
                //}
                //string = [NSString stringWithFormat:@"%@\n",string];
                loopCount++;
            }
            [NSThread sleepForTimeInterval:1];
            TimeCount++;
            PortIndex++;
            //电流对比框向后写入
//            if (j== (m_PortNameArray.count - 1)) {
//                DUTCurrentCount++;
//                if (DUTCurrentCount > 2) {
//                    DUTCurrentCount = 0;
//                }
//            }
            startone=0;
            if (PortIndex >= m_PortNameArray.count) {
                PortIndex = 0;
            }
        }
    }
    goto LoopStart;
    
}

//new
-(void)AutoProcess_OldB235
{
LoopStart:
    while (!START) {
        usleep(20);
        startone=1;
        continue;
        
    }
    NSDate *StartTime=[NSDate date];
    while (START) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B235"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
        FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,FilePath];//写log文件路径，文件夹B235/yyyy-MM-dd.csv
        if (![m_Log IsExist:testDirectory isFolder:YES]) {
            [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![m_Log IsExist:FilePath isFolder:NO]) {
            NSString *string = @"Force Engine to GT AOI,Version: 9.1l20150930_1.5.1V-FGT-AOI-2\n";
            string=[string stringByAppendingString:@"Product,SerialNumber,Station ID,Test Pass/Fail Status,StartTime,EndTime,List Of Failing Tests,0,5,10,15,20,25,30,35,40,45,50,55,60,65\n"];
            string=[string stringByAppendingString:@"Display Name ----->\n"];
            string=[string stringByAppendingString:@"PDCA Priority ----->,,,,,,,0,0,0,0,0,0,0,0,0\n"];
            string=[string stringByAppendingString:@"Upper Limit ----->\n"];
            string=[string stringByAppendingString:@"Lower Limit ----->\n"];
            string=[string stringByAppendingString:@"Measurement Unit ----->,,,,,,,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA\n"];
            
            [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
        //NSString *sn[100];
        for(int m=0;m<100;m++)
        {
            sn[m]=[[arrSNTextBoxs objectAtIndex:m] stringValue];
        }
        int loopCount=0;
        
        int xxx = [[NSDate date] timeIntervalSinceDate:StartTime];
        if(xxx<10){
            
            continue;
        }
        else{
            StartTime=[NSDate date];
        }
        for (int j=0; j < m_PortNameArray.count; j++) {
            //[m_Board Close];
            usleep(2500);
            
            if([m_Board Open:[m_SavePortName objectAtIndex:j] andBaudRate:115200]){
                //[btnStart setEnabled:false];
            }
            [BoardIndex setStringValue:[NSString stringWithFormat:@"%d",j+1]];  //给控制板号为当前串口号
            int nport=8;
            if((j+1)%3==0){
                nport=4;
            }
            for (int i = 0; i < nport; i++) {
                if (!START) {
                    goto LoopStart;
                }
                NSString *string = [NSString stringWithFormat:@"%@",[m_Board ReadDI:(7-i)]];
                usleep(200);
                
                //读取，显示SN
                sn[loopCount] = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:(7-i)]];
                usleep(200);
                [[arrSNTextBoxs objectAtIndex:loopCount] setStringValue:sn[loopCount]];
                
                if ([string integerValue] == 0) {//字符串返回没有充电
                    [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor redColor]];
                }
                else if ([string integerValue] > 0 && [string integerValue] <= CurrentOfBlueUpper) {
                    [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor blueColor]];
                }
                else if ([string integerValue] > CurrentOfGreenLower && [string integerValue] <= CurrentOfGreenUpper  ){
                    [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue] > CurrentOfOrangeLower && [string integerValue] <= CurrentOfOrangeUpper  ){
                    [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor orangeColor]];
                }
                else if ([string integerValue] > CurrentOfWriteUpper ){
                    [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor whiteColor]];
                }
                
                [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:DUTCurrentCount ] setStringValue:string];
                
                if(![sn[loopCount] isEqualToString:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]])
                {
                    NSLog(@"Serial number in DUT%d changed!",loopCount+1);
                    if([[m_dictRecord allKeys] containsObject:sn[loopCount]]){
                        [m_dictRecord removeObjectForKey:sn[loopCount]];
                    }
                    if([[m_dictRecord allKeys] containsObject:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]]){
                        [m_dictRecord removeObjectForKey:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]];
                    }
                    sn[loopCount]=[[arrSNTextBoxs objectAtIndex:loopCount] stringValue];
                    
                }
                if([sn[loopCount] isEqualToString:@""]){//Empty SN is not valid
                    loopCount++;
                    continue;
                }
                if([[m_dictRecord allKeys] containsObject:sn[loopCount]])
                {
                    DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sn[loopCount]];
                    dr.index++;
                    if(dr.index<14 && dr.bFinished==false){//in a 5 minute loop, record data
                        [dr setValue:[string integerValue] forIdx:dr.index];
                        dr.EndTime=[self CurrentTime];
                    }
                    else if(dr.bFinished){
                        //already finished, do nothing
                    }
                    else{
                        //save result to csv log file
                        //string = [NSString stringWithFormat:@"%@,DUT%d,%@\n",[self CurrentTime],loopCount+1,string];
                        dr.EndTime=[self CurrentTime];
                        string=[NSString stringWithFormat:@"%@\n",[dr getDataString]];
                        
                        
                        //PDCA add
                        //1.需要生成 overlay版本
                        //
//                        struct structPDCA structtest;
//                        [[PoolPDCA Instance] setIsPDCAStart:NO];
//                        structtest.isNeedStart=YES;
//                        
//                        structtest.strSN = dr.SN;//
//                        structtest.strSoftName=@"123";
//                        structtest.strSoftVersion = @"456";
//                        structtest.strTestPoint= string;
//                        [[PoolPDCA Instance] PDCAStart:structtest];
                        
                        //文件写入PDCA
                        NSLog(@"执行PDCA上传数据");
                        [[PoolPDCA Instance] AdjustPDCA:"CC4RC2ZZG2RL" strSWName:"InnorevSkunk-Test" str_SWVersion:"1.0.2" str_PDCAData:string];
                        
                        [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
                        dr.bFinished=true;
                    }
                }
                else{ //first time record
                    DataRecord *dr=[[DataRecord alloc]init];
                    dr.index=0;
                    dr.StartTime=[self CurrentTime];
                    dr.SN=sn[loopCount];
                    dr.product=@"B222";
                    dr.stationID=@"FLDG_FQ3-3FT-02_1_AOI1";
                    dr.bPass=false;
                    dr.bFinished=false;
                    dr.EndTime=@"";
                    [dr setValue:[string integerValue] forIdx:dr.index];
                    [m_dictRecord setObject:dr forKey:sn[loopCount]];
                    
                }
                //if (startone==1) {
                
                //}
                //string = [NSString stringWithFormat:@"%@\n",string];
                loopCount++;
            }
            [NSThread sleepForTimeInterval:1];
            TimeCount++;
            PortIndex++;
            if (j== (m_PortNameArray.count - 1)) {
                DUTCurrentCount++;
                if (DUTCurrentCount > 2) {
                    DUTCurrentCount = 0;
                }
            }
            startone=0;
            if (PortIndex >= m_PortNameArray.count) {
                PortIndex = 0;
            }
        }
    }
    goto LoopStart;

}

-(void)AutoProcess_Threadtest
{
    while(START){
        for (int j=0; j < 1;j++) //m_PortNameArray.count; j++)
        {
            [BoardIndex setStringValue:[NSString stringWithFormat:@"%d",j+1]];  //给控制板号为当前串口号
            int nport=50;//50个通道
            //            if((j+1)%3==0){
            //                nport=4;
            //            }
            for (int i = 0; i < nport; i++) {
                [self testThread:i];
            }
        }
    }
}
-(void)AutoProcess_GG
{
    int avgCur[100],avgVolt[100],avgPer[100];
LoopStart:
    while (!START) {
        usleep(20);
        startone=1;
        continue;
        
    }
    NSDate *StartTime=[NSDate date];
    while (START) {
        
        //获取SN值 一张板上有50个通道
        /*if(startone==1){
         for(int m=0;m<50;m++)
         {
         sn[m]=[NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:m+1]];//[[arrSNTextBoxs objectAtIndex:m] stringValue];
         [[arrSNTextBoxs objectAtIndex:m] setStringValue:sn[m]];
         if([sn[m] isEqualToString:@""]){
         [m_Board GetDutSETLED:4 Com:m+1];
         }
         }
         startone=0;
         }*/
        bool bLogData=true; //false
        int loopCount=0;
        int xxx = [[NSDate date] timeIntervalSinceDate:StartTime];
        if(xxx>=5){
            bLogData=true;
            StartTime=[NSDate date];
            //data need be saved
            //continue;
        }
        
        //Open Com
        for (int j=0; j < 1;j++) //m_PortNameArray.count; j++)
        {
            [BoardIndex setStringValue:[NSString stringWithFormat:@"%d",j+1]];  //给控制板号为当前串口号
            int nport=50;//50个通道
            //            if((j+1)%3==0){
            //                nport=4;
            //            }
            for (int i = 0; i < nport; i++) {
                if (!START) {
                    goto LoopStart;
                }
                NSString *sntemp=sn[loopCount];
                sn[loopCount] = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:i+1]];
                [[arrSNTextBoxs objectAtIndex:loopCount] setStringValue:sn[loopCount]];
                if([sn[loopCount] isEqualToString:@""]){
                    //Empty SN is not valid
                    if(![sntemp isEqualToString:@""]){
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor whiteColor]];
                        [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:0] setStringValue:@""];
                        [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:1] setStringValue:@""];
                        [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:2] setStringValue:@""];
                       [m_Board GetDutSETLED:6 Com:loopCount+1];
                        
                    }
                    loopCount++;
                    continue;
                }
                //NSString* string =@"";
                //现在是用GG读出电压、电流和电量百分比值
                
                NSString*str_per=@"";
                NSString*str_v=@"";
                NSString*str_current=@"";
                NSString* strdata=@"";
                NSString*rece= [m_Board GetDutChargingStatus:i+1 ];
                if([rece length]>50)
                {
                    NSRange nsr;
                    nsr=[rece rangeOfString:@"gg-v="];
                    if(nsr.location!=NSNotFound){
                        str_v=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,4)];
                    }
                    else{
                        str_v=@"";
                    }
                    nsr=[rece rangeOfString:@"i="];
                    if(nsr.location!=NSNotFound){
                        str_current=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,4)];
                    }
                    else{
                        str_current=@"";
                    }
                    nsr=[rece rangeOfString:@"c="];
                    if(nsr.location!=NSNotFound){
                        str_per=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,3)];
                    }
                    else{
                        str_per=@"";
                    }
                    
                    //[self SaveResult2File:sn[loopCount] strdata];
                    //[self SaveResult2File:sn[loopCount] DataToSave:strdata];
                    
                }
                else {
                    str_per = @"0";
                    str_v = @"0";
                    str_current= @"0";
                    
                }
                
                // NSString *string =[NSString stringWithFormat:@"%@",[m_Board GetDutBATMAN:i]];
                
                //读取，显示SN already read out of loop
                //usleep(200);
                //[[arrSNTextBoxs objectAtIndex:loopCount] setStringValue:sn[loopCount]];
                avgCur[loopCount]+=[str_current integerValue];
                avgVolt[loopCount]+=[str_v integerValue];
                avgPer[loopCount]+=[str_per integerValue];
                if(DUTCurrentCount==2){
                    [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:0 ] setStringValue:[NSString stringWithFormat:@"%4d",avgCur[loopCount]/3]];
                    
                    [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:1 ] setStringValue:[NSString stringWithFormat:@"%4d",avgVolt[loopCount]/3]];
                    
                    [[[arrDUTResultTextBoxs objectAtIndex:loopCount] objectAtIndex:2 ] setStringValue:[NSString stringWithFormat:@"%4d",avgPer[loopCount]/3]];

                if ([str_current integerValue] > 0) {
                    
                    if (avgPer[loopCount]/3 < 80 ) {
                        
                        [m_Board GetDutSETLED:2 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor orangeColor]];
                    }
                    if ( (avgPer[loopCount]/3 >= 80)&& (avgPer[loopCount]/3  < 85) ) {
                        
                        [m_Board GetDutSETLED:3 Com:i+1];
                        if(avgPer[loopCount]/3 >= 83){
                            [m_Board DisCharging:i+1 ];
                        }
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor greenColor]];
                        
                    }
                    if (avgPer[loopCount]/3 >= 85) {
                        [m_Board DisCharging:i+1 ];
                        [m_Board GetDutSETLED:7 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor  yellowColor]];
                    }
                }
                else if ([str_current integerValue] == 0) {
                    if (avgPer[loopCount]/3 == 0) {
                        [m_Board GetDutSETLED:2 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor  orangeColor]];
                    }
                    else if ((avgPer[loopCount]/3 >= 80)&& (avgPer[loopCount]/3  < 85) ) {
                        
                        [m_Board GetDutSETLED:3 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor greenColor]];
                        
                    }
                    else if (avgPer[loopCount]/3 >= 85 ) {
                        
                        [m_Board GetDutSETLED:7 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor yellowColor]];
                        
                    }
                    else if ([str_per integerValue] < 80 ) {
                        
                        [m_Board GetDutSETLED:0 Com:i+1];
                        [[arrSNTextBoxs objectAtIndex:loopCount] setBackgroundColor:[NSColor brownColor]];
                    }
                }
                NSString * strTime = [self CurrentTime];
                strdata =  [NSString stringWithFormat:@"%@,%@,%@,%@,%@\n",sn[loopCount],strTime,str_current,str_v,str_per];
                NSLog(@"%@",strdata);
                if(![sn[loopCount] isEqualToString:@""]){
                    [self SaveResult2File:sn[loopCount] DataToSave:strdata];
                }
                    avgCur[loopCount]=0;
                    avgVolt[loopCount]=0;
                    avgPer[loopCount]=0;
                }
//                if(![sn[loopCount] isEqualToString:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]])
//                {
//                    NSLog(@"Serial number in DUT%d changed!",loopCount+1);
//                    /*
//                    if([[m_dictRecord allKeys] containsObject:sn[loopCount]]){
//                        [m_dictRecord removeObjectForKey:sn[loopCount]];
//                    }
//                    if([[m_dictRecord allKeys] containsObject:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]]){
//                        [m_dictRecord removeObjectForKey:[[arrSNTextBoxs objectAtIndex:loopCount] stringValue]];
//                    }
//                     */
//                    sn[loopCount]=[[arrSNTextBoxs objectAtIndex:loopCount] stringValue];
//                    
//                }
//                
//                if([[m_dictRecord allKeys] containsObject:sn[loopCount]])
//                {
//                    if(bLogData){//only log data every 5 minutes
//                        DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:sn[loopCount]];
//                        dr.index++;
//                        if(dr.index<14 && dr.bFinished==false)
//                        {//in a 5 minute loop, record data
//                            [dr setValue:[str_per integerValue] forIdx:dr.index];
//                            dr.EndTime=[self CurrentTime];
//                        }
//                        else if(dr.bFinished){
//                            //already finished, do nothing
//                        }
//                        else{
//                            //save result to csv log file
//                            //string = [NSString stringWithFormat:@"%@,DUT%d,%@\n",[self CurrentTime],loopCount+1,string];
//                            dr.EndTime=[self CurrentTime];
//                            string=[NSString stringWithFormat:@"%@\n",[dr getDataString]];
//                            
//                            const char * serialname =[sn[loopCount] UTF8String];
//                            
//                            //PDCA add
//                            NSLog(@"执行PDCA上传数据");
//                            [[PoolPDCA Instance] AdjustPDCA:serialname strSWName:"InnorevSkunk-Test" str_SWVersion:"1.0.2" str_PDCAData:string];
//                            
//                            //[m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
//                            dr.bFinished=true;
//                        }
//                    }
//                }
//                else{ //first time record
//                    DataRecord *dr=[[DataRecord alloc]init];
//                    dr.index=0;
//                    dr.StartTime=[self CurrentTime];
//                    dr.SN=sn[loopCount];
//                    dr.product=@"B235";
//                    dr.stationID=@"DEVELOPMENT17";
//                    dr.bPass=false;
//                    dr.bFinished=false;
//                    dr.EndTime=@"";
//                    [dr setValue:[string integerValue] forIdx:dr.index];
//                    [m_dictRecord setObject:dr forKey:sn[loopCount]];
//                    
//                }
                //if (startone==1) {
                
                //}
                //string = [NSString stringWithFormat:@"%@\n",string];
                loopCount++;
            }
            [NSThread sleepForTimeInterval:1];
            TimeCount++;
            PortIndex++;
            DUTCurrentCount++;
            if (DUTCurrentCount > 2) {
                  DUTCurrentCount = 0;
            }

            //电流对比框向后写入
            //            if (j== (m_PortNameArray.count - 1)) {
            //                DUTCurrentCount++;
            //                if (DUTCurrentCount > 2) {
            //                    DUTCurrentCount = 0;
            //                }
            //            }
            startone=0;
            if (PortIndex >= m_PortNameArray.count) {
                PortIndex = 0;
            }
        }
    }
    goto LoopStart;
    
}

-(void) singleloop:(NSInteger)portIndex{
    NSString *fsn=@"";
    //NSString* string =@"";
    //现在是测试电压值了
    
    NSString*str_per=@"";
    NSString*str_v=@"";
    NSString*str_current=@"";
    
    fsn=[m_Board GetDutSerialName:portIndex];
    
    NSString*rece= [m_Board GetDutChargingStatus:portIndex ];
    //NSString*rece= [m_Board GetDutBATMAN_DirectDUT];
   if([rece length]>50)
    {
        NSRange nsr;
        nsr=[rece rangeOfString:@"gg-v="];
        if(nsr.location!=NSNotFound){
            str_v=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,4)];
        }
        else{
            str_v=@"";
        }
        nsr=[rece rangeOfString:@"i="];
        if(nsr.location!=NSNotFound){
            str_current=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,4)];
        }
        else{
            str_current=@"";
        }
        nsr=[rece rangeOfString:@"c="];
        if(nsr.location!=NSNotFound){
            str_per=[rece substringWithRange: NSMakeRange(nsr.location+nsr.length,3)];
        }
        else{
            str_per=@"";
        }
        
        NSString * strTime = [self CurrentTime];
        NSString *strdata =  [NSString stringWithFormat:@"%@,%@,%@,%@\n",strTime,str_per,str_v,str_current];
        NSLog(@"%@",strdata);
        //[self SaveResult2File:strdata];
        
    }
    else {
        str_per = @"0";
        str_v = @"0";
        str_current= @"0";
        
    }
 
    
    //              NSString *string =[NSString stringWithFormat:@"%@",[m_Board GetDutBATMAN:i]];
    [[arrSNTextBoxs objectAtIndex:portIndex] setStringValue:fsn];
    
    [[[arrDUTResultTextBoxs objectAtIndex:portIndex] objectAtIndex:1 ] setStringValue:str_v];
    [[[arrDUTResultTextBoxs objectAtIndex:portIndex] objectAtIndex:2 ] setStringValue:str_per];
    [[[arrDUTResultTextBoxs objectAtIndex:portIndex] objectAtIndex:0 ] setStringValue:str_current];

}

- (IBAction)Start:(id)sender {
    
    [m_Board Open:[m_SavePortName objectAtIndex:0] andBaudRate:230400];
    
    for (int i=1; i<51; i++) {
        sn[i-1]=@"";
        [[arrSNTextBoxs objectAtIndex:i-1] setStringValue:@""];
        [m_Board GetDutSETLED:6 Com:i]; //LED off
    }
    START = true;
//    NSLog(@"Start 100 loops");
//    NSDate *StartTime=[NSDate date];
//    
//    for(int i=0;i<100;i++){
//        [self singleloop:27];
//    }
//    int xxx = [[NSDate date] timeIntervalSinceDate:StartTime];
//    NSLog(@"total loop time:%d",xxx);
    //[btnStart setEnabled:false];

    //[self ScanPort];
    
    
    /*NSString * Fsn;
    //读取，显示SN
    Fsn = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:2]];
    //usleep(200);
    
    [[[arrDUTResultTextBoxs objectAtIndex:0] objectAtIndex:0 ] setStringValue:@""];
    

    
    //usleep(200);
    [[arrSNTextBoxs objectAtIndex:0] setStringValue:Fsn];

    
     NSLog(@"Start 100 loops");
     NSDate *StartTime=[NSDate date];
     
     for(int i=0;i<100;i++){
     [self singleloop];
     }
     int xxx = [[NSDate date] timeIntervalSinceDate:StartTime];
     NSLog(@"total loop time:%d",xxx);
     */
    //test b235
    //    for(int j=0;j<100;j++)
    //    {
    //        [self testThread:j];
    //    }
//    NSString* str_per;
//    NSString*str_v;
//    NSString*str_cs;
//    NSString*rece= [m_Board GetDutBATMAN:2 ];
//    NSRange Range=NSMakeRange(16,4);
//    str_per = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range]];
//    
//    NSRange Range1=NSMakeRange(23,4);
//    str_v = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range1]];
//    
//    NSRange Range2=NSMakeRange(31,2);
//    str_cs = [NSString stringWithFormat:@"%@",[rece substringWithRange:Range2]];
//
    
}

- (IBAction)Start_PDCATest:(id)sender {
    
    
//    [self ScanPort];
//    START = true;
    
    //test b235
//    for(int j=0;j<100;j++)
//    {
//        [self testThread:j];
//    }
    
    NSString *string = [NSString stringWithFormat:@"%@",[m_Board GetDutSerialName:1]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsDirectory  =@"/vault/log";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B235"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
    FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,FilePath];//写log文件路径，文件夹B235/yyyy-MM-dd.csv
    if (![m_Log IsExist:testDirectory isFolder:YES]) {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![m_Log IsExist:FilePath isFolder:NO]) {
        NSString *string = @"Force Engine to GT AOI,Version: 9.1l20150930_1.5.1V-FGT-AOI-2\n";
        string=[string stringByAppendingString:@"Product,SerialNumber,Station ID,Test Pass/Fail Status,StartTime,EndTime,List Of Failing Tests,0,5,10,15,20,25,30,35,40,45,50,55,60,65\n"];
        string=[string stringByAppendingString:@"Display Name ----->\n"];
        string=[string stringByAppendingString:@"PDCA Priority ----->,,,,,,,0,0,0,0,0,0,0,0,0\n"];
        string=[string stringByAppendingString:@"Upper Limit ----->\n"];
        string=[string stringByAppendingString:@"Lower Limit ----->\n"];
        string=[string stringByAppendingString:@"Measurement Unit ----->,,,,,,,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA,mA\n"];
        
        [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
    for(int j=0; j<10;j++)
    {
        [m_dictRecord setObject:[[DataRecord alloc]init] forKey:[NSString stringWithFormat:@"CC4RC2%d%dG2RL",j,j]];
        DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:[NSString stringWithFormat:@"CC4RC2%d%dG2RL",j,j]];
        for(int i=0;i<14;i++)
        {
            dr.index=i;
            dr.SN=[NSString stringWithFormat:@"CC4RC2%d%dG2RL",j,j];
            [dr setValue:i*j forIdx:dr.index];
        }
        NSLog(@"%@",[(DataRecord *)[m_dictRecord objectForKey:[NSString stringWithFormat:@"CC4RC2%d%dG2RL",j,j]] getDataString]);
        NSString *string=[NSString stringWithFormat:@"%@\n", [(DataRecord *)[m_dictRecord objectForKey:[NSString stringWithFormat:@"CC4RC2%d%dG2RL",j,j]] getDataString]];
        [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        
//
//        //1.需要生成 overlay版本
//        
        // Start IP uut and add test station parameters
        struct structPDCA structtest;
        [[PoolPDCA Instance] setIsPDCAStart:NO];
        structtest.isNeedStart=YES;
        
        structtest.strSN = dr.SN;//
        structtest.strSN=@"CC4RC2ZZG2RL";
        structtest.strSoftName=@"1.0.2";
        structtest.strSoftVersion = @"InnorevB235";
        structtest.strTestPoint= string;
////        [[PoolPDCA Instance] PDCAStart:structtest];
////        
////        // ------Check Bobcat -------上一步已经完成
////       
////        [[PoolPDCA Instance] WritePoolResultItemPDCA:structtest.strSN andValue:structtest.strSoftVersion str_PDCA:string];
//
//        //可以工作
        [[PoolPDCA Instance] AdjustPDCA:"CC4RC2ZZG2RL" strSWName:"InnorevSkunk-Test" str_SWVersion:"1.0.2" str_PDCAData:structtest.strTestPoint];
    
        
        
        

//        NSString * strOK=@"";
//        strOK=[[PoolPDCA Instance] PDCA_GetStationID];
//        NSRunAlertPanel(@"Error",strOK, @"OK", nil, nil);
        
      

        
    }

    //                NSRunAlertPanel(@"Error", @"危险！X、Y过于接近", @"OK", nil, nil);
    
}


- (IBAction)Start_1:(id)sender {
    //[self ScanPort];
    //START = true;
    for(int j=0; j<100;j++){
        [m_dictRecord setObject:[[DataRecord alloc]init] forKey:[NSString stringWithFormat:@"SN%d",j]];
        DataRecord *dr=(DataRecord *)[m_dictRecord objectForKey:[NSString stringWithFormat:@"SN%d",j]];
        for(int i=0;i<14;i++)
        {
            dr.index=i;
            [dr setValue:i*j forIdx:dr.index];
        }
        NSLog(@"%d,SN%d,%@",j,j,[(DataRecord *)[m_dictRecord objectForKey:[NSString stringWithFormat:@"SN%d",j]] getDataString]);
    }
    /*
    DataRecord *dr=[[DataRecord alloc]init];
    for(int i=0;i<14;i++)
    {
        dr.index=i;
        [dr setValue:i forIdx:dr.index];
    }
     */
    
}

- (IBAction)Stop:(id)sender {
    START = false;

}



- (void) testThread:(NSInteger) portNum{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block NSString *ss=nil;
        dispatch_sync(concurrentQueue, ^{
            /* Below is just a sample to get a string, we can replace with uart read later*/
            //usleep(2000000/(portNum+1));
            //ss= [NSString stringWithFormat:@"thread--%ld",(long)portNum];
            ss=[m_Board GetDutSerialName:portNum+1];
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            /* Show the result to the user here on the main queue*/
            if (ss != nil){
                [[arrSNTextBoxs objectAtIndex:portNum] setStringValue:ss];
                
            } else {
                NSLog(@"Thread Error.");
            }
        });
    });
}

- (void) SaveResult2File:(NSString*)sdata
{
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
    NSString *documentsDirectory = @"/vault";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B235_GG_Data"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
    FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,FilePath];//写log文件路径，文件夹B235/yyyy-MM-dd.csv
    if (![m_Log IsExist:testDirectory isFolder:YES]) {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![m_Log IsExist:FilePath isFolder:NO]) {
        NSString *string = @"序列号，日期时间,电流,电压,充电百分比\n";
        
        [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
    [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:sdata IsAppend:YES];
    
}


//song 保存输出结果
- (void) SaveResult2File:(NSString *)serialNumber DataToSave:(NSString*)sdata
{

    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
    NSString *documentsDirectory = @"/vault";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B235_GG_Data"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
    //FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,FilePath];//写log文件路径，文件夹B235/yyyy-MM-dd.csv
    if (![m_Log IsExist:testDirectory isFolder:YES]) {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[testDirectory stringByAppendingPathComponent:FilePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else{
        if(![m_Log IsExist:[testDirectory stringByAppendingPathComponent:FilePath] isFolder:YES])
            [fileManager createDirectoryAtPath:[testDirectory stringByAppendingPathComponent:FilePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    testDirectory=[testDirectory stringByAppendingPathComponent:FilePath];
    FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,serialNumber];//写log文件路径，文件夹B235/yyyy-MM-dd/serialNumber.csv
    if (![m_Log IsExist:FilePath isFolder:NO]) {
        NSString *string = @"SerialNumber,DateTime,Current,Voltage,Percentage\n";

        [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
    [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:sdata IsAppend:YES];

}




@end
