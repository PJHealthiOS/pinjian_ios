//
//  ArticleListVO.m
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ArticleListVO.h"

@implementation ArticleListVO

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc" : @"descrption"
             };
}

@end
