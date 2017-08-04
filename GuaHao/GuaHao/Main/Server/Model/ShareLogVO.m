//
//  ShareLogVO.m
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ShareLogVO.h"

@implementation ShareLogVO
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc" : @"desctiption"
             };
}
@end
