//
//  CreateOrderVO.m
//  GuaHao
//
//  Created by qiye on 16/5/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderVO.h"

@implementation CreateOrderVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"patients" : @"PatientVO"
             };
}
@end
