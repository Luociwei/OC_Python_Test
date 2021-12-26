//
//  CutReponse.h
//  LUXSHARE_B435_WirelessCharge
//
//  Created by 罗词威 on 05/06/18.
//  Copyright © 2018年 Innrove. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CutResponseModel;

@interface CutReponse : NSObject

+(NSString *)cutReponse:(NSArray *)reponse keywords:(NSArray<CutResponseModel *> *)keywordArray UUTTestData:(NSMutableArray *) UUTTestData;

@end
