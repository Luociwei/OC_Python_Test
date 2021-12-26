//
//  PythonClass.m
//  callclipy
//
//  Created by gdadmin on 2018/6/25.
//  Copyright © 2018年 user. All rights reserved.
//

#import "PythonClass.h"

@implementation PythonClass
-(BOOL)Init:(NSString*)path port:(NSString*) portName
{
    if(isOpen == true)
    {
        return true;
    }
    
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", [NSString stringWithFormat:@"%@", path], nil]];
    readPipe = [NSPipe pipe];
    readHandle = [readPipe fileHandleForReading];
    writePipe = [NSPipe pipe];
    writeHandle = [writePipe fileHandleForWriting];
    [task setStandardInput:writePipe];
    [task setStandardOutput:readPipe];
    [task launch];
    usleep(200000);
    NSData *readData_init = [readHandle availableData];
    NSString *string_init = [[NSString alloc] initWithData:readData_init encoding:NSUTF8StringEncoding];
    NSLog(@"%@", string_init);
    NSString * portNum = @"";
    if(![string_init containsString:portName])
    {
        NSLog(@"\n######Open the port Fail!#####\n");
        return false;
    }
    NSRange range = [string_init rangeOfString:portName];
    if (range.location != NSNotFound)
    {
        NSUInteger locataion =range.location-4;
        NSString * subReponse=[string_init substringWithRange: NSMakeRange(locataion,1)];
        NSLog(subReponse);
        portNum = [[portNum stringByAppendingString:subReponse] stringByAppendingString:@"\n"];
    }
    if(portNum == @""||portNum == @"\n"||portNum.length!=2)
    {
        NSLog(@"\n######Open the port Fail! Can't find the port number.#####\n");
        return false;
    }
    //NSString * in_str = [[NSString stringWithFormat:@"%d",portNum] stringByAppendingString:@"\n"];
    NSData * in_data = [portNum dataUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
    [writeHandle writeData:in_data];
    //[writeHandle closeFile];
    usleep(200000);
    NSData *readData = [readHandle availableData];
    NSString *string = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    NSLog(@"\nsend command: %@ ----> %@\n", portNum, string);
    isOpen = true;
    return true;
}

-(NSString*)timeoutsend:(NSString*)command
{
    if(isOpen == false)
    {
        return @"";
    }
    NSData * in_data = [command dataUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
    [writeHandle writeData:in_data];
    usleep(4000000);
//    [writeHandle writeData:in_data];
//    usleep(3000000);
    //usleep(1000000);
    //[QThread usleep: 100];
    NSData *readData = [readHandle availableData];
    NSString *string = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    NSLog(@"\nsend command: %@ ----> %@\n", command, string);
    return string;
}

-(NSString*)send:(NSString*)command
{
    if(isOpen == false)
    {
        return @"";
    }
    NSData * in_data = [command dataUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
    [writeHandle writeData:in_data];
    usleep(200000);
    //[QThread usleep: 100];
    NSData *readData = [readHandle availableData];
    NSString *string = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    NSLog(@"\nsend command: %@ ----> %@\n", command, string);
    return string;
}
-(BOOL)close
{
    if(isOpen == false)
    {
        return true;
    }
    BOOL result = false;
    NSString * in_str = @"quit\n";
    NSData * in_data = [in_str dataUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
    [writeHandle writeData:in_data];
    [writeHandle closeFile];
    usleep(100000);
    NSData *readData = [readHandle availableData];
    NSString *string = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    NSLog(@"\nsend command: %@ ----> %@\n", @"quit", string);
    if([string containsString:@"Quitting"])
    {
        isOpen = false;
        result = true;
    }
    [task waitUntilExit];
    return result;
}
-(BOOL)isOpen
{
    return isOpen;
}
@end
