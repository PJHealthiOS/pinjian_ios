//
//  ShareVO.m
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ShareVO.h"

@implementation ShareVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"shareLogs" : @"ShareLogVO",
             @"shareRules" : @"ShareRuleVO"
             };
}
@end
