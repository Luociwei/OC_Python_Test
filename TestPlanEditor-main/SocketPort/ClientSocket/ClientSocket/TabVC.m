//
//  TabVC.m
//  ClientSocket
//
//  Created by ciwei luo on 2020/3/9.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "TabVC.h"
#import "ViewController.h"
#import <CWGeneralManager/CWFileManager.h>
#import <CWGeneralManager/NSString+Extension.h>

@implementation TabVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *logDirPath = [[NSString cw_getUserPath]stringByAppendingString:@"/Suncode/StimPanel/"];
    [CWFileManager cw_createFile:logDirPath isDirectory:YES];
    NSString * path1 = [[NSBundle mainBundle] pathForResource:@"fixturesList" ofType:@".json"];
//    NSString * path2 = [logDirPath stringByAppendingPathComponent:@"fixturesList.json"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path2]) {
//        path1 = path2;
//    }
    NSArray *fixtureList = [CWFileManager cw_serializationWithJsonFilePath:path1];
    [CWFileManager cw_copyBundleFileToDestPath:@"fixturesList.json" destDir:logDirPath];
    [CWFileManager cw_copyBundleFileToDestPath:@"script_cmds_0101.json" destDir:logDirPath];
    if (fixtureList.count) {
        for (NSDictionary *dic in fixtureList) {
            NSString *name = dic[@"fixture"];
            NSString *ip = dic[@"ip"];
            NSString *port = dic[@"port"];
            ViewController *vc = [[ViewController alloc] initWithIp:ip port:port logDirPath:logDirPath];
            [self setUPChildVC:vc title:name];
        }
    }
    
    if (fixtureList.count==1) {
        self.tabStyle = -1;
    }

   // self.tabStyle

    
    
}

-(void)setUPChildVC:(NSViewController *)vc title:(NSString *)title{
    
    vc.title = title;
    
    self.view.frame = vc.view.bounds;
    [self addChildViewController:vc];
    
    
}

@end
