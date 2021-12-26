//
//  PowerSupply.m
//  powerSupply
//
//  Created by gdadmin on 2018/6/22.
//  Copyright © 2018年 gdadmin. All rights reserved.
//

#import "PowerSupply.h"

@implementation PowerSupply
-(BOOL)Init:(NSString *)path andBaudRate:(unsigned)baud_rate
{
    isConnectPowerSupply = false;
    status=viOpenDefaultRM (&defaultRM);
    if (status < VI_SUCCESS)
    {
        printf ("Could not open a session to the VISA Resource Manager!\n");
        return false;
    }
    
    status = viOpen (defaultRM, [path UTF8String], VI_NULL, VI_NULL, &instr);
    if (status < VI_SUCCESS)
    {
        printf ("Cannot open a session to the device.\n");
        status = viClose (instr);
        status = viClose (defaultRM);
        return false;
    }
    /* Set the timeout to 5 seconds (5000 milliseconds). */
    status = viSetAttribute (instr, VI_ATTR_TMO_VALUE, 5000);
    
    /* Set the baud rate to 4800 (default is 9600). */
    status = viSetAttribute (instr, VI_ATTR_ASRL_BAUD, baud_rate);
    
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
    strcpy (stringinput,"SYSTem:REMote\n");
    status = viWrite (instr, (ViBuf)stringinput, (ViUInt32)strlen(stringinput), &writeCount);
    if (status < VI_SUCCESS)
    {
        printf ("Error writing to the device.\n");
        status = viClose (instr);
        status = viClose (defaultRM);
        return false;
    }
    isConnectPowerSupply = true;
    return true;
}

-(BOOL)write:(NSString *)str
{
    @synchronized(self){
        strcpy (stringinput,[str UTF8String]);
        status = viWrite (instr, (ViBuf)stringinput, (ViUInt32)strlen(stringinput), &writeCount);
        if (status < VI_SUCCESS)
        {
            printf ("Error writing to the device.\n");
            return false;
        }
    }
    return true;
}


-(NSString *)query:(NSString *)str output:(NSString **)ostr
{
    @synchronized(self){
    strcpy (stringinput,[str UTF8String]);
    status = viWrite (instr, (ViBuf)stringinput, (ViUInt32)strlen(stringinput), &writeCount);
    if (status < VI_SUCCESS)
    {
        printf ("Error writing to the device.\n");
        //return false;
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
}
    NSString *reply;
    if (status < VI_SUCCESS)
    {
        printf ("Error reading a response from the device.\n");
        //return false;
    }
    else
    {
        printf ("\nData read: %*s\n", retCount, buffer);
        NSMutableString *hexString = [NSMutableString string];
        for (int i=0; i<sizeof(buffer); i++)
        {
            [hexString appendFormat:@"%c", buffer[i]];
        }
        reply = (NSString *)hexString;
        
    }
    return reply;
    //return true;
}
@end
