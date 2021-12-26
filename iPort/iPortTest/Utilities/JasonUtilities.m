//
//  JasonUtilities.m
//  iPortTest
//
//  Created by Zaffer.yang on 3/18/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "JasonUtilities.h"

@implementation JasonUtilities

+(NSDictionary*)loadJSONContentToDictionaryWithWholePath:(NSString*)JSONFilePath
{
    NSDictionary* dicContent = nil;
    NSData *dataOfJSON;
    id JSONContent;
    
#ifdef DEBUG
    NSLog(@"Path of demo type JSON file = %@", JSONFilePath);
#endif
    
    dataOfJSON = [NSData dataWithContentsOfFile:JSONFilePath];
    if (dataOfJSON == nil)
    {
        return nil;
    }
    JSONContent = [NSJSONSerialization JSONObjectWithData:dataOfJSON
                                                  options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers
                                                    error:nil];
    
    if (JSONContent==nil || ![JSONContent isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Invalid parameter.");
    }
    else
    {
        dicContent = (NSDictionary*)JSONContent;
    }
    
    return dicContent;
}



+(NSDictionary*)loadJSONContentToDictionaryWithNoOrder:(NSString*)JSONFilePath
{
    NSString *ProjectPath;
    NSString *filePathOfJSON;
    
    ProjectPath= [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    filePathOfJSON = [ProjectPath stringByAppendingFormat:JSONFilePath,nil];
    
#ifdef DEBUG
    NSLog(@"Path of demo type JSON file = %@", filePathOfJSON);
#endif
    
    return [self loadJSONContentToDictionaryWithWholePath:filePathOfJSON];
}


+(NSDictionary*)loadJSONContentToDictionary:(NSString*)jsonData{
    NSDictionary* jsonDic = nil;
    NSData *data = [NSData dataWithBytes:[jsonData UTF8String] length:[jsonData length]];
    
    jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers
                                                    error:nil];
    return jsonDic;
}
@end
