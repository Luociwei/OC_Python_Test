//
//  MapView.m
//  iPort
//
//  Created by Zaffer.Yang on 7/21/17.
//  Copyright © 2017 Zaffer.yang. All rights reserved.
//

#import "MapView.h"

@implementation MapView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect        bounds = [self bounds];
    //fill background
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor blackColor] setStroke];
    [NSBezierPath strokeRect:bounds];
}

@end
