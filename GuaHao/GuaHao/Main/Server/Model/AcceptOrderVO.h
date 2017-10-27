//
//  AcceptOrderVO.h
//  GuaHao
//
//  Created by PJYL on 16/9/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"
#import "NSObject+MJExtension.h"
#import "OrderListVO.h"
#import "StatusLogVO.h"
@interface AcceptOrderVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * visitType;///0表示挂号单 1表示预约单
@property(strong) NSNumber * status; //订单接单状态  1待接单 2待上传 3 待审核  4 审核失败 9已完成  10已取消
@property(strong) NSString * statusCn;
@property(strong) NSString * statusDesc;
@property(strong) NSArray * statusLogs;
@property(strong) NSString * servicePhone;
@property(strong) NSString * serialNo;
@property(strong) NSString * orderType;
@property(strong) NSString * outpatientType;//普通  专家  特需
@property(strong) NSString * hospName;
@property(strong) NSString * deptName;
@property(strong) NSString * hospitalName;
@property(strong) NSString * departmentName;
@property(strong) NSString * hospDistance;
@property(strong) NSString * visitDate;
@property(strong) NSString * patientName;
@property(strong) NSString * patientIdcard;
@property(strong) NSString * patientSex;
@property(strong) NSNumber * patientStatus;

@property(strong) NSString * patientBirthday;
@property(strong) NSString * patientMobile;
@property(strong) NSString * patientComments;

@property(strong) NSNumber * totalFee;
@property(strong) NSNumber * serviceFee;
@property(strong) NSNumber * couponsePay;
@property(strong) NSNumber * discountPay;
@property(strong) NSNumber * actualPay;
@property(strong) NSNumber * operation;

@property(strong) NSString * acceptDate;
@property(strong) NSString * acceptorMobile;
@property(strong) NSString * acceptQRCode;
@property(strong) NSString * ticketImgUrl;
@property(strong) NSString * getTicketQRCode;
@property(strong) NSNumber * visitSeq;
@property(strong) NSNumber * payRemainingTime;//支付剩余时间
@property(strong) NSNumber * regRemainingTime;//挂号剩余时间
@property(strong) NSNumber * qrPaidStatus;///0无需出现扫码支付显示  1.待扫码支付    2.扫码支付成功 当值为0时，界面不显示扫码支付提示，不进行轮询 当值为1时，界面显示待扫码支付提示，进行轮询（5秒一次，保持进度条存在） 当值为2时，界面显示扫码支付成功提示，不进行轮询
-(OrderListVO *)getOrderListVO;
@end
