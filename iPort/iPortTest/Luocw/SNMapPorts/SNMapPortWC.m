//
//  SNMapPortWC.m
//  iPort
//
//  Created by ciwei luo on 2019/4/29.
//  Copyright © 2019 Zaffer.yang. All rights reserved.
//

#import "SNMapPortWC.h"

@interface SNMapPortWC ()

@end

@implementation SNMapPortWC

- (void)windowDidLoad {
    [super windowDidLoad];
    self.type = BaseMapPortWCTypeSN;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)windowWillLoad{
    [super windowWillLoad];
}

@end
