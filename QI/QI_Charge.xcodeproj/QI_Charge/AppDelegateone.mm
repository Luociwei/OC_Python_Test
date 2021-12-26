//
//  AppDelegate.m
//  Electricity Recorder
//
//  Created by ydhuang on 15-9-16.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [window setDelegate:self];
    m_PortNameArray = [[NSMutableArray alloc]init];
    m_SavePortName = [[NSArray alloc]initWithObjects:
                      @"/dev/cu.usbserial-FIX-01",@"/dev/cu.usbserial-FIX-02",
                      @"/dev/cu.usbserial-FIX-03",@"/dev/cu.usbserial-FIX-04",
                      @"/dev/cu.usbserial-FIX-05",@"/dev/cu.usbserial-FIX-06",
                      @"/dev/cu.usbserial-FIX-07",@"/dev/cu.usbserial-FIX-08",
                      @"/dev/cu.usbserial-FIX-09",@"/dev/cu.usbserial-FIX-10",
                      @"/dev/cu.usbserial-FIX-11",@"/dev/cu.usbserial-FIX-12",
                      @"/dev/cu.usbserial-FIX-13",nil];
    scanPort = [[SerialNameScan alloc] init];
    m_Board = [[BoardController alloc]init];
    m_Log = [CSVLog Instance];
    PortIndex = 0;
    START = false;
    [self ScanPort];
    
    [NSThread detachNewThreadSelector:@selector(AutoProcess) toTarget:self withObject:nil];
}
-(void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}
- (NSMutableArray*)ScanPort
{
    [scanPort scanPortName:@"/dev/cu.usbserial" needName:m_PortNameArray];
    usleep(500);
    [BoardNum setStringValue:[NSString stringWithFormat:@"%lu",(unsigned long)m_PortNameArray.count]];
    return m_PortNameArray;
}
- (void)AutoProcess
{
LoopStart:
    while (!START) {
        usleep(20);
        continue;
    }
    while(START){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //返回一个绝对路径用来存放我们需要储存的文件,为每一个应用程序生成一个私有目录，所以通常使用Documents目录进行数据持久化的保存，而这个Documents目录可以通过：NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserdomainMask，YES) 得到。
    NSString *documentsDirectory = [paths objectAtIndex:0];
        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"B235"];
    for(int j = 0;j < m_PortNameArray.count;j++)//循环检测操作所有的端口
    {
        [m_Board Close];
        usleep(20000);
        if([m_Board Open:[m_SavePortName objectAtIndex:j] andBaudRate:115200]){
            //[btnStart setEnabled:false];
        }
        [BoardIndex setStringValue:[NSString stringWithFormat:@"%d",j+1]];  //给控制板号为当前串口号
    for(int i = 0;i < 13;i++)//依次检测当前控制板状态，13个控制板对应哪一个
    {
        if (!START) {
            goto LoopStart;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* FilePath = [dateFormatter stringFromDate:[NSDate date]];
        FilePath = [NSString stringWithFormat:@"%@/%@.csv",testDirectory,FilePath];//写log文件路径，文件夹B235/yyyy-MM-dd.csv
        if (![m_Log IsExist:testDirectory isFolder:YES]) {
            [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![m_Log IsExist:FilePath isFolder:NO]) {
            NSString *string = @"Time,Port Name,Electricity\n";
            [fileManager createFileAtPath:FilePath contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
//        NSString *string = [NSString stringWithFormat:@"%@,",[m_Board ReadDI:j*8+i]];
        NSString *string = [NSString stringWithFormat:@"%@,",[m_Board ReadDI:i]];
        usleep(200);
        if(j == 0){
            [m_Tab selectTabViewItemAtIndex:0];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board1Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity1 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board1Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity2 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board1Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity3 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board1Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity4 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board1Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity5 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board1Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity6 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board1Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity7 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board1Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board1Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board1Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity8 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==1){
            [m_Tab selectTabViewItemAtIndex:1];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board2Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity9 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board2Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity10 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board2Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity11 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board2Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity12 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board2Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity13 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board2Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity14 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board2Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity15 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board2Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board2Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board2Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity16 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j == 2){
            [m_Tab selectTabViewItemAtIndex:2];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board3Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity17 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board3Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity18 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board3Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity19 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board3Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity20 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board3Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity21 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board3Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity22 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board3Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity23 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board3Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board3Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board3Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity24 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==3){
            [m_Tab selectTabViewItemAtIndex:3];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board4Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity25 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board4Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity26 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board4Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity27 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board4Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity28 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board4Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity29 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board4Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity30 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board4Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity31 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board4Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board4Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board4Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity32 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==4){
            [m_Tab selectTabViewItemAtIndex:4];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board5Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity33 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board5Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity34 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board5Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity35 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board5Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity36 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board5Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity37 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board5Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity38 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board5Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity39 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board5Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board5Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board5Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity40 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==5){
            [m_Tab selectTabViewItemAtIndex:5];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board6Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity41 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board6Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity42 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board6Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity43 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board6Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity44 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board6Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity45 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board6Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity46 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board6Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity47 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board6Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board6Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board6Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity48 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==6){
            [m_Tab selectTabViewItemAtIndex:6];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board7Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity49 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board7Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity50 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board7Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity51 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board7Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity52 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board7Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity53 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board7Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity54 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board7Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity55 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board7Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board7Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board7Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity56 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==7){
            [m_Tab selectTabViewItemAtIndex:7];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board8Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity57 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board8Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity58 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board8Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity59 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board8Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity60 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board8Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity61 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board8Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity62 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board8Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity63 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board8Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board8Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board8Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity64 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==8){
            [m_Tab selectTabViewItemAtIndex:8];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board9Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity65 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board9Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity66 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board9Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity67 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board9Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity68 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board9Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity69 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board9Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity70 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board9Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity71 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board9Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board9Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board9Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity72 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==9){
            [m_Tab selectTabViewItemAtIndex:9];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board10Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity73 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board10Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity74 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board10Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity75 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board10Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity76 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board10Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity77 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board10Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity78 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board10Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity79 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board10Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board10Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board10Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity80 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==10){
            [m_Tab selectTabViewItemAtIndex:10];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board11Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity81 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board11Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity82 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board11Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity83 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board11Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity84 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board11Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity85 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board11Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity86 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board11Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity87 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board11Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board11Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board11Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity88 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==11){
            [m_Tab selectTabViewItemAtIndex:11];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board12Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity89 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board12Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity90 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board12Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity91 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board12Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity92 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board12Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity93 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board12Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity94 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board12Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity95 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board12Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board12Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board12Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity96 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==12){
            [m_Tab selectTabViewItemAtIndex:12];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board13Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity97 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board13Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity98 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board13Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity99 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board13Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity100 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board13Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity101 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board13Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity102 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board13Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity103 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board13Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board13Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board13Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity104 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==13){
            [m_Tab selectTabViewItemAtIndex:13];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board14Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity105 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board14Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity106 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board14Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity107 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board14Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity108 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board14Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity109 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board14Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity110 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board14Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity111 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board14Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board14Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board14Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity112 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==14){
            [m_Tab selectTabViewItemAtIndex:14];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board15Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity113 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board15Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity114 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board15Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity115 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board15Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity116 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board15Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity117 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board15Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity118 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board15Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity119 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board15Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board15Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board15Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity120 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        else if(j==15){
            [m_Tab selectTabViewItemAtIndex:15];
            if (i == 0) {
                if ([string integerValue]==0) {
                    [Board16Port1Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port1Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port1Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity121 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+1),string];
            }
            else if (i == 1) {
                if ([string integerValue]==0) {
                    [Board16Port2Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port2Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port2Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity122 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+2),string];
            }
            else if (i == 2) {
                if ([string integerValue]==0) {
                    [Board16Port3Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port3Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port3Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity123 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+3),string];
            }
            else if (i == 3) {
                if ([string integerValue]==0) {
                    [Board16Port4Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port4Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port4Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity124 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+4),string];
            }
            else if (i == 4) {
                if ([string integerValue]==0) {
                    [Board16Port5Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port5Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port5Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity125 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+5),string];
            }
            else if (i == 5) {
                if ([string integerValue]==0) {
                    [Board16Port6Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port6Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port6Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity126 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+6),string];
            }
            else if (i == 6) {
                if ([string integerValue]==0) {
                    [Board16Port7Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port7Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port7Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity127 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+7),string];
            }
            else if (i == 7) {
                if ([string integerValue]==0) {
                    [Board16Port8Color setBackgroundColor:[NSColor whiteColor]];
                }
                else if ([string integerValue]<=80){
                    [Board16Port8Color setBackgroundColor:[NSColor greenColor]];
                }
                else if ([string integerValue]>80){
                    [Board16Port8Color setBackgroundColor:[NSColor redColor]];
                }
                [Electricity128 setStringValue:string];
                string = [NSString stringWithFormat:@"%lds,Slot%ld,%@\n",(long)TimeCount,(long)(PortIndex*8+8),string];
            }
            [m_Log WriteFile:testDirectory andFullPath:FilePath andContent:string IsAppend:YES];
        }
        string = @"";
    }
    [NSThread sleepForTimeInterval:1];
    TimeCount++;
        PortIndex++;
        if (PortIndex >=m_PortNameArray.count) {
            PortIndex = 0;
        }
    }
    }
    goto LoopStart;
}
- (IBAction)Start:(id)sender
{
    START = true;
}
- (IBAction)Stop:(id)sender
{
    START = false;
}
- (IBAction)Refresh:(id)sender
{
    [self ScanPort];
}
@end
