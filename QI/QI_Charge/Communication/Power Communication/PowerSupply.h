//
//  PowerSupply.h
//  powerSupply
//
//  Created by gdadmin on 2018/6/22.
//  Copyright © 2018年 gdadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "visa.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
static ViSession defaultRM;
static ViSession instr;
static ViUInt32 retCount;
static ViUInt32 writeCount;
static ViStatus status;
static unsigned char buffer[100];
static char stringinput[512];

@interface PowerSupply : NSObject
{
    BOOL isConnectPowerSupply;// = false;
}
-(BOOL)Init:(NSString *)path andBaudRate:(unsigned)baud_rate;
-(BOOL)write:(NSString *)str;
-(NSString *)query:(NSString *)str output:(NSString **)ostr;
@end
