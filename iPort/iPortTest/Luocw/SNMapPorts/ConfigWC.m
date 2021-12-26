//
//  ConfigWC.m
//  iPort
//
//  Created by ciwei luo on 2019/5/13.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "ConfigWC.h"

@implementation ConfigWC
- (void)windowDidLoad {
    [super windowDidLoad];
    self.type = BaseMapPortWCTypeConfig;
    [self.snMapTextView setEditable:NO];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)setConfigPath:(NSString *)configPath
{
    _configPath = configPath;
    NSString *content = [self getFileContentWithFileName:configPath];
    self.window.title = @"Running Config";
    [self.snMapTextView setString:content];
}

@end
