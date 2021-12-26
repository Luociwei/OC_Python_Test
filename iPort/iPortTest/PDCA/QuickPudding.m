//
//  QuickPudding.m
//  SippyCup
//
//  Created by Kai Huang on 9/17/15.
//  Copyright (c) 2015 Apple Inc. All rights reserved.
//

#import "QuickPudding.h"
#import "LogFile.h"

NSString * const kIPParametricKey = @"parametric_key";
NSString * const kIPLowerLimit    = @"lower_limit";
NSString * const kIPUpperLimit    = @"upper_limit";
NSString * const kIPValue         = @"value";
NSString * const kIPUnits         = @"units";
NSString * const kIPMessage       = @"message";
NSString * const kIPBooleanResult = @"result";

NSString * const kIPTestNameTree  = @"kIPTestNameTree";

NSString * const kTestGroupKey    = @"kTestGroupKey";

NSString * const kIPBlobName      = @"blob_name";
NSString * const kIPBlobData      = @"blob_value";


static inline bool handle_reply(IP_API_Reply reply)
{
	bool retval = IP_success(reply);
	if (!retval) {
		NSLog(@"IP_reply error: %s, IP_reply class: %d", IP_reply_getError(reply), IP_reply_getClass(reply));
       // [LogFile AddLog:DebugFOLDER FileName:debugFileName Content:[NSString stringWithFormat:@"Uploaded test result L:%@ to PDCA", !failed ? @"Succeed" : @"Failed"]];
	}

	IP_reply_destroy(reply);

	return retval;
}

NSArray *
param_map_to_array(NSDictionary *map)
{
	NSMutableArray *retval = [NSMutableArray array];
	for (id key in [map allKeys]) {
		id value = map[key];
		NSDictionary *d = @{ kIPParametricKey : key, kIPValue : value };
		[retval addObject:d];
	}

	return retval;
}

NSArray *
append_string_to_each_key(NSArray *dicts, NSString *to_add)
{
	NSMutableArray *retval = [NSMutableArray array];
	for (NSDictionary *dict in dicts) {
		NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
		NSString *key     = mdict[kIPParametricKey];
		NSString *new_key = [key stringByAppendingString:to_add];
		mdict[kIPParametricKey] = new_key;
		[retval addObject:mdict];
	}
	return retval;
}

@interface NSString(utf8_length)
- (size_t)UTF8Length;
@end


@implementation NSString(utf8_length)
- (size_t)UTF8Length
{
	/*
	 * XXX : mpetit :
	 *
	 *   A lot of people (me included, sometimes) unwisely
	 *   call IP functions like:
	 *
	 *      IP_xxx(..., [string UTF8String], [string length]);
	 *
	 *   This is plainly wrong... [string length] returns the
	 *   number of glyphs, but IP is asking for the number of
	 *   bytes.
	 */
	return strlen([self UTF8String]);
}
@end


@interface QuickPudding()

@property (assign) IP_UUTHandle uutHandle;

@property (retain) NSMutableDictionary *parametrics;
@property (retain) NSMutableDictionary *attributes;
@property (retain) NSMutableDictionary *blobs;

@property (retain) NSMutableOrderedSet *parametricKeys;
@property (retain) NSMutableOrderedSet *attributeKeys;
@property (retain) NSMutableOrderedSet *blobKeys;

@end

@implementation QuickPudding

- (id) init
{
	self = [super init];

	if (self) {
		self.uutHandle = NULL;

		self.parametrics = [NSMutableDictionary dictionary];
		self.attributes  = [NSMutableDictionary dictionary];
		self.blobs       = [NSMutableDictionary dictionary];

		self.parametricKeys = [NSMutableOrderedSet orderedSetWithCapacity:0];
		self.attributeKeys  = [NSMutableOrderedSet orderedSetWithCapacity:0];
		self.blobKeys       = [NSMutableOrderedSet orderedSetWithCapacity:0];

		self.priority = IP_PRIORITY_REALTIME_WITH_ALARMS;
	}

	return self;
}

- (void) dealloc
{
	self.uutHandle = nil;

	self.parametrics = nil;
	self.attributes  = nil;
	self.blobs       = nil;

	self.parametricKeys = nil;
	self.attributeKeys  = nil;
	self.blobKeys       = nil;

	self.limitsMap = nil;
}

- (bool) amIOkay:(NSString *)sn
{
	return handle_reply(IP_amIOkay(self.uutHandle, [sn UTF8String]));
}

- (void) startInstantPudding
{
	@synchronized(self) {
		IP_UUTHandle handle;
		handle_reply(IP_UUTStart(&handle));

		self.uutHandle = handle;
	}
}

- (NSString *)amIOKWithRespond:(NSString *)SN
{
    @synchronized(self) {
        
        IP_API_Reply replyAMIOK = IP_amIOkay(self.uutHandle, [SN UTF8String]);
        if (!IP_success(replyAMIOK)) {
            const char *errorInfo = " ";
            errorInfo = IP_reply_getError(replyAMIOK);
            NSString* failInfo = [NSString stringWithUTF8String:errorInfo];
            IP_reply_destroy(replyAMIOK);
            return failInfo;
        }
        IP_reply_destroy(replyAMIOK);
    }
    return @"PASS";
}
- (void)submitPuddingg:(BOOL)final_result
{
    if (!self.uutHandle) {
        return;
    }
    
    [self write_to_pudding];
    
    @synchronized(self) {
        
        handle_reply(IP_UUTDone(self.uutHandle));
        handle_reply(IP_UUTCommit(self.uutHandle, final_result ? IP_PASS : IP_FAIL));
        
        IP_UID_destroy(self.uutHandle);
        self.uutHandle = NULL;
    }
}

- (void) cancel
{
	if (self.uutHandle) {
		handle_reply(IP_UUTCancel(self.uutHandle));
	}
}

- (void) setSerialNumber:(NSString *)serial
{
	handle_reply(IP_addAttribute(self.uutHandle, IP_ATTRIBUTE_SERIALNUMBER, [serial UTF8String]));
}

- (void) setStationSoftwareName:(NSString *)sw_name
{
	handle_reply(IP_addAttribute(self.uutHandle, IP_ATTRIBUTE_STATIONSOFTWARENAME, [sw_name UTF8String]));
}

- (void) setStationSoftwareVersion:(NSString *)sw_vers
{
	handle_reply(IP_addAttribute(self.uutHandle, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, [sw_vers UTF8String]));
}

- (void) addAttributeValue:(NSString *)val forKey:(NSString *)key
{
	if (!val || !key) {
		@throw [NSException exceptionWithName:@"Attribute key/value cannot be nil" reason:nil userInfo:nil];
	}

	self.attributes[key] = val;
}


-(void)validateSerialNumber:(NSString *)str_SN
{
    IP_validateSerialNumber(self.uutHandle,[str_SN UTF8String]);
}



- (bool) allItemsPassedTestGroup:(NSString *)group_name failures:(NSArray **)fails
{
	NSString *pred_fmt = [NSString stringWithFormat:@"%@ == %@", kTestGroupKey, group_name];
	NSPredicate  *pred = [NSPredicate predicateWithFormat:pred_fmt];
	NSArray *group_params = [[self.parametrics allValues] filteredArrayUsingPredicate:pred];

	if (![group_params count]) {
		NSLog(@"No params found with group name '%@'", group_name);
		return false;
	}

	[self evaluateParameters:group_params failures:nil];

	pred_fmt = [NSString stringWithFormat:@"%@ == false", kIPBooleanResult];
	pred     = [NSPredicate predicateWithFormat:pred_fmt];
	NSArray *fail_params  = [group_params filteredArrayUsingPredicate:pred];

	if (![fail_params count]) {
		return true;
	}

	if (fails) {
		*fails = [NSArray arrayWithArray:fail_params];
	}

	return false;
}

- (bool) evaluateResult:(NSArray **)fails
{
	return [self evaluateParameters:[self.parametrics allValues] failures:fails];
}


- (bool) getOverallStatus:(NSArray **)fails
{
	NSString *fail_pred_fmt = [NSString stringWithFormat:@"%@ != nil && %@ == false", kIPBooleanResult, kIPBooleanResult];
	NSPredicate  *fail_pred = [NSPredicate predicateWithFormat:fail_pred_fmt];
	NSArray     *fail_items = [[self.parametrics allValues] filteredArrayUsingPredicate:fail_pred];
	
	if ([fail_items count] && fails) {
		*fails = [NSArray arrayWithArray:fail_items];
	}
	
	return ![fail_items count];
}

- (void)addParameter:(NSString *)param
			   value:(NSNumber *)value
{
	[self addParameter:param value:value upper:nil lower:nil];
}


- (void)addParameter:(NSString *)param
			   value:(NSNumber *)value
			   upper:(NSNumber *)upper
			   lower:(NSNumber *)lower
{
	[self addParameter:param value:value upper:upper lower:lower testNameTree:nil];
}

- (void)addParameter:(NSString *)param
			   value:(NSNumber *)value
			   upper:(NSNumber *)upper
			   lower:(NSNumber *)lower
		testNameTree:(NSArray  *)testNameTree
{
	NSDictionary *pdict =
	@{
	  kIPParametricKey : param,
	  kIPValue         : value,
	};

	NSMutableDictionary *mpd = [NSMutableDictionary dictionaryWithDictionary:pdict];

	if (upper)		  mpd[kIPUpperLimit]   = upper;
	if (lower)        mpd[kIPLowerLimit]   = lower;
	if (testNameTree) mpd[kIPTestNameTree] = testNameTree;

	[self.parametricKeys addObject:param];
	[self.parametrics setObject:mpd forKey:param];
}

- (void)addParametersWithDictionaries:(NSArray *)dictionaries
{
	if (!dictionaries) {
		return;
	}
	
	for (NSDictionary *each in dictionaries) {
		[self addParameterWithDictionary:each];
	}
}

- (void)addParameterWithDictionary:(NSDictionary *)paramd
{
    
	NSString *param_name = paramd[kIPParametricKey];

	NSMutableDictionary *mpd = [NSMutableDictionary dictionaryWithDictionary:paramd];
	[self.parametricKeys addObject:param_name];
	[self.parametrics setObject:mpd forKey:param_name];
}


- (void)addBooleanParam:(NSString *)param
				  value:(bool)val
				message:(NSString *)msg
{
	[self addBooleanParam:param value:val message:msg testNameTree:nil];
}

- (void)addBooleanParam:(NSString *)param
				  value:(bool)val
				message:(NSString *)msg
		   testNameTree:(NSArray  *)testNameTree
{
	NSDictionary *pdict =
	@{
	  kIPParametricKey : param,
	  kIPBooleanResult : @(val)
	};

	NSMutableDictionary *mpd = [NSMutableDictionary dictionaryWithDictionary:pdict];
	if (msg)		  mpd[kIPMessage]      = msg;
	if (testNameTree) mpd[kIPTestNameTree] = testNameTree;

	[self.parametricKeys addObject:param];
	[self.parametrics setObject:mpd forKey:param];
}
//*****************************************************************************
// Add Blob File
//*****************************************************************************
- (void)addBlobFile:(NSString*)fileName FilePath:(NSString*)filePath{
    @synchronized (self) {
        handle_reply(IP_addBlob(self.uutHandle,[fileName UTF8String],[filePath UTF8String]));
    }
}

- (void)addBlob:(NSString *)param value:(NSData *)value
{
	[self addBlobWithDictionary:@{
								 kIPBlobName : param,
								 kIPBlobData : value
								 }];
}

- (void)addBlobWithDictionary:(NSDictionary *)blobd
{
	[self.blobKeys addObject:blobd[kIPBlobName]];
	[self.blobs    setObject:[blobd copy] forKey:blobd[kIPBlobName]];
}

- (void) write_to_pudding
{
	[self addAttributeValue:StationSoftwareName()    forKey:@IP_ATTRIBUTE_STATIONSOFTWARENAME];
	[self addAttributeValue:StationSoftwareVersion() forKey:@IP_ATTRIBUTE_STATIONSOFTWAREVERSION];

	for (NSString *key in self.parametricKeys) {
		NSDictionary *pdict = self.parametrics[key];

		[self dictionary_to_pudding:pdict];
	}

	for (NSString *key in self.blobKeys) {
		NSDictionary *bdict = self.blobs[key];

		[self blob_to_pudding:bdict];
	}

	for (NSString *key in [self.attributes allKeys]) {
		NSString *attr = self.attributes[key];
		@synchronized(self) {
			handle_reply(IP_addAttribute(self.uutHandle, [key UTF8String], [attr UTF8String]));
		}
	}
}


- (void) dictionary_to_pudding:(NSDictionary *)pdict
{
	NSString *name     = [pdict[kIPParametricKey] stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSNumber *lower    = pdict[kIPLowerLimit];
	NSNumber *upper    = pdict[kIPUpperLimit];
	NSNumber *val      = pdict[kIPValue];
	NSString *units    = [pdict[kIPUnits]  stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *msg      = pdict[kIPMessage];
	NSNumber *result   = pdict[kIPBooleanResult];
	NSArray *sub_names = pdict[kIPTestNameTree];
    
    NSString *lower_lim = lower.integerValue ? [[lower stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""]: @(IP_NOVALUE);
    NSString *upper_lim = upper.integerValue ? [[upper stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""]: @(IP_NOVALUE);
    
//    if ([val.stringValue isEqualToString:@"27.55"]) {
//
//        BOOL b1 = [upper isEqualToNumber:@0];
//        BOOL b2 = lower.integerValue > upper.integerValue;
//        [LogFile AddLog:DebugFOLDER FileName:self.debugFileName Content:[NSString stringWithFormat:@"-----item:%@--low:%ld--upper:%ld--b1:%d--b2--%d",name,lower.integerValue,upper.integerValue,b1,b2]];
//    }
    if (![upper isEqualToNumber:@0]) {
        
        if (lower.integerValue > upper.integerValue) {//upper:200 lower:600
            NSString *temp_lower = lower_lim;
            lower_lim = upper_lim;
            upper_lim = temp_lower;
            
//            if (![result boolValue] &&[name containsString:@"cap"]) {
//
//                [LogFile AddLog:DebugFOLDER FileName:self.debugFileName Content:[NSString stringWithFormat:@"-----item:%@--lower_lim:%@--upper_lim:%@--",name,lower_lim,upper_lim]];
//            }
            
        }
    }

	NSString *val_str	=[NSString stringWithFormat:@"%0.2f",val.floatValue];//[[val stringValue] stringByReplacingOccurrencesOfString:@" "withString:@""]

	IP_TestResultHandle testResult = IP_testResult_create();
	IP_TestSpecHandle   testSpec   = IP_testSpec_create();


	if ([sub_names count] > 0) {
		IP_testSpec_setSubTestName(testSpec, [sub_names[0] UTF8String], [sub_names[0] UTF8Length]);
	}
	if ([sub_names count] > 1) {
		IP_testSpec_setSubSubTestName(testSpec, [sub_names[1] UTF8String], [sub_names[1] UTF8Length]);
	}
	if (val_str) {
		IP_testResult_setValue(testResult, [val_str UTF8String], [val_str UTF8Length]);
	}

	IP_testSpec_setTestName(testSpec, [name UTF8String], [name UTF8Length]);
	IP_testSpec_setLimits(testSpec, [lower_lim UTF8String], [lower_lim UTF8Length], [upper_lim UTF8String], [upper_lim UTF8Length]);
	IP_testSpec_setUnits(testSpec, [units UTF8String], [units UTF8Length]);
	IP_testResult_setResult(testResult, [result boolValue] ? IP_PASS : IP_FAIL);
	IP_testSpec_setPriority(testSpec, self.priority);

	if (![result boolValue]) {
		msg = msg ? msg : @"Fail";
		IP_testResult_setMessage(testResult, [msg UTF8String], [msg UTF8Length]);
	}

	@synchronized(self) {
		handle_reply(IP_addResult(self.uutHandle, testSpec, testResult));
	}

	IP_testResult_destroy(testResult);
	IP_testSpec_destroy(testSpec);
}

- (void)blob_to_pudding:(NSDictionary *)my_lovely_blob
{
	NSString *blob_name = [my_lovely_blob objectForKey:kIPBlobName];
	NSData   *blob_data = [my_lovely_blob objectForKey:kIPBlobData];
	
	if (blob_name && blob_data) {
		handle_reply(IP_addBlobData(self.uutHandle, [blob_name UTF8String], [blob_data bytes], [blob_data length]));
	}
}


- (bool) evaluateParameters:(NSArray *)params failures:(NSArray **)fails
{
	[params enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSMutableDictionary *pdict, NSUInteger idx, BOOL *stop) {

		NSString *param_name = pdict[kIPParametricKey];
		if (!pdict[kIPValue] && pdict[kIPBooleanResult]) {
			return;
		}

		NSNumber *val = pdict[kIPValue];
		NSNumber *usl = pdict[kIPUpperLimit];
		NSNumber *lsl = pdict[kIPLowerLimit];

		/* if limits are not specified already, check the limits map */

		if (!usl) {
			usl = self.limitsMap[param_name][kIPUpperLimit];
			if (usl) pdict[kIPUpperLimit] = usl;
		}

		if (!lsl) {
			lsl = self.limitsMap[param_name][kIPLowerLimit];
			if (lsl) pdict[kIPLowerLimit] = lsl;
		}

		bool i_res = true;
		if (lsl) i_res &= [val isGreaterThanOrEqualTo:lsl];
		if (usl) i_res &= [val isLessThanOrEqualTo:usl];

		pdict[kIPBooleanResult] = @(i_res);
	}];

	NSString *fail_pred_fmt = [NSString stringWithFormat:@"%@ != nil && %@ == false", kIPBooleanResult, kIPBooleanResult];
	NSPredicate  *fail_pred = [NSPredicate predicateWithFormat:fail_pred_fmt];
	NSArray     *fail_items = [[self.parametrics allValues] filteredArrayUsingPredicate:fail_pred];

	if ([fail_items count] && fails) {
		*fails = [NSArray arrayWithArray:fail_items];
	}

	return ![fail_items count];
}

- (void) setDUTPos:(NSString *)fixture_id headID:(NSString *)head_id
{
	handle_reply(IP_setDUTPos(self.uutHandle, [fixture_id UTF8String], [head_id UTF8String]));
}





- (void)destroyPudding:(BOOL)final_result
{
    if (!self.uutHandle) {
        return;
    }
    [self addAttributeValue:StationSoftwareName()    forKey:@IP_ATTRIBUTE_STATIONSOFTWARENAME];
    [self addAttributeValue:StationSoftwareVersion() forKey:@IP_ATTRIBUTE_STATIONSOFTWAREVERSION];
    @synchronized(self) {
        
        handle_reply(IP_UUTDone(self.uutHandle));
        handle_reply(IP_UUTCommit(self.uutHandle, final_result ? IP_PASS : IP_FAIL));
        
        IP_UID_destroy(self.uutHandle);
        self.uutHandle = NULL;
    }
}

- (BOOL)submitPudding:(BOOL)final_result
{
    //final_result = YES;
	if (!self.uutHandle) {
		return NO;
	}

	[self write_to_pudding];

	@synchronized(self) {

		IP_API_Reply doneReply =(IP_UUTDone(self.uutHandle));
        bool isDone = IP_success(doneReply);
        if (!isDone) {
            [LogFile AddLog:DebugFOLDER FileName:self.debugFileName Content:[NSString stringWithFormat:@"IP_reply error: %s, IP_reply class: %d,final_result:%d", IP_reply_getError(doneReply), IP_reply_getClass(doneReply),final_result]];
        }
        IP_reply_destroy(doneReply);
        
		//handle_reply(IP_UUTCommit(self.uutHandle, final_result ? IP_PASS : IP_FAIL));
        IP_API_Reply commitReply =IP_UUTCommit(self.uutHandle, final_result ? IP_PASS : IP_FAIL);
        bool isCommit = IP_success(commitReply);
        
        if (!isCommit) {
//            NSLog(@"IP_reply error: %s, IP_reply class: %d", IP_reply_getError(reply), IP_reply_getClass(reply));
            [LogFile AddLog:DebugFOLDER FileName:self.debugFileName Content:[NSString stringWithFormat:@"IP_reply error: %s, IP_reply class: %d，final_result:%d", IP_reply_getError(commitReply), IP_reply_getClass(commitReply),final_result]];
        }
        
        IP_reply_destroy(commitReply);
		IP_UID_destroy(self.uutHandle);
		self.uutHandle = NULL;
        return isCommit&&isDone;
	}
}

- (bool) AddTestItem:(NSString*)itemName TestValue:(NSString*)testValue TestResult:(NSString*)testResult HighLimit:(NSString*)high_Limit LowLimit:(NSString*)low_Limit Units:(NSString*)units ErrorInfo:(NSString*)errorInfo Priority:(NSString*)priority logfile:(NSString*)fileName{
    //Need to make sure the units are set to something
//    if([highLimit isEqualToString:@""])
//    {
//        highLimit = @"N/A";
//    }
//    if([lowLimit isEqualToString:@""])
//    {
//        lowLimit = @"N/A";
//    }
//    if([units isEqualToString:@""])
//    {
//        units = @"N/A";
//    }
    
    //need to trim error info to a max of 512
    
    NSString *lower_lim = [low_Limit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *upper_lim = [high_Limit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    

    if (upper_lim.integerValue !=0) {
        
        if (lower_lim.integerValue > upper_lim.integerValue) {//upper:200 lower:600
            NSString *temp_lower = lower_lim;
            lower_lim = upper_lim;
            upper_lim = temp_lower;

        }
    }
    
    if (lower_lim.integerValue ==0 ) {
        lower_lim = @"NA";
    }
    if (upper_lim.integerValue ==0 ) {
        upper_lim = @"NA";
    }
    
    if([errorInfo length]>512)
        errorInfo = [errorInfo substringToIndex:512];
    
    IP_TestSpecHandle specHandle = IP_testSpec_create();
    if (!specHandle) {
        NSLog(@"Error: IP_testSpec_create :%@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testSpec_create :%@",itemName]]];
        specHandle = NULL;
        return NO;
    }
    IP_TestResultHandle resultHandle = IP_testResult_create();
    if (!resultHandle) {
        NSLog(@"Error: IP_testResult_create: %@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testResult_create:%@",itemName]]];
        resultHandle = NULL;
        return NO;
    }
    
    // set the item parameter
    // name
    BOOL bol_SetItem = IP_testSpec_setTestName(specHandle,[itemName UTF8String],[itemName length]);
    if (!bol_SetItem) {
        NSLog(@"Error: IP_testSpec_setTestName: %@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testSpec_setTestName: %@", itemName]]];
        return NO;
    }
    // priority
    bol_SetItem = IP_testSpec_setPriority(specHandle, [priority intValue]);
    if (!bol_SetItem) {
        NSLog(@"Error: IP_testSpec_setPriority: %@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testSpec_setPriority: %@", itemName]]];
        return NO;
    }
    // pass result
    if ([[testResult uppercaseString] isEqualToString:@"PASS"]) {
        bol_SetItem = IP_testResult_setResult(resultHandle, IP_PASS);
        if (!bol_SetItem) {
            NSLog(@"Error: IP_testResult_setResult IP_PASS: %@",itemName);
            [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testResult_setResult IP_PASS: %@",itemName]]];
            return NO;
        }
    }else if([[testResult uppercaseString] isEqualToString:@"FAIL"]){
        bol_SetItem = IP_testResult_setResult(resultHandle, IP_FAIL);
        BOOL bol_SetErrorInfo = IP_testResult_setMessage(resultHandle, [errorInfo UTF8String], [errorInfo length]);
        if (!bol_SetItem || !bol_SetErrorInfo) {
            NSLog(@"Error: IP_testResult_setResult IP_FAIL: %@",itemName);
            [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testResult_setResult IP_FAIL: %@",itemName]]];
            return NO;
        }
    }else{
        bol_SetItem = IP_testResult_setResult(resultHandle, IP_NA);
        if (!bol_SetItem) {
            NSLog(@"Error: IP_testResult_setResult IP_NA: %@",itemName);
            [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testResult_setResult IP_NA: %@",itemName]]];
            return NO;
        }
    }
    // just digit can set test value otherwise do not do it
//    if ([Utilities isAllDigits:testValue]) {
    // limits
    bol_SetItem = IP_testSpec_setLimits(specHandle, [lower_lim UTF8String], [lower_lim length], [upper_lim UTF8String], [upper_lim length]);
    if (!bol_SetItem) {
        NSLog(@"Error: IP_testSpec_setLimits: %@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testSpec_setLimits: %@", itemName]]];
        return NO;
    }
    
    // units
    bol_SetItem = IP_testSpec_setUnits(specHandle, [units UTF8String], [units length]);
    if (!bol_SetItem) {
        NSLog(@"Error: IP_testSpec_setUnits: %@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testSpec_setUnits: %@", itemName]]];
        return NO;
    }
    
    // set value
    bol_SetItem = IP_testResult_setValue(resultHandle, [testValue UTF8String], [testValue length]);
    if (!bol_SetItem) {
        NSLog(@"Error: IP_testResult_setValue: %@", itemName);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"Error: IP_testResult_setValue: %@", itemName]]];
        return NO;
    }
//    }
    
    // set result
    IP_API_Reply replyAddResult = IP_addResult(self.uutHandle, specHandle, resultHandle);
    if (!IP_success(replyAddResult)) {
        const char*errorInfo = " ";
        errorInfo = IP_reply_getError(replyAddResult);
        NSString* failInfo = [NSString stringWithFormat:@"Error: IP_addResult: %@", [NSString stringWithUTF8String:errorInfo]];
        NSLog(@"PDCA%@",failInfo);
        [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"PDCA%@",failInfo]]];
        return NO;
    }
    [LogFile AddLog:DebugFOLDER FileName:fileName Content:[NSString stringWithFormat:@"%@ %@",[LogFile CurrentTimeForLog],[NSString stringWithFormat:@"upload succeed"]]];
    return YES;
    
}

@end


NSString * StationSoftwareName()
{
	NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];

	return name;
}

NSString * StationSoftwareVersion()
{
	NSBundle *bundle        = [NSBundle mainBundle];
	NSString *version       = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	NSArray  *version_parts = [version componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *version_main  = [version_parts componentsJoinedByString:@"_"];

	return version_main;
}
