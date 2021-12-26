//
//  crc32Utilities.h
//  iPortTest
//
//  Created by YangZhiyong on 4/6/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"

@interface crc32Utilities : NSObject
+ (uLong)crc32WithFilePath:(NSString *)filePath;
@end
