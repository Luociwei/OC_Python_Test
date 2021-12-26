//
//  PlistUtilities.h
//  MYAPP
//
//  Created by Zaffer.yang on 3/8/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistUtilities : NSObject
+ (NSDictionary *)loadFile:(NSString *)file;
+ (NSArray *)loadFile:(NSString *)file forProduct:(NSString *)productName;
+ (id)propertyListWithCommentsRemovedFromOriginal:(id)plist withCommentMarker:(NSString *)marker;
@end
