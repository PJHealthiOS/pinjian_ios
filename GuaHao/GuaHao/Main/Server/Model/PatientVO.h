//
//  PatientVO.h
//  GuaHao
//
//  Created by qiye on 16/1/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "CertificationInfoVO.h"
@interface PatientVO : NSObject

@property(strong) NSNumber* id;
@property(strong) NSString * name;
@property(strong) NSString * mobile;

@property(strong) NSNumber * sex;
@property(strong) NSNumber * type;//1 成人 2儿童 3爱心就诊人成人 4.爱心就诊人儿童
@property(strong) NSNumber * cardType;//证件类型 1身份证  2护照 3监护人身份证

@property(strong) NSDate   * createDate;
@property(strong) NSDate   * modifyDate;
@property(strong) NSString * birthday;

@property(strong) NSString * idcard;
@property(strong) NSString * socialSecurityCard;
@property(strong) NSString * medicalCard;
@property(strong) NSNumber * status;// 认证状态 0未审核 1待审核 2审核成功 3 认证失败
-(NSString *) getStatus;
//@property(strong) NSNumber * imgType;//1表示身份证图片 2表示残疾人图片  3表示低保图片
//@property(strong) NSString * idcardFrontImg;
//@property(strong) NSString * idcardBackImg;
//@property(strong) NSString * passportImg;
//@property(strong) NSString * otherImg;//残疾人图片或者低保图片

@end
//就诊人增加CertificationInfo对象属性，type ：1表示普通实名认证 2表示爱心认证
//status：1待认证 2认证成功 3认证失败  ---CertificationInfo对象为空或者status为0表示尚未认证







