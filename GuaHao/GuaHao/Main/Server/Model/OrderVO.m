//
//  OrderVO.m
//  GuaHao
//
//  Created by qiye on 16/1/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderVO.h"

@implementation OrderVO


-(OrderListVO *)getOrderListVO
{
    OrderListVO * listVO = [OrderListVO new];
    listVO.id = self.id;
    return listVO;
}
+ (NSDictionary *)objectClassInArray{
    return @{
             @"statusLogs" : @"StatusLogVO"
             };
}
@end
