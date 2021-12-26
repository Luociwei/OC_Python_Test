//
//  QuickPudding.h
//
//
//  Created by Kai Huang on 9/17/15.
//  Copyright (c) 2015 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstantPudding_API.h"


extern NSString * const kIPParametricKey;
extern NSString * const kIPLowerLimit;
extern NSString * const kIPUpperLimit;
extern NSString * const kIPValue;
extern NSString * const kIPUnits;
extern NSString * const kIPMessage;
extern NSString * const kIPBooleanResult;

extern NSString * const kIPTestNameTree;

extern NSString * const kTestGroupKey;

extern NSString * const kIPBlobName;
extern NSString * const kIPBlobData;


#ifdef __cplusplus
extern "C" {
#endif

NSString * StationSoftwareName();
NSString * StationSoftwareVersion();


NSArray * append_string_to_each_key(NSArray *dicts, NSString *to_add);
NSArray * param_map_to_array(NSDictionary *map);

#ifdef __cplusplus
}
#endif



@interface QuickPudding : NSObject

- (void) startInstantPudding;
- (BOOL)submitPudding:(BOOL)final_result;
- (void)submitPuddingg:(BOOL)final_result;
- (void) cancel;
- (bool) amIOkay:(NSString *)sn;
- (NSString *)amIOKWithRespond:(NSString *)SN;


- (void) setSerialNumber:(NSString *)serial;
- (void) setStationSoftwareName:(NSString *)sw_name;
- (void) setStationSoftwareVersion:(NSString *)sw_vers;
- (void) setDUTPos:(NSString *)fixture_id headID:(NSString *)head_id;


- (void) addAttributeValue:(NSString *)val forKey:(NSString *)key;


- (bool) allItemsPassedTestGroup:(NSString *)group_name failures:(NSArray **)fails;
- (bool) evaluateParameters:(NSArray *)params failures:(NSArray **)fails;
- (bool) evaluateResult:(NSArray **)fails;

- (bool) getOverallStatus:(NSArray **)fails;

- (void)addParameter:(NSString *)param value:(NSNumber *)value;
- (void)addParameter:(NSString *)param value:(NSNumber *)value upper:(NSNumber *)upper lower:(NSNumber *)lower;
- (void)addParameter:(NSString *)param value:(NSNumber *)value upper:(NSNumber *)upper lower:(NSNumber *)lower testNameTree:(NSArray  *)testNameTree;

- (void)addBooleanParam:(NSString *)param value:(bool)val message:(NSString *)msg;
- (void)addBooleanParam:(NSString *)param value:(bool)val message:(NSString *)msg testNameTree:(NSArray  *)testNameTree;

- (void)addParameterWithDictionary:(NSDictionary *)paramd;
- (void)addParametersWithDictionaries:(NSArray *)dictionaries;

- (void)addBlob:(NSString *)param value:(NSData *)value;
- (void)addBlobWithDictionary:(NSDictionary *)blobd;
- (void)addBlobFile:(NSString*)fileName FilePath:(NSString*)filePath;
- (bool) AddTestItem:(NSString*)itemName
           TestValue:(NSString*)testValue
          TestResult:(NSString*)testResult
           HighLimit:(NSString*)highLimit
            LowLimit:(NSString*)lowLimit
               Units:(NSString*)units
           ErrorInfo:(NSString*)errorInfo
            Priority:(NSString*)priority
             logfile:(NSString*)fileName;

@property (retain) NSDictionary *limitsMap;
- (void)destroyPudding:(BOOL)final_result;
-(void)validateSerialNumber:(NSString *)str_SN;
@property (readonly) IP_UUTHandle uutHandle;
@property (assign) enum IP_PDCA_PRIORITY priority; /* by default IP_PRIORITY_REALTIME_WITH_ALARMS */
@property (copy) NSString *debugFileName;
@end
