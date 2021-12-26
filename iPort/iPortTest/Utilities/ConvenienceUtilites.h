//
//  ConvenienceUtilites.h
//  MYAPP
//
//  Created by Zaffer.yang on 3/8/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvenienceUtilites : NSObject

long subtractTimeVal(struct timeval *now, struct timeval *start);

NSString *ftdiSerialPortNameFromPortName(NSString *portname);

void setFlag(int32_t *flag);

void resetFlag(int32_t *flag);

bool isFlagSet(int32_t *flag);

NSString *factoryFormattedCurrentDate();

NSString *factoryFormattedDateFromTimeval(struct timeval *time);

@end
