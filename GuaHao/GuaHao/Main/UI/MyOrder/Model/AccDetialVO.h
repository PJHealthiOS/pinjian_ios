//
//  AccDetialVO.h
//  GuaHao
//
//  Created by PJYL on 2016/10/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "OrderListVO.h"
#import "StatusLogVO.h"
#import "UsedCouponsVO.h"
@interface AccDetialVO : NSObject



@property(strong) NSNumber * id;
@property(strong) NSNumber * status;
@property(strong) NSString * statusCn;
@property(strong) NSString * statusDesc;
@property(strong) NSArray  * statusLogs;
@property(strong) NSString * serialNo;

@property(strong) NSString * serviceTypeCn;
@property(strong) NSString * patientName;
@property(strong) NSString * patientIdcard;
@property(strong) NSString * patientMobile;
@property(strong) NSString * hospName;
@property(strong) NSString * hospAddr;

@property(strong) NSString * transferTypeCn;//普通  专家  特需


@property(strong) NSString * transferAddr;
@property(strong) NSString * visitDate;


@property(strong) NSString * payTypeCn;


@property(strong) NSNumber * service_fee;
@property(strong) NSNumber * total_fee;
@property(strong) NSNumber * drugFee;
@property(strong) NSNumber * evaluated;
@property(strong) NSNumber * insurance_fee;
@property(strong) NSNumber * transfer_fee;

@property(strong) NSNumber * actual_pay;

@property(strong) NSNumber * banlance_pay;

@property(strong) UsedCouponsVO * couponse_pay;


@property(strong) NSNumber * pzType;

@property(strong) NSNumber * payRemainingTime;
@property(strong) NSString * waiterName;

@property(strong) NSString * waiterMobile;
@property(strong) NSString * ticketQrcode;
@property(assign) BOOL insured;

@property(strong) NSString * receiverName;
@property(strong) NSString * receiverMobile;
@property(strong) NSArray * illnessImgs;
@property(strong) NSArray * imgs;
@property(strong) NSNumber * canBeCancelled;


@end
