//
//  UsedCouponsVO.h
//  GuaHao
//
//  Created by 123456 on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface UsedCouponsVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString   * desc;
@property(strong) NSString   * useCondition;
@property(strong) NSNumber * money;
@property(strong) NSString   * imgUrl;
@property(strong) NSString   * createDate;
@property(strong) NSNumber * exchangePoint;
@property  BOOL   expired;
@property(strong) NSString   * endDate;
@property  BOOL   used;
@property(strong) NSString   * beginDate;
@property(strong) NSString   * useScope;
@property(strong) NSString   * name;


@end
