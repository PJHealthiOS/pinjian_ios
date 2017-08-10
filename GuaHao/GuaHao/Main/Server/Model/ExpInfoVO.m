//
//  ExpInfoVO.m
//  GuaHao
//
//  Created by qiye on 16/4/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpInfoVO.h"

@implementation ExpInfoVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"patients" : @"PatientVO",
             @"servicePackages" : @"ServiceVO"
             };
}
@end
