//
//  PythonClass.h
//  callclipy
//
//  Created by gdadmin on 2018/6/25.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PythonClass : NSObject
{
    BOOL isOpen;
    NSTask *task;
    NSPipe *readPipe;
    NSFileHandle *readHandle;
    NSPipe *writePipe;
    NSFileHandle *writeHandle;
}
-(BOOL)Init:(NSString*)path port:(NSString*) portName;
-(NSString*)send:(NSString*)command;
-(NSString*)timeoutsend:(NSString*)command;
-(BOOL)close;
-(BOOL)isOpen;
@end
