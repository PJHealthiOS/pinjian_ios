//
//  AccDetialVO.m
//  GuaHao
//
//  Created by PJYL on 2016/10/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccDetialVO.h"

@implementation AccDetialVO
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
