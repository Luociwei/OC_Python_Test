//
//  SNMapPortsWC.m
//  iPort
//
//  Created by ciwei luo on 2019/4/29.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "BaseMapPortWC.h"
#import "CWFileManager.h"
#import "MyEexception.h"

@interface BaseMapPortWC ()
@property (weak) IBOutlet NSButton *cancelBtn;
@property (weak) IBOutlet NSButton *saveBtn;

@property BOOL isSave;
//@property (copy)NSString *content;

@end

@implementation BaseMapPortWC
+(instancetype)mapPortWC{
    return [[self alloc]initWithWindowNibName:@"BaseMapPortWC"];
}
- (void)windowDidLoad {
    [super windowDidLoad];
  // self.loadTimes = self.loadTimes+1;
//    NSString *content = @"";
//    _isSave = NO;
//    if (self.type == BaseMapPortWCTypeSN) {
//        //@"snMapPort.json"
//        content = [self getFileContentWithFileName:@"snMapPort.json"];
//        self.window.title = @"SNMapPort";
//
//    }else if (self.type == BaseMapPortWCTypeEcode){
//        content = [self getFileContentWithFileName:@"EEEE_Code.json"];
//        self.window.title = @"ECodeMapPort";
//    }else if (self.type == BaseMapPortWCTypeStation){
//        content = [self getFileContentWithFileName:@"stationMapPort.json"];
//        self.window.title = @"StationMapPort";
//    }
//    [self.snMapTextView setString:content];
}



-(void)windowWillLoad{
    [super windowWillLoad];
}

-(NSString *)defaultFilePathWithFileName:(NSString *)name{
//    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *path=[desktopPath stringByDeletingLastPathComponent];
//    NSString *configfile=[path stringByAppendingPathComponent:name];
    NSString *configfile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    return configfile;
}


-(NSString *)getFileContentWithFileName:(NSString *)fileName
{
    NSString *configfile =  [self defaultFilePathWithFileName:fileName];
    NSString *string = [CWFileManager cw_readFromFile:configfile];
    return string;
}

-(BOOL)saveFileContentWithFileName:(NSString *)fileName
{
    NSString *configfile =  [self defaultFilePathWithFileName:fileName];
    
    NSString *content =self.snMapTextView.string;
//    BOOL isWriteSucess = [CWFileManager cw_writeToFile:configfile content:content];
   BOOL isSucess = YES;
  
        if ([self checkWithContent:content]) {
            [CWFileManager cw_removeItemAtPath:configfile];
            [CWFileManager cw_createFile:configfile isDirectory:NO];
            [CWFileManager cw_writeToFile:configfile content:content];
            _isSave = YES;
            
        }else{
            isSucess = NO;
        }
    
    
    return isSucess;
}


-(BOOL)checkWithContent:(NSString *)content{
//    if (self.type == BaseMapPortWCTypeEcode) {
//        return YES;
//    }
    NSData *data= [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;

    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject==nil &&content.length>40) {

        [MyEexception RemindException:@"ERROR" Information:@"please check your writing form"];
        return NO;
    }
    return YES;
}

-(void)setType:(BaseMapPortWCType)type
{
    _type = type;
    if (self.snMapTextView == nil) {
        self.loadTimes = self.loadTimes+1;
        return;
    }
    if (!_isSave) {
        if (!self.loadTimes) {
            return;
        }
        NSString *content=@"";
        [self.saveBtn setHidden:NO];
        [self.cancelBtn setHidden:NO];
        if (self.type == BaseMapPortWCTypeSN) {
            //@"snMapPort.json"
            content = [self getFileContentWithFileName:@"snMapPort.json"];
            self.window.title = @"SNMapPort";
            
        }else if (self.type == BaseMapPortWCTypeEcode){
            content = [self getFileContentWithFileName:@"EEEE_Code.json"];
            self.window.title = @"ECodeMapPort";
        }else if (self.type == BaseMapPortWCTypeStation){
            content = [self getFileContentWithFileName:@"stationMapPort.json"];
            self.window.title = @"StationMapPort";
        }else if (self.type==BaseMapPortWCTypeConfig){
            
           // content = [self getFileContentWithFileName:@"EEEE_Code.json"];
            [self.saveBtn setHidden:YES];
            [self.cancelBtn setHidden:YES];
           // self.window.title = @"Running Config";
        }
        [self.snMapTextView setString:content];
        
    }
}

-(void)exit{
    [self.window close];
}

- (IBAction)save:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseMapPortWCSaveClick)]) {
        BOOL isSaveSucess = YES;
        if (self.type == BaseMapPortWCTypeSN) {
            isSaveSucess =[self saveFileContentWithFileName:@"snMapPort.json"];
            
        }else if (self.type == BaseMapPortWCTypeEcode){
            isSaveSucess =[self saveFileContentWithFileName:@"EEEE_Code.json"];
        }else if (self.type == BaseMapPortWCTypeStation){
            isSaveSucess =[self saveFileContentWithFileName:@"stationMapPort.json"];
        }
        
        
        [self.delegate baseMapPortWCSaveClick];
        
        if (isSaveSucess) {
            [self exit];
        }
    }
   
    
}

- (IBAction)cancel:(id)sender {
   // [self.snMapTextView setString:_content];
    [self exit];
    
}

@end
