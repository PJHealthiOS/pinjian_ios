//
//  OrderVO.h
//  GuaHao
//
//  Created by qiye on 16/1/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"
#import "NSObject+MJExtension.h"
#import "OrderListVO.h"
#import "StatusLogVO.h"

@interface OrderVO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSNumber * status;
@property(strong) NSString * statusCn;
@property(strong) NSString * statusDesc;
@property(strong) NSArray * statusLogs;
@property(strong) NSString * serialNo;

@property(strong) NSString * servicePhone;
@property(strong) NSString * outpatientType;//普通  专家  特需
@property(strong) NSString * hospName;
@property(strong) NSString * hospDistance;
@property(strong) NSString * deptName;
@property(strong) NSString * visitDate;
@property(strong) NSString * visitSeq;
@property(strong) NSString * patientName;
@property(strong) NSString * patientIdcard;
@property(strong) NSNumber * acceptorOperation;

@property(strong) NSString * patientSex;
@property(strong) NSNumber * patientStatus;

@property(strong) NSString * patientBirthday;
@property(strong) NSString * patientMobile;
@property(strong) NSString * patientComments;
@property(strong) NSString * visitSeqNotice;

@property(strong) NSNumber * totalFee;
@property(strong) NSNumber * pzFee;
@property(strong) NSNumber * registrationFee;
@property(strong) NSNumber * serviceFee;
@property(strong) NSNumber * couponsePay;
@property(strong) NSNumber * discountPay;
@property(strong) NSNumber * actualPay;

@property(strong) NSString * acceptUser;
@property(strong) NSString * acceptDate;
@property(strong) NSString * acceptorMobile;
@property(strong) NSString * acceptQRCode;
@property(strong) NSString * ticketImgUrl;
@property(strong) NSString * getTicketQRCode;
@property(strong) NSString * doctorName;
@property(strong) NSString * payType;

@property(strong) NSNumber * payRemainingTime;//支付剩余时间
@property(strong) NSNumber * regRemainingTime;//挂号剩余时间
@property(strong) NSNumber *evaluated;

@property(strong) NSString * transferAddr;
@property(strong) NSString * transferTypeCn;
@property(strong) NSString * serviceTypeCn;
@property(assign) BOOL  onlineQueue;
@property(assign) BOOL canUpdateTime;
@property(strong) NSString * commentImgs;


@property(strong) NSArray * orderFeeTo;
@property(strong) NSArray * orderFeeFrom;




@property(strong) NSNumber * discountRate;//折扣
@property(strong) NSNumber * discountMoney;//折扣的钱
@property(copy) NSString * discountName;





-(OrderListVO *)getOrderListVO;
@end
