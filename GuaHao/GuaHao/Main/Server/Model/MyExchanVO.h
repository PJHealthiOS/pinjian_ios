//
//  MyExchanVO.h
//  GuaHao
//
//  Created by 123456 on 16/6/27.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyExchanVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * name;
@property(strong) NSString * useScope;//全场可用
@property(strong) NSString * useCondition;//"无条件使用"
//@property(strong) NSString * description;//"挂号豆兑换优惠券1"
@property(strong) NSNumber * money;
@property(strong) NSNumber * exchangePoint;
@property(strong) NSString * imgUrl;
@property(strong) NSString * beginDate;
@property(strong) NSString * endDate;
@property(strong) NSString * createDate;
@end
