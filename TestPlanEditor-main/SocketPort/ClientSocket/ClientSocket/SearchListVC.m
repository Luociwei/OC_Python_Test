//
//  SearchListVC.m
//  ClientSocket
//
//  Created by ciwei luo on 2020/3/11.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "SearchListVC.h"
#import "HWIOMode.h"
#import <CWGeneralManager/CWFileManager.h>
#import "RegexKitLite.h"

@interface SearchListVC ()
@property (nonatomic,strong)NSMutableArray *cellArray;
@property (nonatomic,strong)NSMutableArray *cellArray_Current;
@property (nonatomic,strong)NSMutableArray *cellArray_Frequence;
@property (copy)NSArray *searchArrVoltage;
@property (weak) IBOutlet NSSearchField *searchBtn;
@property (weak) IBOutlet NSTableView *cmdControll_AIList;

@end

@implementation SearchListVC{
    NSString *gainValue;
    NSString *nameAIMeas;
    NSString *nameAIUnit;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.cellArray = [[NSMutableArray alloc]init];
    self.cellArray_Current = [[NSMutableArray alloc]init];
    self.cellArray_Frequence = [[NSMutableArray alloc]init];
    //[self loadHwioTableFile];
    [self loadHwioTableFile:self.file];
    [self.cmdControll_AIList setTarget:self];
    [self.cmdControll_AIList setDoubleAction:@selector(doubleClickOnTableView:)];
    [self.cmdControll_AIList setAction:@selector(signelClickOnTableView:)];
}


-(int)loadHwioTableFile:(NSString *)fileName
{
    NSString *luapath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    NSString * luaCont = [NSString stringWithContentsOfFile:luapath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *arrayCont = [luaCont componentsSeparatedByString:@"\n"];
    
    NSString *pattern0 = @"CH\\s*=";
    NSRegularExpression *regular0 = [[NSRegularExpression alloc] initWithPattern:pattern0 options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSString *str in arrayCont)
    {
        if (str)
        {
            NSString *mutStr1 =  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([mutStr1 length] >3 &&[mutStr1 isNotEqualTo:@""])
            {
                if ([[mutStr1 substringWithRange:NSMakeRange(0, 2)] isNotEqualTo:@"--"] && ![mutStr1 containsString:@"HWIO.critical"] &&![mutStr1 containsString:@"HWIO.MeasureTable"] && ![mutStr1 containsString:@"HWIO.RelayTable"])
                {
                    
                    NSString *pattern = @"IO\\s*=";
                    //1.1将正则表达式设置为OC规则
                    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
                    //2.利用规则测试字符串获取匹配结果
                    NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, mutStr1.length)];
                   
                    
                    if (results.count)
                    {
                        //[cellArray addObject:[NSString stringWithFormat:@"%@ %@",nameItem,str]];
                        NSArray *results0 = [regular0 matchesInString:mutStr1 options:0 range:NSMakeRange(0, mutStr1.length)];
                        NSString *mutStr2 = [mutStr1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if (results0.count)
                        {
                            if ([fileName isEqualToString:@"HWIO_Voltage.lua"] || [fileName isEqualToString:@"HWIO_Current.lua"] || [fileName isEqualToString:@"HWIO_Frequency.lua"])
                            {
                                [self.cellArray addObject:[self setHWIOModeAIWithStr:mutStr2]];
                            }
//                            else if([fileName isEqualToString:@"HWIO_Current.lua"])
//                            {
//                                [self.cellArray_Current addObject:[self setHWIOModeAIWithStr:mutStr2]];
//                            }
//                            else if([fileName isEqualToString:@"HWIO_Frequency.lua"])
//                            {
//                                [self.cellArray_Frequence addObject:[self setHWIOModeAIWithStr:mutStr2]];
//                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    return 0;
}

//-(void)loadHwioTableFile
//{
//    [self.cellArray_Voltage removeAllObjects];
//    NSArray *arr = [CWFileManager cw_serializationInMainBundleFile:@"HWIO_Socpe.json"];
//    for (NSDictionary *dic in arr) {
//        HWIOModeAI *mode = [[HWIOModeAI alloc]init];
//        mode.itemname = dic[@"itemname"];
//        mode.iovalue = dic[@"iovalue"];
//        mode.channel = dic[@"channel"];
//        mode.fullname = dic[@"fullname"];
//        mode.gain = dic[@"gain"];
//        mode.unit = dic[@"unit"];
//        mode.gnd = dic[@"gnd"];
//        mode.range = dic[@"range"];
//        [self.cellArray_Voltage addObject:mode];
//
//    }
//
//    [self.cmdControll_AIList reloadData];
//
//}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    
   
    NSInteger count = self.searchArrVoltage.count ? :self.cellArray.count;
    return count;
    
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    
    return YES;
}


#pragma mark- NSTableViewDelegate
-(void)doubleClickOnTableView:(id)sender
{

    NSString *cmds = [self getCommand];
    if (self.delegate && [self.delegate respondsToSelector:@selector(SearchListDoubleClick:)]&& cmds.length) {
        [self.delegate SearchListDoubleClick:cmds];
    }
    //[self btSend:nil];
}
// "PP0V775_S2_AOP\t\t\t\t \t\t= {  IO = { { 41, 1 }, { 42, 0 }, { 48, 0 }, { 45, 1 }, { 126, 0 }, { 125, 0 }, { 30, 0 },{ 124, 0 },{ 123, 0 }, { 122, 0 } }, CH = \"AI1\", GND = \"DUT\" ,GAIN = 1,range = \"5V\"},"
-(void)signelClickOnTableView:(id)sender{

    NSString *cmds = [self getCommand];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SearchListSignelClick:)] && cmds.length) {
        [self.delegate SearchListSignelClick:cmds];
    }
    //[self btSend:nil];
}

-(NSString *)getCommand{
    NSInteger row = [self.cmdControll_AIList selectedRow];
    if (row<0) return nil;
    
    NSArray *array = self.searchArrVoltage.count ? self.searchArrVoltage : self.cellArray;
    HWIOModeAI *mode =[array objectAtIndex:row];
    NSString *string = mode.fullname;
    gainValue = mode.gain;
    nameAIMeas = mode.itemname;
    nameAIUnit = @"mV";
    NSString *name = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *cmds =[self cmdRealyIO:mode];
    return cmds;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //NSLog(@"---NSTableViewDelegate--");
    //根据表格列的标识,创建单元视图
    
    NSView *view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSArray *subviews = [view subviews];
    NSTextField *textField = subviews[0];
    //更新单元格的文本
    //        NSArray *array = self.searchArrVoltage.count ? self.searchArrVoltage : cellArray_Voltage;
    NSArray *array = self.searchArrVoltage.count ? self.searchArrVoltage : self.cellArray;
    HWIOModeAI *mode =[array objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"HWIO_Name"])
    {
        
        textField.stringValue = mode.itemname;
    }
    else if([tableColumn.identifier isEqualToString:@"HWIO_Vaule"])
    {
        
        textField.stringValue = mode.iovalue;
        
        
    }
    else if([tableColumn.identifier isEqualToString:@"HWIO_GAIN"])
    {//HWIO_GAIN
        textField.stringValue = mode.gain;
    }
    return view;
    
    
}




- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *textF=obj.object;
    if (textF == self.searchBtn) {
        NSString *string = [textF stringValue];
        [self searchListWithCharacter:string];
    }

    
}
- (void)searchFieldDidEndSearching:(NSSearchField *)sender NS_AVAILABLE_MAC(10_11){
   //self.searchArrAI=nil;
    self.searchArrVoltage=nil;
    [self.cmdControll_AIList reloadData];

    
}

-(void)searchListWithCharacter:(NSString *)character{
    if (character.length<=3) {
        return;
    }
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (HWIOModeAI *mode in self.cellArray) {
        if ([mode.fullname containsString:character.uppercaseString]) {
            [mutArr addObject:mode];
        }
    }
    self.searchArrVoltage = mutArr;
    [self.cmdControll_AIList reloadData];
}

-(NSString *) channel_number:(NSString *)ch
{
    NSString* temp =@"";
    if ([ch isEqualToString:@"AI1"])
    {
        temp = @"A";
    }
    else if ([ch isEqualToString:@"AI2"])
    {
        temp = @"B";
    }
    else if ([ch isEqualToString:@"AI3"])
    {
        temp = @"C";
    }
    else if ([ch isEqualToString:@"AI4"])
    {
        temp = @"D";
    }
    else if ([ch isEqualToString:@"AI5"])
    {
        temp = @"E";
    }
    else if ([ch isEqualToString:@"AI6"])
    {
        temp = @"F";
    }
    else if ([ch isEqualToString:@"AI7"])
    {
        temp = @"G";
    }
    else
    {
        temp = @"H";
    }
    
    return temp;
}

-(NSString *)aiCommand:(NSString *)ch
{
    NSString * option = @"nor";
    NSString * channel = [self channel_number:ch];
    NSString * adc_range = @"10V";
    int sample_rate = 10000;
    int count = 1;
    int measue_time = 150;
    
    NSString *cmd = [NSString stringWithFormat:@"[444555666]adc read(%@,%@,%@,%d,%d,%d)",option,channel,adc_range,sample_rate,count,measue_time];
    return cmd;
    
}
-(NSString *)convertCmd:(NSArray *)arrayIO with:(NSString *)ioname
{
    NSMutableString *cmd = [[NSMutableString alloc] initWithString:@""];
    for (NSString *sub in arrayIO)
    {
        NSArray *s = [sub componentsSeparatedByString:@","];
        if ([s count]>1)
        {
            NSString *io = [s[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *status = [s[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [cmd appendString:[NSString stringWithFormat:@"bit%@=%@,",io,status]];
        }
        
    }
    NSString *cmdIO =[NSString stringWithFormat:@"[123]%@(%zd,%@,,)",ioname,[arrayIO count],cmd];
    cmdIO = [cmdIO stringByReplacingOccurrencesOfString:@",,," withString:@""];
 
    return cmdIO;
}
-(NSString *)frequenceCommand
{
    
    int door_v = 300;
    NSString *cmd = [NSString stringWithFormat:@"[444555666]frequency measure(-fdv,%d,200)",door_v];
    return cmd;
}

-(NSString *) cmdRealyIO:(HWIOModeAI *)modeAI
{
    NSString *str = modeAI.fullname;
    //NSLog(@"==>> %@",str);
    NSString *pattern = @"[0-9]+\\s*,\\s*[0-9]+";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    NSMutableArray *arrayIO = [[NSMutableArray alloc]init];
    for (NSTextCheckingResult *result in results)
    {
        //NSLog(@"==> %@",[str substringWithRange:result.range]);
        [arrayIO addObject:[str substringWithRange:result.range]];
    }
    if ( [arrayIO count] == 0)
    {
//        [regular release];
//        [arrayIO release];
        return @"click is wrong!!!";
    }
    
    NSString *pattern0 = @"CH\\s*=";
    NSRegularExpression *regular0 = [[NSRegularExpression alloc] initWithPattern:pattern0 options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results0 = [regular0 matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    if (results0.count)
    {
        //for AI measurement

        NSString *matchedStr1 = modeAI.iovalue;
        //NSLog(@"%@    | %@   |   %@",matchedStr1,matchedStr2,matchedStr3);
        NSArray *results1=nil;
        if (matchedStr1.length) {
            results1 = [regular matchesInString:matchedStr1 options:0 range:NSMakeRange(0, matchedStr1.length)];
        }
        NSString *results4 = modeAI.channel;
        NSMutableString *cmdIO = [[NSMutableString alloc]initWithString:@""];
       
        if (results1.count) {
            if (arrayIO)
            {
                [arrayIO removeAllObjects];
            }
            for (NSTextCheckingResult *result in results1)
            {
                [arrayIO addObject:[matchedStr1 substringWithRange:result.range]];
            }
            
            [cmdIO appendString: [self convertCmd:arrayIO with:@"io set"]];
            
        }
        if (results4.length)
        {
            [cmdIO appendString:@";"];
            [cmdIO appendString:[self aiCommand:results4]];
        }
        return cmdIO;
    }else{
        //for relay
        
        NSMutableString *cmd = [[NSMutableString alloc] initWithString:@""];
        for (NSString *sub in arrayIO)
        {
            NSArray *s = [sub componentsSeparatedByString:@","];
            if ([s count]>1)
            {
                NSString *io = [s[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *status = [s[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [cmd appendString:[NSString stringWithFormat:@"bit%@=%@,",io,status]];
            }
            
        }
        
        NSString *pattern2 = @"EXIO\\s*=";
        NSRegularExpression *regular2 = [[NSRegularExpression alloc] initWithPattern:pattern2 options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results2 = [regular2 matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        
        NSString * ioname= @"io set";
        if (results2.count)
        {
            ioname= @"exio set";
        }
        NSString *cmdIO =[NSString stringWithFormat:@"[123]%@(%zd,%@,,)",ioname,[arrayIO count],cmd];
        cmdIO = [cmdIO stringByReplacingOccurrencesOfString:@",,," withString:@""];
        return cmdIO;
    }
    
}

-(HWIOModeAI *)setHWIOModeAIWithStr:(NSString *)subjectString
{
    HWIOModeAI *mode = [[HWIOModeAI alloc]init];
    mode.fullname = subjectString;
    
    NSString *regexStringName = @"(.*?)\\s*=\\s*\\{\\s*IO\\s*=";
    NSString *matchedStringName = [subjectString stringByMatching:regexStringName capture:1L];
    if (!matchedStringName) {
        matchedStringName = @"NULL";
    }
    mode.itemname =matchedStringName;
    
    NSString *regexStringIOvalue = @".*?\\s*=\\s*\\{\\s*(IO\\s*=.*)\\s*CH";
    NSString *matchedStringIOvalue = [subjectString stringByMatching:regexStringIOvalue capture:1L];
    if (!matchedStringIOvalue) {
        matchedStringIOvalue = @"NULL";
    }
    mode.iovalue = matchedStringIOvalue;
    
    NSString *regexStringCH = @"CH\\s*=\\s*\"\\s*(\\w+)\\s*\"";
    NSString *matchedStringCH = [subjectString stringByMatching:regexStringCH capture:1L];
    if (!matchedStringCH) {
        matchedStringCH = @"NULL";
    }
    mode.channel = matchedStringCH;
    
    NSString *regexStringGain = @"GAIN\\s*=\\s*([0-9]{1,}[.]?[0-9]*)";
    NSString *matchedStringGain = [subjectString stringByMatching:regexStringGain capture:1L];
    if (!matchedStringGain) {
        matchedStringGain = @"1";
    }
    mode.gain = matchedStringGain;
    return mode;
}
@end
