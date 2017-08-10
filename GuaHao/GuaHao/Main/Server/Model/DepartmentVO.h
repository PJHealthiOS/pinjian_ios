//
//  DepartmentVO.h
//  GuaHao
//
//  Created by qiye on 16/2/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface DepartmentVO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSNumber * type;
@property(strong) NSString * name;
@property(strong) NSString * comments;
@property(strong) NSString * weekSchedule;
@property(strong) NSNumber * openStatus;
@property(strong) NSNumber * startByHalfDay;
@property(strong) NSNumber * serviceFee;



@end
