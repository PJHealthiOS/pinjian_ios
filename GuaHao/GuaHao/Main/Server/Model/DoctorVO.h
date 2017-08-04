//
//  DoctorVO.h
//  GuaHao
//
//  Created by qiye on 16/4/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface DoctorVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * name;
@property(strong) NSString * img;
@property(strong) NSString * desc;
@property(strong) NSNumber * outpatientCount;
@property(strong) NSNumber * outpatientType;

@property(strong) NSString * departmentName;
@property(strong) NSString * grade;
@property(strong) NSString * hospitalLevel;// 医院级别： 0-三级特等 1-三级甲等, 2-三级乙等， 3-三级丙等， 4-二级甲等， 5-二级乙等， 6-二级丙等， 7-一级甲等， 8-一级乙等， 9-一级丙等
@property(strong) NSString * hospitalName;
@property(strong) NSString * status;

@property(nonatomic) BOOL  followed;
-(BOOL)is3AG;
@end
