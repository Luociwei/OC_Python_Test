//
//  ConvenienceUtilites.m
//  MYAPP
//
//  Created by Zaffer.yang on 3/8/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "ConvenienceUtilites.h"
#import <libkern/OSAtomic.h>
#import <stdatomic.h>
#include <sys/time.h>


@implementation ConvenienceUtilites

/*
 * Returns in units of microseconds.  Subtract two timeval structs, convenience function.
 */
long subtractTimeVal(struct timeval *now, struct timeval *start)
{
    return (now->tv_sec - start->tv_sec) * USEC_PER_SEC + (now->tv_usec - start->tv_usec);
}

/*
 * Given a portname, return the full serial port path to the handle.
 */
NSString *ftdiSerialPortNameFromPortName(NSString *portname)
{
    return [NSString stringWithFormat:@"/dev/cu.usbserial-%@", portname];
}

// Convenience methods for setting a flag using the OSAtomic library

void setFlag(int32_t *flag)
{
    OSAtomicCompareAndSwap32(0, 1, flag);
}

void resetFlag(int32_t *flag)
{
    OSAtomicCompareAndSwap32(1, 0, flag);
}

bool isFlagSet(int32_t *flag)
{
    return OSAtomicCompareAndSwap32(1, 1, flag);
}

/*
 * Return the current date and time stamp in a predefined (by me, not POR)
 * formatted string.
 */
NSString *factoryFormattedCurrentDate()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    return date;
}

/*
 * Return a formatted data and time stamp string from a timeval struct.
 */
NSString *factoryFormattedDateFromTimeval(struct timeval *time)
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time->tv_sec + (time->tv_usec / USEC_PER_SEC)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
@end
