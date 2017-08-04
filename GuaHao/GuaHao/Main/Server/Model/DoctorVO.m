//
//  DoctorVO.m
//  GuaHao
//
//  Created by qiye on 16/4/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DoctorVO.h"

@implementation DoctorVO

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc" : @"description"
             };
}

-(BOOL)is3AG
{
    return _hospitalLevel.intValue == 1 ;
}
@end
