//
//  pudding.h
//  DFU
//
//  Created by TOD on 2/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InstantPudding_API.h"

struct structPDCA
{
    __unsafe_unretained NSString* strSN;
    
    __unsafe_unretained NSString* station;
    __unsafe_unretained NSString* passflg;
    __unsafe_unretained NSString* startTime;
    __unsafe_unretained NSString* endTime;
    __unsafe_unretained NSString* mesOfFail;
    __unsafe_unretained NSString* initVolt;
    __unsafe_unretained NSString* initPer;
    __unsafe_unretained NSString* finalVolt;
    __unsafe_unretained NSString* finalPer;
    __unsafe_unretained NSString* testTime;
    __unsafe_unretained NSString* chargeSpeed;
    __unsafe_unretained NSString* criticalErrBegin;
    __unsafe_unretained NSString* criticalErrEned;
    
    __unsafe_unretained NSString* strSoftName;
    __unsafe_unretained NSString* strSoftVersion;
    __unsafe_unretained NSString* strTestPoint;
    BOOL      isNeedRelease;
    BOOL      isNeedStart;
};

@interface pudding : NSObject
{
@private
	IP_UUTHandle UID;
	IP_API_Reply reply;
	IP_TestSpecHandle testSpec;
	IP_TestResultHandle testResult;
	
	NSString* ErrorInfo;
	NSString* DoneErrorInfo;
	NSString* CommitErrorInfo;
	NSString* UartFileLog;
	NSString* DCSDFileLog;
}

@property(readwrite,copy) NSString* ErrorInfo;
@property(readwrite,copy) NSString* DoneErrorInfo;
@property(readwrite,copy) NSString* CommitErrorInfo;
@property(readwrite,copy) NSString* UartFileLog;
@property(readwrite,copy) NSString* DCSDFileLog;

-(BOOL) UUTStartTest;

-(BOOL) ValidateSerialNumber:(NSString*)sn;
-(BOOL) ValidateAMIOK:(NSString *)sn;
-(BOOL) AddAttribute:(NSString*) attributeName AttributeValue:(NSString*) attributeValue;
-(BOOL) AddBlob:(NSString*) fileName FilePath:(NSString*) filePath;
-(BOOL) SetStartTime:(time_t) startTime;
-(BOOL) SetEndTime:(time_t) endTime;
-(BOOL) UUTRelease;

-(NSString*) GetFailInfomation;
-(NSString*) GetSITEInfo;
-(NSString*)GetStationType;
-(NSString*)GetStationID;

-(BOOL) AddTestItem:(NSString*)itemName TestValue:(NSString*)testValue
		 TestResult:(NSString*)tr ErrorInfo:(NSString*)errorInfo Priority:(NSString*)priority;

-(BOOL) AddTestItemAndSubItems:(NSString*)itemName SubItems:(NSArray*)subItems TestValues:(NSArray*)testValues
				   TestResults:(NSArray*)tesetResults ErrorInfoes:(NSArray*)errorInfoes Priorities:(NSArray*)priorities;

-(BOOL) AddTestItemAndSubItems:(NSString*)itemName SubItems:(NSArray*)subItems
					LowerSpecs:(NSArray*)lowerSpecs UpperSpecs:(NSArray*)upperSpecs Units:(NSArray*)units
					TestValues:(NSArray*)testValues TestResults:(NSArray*)tesetResults
				   ErrorInfoes:(NSArray*)errorInfoes Priorities:(NSArray*)priorities;

-(BOOL) AddTestItem:(NSString*)itemName
		  LowerSpec:(NSString*)lowerSpec UpperSpec:(NSString*)upperSpec Unit:(NSString*)unit
		  TestValue:(NSString*)testValue TestResult:(NSString*)tr
		  ErrorInfo:(NSString*)errorInfo Priority:(NSString*)priority;

@end
