//
//  HealthManagerOrderModel.h
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "NSObject+MJExtension.h"
@interface HealthManagerOrderModel : NSObject
@property (nonatomic, copy)NSString *patientName;
@property (nonatomic, copy)NSString *patientMobile;
@property (nonatomic, copy)NSString *packageName;
@property (nonatomic, copy)NSNumber *id;
@property (nonatomic, copy)NSNumber *serviceType;

@end
