//
//  ViewController.h
//  ClientSocket
//
//  Created by ciwei luo on 2020/1/15.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

-(instancetype)initWithIp:(NSString *)ip port:(NSString *)port logDirPath:(NSString *)logDirPath;

@end

