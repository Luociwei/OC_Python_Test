//
//  NSString+Extension.h
//  
//
//  Created by ciwei luo on 2020/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/*
 NSString+Cut
 */
-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to;
-(NSString *)cw_getSubstringFromIndex:(NSInteger)fromIndex toLength:(NSInteger)length;
-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from;
-(NSString *)cw_getSubstringFromString:(NSString *)from toLength:(NSInteger)length;
-(NSString *)cw_deleteSpecialCharacter:(NSString *)chargcter;

+(NSString *)cw_returnJoinStringWithArray:(NSArray *)array;


-(NSArray *)cw_componentsSeparatedByString:(NSString *)separate;
-(NSString *)cw_getSubstringSeparate:(NSString *)separate index:(NSInteger)index;
-(NSString *)cw_getSubstringFromStringToEnd:(NSString *)from separate:(NSString *)separate index:(NSInteger)index;
-(NSString *)cw_getStringBetween:(NSString *)from and:(NSString *)to separate:(NSString *)separate index:(NSInteger)index;




/*
 NSString+Path
 */
+(NSString *)cw_getDesktopPath;

+(NSString *)cw_getUserPath;

+(NSString *)cw_getResourcePath;
+(NSMutableArray *)cw_getFileNameListInDirPath:(NSString *)filePath str1:(NSString *)str1;
+(NSMutableArray *)cw_getFileNameListInDirPath:(NSString *)filePath str1:(NSString *)str1 str2:(NSString *)str2;



/*
 NSString+Date
 */
+(NSString *)cw_stringFromCurrentDateTimeWithSecond;

+(NSString *)cw_stringFromCurrentDateTimeWithMicrosecond;

+(time_t)cw_Time_tSince1970;

+(NSString *)cw_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;


+ (NSString *)cw_dictionaryToJSONString:(NSDictionary *)dictionary;
+ (NSString *)cw_arrayToJSONString:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
