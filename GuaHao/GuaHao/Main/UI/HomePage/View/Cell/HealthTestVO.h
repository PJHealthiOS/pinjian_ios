//
//  HealthTestVO.h
//  GuaHao
//
//  Created by PJYL on 16/10/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface HealthTestVO : NSObject
@property(nonatomic,copy)NSString * coverUrl;
@property(nonatomic,copy)NSString * linkUrl;
@property(nonatomic,copy)NSNumber * numOfTest;
@property(nonatomic,copy)NSString * name;
@end
