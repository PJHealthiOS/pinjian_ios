//
//  PointVO.h
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface PointVO : NSObject
@property(strong) NSNumber * point;
@property(strong) NSNumber * serialSignCount;
@property(strong) NSNumber * tomorrowPoint;
@property(strong) NSArray  * signDates;
@property(strong) NSArray  * couponses;//兑换券
@property(strong) NSString * validityOfExchangeCoupons;
@property BOOL openSignWarn;

@property(strong) NSNumber * toExpirePoint;//到期豆
@property(strong) NSNumber * currentPoint;//签到豆数
@property(strong) NSString * expireDate;
@property(strong) NSString * pointRuleUrl;
@property(strong) NSArray  * logs;

@end
