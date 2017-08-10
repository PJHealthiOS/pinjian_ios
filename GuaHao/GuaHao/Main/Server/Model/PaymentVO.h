//
//  PaymentVO.h
//  GuaHao
//
//  Created by qiye on 16/4/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsedCouponsVO.h"
#import "NSObject+MJExtension.h"

@interface PaymentVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * discountMoney;
@property(strong) UsedCouponsVO * userCoupons;
@end
