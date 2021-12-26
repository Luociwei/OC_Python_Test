//
//  JasonUtilities.h
//  iPortTest
//
//  Created by Zaffer.yang on 3/18/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JasonUtilities : NSObject
+(NSDictionary*)loadJSONContentToDictionary:(NSString*)jsonData;
+(NSDictionary*)loadJSONContentToDictionaryWithNoOrder:(NSString*)JSONFilePath;
+(NSDictionary*)loadJSONContentToDictionaryWithWholePath:(NSString*)JSONFilePath;

@end
