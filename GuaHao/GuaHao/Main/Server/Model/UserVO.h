//
//  UserVO.h
//  GuaHao
//
//  Created by qiye on 16/1/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface UserVO : NSObject

@property(strong) NSNumber* id;
@property(copy) NSString * mobile;
@property(copy) NSString * avatar;
@property(strong) NSNumber * sex;
@property(strong) NSNumber * verifyStatus;//未审核  待审核  审核通过  审核失败 部分认证通过  0 1 2
@property(strong) NSNumber * point;
@property(strong) NSNumber * banlance;

@property(copy) NSString * nickName;
@property(copy) NSString * loginName;

@property(copy) NSString * token;

@property(strong) NSNumber * hospId;
@property(copy) NSString * hospName;

@property(strong) NSNumber * acceptOrderPush;
@property(copy) NSString * selfcode;

@property(copy) NSString * hxUsername;
@property(copy) NSString * hxPassword;


@property(copy) NSString * latitude;
@property(copy) NSString * longitude;

@property(strong) NSMutableArray * citySonArray;


@property (nonatomic, copy) NSNumber *memberLevel;///会员等级
@property (nonatomic, copy) NSNumber *discountRate;///会员折扣
@property (nonatomic, copy) NSNumber *curAvailableTimes;///折扣剩余次数





@end
