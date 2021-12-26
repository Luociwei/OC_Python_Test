//
//  PowerCommuioncation.m
//  test
//
//  Created by 罗词威 on 10/06/18.
//  Copyright © 2018年 luocw. All rights reserved.
//
#if defined(_MSC_VER) && !defined(_CRT_SECURE_NO_DEPRECATE)
/* Functions like strcpy are technically not secure because they do */
/* not contain a 'length'. But we disable this warning for the VISA */
/* examples since we never copy more than the actual buffer size.   */
#define _CRT_SECURE_NO_DEPRECATE
#endif
#import "AppDelegate.h"
#import "visa.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#import "PowerCommuioncation.h"

static ViSession defaultRM;
static ViSession instr;
static ViUInt32 retCount;
static ViUInt32 writeCount;
static ViStatus status;
static unsigned char buffer[100];
static char stringinput[512];

@implementation PowerCommuioncation

+(BOOL)connectPowerSupply
{
    status=viOpenDefaultRM (&defaultRM);
    if (status < VI_SUCCESS)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"check fail"];
        [alert setInformativeText:@"Could not open a session to the VISA Resource Manager!\n"];
        [alert runModal];
       // printf ("Could not open a session to the VISA Resource Manager!\n");
        return NO;
    }
    
    status = viOpen (defaultRM, "USB0::0x05E6::0x2220::9201905::INSTR", VI_NULL, VI_NULL, &instr);
    if (status < VI_SUCCESS)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"check fail"];
        [alert setInformativeText:@"Cannot open a session to the device."];
        [alert runModal];
       // printf ("Cannot open a session to the device.\n");
        [self close];
        return NO;
    }
    
    /* Set the timeout to 5 seconds (5000 milliseconds). */
    status = viSetAttribute (instr, VI_ATTR_TMO_VALUE, 5000);
    
    /* Set the baud rate to 4800 (default is 9600). */
    status = viSetAttribute (instr, VI_ATTR_ASRL_BAUD, 115200);
    
    /* Set the number of data bits contained in each frame (from 5 to 8).
     * The data bits for  each frame are located in the low-order bits of
     * every byte stored in memory.
     */
    status = viSetAttribute (instr, VI_ATTR_ASRL_DATA_BITS, 8);
    
    /* Specify parity. Options:
     * VI_ASRL_PAR_NONE  - No parity bit exists,
     * VI_ASRL_PAR_ODD   - Odd parity should be used,
     * VI_ASRL_PAR_EVEN  - Even parity should be used,
     * VI_ASRL_PAR_MARK  - Parity bit exists and is always 1,
     * VI_ASRL_PAR_SPACE - Parity bit exists and is always 0.
     */
    status = viSetAttribute (instr, VI_ATTR_ASRL_PARITY, VI_ASRL_PAR_NONE);
    
    /* Specify stop bit. Options:
     * VI_ASRL_STOP_ONE   - 1 stop bit is used per frame,
     * VI_ASRL_STOP_ONE_5 - 1.5 stop bits are used per frame,
     * VI_ASRL_STOP_TWO   - 2 stop bits are used per frame.
     */
    status = viSetAttribute (instr, VI_ATTR_ASRL_STOP_BITS, VI_ASRL_STOP_ONE);
    
    /* Specify that the read operation should terminate when a termination
     * character is received.
     */
    status = viSetAttribute (instr, VI_ATTR_TERMCHAR_EN, VI_TRUE);
    
    /* Set the termination character to 0xA
     */
    status = viSetAttribute (instr, VI_ATTR_TERMCHAR, 0xA);
//    strcpy (stringinput,"SYSTem:REMote\n");
//    status = viWrite (instr, (ViBuf)stringinput, (ViUInt32)strlen(stringinput), &writeCount);
    BOOL isSuccess = [self write:@"SYSTem:REMote"];
   
//    if (status < VI_SUCCESS)
//    {
//        printf ("Error writing to the device.\n");
//        status = viClose (instr);
//        status = viClose (defaultRM);
//        return false;
//    }
    
    return isSuccess;
    
}
//[ps write:@"OUTPut 1\n"];
//[ps write:@"INSTrument:NSELect 1\n"];//change the channel CH1
//[ps write:@"VOLTage 19.0\n"];//set the val value
//[ps write:@"INSTrument:NSELect 2\n"];//change the channel CH2
//[ps write:@"VOLTage 19.0\n"];//set the val value

//MEASure:VOLTage?\n
//MEASure:VOLTage? ALL\n
//NSString *OUT =[NSString alloc];
//[ps query:@"MEASure:VOLTage? ALL\n" output:&OUT];//read the vol value of two channels
//NSLog(OUT);
//static unsigned char buffer[100];
+(BOOL)write:(NSString *)string
{
    /* We will use the viWrite function to send the device the string "*IDN?\n",
     * asking for the device's identification.
     */
    @synchronized(self) {
        
        memcpy(stringinput, [string cStringUsingEncoding:NSASCIIStringEncoding], 2*[string length]);
        
        strcpy (stringinput,"\n");//*IDN?
        status = viWrite (instr, (ViBuf)stringinput, (ViUInt32)strlen(stringinput), &writeCount);
        if (status < VI_SUCCESS)
        {
            printf ("%s,Error writing to the device.\n",stringinput);
            [self close];
            return NO;
        }else{
            return YES;
        }
    }
}

+(NSString *)read
{
    @synchronized(self) {
        status = viRead (instr, buffer, 100, &retCount);
        if (status < VI_SUCCESS)
        {
            printf ("Error reading a response from the device.\n");
            return @"error";
        }
        else
        {
            printf ("\nData read: %*s\n", retCount, buffer);
            
            NSMutableString *hexString = [NSMutableString string];
            for (int i=0; i<sizeof(buffer); i++)
            {
                [hexString appendFormat:@"%c", buffer[i]];
            }
            NSString *str = (NSString *)hexString;
            return str;
            
        }
    }
}

+(void)close
{
    status = viClose (instr);
    status = viClose (defaultRM);
    printf ("Hit enter to continue.");
    fflush (stdin);
    getchar();
   // return ;
}
+(BOOL*)query:(NSString *)str output:(NSString **)ostr
{
    strcpy (stringinput,[str UTF8String]);
    status = viWrite (instr, (ViBuf)stringinput, (ViUInt32)strlen(stringinput), &writeCount);
    if (status < VI_SUCCESS)
    {
        printf ("Error writing to the device.\n");
        return false;
    }
    /*
     * Now we will attempt to read back a response from the device to
     * the identification query that was sent.  We will use the viRead
     * function to acquire the data.  We will try to read back 100 bytes.
     * This function will stop reading if it finds the termination character
     * before it reads 100 bytes.
     * After the data has been read the response is displayed.
     */
    status = viRead (instr, buffer, 100, &retCount);
    if (status < VI_SUCCESS)
    {
        printf ("Error reading a response from the device.\n");
        return false;
    }
    else
    {
        printf ("\nData read: %*s\n", retCount, buffer);
        NSMutableString *hexString = [NSMutableString string];
        for (int i=0; i<sizeof(buffer); i++)
        {
            [hexString appendFormat:@"%c", buffer[i]];
        }
        NSString *str = (NSString *)hexString;
        *ostr = [[NSString alloc] initWithBytes:buffer length:retCount encoding:NSUTF8StringEncoding];
    }
    return true;
}
@end
