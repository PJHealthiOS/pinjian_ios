//
//  OrderListVO.h
//  GuaHao
//
//  Created by qiye on 16/6/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface OrderListVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * orderStatus;
@property(strong) NSNumber * paymentStatus;
@property(strong) NSNumber * payRemainingTime;
@property(strong) NSNumber * orderType;

@property(strong) NSString * hospitalDistance;
@property(strong) NSString * hospitalName;
@property(strong) NSString * patientName;
@property(strong) NSString * patientSex;
@property(strong) NSNumber * regRemainingTime;
@property(strong) NSString * serialNo;
@property(strong) NSNumber * status;
@property(strong) NSString * statusCn;
@property(strong) NSString * visitDate;
@property(strong) NSString * statusDesc;
@property(strong) NSNumber * visitType; //0预约   1 挂号
@property(strong) NSNumber * pzType; //0全程   1 报告 2 取药
@property(strong) NSString * serviceTypeCn;
@property(strong) NSNumber * evaluated;
@property BOOL hasBeenAccepted;

@end
