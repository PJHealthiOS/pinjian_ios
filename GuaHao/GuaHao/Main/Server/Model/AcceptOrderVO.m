//
//  AcceptOrderVO.m
//  GuaHao
//
//  Created by PJYL on 16/9/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AcceptOrderVO.h"

@implementation AcceptOrderVO
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
