//
//  PointVO.m
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PointVO.h"

@implementation PointVO

+ (NSDictionary *)objectClassInArray{
    return @{
             @"signDates" : @"SignDateVO",
             @"couponses" : @"MyCouponsVO",
             @"logs"      : @"LogsVO"
             };
}
@end
