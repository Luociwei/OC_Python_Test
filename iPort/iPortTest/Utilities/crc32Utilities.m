//
//  crc32Utilities.m
//  iPortTest
//
//  Created by YangZhiyong on 4/6/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "crc32Utilities.h"

@implementation crc32Utilities

+ (uLong)crc32WithFilePath:(NSString *)filePath {
    return [self crc32WithData:[NSData dataWithContentsOfFile:filePath]];
}
+ (uLong)crc32WithData:(NSData *)data {
    uLong crc = crc32(0, Z_NULL, 0);
    return crc32(crc, data.bytes, (uInt)data.length);
}
@end
