//
//  ExpertOrderVO.h
//  GuaHao
//
//  Created by qiye on 16/6/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface ExpertOrderVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * departmentName;
@property(strong) NSString * doctorName;
@property(strong) NSString * hospitalDistance;
@property(strong) NSString * hospitalName;
@property(strong) NSString * patientName;
@property(strong) NSString * patientSex;
@property(strong) NSString * serialNo;
@property(strong) NSString * statusCn;
@property(strong) NSString * visitDate;
@property(strong) NSNumber * orderStatus;//1已提交  2已完成 3 已取消
@end
