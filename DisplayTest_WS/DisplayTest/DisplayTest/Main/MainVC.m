//
//  MainVC.m
//  DisplayTest
//
//  Created by ciwei luo on 2021/12/24.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "MainVC.h"
#import "ProgressBarVC.h"
@interface MainVC ()
@property (weak) IBOutlet NSTextField *pathLable;
@property(nonatomic,strong)ProgressBarVC *progressBarVC;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    
    self.progressBarVC = [[ProgressBarVC alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leftFileVCScriptFileClick:)
                                                 name:@"LeftFileVCScriptFileClick"
                                               object:nil];
    
    
}


-(void)leftFileVCScriptFileClick:(NSNotification *)notif{
    NSString *path = notif.object;
    self.pathLable.stringValue = path;
    //[self refleshWithPath:path];
    [self generate_py:path];
}


-(void)generate_py:(NSString *)path{
    self.progressBarVC = [[ProgressBarVC alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

            
            [self.progressBarVC showViewAsSheetOnViewController:self];
            
            [self.progressBarVC setProgressBarPercentValue:0.5 info:@"ssss"];
            [NSThread sleepForTimeInterval:3];
            [self.progressBarVC setProgressBarPercentValue:0.9 info:@"ssss"];
            [NSThread sleepForTimeInterval:3];
            [self.progressBarVC close];

    });

    
    AppDelegate * appDelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    
    int ret = [appDelegate.zmqMainPy sendMessage:@"ScriptListVC" event:@"ScriptClick" params:@[path]];
    
    if (ret > 0)
    {
        BOOL __block isShow = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            [NSThread sleepForTimeInterval:0.5];

            int i =0;
            NSString *last_percent_str = @"";
            while (true) {
                i = i+1;
                [NSThread sleepForTimeInterval:0.2];
                NSDictionary *loadingDict =(NSDictionary *)[appDelegate.redis get:@"loading"];
                if (loadingDict.count) {
                    NSString *percent_str = [loadingDict objectForKey:@"percent"];
                    NSString *info_str = [loadingDict objectForKey:@"info"];
                    if ([percent_str isEqualToString:last_percent_str]) {
                        continue;
                    }else{
                        last_percent_str = percent_str;
                        float per = [percent_str floatValue];
                        NSLog(@"mes:%@--percent:%f",percent_str,per);
                        NSLog(@"1111111--%d",i);
                        if (per == 1) {
                            break;
                        }
                    }
 
                }
            }
//            'percent': percent_str,
//            'info': info_str,
            
//            while (true) {
//                i = i+1;
//                [NSThread sleepForTimeInterval:0.05];
//                //                NSString *redis_ret = [appDelegate.redis get:@"common"];
//                NSDictionary *loadingDict =(NSDictionary *)[appDelegate.redis get:@"common"];
//
//
//                if (loadingDict) {
//
//                    NSString *title = [loadingDict objectForKey:@"title"];
//                    NSArray *infoArr = [loadingDict objectForKey:@"info"];
//                    if ([title isEqualToString:@"warning"] && (infoArr.count >=2)) {
//
//                        NSString *name = infoArr[0];
//                        NSString *mes = infoArr[1];
//                        NSLog(@"name:%@---mes:%@",name,mes);
//                        break;
//
//                    }else if ([title isEqualToString:@"loading"]){
//
//                        NSString *mes = infoArr[0];
//                        float per = [infoArr[1] floatValue];
//                        NSLog(@"mes:%@--percent:%f",mes,per);
//                        //
////                        if (!isShow) {
////                            isShow = YES;
////
////                            [self.progressBarVC showViewAsSheetOnViewController:self];
////
////                        }else{
////                            if (self.progressBarVC.isActive) {
////
////                                [self.progressBarVC setProgressBarPercentValue:per info:mes];
////
////                            }
////                        }
//
//                        if (per >= 1) {
//                            [NSThread sleepForTimeInterval:0.5];
//
////                            [self.progressBarVC close];
//
//                            break;
//
//
//                        }
//
//                    }
//
//                }else{
//                    NSLog(@"1111111--%d",i);
//                }
//
//            }

            id response = [appDelegate.zmqMainPy read];

            if ([response isKindOfClass:[NSArray class]]) {
                NSLog(@"NSArray");
            }else if ([response isKindOfClass:[NSString class]]){
                NSLog(@"NSString");
            }else if ([response isKindOfClass:[NSDictionary class]]){
                NSLog(@"NSDictionary");
                NSDictionary *response_dict = (NSDictionary *)response;
                NSString *tilte = [response_dict objectForKey:@"title"];
                NSString *info = [response_dict objectForKey:@"info"];
                if (tilte.length && [tilte.lowercaseString containsString:@"warning"]) {
                    if (info.length) {
                        [Alert cw_messageBox:tilte Information:info];
                    }
                }else{
                    
                }
            }
            
            NSLog(@"%@",response);
            [CWRedis flushall];
//            [NSThread sleepForTimeInterval:1];
                //                                return;

        });
    }
}


@end
