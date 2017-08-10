//
//  MemberCenterModel.h
//  GuaHao
//
//  Created by PJYL on 2017/7/21.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface MemberCenterModel : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *curLevel;
@property (nonatomic, copy)NSNumber *curDiscountRate;
@property (nonatomic, copy)NSNumber *curAvailableTimes;

@property (nonatomic, copy)NSString *docUrl;
@property (nonatomic, strong)NSArray *memberItems;


@end
