//
//  HospitalVO.h
//  GuaHao
//
//  Created by qiye on 16/1/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface HospitalVO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSString * name;
@property(strong) NSNumber * level;// 0-三级特等 1-三级甲等, 2-三级乙等， 3-三级丙等， 4-二级甲等， 5-二级乙等， 6-二级丙等， 7-一级甲等，* 8-一级乙等， 9-一级丙等
@property(strong) NSNumber * type;// 0 成人  1 儿童
@property(strong) NSString * expert;
@property(strong) NSString * address;
@property(strong) NSString * url;
@property(strong) NSString * longitude;
@property(strong) NSString * latitude;
@property(strong) NSString * image;
@property(strong) NSString * hospitalDistance;
@property(strong) NSString * distance;
@property(strong) NSNumber * outpatientCount;
@property(strong) NSNumber * issuingFee;//工本费
@property(assign) BOOL isNeedSSC;
@property  BOOL isOpenMedicalCard;//是否开放就诊卡
@property  BOOL isOpenSocialSecurityCard;//是否开放社保卡
@property  BOOL isNeedRealnameAuth;
@property(assign) BOOL  isOnlineQueue;
@property(copy) NSString * deptName;
@end
