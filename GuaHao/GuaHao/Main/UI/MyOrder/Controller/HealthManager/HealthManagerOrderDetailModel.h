//
//  HealthManagerOrderDetailModel.h
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface HealthManagerOrderDetailModel : NSObject
@property (nonatomic, copy)NSString *idCard;
@property (nonatomic, copy)NSNumber *amount;
@property (nonatomic, copy)NSString *patientName;
@property (nonatomic, copy)NSNumber *monthNumbers;
@property (nonatomic, copy)NSNumber *packageType;
@property (nonatomic, strong)NSArray *packageContent;
@property (nonatomic, copy)NSNumber *serviceType;
@property (nonatomic, copy)NSString *patientMobile;
@property (nonatomic, copy)NSNumber *teamNumbers;
@property (nonatomic, copy)NSString *packageName;
@property (nonatomic, copy)NSNumber *id;
@end
