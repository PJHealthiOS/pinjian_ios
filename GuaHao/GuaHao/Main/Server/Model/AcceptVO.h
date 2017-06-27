//
//  AcceptVO.h
//  GuaHao
//
//  Created by qiye on 16/5/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface AcceptVO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSString * statusCn;
@property(strong) NSNumber * status;
@property(strong) NSNumber * acceptStatus;//万家订单状态

@property(strong) NSString * serialNo;
@property(strong) NSString * hospitalName;
@property(strong) NSString * departmentName;
@property(strong) NSString * visitDate;
@property(strong) NSString * patientName;
@property(strong) NSString * patientSex;
@property(strong) NSNumber * remainingTime;
@property(strong) NSNumber * type;
@property(strong) NSNumber * visitType; ///0表示挂号 1表示预约
@property(strong) NSNumber * cardType;
@property(strong) NSString * idcardFrontImg;
@property(strong) NSString * idcardBackImg;
@property(strong) NSString * passportImg;
@property(strong) NSNumber * patientStatus;
@property(assign) BOOL hasSubmit;


-(NSString *)typeCN;
@end
