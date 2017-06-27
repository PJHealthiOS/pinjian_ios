//
//  CityVO.h
//  GuaHao
//
//  Created by qiye on 16/9/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface CityVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * code;
@property(strong) NSString * name;
@property(strong) NSNumber * level;
@property(strong) NSArray * children;
@end
