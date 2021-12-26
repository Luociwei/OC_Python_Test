//
//  SerialNameScan.m
//  FDTIScanner
//
//  Created by chenzw on 15-6-26.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#import "SerialNameScan.h"

@implementation SerialNameScan

-(id) init
{
	self = [super init];
	
	return self;
}

-(void) scanPortName:(NSString *) shortName needName:(NSMutableArray *) m_PortNameArray
{
	kern_return_t			kernResult;//找到串口设备结果后，存储到这个变量中
    CFMutableDictionaryRef	classesToMatch;//scan and match the fixtures
	io_object_t				modemService;
	io_iterator_t			matchingServices;
	bool					findFlag;
    
	
	classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
    if (classesToMatch == NULL)
    {
        NSLog(@"IOServiceMatching returned a NULL dictionary.");
    }
    else
	{
		CFDictionarySetValue(classesToMatch,
                             CFSTR(kIOSerialBSDTypeKey),
							 CFSTR(kIOSerialBSDRS232Type));
	}
	
	kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, classesToMatch, &matchingServices);
    if (KERN_SUCCESS != kernResult)
    {
        NSLog(@"IOServiceGetMatchingServices returned %d", kernResult);
    }
	//上述代码已搜索得到所有的串口
    
	while ((modemService = IOIteratorNext(matchingServices)) && (0 == findFlag))
	{
        usleep(20000);
		CFTypeRef	bsdPathAsCFString;
		bsdPathAsCFString = IORegistryEntryCreateCFProperty(modemService,
                                                            CFSTR(kIOCalloutDeviceKey),
                                                            kCFAllocatorDefault,
                                                            0);
		
		if (bsdPathAsCFString)
        {
			NSString *tempStr = [NSString stringWithFormat: @"%@",bsdPathAsCFString];
            if ([tempStr hasPrefix:shortName])
			{
				NSLog(@"%@",tempStr);
                if (m_PortNameArray.count == 0) {
                    [m_PortNameArray addObject: tempStr];//如果没给定串口名称,则将搜到的串口赋值到数组m_portnamearry
                }
                ///读到相同串口后不进行操作，依次比较串口数字名，如果不同则赋值给m_portnamearry
                else{
                    BOOL flag = false;
                    for(int i = 0;i < m_PortNameArray.count;i++){
                        if ([tempStr isEqualToString:m_PortNameArray[i]]) {
                           flag = true;
                        }
                    }
                    if (flag == false) {
                        [m_PortNameArray addObject: tempStr];
                    }
                }
			}
        }
        else
        {
            findFlag = 1;
        }
		//CFRelease(bsdPathAsCFString);
	}
	
	(void) IOObjectRelease(modemService);
}

- (void)dealloc
{
	
    //[super dealloc];
}
@end
