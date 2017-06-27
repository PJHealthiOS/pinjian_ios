//
//  PayPageVO.h
//  GuaHao
//
//  Created by qiye on 16/4/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "UsedCouponsVO.h"

@interface PayPageVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * serialNo;
@property(strong) NSString * orderDetail;
@property(strong) NSNumber * reg_fee;
@property(strong) NSNumber * service_fee;
@property(strong) NSNumber * payRemainingTime;
@property(strong) NSNumber * actualPay;
@property(strong) NSNumber * banlance_pay;
@property(strong) NSNumber * pzType;
@property(strong) NSNumber * drugFee;
@property(strong) NSNumber * insurance_fee;
@property(strong) UsedCouponsVO * couponse_pay;
@property (nonatomic, strong)NSArray *orderFee;
@end
