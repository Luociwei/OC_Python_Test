//
//  UART.m
//  FDTIScanner
//
//  Created by chenzw on 15-7-16.
//  Copyright (c) 2015年 chenzw. All rights reserved.
//

#include <termios.h>      /*POSIX 终端控制定义*/
#include <sys/ioctl.h>
#import "UART.h"

@implementation UART

@synthesize uart_handle;
@synthesize uart_path;
@synthesize uart_nl;

-(id) initWithPath:(NSString *)path andBaudRate:(unsigned)baud_rate
{
	self = [super init];
    
	int handle=0;
	struct termios  options;
    
	self->uart_handle = -1;
	if (self)
    {
		@synchronized([UART class])
        {
			handle = open([path UTF8String], O_RDWR | O_NONBLOCK| O_NOCTTY );
            /*linux下的串口访问是以设备文件形式进行的，所以打开串口也即是打开文件的操作。函数原型可以如下所示：
            int open（“DE_name”，int open_Status）
            参数说明：
            （1）.DE_name：要打开的设备文件名
            比如要打开串口1，即为/dev/ttyS0。
            （2）.open_Status：文件打开方式，可采用下面的文件打开模式：
            l          O_RDONLY：以只读方式打开文件
            l          O_WRONLY：以只写方式打开文件
            l          O_RDWR：以读写方式打开文件
            l          O_APPEND：写入数据时添加到文件末尾
            l          O_CREATE：如果文件不存在则产生该文件，使用该标志需要设置访问权限位mode_t
            l          O_EXCL：指定该标志，并且指定了O_CREATE标志，如果打开的文件存在则会产生一个错误
            l          O_TRUNC：如果文件存在并且成功以写或者只写方式打开，则清除文件所有内容，使得文件长度变为0
            l          O_NOCTTY：如果打开的是一个终端设备，这个程序不会成为对应这个端口的控制终端，如果没有该标志，任何一个输入，例如键盘中止信号等，都将影响进程。
            l          O_NONBLOCK：该标志与早期使用的O_NDELAY标志作用差不多。程序不关心DCD信号线的状态，如果指定该标志，进程将一直在休眠状态，直到DCD信号线为0。
            函数返回值： 
            成功返回文件描述符，如果失败返回-1
            */
            
            
			if (handle < 0) {
				NSLog(@"Error opening serial port %@ - %s(%d).", path, strerror(errno), errno);
				goto error;
			}
		}
	}
    
	if (self)
    {
#if 0  // ＃if 0 code #endif 调试代码， 当改0为1，则执行code否则只是注释
		if (ioctl(handle, TIOCEXCL) == -1)
        {
			NSLog(@"Error setting TIOCEXCL on %@ - %s(%d).\n", path, strerror(errno), errno);
			goto error;
		}
#endif
        
        
		if (fcntl(handle, F_SETFL, 0) == -1)
            //fcntl()用来操作文件描述符的一些特性。参数fd代表欲设置的文件描述符。F_SETFL 设置文件描述符状态旗标但只允许O_APPEND、O_NONBLOCK和O_ASYNC位的改变，，参数arg为新旗标.设置为阻塞。阻塞操作：是指在执行设备操作时，若不能获得资源则挂起进程，直到满足可操作的条件后进行操作，被挂起的进程进入睡眠状态，被从调度器的运行队列移走，直到等待的条件被满足.
        {
			NSLog(@"Error clearing O_NONBLOCK %@ - %s(%d).\n", path, strerror(errno), errno);
			goto error;
		}
        
        
		if (tcgetattr(handle, &options) == -1) {
			NSLog(@"Error getting tty attributes %@ - %s(%d).\n", path, strerror(errno), errno);
            //tcgetattr函数用于获取与终端相关的参数。参数fd为终端的文件描述符，返回的结果保存在termios结构体中
			goto error;
		}
        
		cfmakeraw(&options);//制作新的终端控制属性,设置终端属性
        
		cfsetspeed(&options, baud_rate);
		options.c_cflag |=  (CS8); //     |  CCTS_OFLOW |    CRTS_IFLOW);
		options.c_cflag &=  (CLOCAL  |  CREAD);
		options.c_cflag &= ~(PARENB);
		options.c_cflag &= ~(CSTOPB);
		options.c_cflag &= ~(CSIZE);
		options.c_lflag &= ~(ICANON  |   ECHO   |   ECHOE   |   ISIG);
		options.c_oflag &= ~(OPOST);
        
		options.c_iflag = 0;
        
		options.c_lflag = 0;
        
		options.c_oflag       = 0;
		options.c_cc[VINTR]   = 0;
		options.c_cc[VQUIT]   = 0;
		options.c_cc[VERASE]  = 0;
		options.c_cc[VKILL]   = 0;
		options.c_cc[VEOF]    = 0;
		options.c_cc[VTIME]   = 0;
		options.c_cc[VMIN]    = 0;
        //		options.c_cc[VSWTC]   = 0;
		options.c_cc[VSTART]  = 0;
		options.c_cc[VSTOP]   = 0;
		options.c_cc[VSUSP]   = 0;
		options.c_cc[VEOL]    = 0;
		options.c_cc[VREPRINT]= 0;
		options.c_cc[VDISCARD]= 0;
		options.c_cc[VWERASE] = 0;
		options.c_cc[VLNEXT]  = 0;
		options.c_cc[VEOL2]   = 0;
        
		NSLog(@"%@ %@ output baud rate changed to %d\n", self, path, (int) cfgetospeed(&options));
        
        
		if (tcsetattr(handle, TCSANOW, &options) == -1) {
			NSLog(@"Error setting tty attributes %@ - %s(%d).\n", path, strerror(errno), errno);
			goto error;
		}
        
		self->uart_handle = handle;
		self->uart_path   = [[NSString alloc] initWithString:path];
		self->uart_nl     = @"\r";
        
#if 0
		NSString *log_path = [NSString stringWithFormat:@"/tmp/uart_log_%@.txt", baseName(self->uart_path)];
        
		[[NSFileManager defaultManager] createFileAtPath:log_path contents:nil attributes:nil];
#endif
		self->uart_log    = 0;
        //[[NSFileHandle fileHandleForWritingAtPath:log_path] retain];
	}
    
	return self;
    
error:
	if (handle >= 0)
    {
		close(handle);
	}
    
	//[self release];
	self = nil;
    
	return self;
}

-(BOOL)close
{
    close(uart_handle);
    return YES;
}

-(void) dealloc
{
	@synchronized([UART class])
    {
		close(uart_handle);
	}
    
	//[uart_path release];
	//[uart_nl release];
	//[super dealloc];
}


-(void) logData:(NSData *)data
{
    
    
}

-(int) write:(NSString *)str
{
	char const *buf = [str UTF8String];
	unsigned    len = (unsigned int)[str length];
    
	for (unsigned i= 0; i< len; i++)
    {
		/*
		 * pace ourselves, dock uarts do not have flow control
		 */
		write(uart_handle, buf+i, 1);
        //函数原型：int write(int fd, const void *buf, size_t length)功能： 把length个字节从buf所指向的缓存区中写到件描述符fd所指向的文件中，返回值为实际写入的字节数
		//[NSThread sleepForTimeInterval:0.001];
	}
    
	return len;
}

-(int) writeLine:(NSString *)str
{
	/* flush input */
	[self flush];
    
	NSLog(@"To '%@' %@: [%@]", self.uart_path, self, str);
    
	return [self write:[str stringByAppendingString:uart_nl]];
}

-(NSString *)read
{
	unsigned char      buffer[256];
	ssize_t   numBytes;
    
    
	numBytes = read(uart_handle, buffer, sizeof(buffer) - 1);
     //函数原型：int read(int fd, const void *buf, size_t length)功能： 从文件描述符fd所指向的文件中读取length个字节到buf所指向的缓存区中，返回值为实际读取的字节数
	if (numBytes > 0)
    {
		int valid;
        
		//[self logData:[NSData dataWithBytes:buffer length:numBytes]];
        
		/*
		 * XXX : mpetit : iBoot produces \0 after its line endings
		 */
		valid = 0;
		for (unsigned i= 0; i< numBytes; i++)
        {
			if (buffer[i]) {
				buffer[valid] = buffer[i];
				valid += 1;
			}
		}
		buffer[valid] = '\0';
        
		return [NSString stringWithFormat:@"%s", buffer];
	}
    
	return @"";
}

-(NSData *)readData
{
	unsigned char      buffer[256];
	ssize_t   numBytes;
    
	numBytes = read(uart_handle, buffer, sizeof(buffer) - 1);
     //函数原型：int read(int fd, const void *buf, size_t length)功能： 从文件描述符fd所指向的文件中读取length个字节到buf所指向的缓存区中，返回值为实际读取的字节数
    
	if (numBytes > 0)
    {
		int valid;
        
		/*
		 * XXX : mpetit : iBoot produces \0 after its line endings
		 */
		valid = 0;
		for (unsigned i= 0; i< numBytes; i++)
        {
			if (buffer[i])
            {
				buffer[valid] = buffer[i];
				valid += 1;
			}
		}
		buffer[valid] = '\0';
        
		return [NSData dataWithBytes:buffer length:numBytes];
	}
    
	return nil;
}

-(NSString *)flush
{
	NSMutableString *retval = [NSMutableString stringWithCapacity:4096];
	NSString        *chunk;
    
	/* flush input */
	do 
    {
		chunk = [self read];
        
		[retval appendString:chunk];
	} 
    while (![chunk isEqualToString:@""]);
	return retval;
}
@end

