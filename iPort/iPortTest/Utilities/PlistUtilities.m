//
//  PlistUtilities.m
//  MYAPP
//
//  Created by Zaffer.yang on 3/8/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "PlistUtilities.h"

@implementation PlistUtilities

#pragma mark - Load Config
+ (NSArray *)loadFile:(NSString *)file forProduct:(NSString *)productName
{
    NSArray *ResDic = nil;
    if ([productName compare:@"UNKNOWN"] != NSOrderedSame)
    {
        // Load the config and testscript
        NSString *ResourceName = [NSString stringWithFormat:@"%@_%@", productName, file];
        NSString *ResourcePath = [[NSBundle mainBundle] pathForResource:ResourceName ofType:@"plist"];
        if (ResourcePath == nil)
        {
            
            NSString *errMsg = [NSString stringWithFormat:@"Can't find the resource file %@_%@",
                                ResourceName, ResourcePath];
            @throw [NSException exceptionWithName:@"Invalid resource name" reason:errMsg userInfo:nil];
            return nil;
        }
        NSData *ResourceData = [NSData dataWithContentsOfFile:ResourcePath];
        NSDictionary *rawDic = [NSPropertyListSerialization propertyListWithData:ResourceData options:0 format:NULL error:NULL];
        ResDic = [PlistUtilities propertyListWithCommentsRemovedFromOriginal:rawDic withCommentMarker:@"//"];
#if (DEBUG == 1)
        NSLog(@"%@", ResDic);
#endif
    }
    return ResDic;
}
+ (NSDictionary *)loadFile:(NSString *)file
{
    NSDictionary * ResDic = nil;
    
    // Load the config and testscript
    //    NSString *ResourceName = [NSString stringWithFormat:@"%@_%@", productName, file];
    NSString *ResourcePath = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    if (ResourcePath == nil)
    {
        
        NSString *errMsg = [NSString stringWithFormat:@"Can't find the resource file %@",ResourcePath];
        @throw [NSException exceptionWithName:@"Invalid resource name" reason:errMsg userInfo:nil];
        return nil;
    }
    
    NSData *ResourceData = [NSData dataWithContentsOfFile:ResourcePath];
    //    NSDictionary * rawDic = [NSPropertyListSerialization propertyListWithData:ResourceData options:0 format:NULL error:NULL];
    //    ResDic = [PlistUtilities propertyListWithCommentsRemovedFromOriginal:rawDic withCommentMarker:@"//"];
    NSError *error = nil;
    ResDic = [NSJSONSerialization JSONObjectWithData:ResourceData options:NSJSONReadingAllowFragments error:&error];
#if (DEBUG == 1)
    NSLog(@"%@", ResDic);
#endif
    return ResDic;
}
+ (id)propertyListWithCommentsRemovedFromOriginal:(id)plist withCommentMarker:(NSString *)marker
{
    return recursiveCommentRemover(plist, [NSArray arrayWithObject:marker]);
}
id recursiveCommentRemover(id object, NSArray *markers)
{
    id retval = nil;
    
    if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *array = object;
        NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[array count]];
        for (id subObject in array)
        {
            id parsedObject = recursiveCommentRemover(subObject, markers);
            if (parsedObject != nil)
                [newArray addObject:parsedObject];
        }
        
        retval = [NSArray arrayWithArray:newArray];
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = object;
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
        NSArray *keys = [dict allKeys];
        
        for (NSString *key in keys)
        {
            id subObject = [dict objectForKey:key];
            id parsedObject = recursiveCommentRemover(subObject, markers);
            if (parsedObject != nil)
                [newDict setObject:parsedObject forKey:key];
        }
        
        retval = [NSDictionary dictionaryWithDictionary:newDict];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        NSString *str = object;
        if (stringContainsAnyOfPrefixes(str, markers) == NO)
        {
            retval = object;
        }
    }
    else
    {
        retval = object;
    }
    
    return retval;
}
BOOL stringContainsAnyOfPrefixes(NSString *str, NSArray *prefixes)
{
    for (NSString *prefix in prefixes)
    {
        if ([str hasPrefix:prefix])
        {
            return YES;
        }
    }
    
    return NO;
}
@end
