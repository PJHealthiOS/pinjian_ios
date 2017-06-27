//
//  AccompanyOrderVO.h
//  GuaHao
//
//  Created by PJYL on 16/10/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PatientVO.h"
#import "NSObject+MJExtension.h"
@interface AccompanyOrderVO : NSObject
@property(nonatomic,copy)NSArray * patients;
@property(nonatomic,copy)NSNumber * insuranceFee;
@property(nonatomic,copy)NSNumber * normalTransferFee;
@property(nonatomic,copy)NSNumber * specialTransferFee;
@property(nonatomic,copy)NSNumber * firstOrderPrice;
@property(nonatomic,copy)NSNumber * pzFee;
@property(nonatomic,copy)NSNumber * defPayType;
@property(nonatomic,assign) BOOL  firstOrder;
@property(nonatomic,copy)NSString * insuranceDocUrl;
@property(nonatomic,copy)NSString * transferDocUrl;
@property(nonatomic,copy)NSString * drugPZUrl;

@end
