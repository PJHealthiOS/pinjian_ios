//
//  CertificationInfoVO.h
//  GuaHao
//
//  Created by 123456 on 16/6/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface CertificationInfoVO : NSObject

@property(strong) NSNumber * status;//1待认证 2认证成功 3认证失败  ---CertificationInfo对象为空或者status为0表示尚未认证
@property(strong) NSNumber * type;//type ：1表示普通实名认证 2表示爱心认证
@property(strong) NSString * idcardFrontImg;//身份证正面
@property(strong) NSString * idcardBackImg;//身份证反面
@property(strong) NSString * passportImg;//护照图片
@property(strong) NSString * otherImg;//残疾人图片或者低保图片
@property(strong) NSNumber * imgType;//1表示身份证图片 2表示残疾人图片  3表示低保图片

@end
