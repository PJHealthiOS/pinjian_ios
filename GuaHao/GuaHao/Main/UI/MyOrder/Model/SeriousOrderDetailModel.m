//
//  SeriousOrderDetailModel.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousOrderDetailModel.h"

@implementation SeriousOrderDetailModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"statusLogs" : @"StatusLogVO",
             @"doctors":@"SeriousDetailModel"
             };
}
@end
