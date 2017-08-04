//
//  AccompanyOrderVO.m
//  GuaHao
//
//  Created by PJYL on 16/10/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccompanyOrderVO.h"

@implementation AccompanyOrderVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"patients" : @"PatientVO"
             };
}
@end
