//
//  PoolPDCA.h
//  PoolingTest
//
//  Created by tod on 6/16/14.
//  Copyright (c) 2014 MINI-007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pudding.h"

@interface PoolPDCA : NSObject
{
    pudding *PDCA;
}

+(PoolPDCA*)Instance;

@property(readwrite)BOOL isPDCAStart;
@property(readwrite)BOOL hasWritePDCAAtrribute;


-(void)PDCAStart:(struct structPDCA)structPDCAAtrribute;
-(void)PDCARelease:(struct structPDCA)structPDCAAtrribute;
-(void)WritePDCAAttribute:(struct structPDCA)structPDCAAtrribute;
-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue andPointNum:(uint8)pointIndex
;
-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue str_PDCA:(NSString*)str_PDCA;
-(NSString*)PDCA_GetStationID;

-(void)WritePoolResultItemPDCA:(NSString*) strName andValue:(NSString*)strValue andLowerSpec:(NSString*)strLowerSpec andUpperSpec:(NSString*)strUpperSpec andUnit:(NSString*)strUnit andIsPass:(NSString*)isPass andPointNum:(uint8)pointIndex;

@end
