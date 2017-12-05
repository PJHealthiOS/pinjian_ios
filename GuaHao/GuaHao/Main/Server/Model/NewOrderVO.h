//
//  NewOrderVO.h
//  GuaHao
//
//  Created by qiye on 16/9/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface NewOrderVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * visitType;
@property(strong) NSString * departmentName;
@property(strong) NSString * hospitalName;
@property(strong) NSString * outpatientType;
@property(strong) NSString * patientName;
@property(strong) NSString * patientSex;
@property(strong) NSString * remainingTime;
@property(strong) NSString * serialNo;
@property(strong) NSString * visitDate;
@property BOOL canBeAccept;
@end
