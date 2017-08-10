//
//  MemberLevelModel.h
//  GuaHao
//
//  Created by PJYL on 2017/7/21.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface MemberLevelModel : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *memberRights;
@property (nonatomic, copy)NSString *memberCondition;
@property (nonatomic, copy)NSString *backgroundImg;
@property (nonatomic, copy)NSNumber *discountRate;
@property (nonatomic, copy)NSNumber *totalRecharge;
@end
