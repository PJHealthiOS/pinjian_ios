
//
//  MyCouponsVO.m
//  GuaHao
//
//  Created by 123456 on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MyCouponsVO.h"

@implementation MyCouponsVO

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc" : @"description"
             };
}
@end
