//
//  ExpertDescVO.h
//  GuaHao
//
//  Created by qiye on 16/6/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ExpertDescVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * patientId;
@property(strong) NSNumber * doctorId;
@property(strong) NSNumber * hospitalId;
@property(strong) NSString * departmentName;
@property(strong) NSString * doctorName;
@property(strong) NSString * hospitalDistance;
@property(strong) NSString * hospitalName;
@property(strong) NSString * patientName;
@property(strong) NSString * patientSex;
@property(strong) NSString * serialNo;
@property(strong) NSString * statusCn;
@property(strong) NSString * visitDate;
@property(strong) NSString * outpatientType;
@property(strong) NSString * doctorGrade;
@property(strong) NSString * hospitalLatitude;
@property(strong) NSString * hospitalLongitude;

@property(strong) NSString * patientBirthday;
@property(strong) NSString * patientComments;
@property(strong) NSString * patientIdcard;
@property(strong) NSString * patientCardType;
@property(strong) NSString * patientMobile;
@property(strong) NSNumber * patientType;
@property(strong) NSNumber * orderStatus;//1已提交  2已完成 3 已取消
@property BOOL isShowBtnAgain;
@property BOOL isShowBtnCancel;
@property BOOL isShowBtnDel;
@end
