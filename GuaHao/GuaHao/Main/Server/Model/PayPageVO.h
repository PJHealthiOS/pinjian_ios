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


@property(strong) NSNumber * discountMoney;///折扣的钱
@property(strong) NSNumber * discountRate;///几折
@property(strong) NSNumber * registrationFee;////挂号费
@property(strong) NSNumber * banlance;///可用余额
@property(strong) NSNumber * pzFee;///陪诊费用
@property(copy) NSString * discountName;

@end
