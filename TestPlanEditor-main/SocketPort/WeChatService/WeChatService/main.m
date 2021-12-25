//
//  main.m
//  10086_Service
//
//  Created by ciwei luo on 2020/1/14.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMGServiceListener.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        XMGServiceListener *listener = [XMGServiceListener new];
        [listener start];
         [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
