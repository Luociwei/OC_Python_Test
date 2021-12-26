//
//  SerialPort.m
//  Quick Test
//
//  Created by yecm on 2017/5/2.
//  Copyright © 2017年 Innorev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerialPort.h"

@implementation SerialPort

//to find the port which has connected DUT
+ (NSMutableArray *)SearchSerialPorts
{
    NSMutableArray *arrSerialPorts = [[NSMutableArray alloc] init];
    int iFound = 0;
    NSComparisonResult		iResult;  //enum
    kern_return_t			kernResult;  //int
    CFMutableDictionaryRef	classesToMatch;     //struct
    io_iterator_t			serialPortIterator;  //unsinged int
    
    classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
    NSLog(@"classesToMatch: %@", classesToMatch);
    if (NULL != classesToMatch)
    {
        CFDictionarySetValue(classesToMatch, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDAllTypes));
        //CFDictionarySetValue(classesToMatch,CFSTR(kIOSerialBSDTypeKey),CFSTR(kIOSerialBSDRS232Type));
        
        kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, classesToMatch, &serialPortIterator);
        if (KERN_SUCCESS == kernResult)
        {
            do
            {
                io_object_t serialService = IOIteratorNext(serialPortIterator);
                if (0 != serialService)
                {
                    CFStringRef modemName = (CFStringRef)IORegistryEntryCreateCFProperty(serialService, CFSTR(kIOTTYDeviceKey), kCFAllocatorDefault, 0);
                    CFStringRef bsdPath = (CFStringRef)IORegistryEntryCreateCFProperty(serialService, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0);
                    CFStringRef serviceType = (CFStringRef)IORegistryEntryCreateCFProperty(serialService, CFSTR(kIOSerialBSDTypeKey), kCFAllocatorDefault, 0);
                    iResult = [(__bridge NSString *)modemName compare:@"cu.usbserial"];
                    
                    if ((int) iResult == 1)
                    {
                        NSString *szPathTemp = [[NSString alloc] initWithFormat:@"%@",(__bridge NSString *)bsdPath];
                        [arrSerialPorts addObject:szPathTemp];
                        //iFound = 1;
                    }
                    NSLog(@"modemName = %@,bsdPath = %@,serviceType = %@",modemName,bsdPath,serviceType);
                    CFRelease(modemName);
                    CFRelease(bsdPath);
                    CFRelease(serviceType);
                }
                else
                    break;
            } while (!iFound);
            (void)IOObjectRelease(serialPortIterator);
        }
        NSLog(@"IOServiceGetMatchingServices returned %d", kernResult);
    }
    
    return arrSerialPorts;
}



@end
