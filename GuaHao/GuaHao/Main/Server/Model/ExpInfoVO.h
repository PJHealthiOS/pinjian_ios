//
//  ExpInfoVO.h
//  GuaHao
//
//  Created by qiye on 16/4/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface ExpInfoVO : NSObject
@property(strong) NSArray * patients;
@property(strong) NSArray * servicePackages;
@property (nonatomic, copy) NSNumber *pzPrice;
@property (nonatomic, copy) NSNumber *transferPrice;
@property (nonatomic, copy) NSString *pzUrl;
@property (nonatomic, assign) BOOL needPz;
@property (nonatomic, copy) NSNumber *curDiscountValue;
@property (nonatomic, copy) NSString *curDiscountDesc;

@end
