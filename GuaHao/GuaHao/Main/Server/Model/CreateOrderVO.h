//
//  CreateOrderVO.h
//  GuaHao
//
//  Created by qiye on 16/5/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "PatientVO.h"
#import "HospitalVO.h"

@interface CreateOrderVO : NSObject
@property(strong) NSNumber * normalPrice;
@property(strong) NSNumber * serviceFee;
@property(strong) NSNumber * defPayType;
@property(strong) NSNumber * totalFee;
@property(strong) NSNumber * orderPzFee;
@property(strong) NSNumber * issuingFee;
@property(strong) NSNumber * orderOriginPzFee;
@property(strong) HospitalVO * hospital;
@property(strong) NSArray * patients;
@property(strong) NSString *ruleDocUrl;
@property(strong) NSString *pzUrl;
@property  BOOL isFirstOrder;
@property  BOOL isCheckMedicalCardMatch;
@property (assign) BOOL enabled;
@end
