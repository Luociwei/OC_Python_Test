//
//  SerialPort.m
//  FactoryCocoa
//
//  Created by Allen Cheung on 6/14/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import "SerialPort.h"
#include <sys/time.h>
#include <poll.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#if defined(MAC_OS_X_VERSION_10_3) && (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_3)
#include <IOKit/serial/ioss.h>
#endif
#include <IOKit/IOBSD.h>
#import "MyEexception.h"
#import "AppDelegate.h"
#define DATAMASK (0xC0)
#define PARITYMASK (0x30)
#define STOPMASK (0x03)

#define PARITY_EVEN (0x20)
#define PARITY_ODD (0x10)
#define PARITY_NONE (0x00)

#define DATA8 (0x80)
#define DATA7 (0x40)
#define DATA6 (0x00)

#define STOP1 (0x01)
#define STOP2 (0x02)

@implementation SerialPort

@synthesize portName = _portName;
@synthesize isOpen = _isOpen;
@synthesize config = _config;

- (id)initWithPort:(NSString *)port
          baudRate:(speed_t)baud
            config:(PORT_CONFIG)config
           timeout:(int)ms fileName:(NSString *)fileName
{
    if (self = [super init])
    {
        size_t portMallocLen = sizeof(char) * ([port length] + 1);
        _portName = malloc(portMallocLen);
        [port getCString:_portName maxLength:portMallocLen encoding:NSUTF8StringEncoding];
        _fileName=fileName;
        _baudRate = baud;
        _config = config;
        _timeout = ms;
        _fd = -1;
        _originalAttr = NULL;
        _isOpen = NO;
        buffer_init(&_buffer);
    }
    
    return self;
}

- (void)dealloc
{
    if (_isOpen)
    {
        [self close];
    }
    
    if (_originalAttr)
    {
        free(_originalAttr);
        _originalAttr = NULL;
    }
    
    if (_portName) free(_portName);
    
//    [super dealloc];
}

- (BOOL)open
{
    BOOL retval = NO;
    
    if (_isOpen)
    {
        return YES;
    }
    
    do
	{
		_fd = open(_portName, O_RDWR | O_NOCTTY | O_NONBLOCK);
		if (_fd == -1)
		{
			break;
		}
        
        _isOpen = YES;
		
		_originalAttr = (struct termios *) malloc(sizeof(struct termios));
		
		if (tcgetattr(_fd, _originalAttr) == -1)
		{
			break;
		}
		
		// Copy the original attributes
		struct termios term_setting = *_originalAttr;
		
		// Baud rate
		cfsetispeed(&term_setting, _baudRate);
		cfsetospeed(&term_setting, _baudRate);
		
        term_setting.c_lflag &= ~(ECHO | ECHOE | ECHOK | ECHONL | ICANON);
        term_setting.c_oflag &= ~(ONLCR);

		// Parse parameters
		
		// Data bits
		term_setting.c_cflag &= ~CSIZE;     // clear all the CSIZE bits.
		
		if ((_config & DATAMASK) == DATA8)
		{
			term_setting.c_iflag &= ~ISTRIP; // clear the ISTRIP flag.
			term_setting.c_cflag |= CS8;  // set the character size.
		}
		else if ((_config & DATAMASK) == DATA7)
		{
			term_setting.c_iflag |= ISTRIP;  // set the ISTRIP flag.
			term_setting.c_cflag |= CS7;  // set the character size.
		}
		else if ((_config & DATAMASK) == DATA6)
		{
			term_setting.c_iflag |= ISTRIP;  // set the ISTRIP flag.
			term_setting.c_cflag |= CS6;  // set the character size.
		}
		else
		{
            [NSException raise:@"Serial Port Config" format:@"Bad data bits parameter on port config: %02X", _config];
			break;
		}
		
		// Stop bits
		if ((_config & STOPMASK) == STOP1)
		{
			term_setting.c_cflag &= ~CSTOPB;
		}
		else if ((_config & STOPMASK) == STOP2)
		{
			term_setting.c_cflag |= CSTOPB;
		}
		else
		{
            [NSException raise:@"Serial Port Config" format:@"Bad stop bits parameter on port config: %02X", _config];
			break;
		}
		
		// Parity
		if ((_config & PARITYMASK) == PARITY_NONE)
		{
			term_setting.c_cflag &= ~(PARENB | PARODD);
		}
		else if ((_config & PARITYMASK) == PARITY_ODD)
		{
			term_setting.c_cflag |= PARENB | PARODD;
		}
		else if ((_config & PARITYMASK) == PARITY_EVEN)
		{
			term_setting.c_cflag |= PARENB ;
			term_setting.c_cflag &= ~PARODD ;
		}
		else
		{
            [NSException raise:@"Serial Port Config" format:@"Bad parity parameter on port config: %02X", _config];
			break;
		}
		
		// Flow control
		term_setting.c_iflag &= ~(IXON|IXOFF);
		term_setting.c_cflag &= ~CRTSCTS;
		
		// VMin, VTime
		term_setting.c_cc[VMIN ] = 1;
		term_setting.c_cc[VTIME] = 0;
/*
		// Turn off nonblocking mode
		int flags = fcntl(_fd, F_GETFL, 0);
		if (-1 == fcntl(_fd, F_SETFL, flags & ~O_NONBLOCK))
		{
			break;
		}
*/
		// Apply these settings
		if (-1 == tcsetattr(_fd, TCSANOW, &term_setting))
		{
			break;
		}
        
        retval = YES;
		
	} while (0);
    
#if (DEBUG == 1)
    if (retval == NO)
    {
        NSLog(@"SerialPort: Failed to open with error: %d, %s", errno, strerror(errno));
        NSLog(@"Port file:%s", _portName);
    }
#endif
   [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s-- serail open",[LogFile CurrentTimeForLog],_portName]];
    return retval;
}

- (BOOL)close
{
    BOOL retval = YES;
    
    if (!_isOpen)
    {
        return NO;
    }
    
    // Reset original attributes
    if (_originalAttr != NULL)
    {
        if (-1 == tcsetattr(_fd, TCSANOW, _originalAttr))
        {
            // Error
            retval = NO;
        }
        
        free(_originalAttr);
        _originalAttr = NULL;
    }
    
    // Close the device if open
    if (_fd != -1)
    {
        fcntl(_fd, F_SETFL, O_NONBLOCK);
        close(_fd);
        _fd = -1;
    }
    
    _isOpen = NO;
    
    [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s-- serail close",[LogFile CurrentTimeForLog],_portName]];
    
    return retval;
}

#pragma mark - Serial Write

- (BOOL)writeBuffer:(const unsigned char *)buf length:(ssize_t)len
{
    NSLock *wirtelock = [[NSLock alloc] init];
    [wirtelock lock];
    BOOL retval = YES;
    
    if (!_isOpen)
    {
#if (DEBUG == 1)
        NSLog(@"SerialPort: Write command received but port is not open");
        NSLog(@"SerialPort: %@", [NSThread callStackSymbols]);
#endif
      
    [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s send command %s write fail_1",[LogFile CurrentTimeForLog],_portName,buf]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MyEexception RemindException:@"Error" Information:[NSString stringWithFormat:@"%@ port name:%s send command %s write fail_1",[LogFile CurrentTimeForLog],_portName,buf]];
//
//            [NSApp terminate:nil];
//        });

//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MyEexception RemindException:@"Error" Information:[NSString stringWithFormat:@"%@ port name:%s write command %s fail",[LogFile CurrentTimeForLog],_portName,buf]];
//
//                [NSApp terminate:nil];
//            }) ;
//        });

        return NO;
    }
    
#ifdef _NONUI
    ssize_t left = len;
    const unsigned char *ptr = buf;
    while (left > 0) {
        // write slowly in blocks
        ssize_t to_write = MIN(left, 8);
        ssize_t written = write(_fd, ptr, to_write);
        tcdrain(_fd);
        if (written != to_write)
        {
            [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s send command %s write fail_2",[LogFile CurrentTimeForLog],_portName,buf]];
            retval = NO;
            break;
        }
        left -= written;
        ptr += written;
        usleep(10000);
    }
#else
    ssize_t written = write(_fd, buf, len);
    tcdrain(_fd);
    if (written != len)
    {
        [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s send command %s write fail_3",[LogFile CurrentTimeForLog],_portName,buf]];
        retval = NO;
    }
#endif

    [wirtelock unlock];
    return retval;
}

- (BOOL)writeCString:(const char *)str
{
    return [self writeBuffer:(const unsigned char *)str length:strlen(str)];
}

- (BOOL)writeString:(NSString *)str
{

    [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s send command:%@",[LogFile CurrentTimeForLog],_portName,str]];
    
    //if ([str isEqualToString:@"debug key1"]) {
//        NSString *strlog = nil;
//        [self readToString:&strlog withDelimiter:@"" withTimeout:50];
//        if (strlog.length) {
//            [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s cache log read:%@",[LogFile CurrentTimeForLog],_portName,strlog]];
//        }
   // }
    BOOL isWriteSucess =[self writeCString:[str UTF8String]];
    

    return isWriteSucess;
}

#pragma mark - Serial Read

- (BOOL)buffer:(char *)buf withLength:(ssize_t)len containsDelimiter:(const char *)delimiter
{
    ssize_t dlen = strlen(delimiter);
    
    BOOL containsDelimiter = NO;
    
    for (int i = 0; i <= len - dlen; ++i)
    {
        containsDelimiter = YES;
        
        for (int j = 0; j < dlen; ++j)
        {
            if (buf[i+j] != delimiter[j])
            {
                containsDelimiter = NO;
                break;
            }
        }
        
        if (containsDelimiter)
            break;
    }
    
    return containsDelimiter;
}

uint64_t getMS()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
       waitForDelimiter:(const char *)delimiter foundDelimiter:(BOOL *)found
            withTimeout:(int)ms
{

    if (found)
    {
        *found = NO;
    }
    
    if (!_isOpen)
    {
        return -1;
    }

    ssize_t remaining = len;
    char *appendPointer = recbuf;
	
	uint64_t now = getMS(), end = now + ms;

    struct pollfd pfd = { _fd, POLLRDNORM | POLLRDBAND | POLLPRI };

    if (delimiter && delimiter[0]) {
        size_t patsize = strlen(delimiter);
        while (remaining >= patsize && now <= end) {
            if (buffer_fill(&_buffer) < patsize) {
                if(poll(&pfd, 1, (int)(end - now)) > 0) {
                buffer_read(&_buffer, _fd);
                } else break;
            }

            // look for a match while there's enough bytes in the buffer
            while (buffer_fill(&_buffer) >= patsize) {
                if (buffer_match(&_buffer, delimiter)) {

                    // found it, get it from the buffer
                    size_t i = patsize;
                    while(i--) {
                        *appendPointer++ = buffer_pop(&_buffer);
                    }
                    remaining -= patsize;
                    if (found) *found = TRUE;
                    return len - remaining;
                } else {
                    assert(remaining >= 0);
                    // didn't find it, pop one and try again
                    *appendPointer++ = buffer_pop(&_buffer);
                    remaining--;
                }
                if (!remaining) return len;
            }
            now = getMS();
        }
    }

    // read remaining data; we can no longer match a delimiter
    // either remaining < patsize, or there is no delimiter
    while (remaining && now <= end) {
        if (buffer_fill(&_buffer) == 0) {
            if(poll(&pfd, 1, (int)(end - now)) > 0) {
            buffer_read(&_buffer, _fd);
            } else break;
        }

        int c;
        while (remaining && (c = buffer_pop(&_buffer)) >= 0) {
            *appendPointer++ = c;
            remaining--;
        }
        now = getMS();
    }

    return len - remaining;
}

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
       waitForDelimiter:(const char *)delimiter foundDelimiter:(BOOL *)found
{
    return [self readToBuffer:recbuf length:len
             waitForDelimiter:delimiter foundDelimiter:found
                  withTimeout:_timeout];
}

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len withTimeout:(int)ms
{
    return [self readToBuffer:recbuf length:len waitForDelimiter:NULL foundDelimiter:NULL withTimeout:ms];
}

- (ssize_t)readToBuffer:(char *)recbuf length:(ssize_t)len
{
    return [self readToBuffer:recbuf length:len waitForDelimiter:NULL foundDelimiter:NULL];
}

- (ssize_t)readOneByte:(unsigned char *)byte
{
    ssize_t retval = 0;
    
    if (!_isOpen)
    {
        return -1;
    }
    
    retval = read(_fd, byte, 1);
#if (DEBUG == 1)
    if (retval < 0)
    {
        NSLog(@"SerialPort: read error with: %d: %s", errno, strerror(errno));
    }
#endif
    
    return retval;
}

- (BOOL)readToString:(NSString **)str withDelimiter:(NSString *)nsdelimiter withTimeout:(int)ms
{
    NSLock *readlock = [[NSLock alloc] init];
    [readlock lock];
    char block[1024];
    ssize_t remaining = sizeof(block) - 1;
    char *appendPointer = block;
    NSString *localStr = @"";
    const char *delimiter = [nsdelimiter cStringUsingEncoding:NSASCIIStringEncoding];

	uint64_t now = getMS(), end = now + ms;

    struct pollfd pfd = { _fd, POLLRDNORM | POLLRDBAND | POLLPRI };

    if (delimiter && delimiter[0]) {
        size_t patsize = strlen(delimiter);
        while (now < end) {
            if (buffer_fill(&_buffer) < patsize) {
                if(poll(&pfd, 1, (int)(end - now)) > 0) {
                buffer_read(&_buffer, _fd);
                } else break;
            }

            // look for a match while there's enough bytes in the buffer
            while (buffer_fill(&_buffer) >= patsize) {
                if (remaining < patsize) {
                    *appendPointer = 0;
                    localStr = [localStr stringByAppendingFormat:@"%s", block];
                    appendPointer = block;
                    remaining = sizeof(block) - 1;
                }
                if (buffer_match(&_buffer, delimiter)) {

                    // found it, get it from the buffer
                    size_t i = patsize;
                    while(i--) {
                        *appendPointer++ = buffer_pop(&_buffer);
                    }
                    remaining -= patsize;
                    *appendPointer = 0;
                    localStr = [localStr stringByAppendingFormat:@"%s", block];
                    *str = localStr;
                    [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s  timeout:%ds read:%@",[LogFile CurrentTimeForLog],_portName,ms/1000,localStr]];

                    return TRUE;
                } else {

                    // didn't find it, pop one and try again
                    *appendPointer++ = buffer_pop(&_buffer);
                    remaining--;
                }
            }
            now = getMS();
        }

    } else {

        // read remaining data; we can no longer match a delimiter
        while (now < end) {
            if (buffer_fill(&_buffer) == 0) {
                if(poll(&pfd, 1, (int)(end - now)) > 0) {
                buffer_read(&_buffer, _fd);
                } else break;
            }

            int c;
            while ((c = buffer_pop(&_buffer)) >= 0) {
                if (remaining == 0) {
                    *appendPointer = 0;
                    localStr = [localStr stringByAppendingFormat:@"%s", block];
                    appendPointer = block;
                    remaining = sizeof(block) - 1;
                }
                *appendPointer++ = c;
                remaining--;
            }
            now = getMS();
        }
    }

    *appendPointer = 0;
    localStr = [localStr stringByAppendingFormat:@"%s", block];

    *str = localStr;
   
    [LogFile AddLog:DebugFOLDER FileName:_fileName Content:[NSString stringWithFormat:@"%@ port name:%s  timeout:%ds read:%@",[LogFile CurrentTimeForLog],_portName,ms/1000,localStr]];
     [readlock unlock];
    return FALSE;
}

- (BOOL)readToString:(NSString **)str withDelimiter:(NSString *)delimiter
{
    return [self readToString:str withDelimiter:delimiter withTimeout:_timeout];
}

- (BOOL)readExistingToString:(NSString **)str
{
    BOOL retval = YES;
    
    if (!_isOpen)
    {
        return NO;
    }
    
    ssize_t currentread = 0;
    char localbuf[1024];
    NSString *localStr = @"";
    
    while (1)
	{
		currentread = read(_fd, localbuf, 1023);
        if (currentread <= 0)
        {
            break;
        }
        
        localbuf[currentread] = 0;
        if (str)
        {
            localStr = [localStr stringByAppendingFormat:@"%s", localbuf];
        }
    }
    
    if (currentread < 0)
    {
        retval = NO;
    }
    
    if (str)
    {
        *str = localStr;
    }
    
    return retval;
}

#pragma mark - Find existing ports

+ (kern_return_t)findModems:(io_iterator_t *)matchingServices
{
    kern_return_t			kernResult; 
	CFMutableDictionaryRef	classesToMatch;
    
    classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
	if (classesToMatch == NULL)
	{
		return KERN_FAILURE;
	}
    else
    {
        CFDictionarySetValue(classesToMatch,
							 CFSTR(kIOSerialBSDTypeKey),
							 CFSTR(kIOSerialBSDRS232Type));
    }
    
    kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, classesToMatch, matchingServices);    
	
	return kernResult;
}

+ (kern_return_t)getModemPath:(io_iterator_t)serialPortIterator
                        paths:(NSArray **)paths maxPathSize:(CFIndex)maxPathSize
{
	io_object_t		modemService;
	kern_return_t	kernResult = KERN_FAILURE;
    NSMutableArray *localPaths = [[NSMutableArray alloc] init];
	
	// Initialize the returned path
	char pBuffer[MAXPATHLEN];
	*pBuffer = '\0';
	
	// Iterate across all modems found. In this example, we bail after finding the first modem.
	
	while ((modemService = IOIteratorNext(serialPortIterator)))
	{
		CFTypeRef	bsdPathAsCFString;
		
		// Get the callout device's path (/dev/cu.xxxxx). The callout device should almost always be
		// used: the dialin device (/dev/tty.xxxxx) would be used when monitoring a serial port for
		// incoming calls, e.g. a fax listener.
		
		bsdPathAsCFString = IORegistryEntryCreateCFProperty(modemService,
															CFSTR(kIOCalloutDeviceKey),
															kCFAllocatorDefault,
															0);
		if (bsdPathAsCFString)
		{
			Boolean result;
			
			// Convert the path from a CFString to a C (NUL-terminated) string for use
			// with the POSIX open() call.
			
			result = CFStringGetCString((CFStringRef) bsdPathAsCFString,
										pBuffer,
										maxPathSize, 
										kCFStringEncodingUTF8);
            
			CFRelease(bsdPathAsCFString);
			
			if (result)
			{
				NSString *str = [[NSString alloc] initWithUTF8String:pBuffer];
				
                if ([str rangeOfString:@"Bluetooth"].location == NSNotFound)
                {
                    [localPaths addObject:str];
                }
				
//                [str release];
				kernResult = KERN_SUCCESS;
			}
		}
		
		// Release the io_service_t now that we are done with it.
		
		(void) IOObjectRelease(modemService);
	}
	
//    *paths = [localPaths autorelease];
    
	return kernResult;
}

+ (BOOL)serialPortList:(NSArray **)list
{
    /*
    io_iterator_t serialPortIterator;
	char bsdPath[MAXPATHLEN];
    BOOL retval = NO;
    
    if ([self findModems:&serialPortIterator] == KERN_SUCCESS)
    {
        if ([self getModemPath:serialPortIterator paths:list maxPathSize:sizeof(bsdPath)] == KERN_SUCCESS)
        {
            retval = YES;
        }
    }
    */

    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:@"/dev" error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'cu.usbserial'"];
    NSArray *serialPorts = [dirContents filteredArrayUsingPredicate:fltr];

    NSMutableArray *tmp = [NSMutableArray new];
    for (NSString *name in serialPorts) {
        [tmp addObject:[NSString stringWithFormat:@"/dev/%@", name]];
    }
    *list = [[NSArray alloc] initWithArray:tmp];
    
	//IOObjectRelease(serialPortIterator);

    return YES; //retval;
}



+ (NSArray *)serialPortList{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:@"/dev" error:nil];
//    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'cu.SLAB_'"];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'cu.usbserial-'"];
    NSArray *serialPorts = [dirContents filteredArrayUsingPredicate:fltr];
    NSMutableArray *serialArr=[[NSMutableArray alloc] init];
    NSMutableArray *tmp = [NSMutableArray new];
    for (NSString *name in serialPorts) {
        NSRange rang=[name rangeOfString:@"cu.usbserial-"];
        NSString *lastName=[name substringFromIndex:rang.location+rang.length];
        [serialArr addObject:lastName];
    }
    NSArray *serialLastName=[serialArr sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *name in serialLastName) {
        [tmp addObject:[NSString stringWithFormat:@"/dev/cu.usbserial-%@", name]];
    }
    NSArray *list = [[NSArray alloc] initWithArray:tmp];
    return list;
}

@end
