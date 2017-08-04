//
//  DayVO.h
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface DayVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * apm;
@property(strong) NSString * scheduleDate;
@property(strong) NSString * clinicType;
@property(strong) NSNumber * price;
@property(strong) NSNumber * type;
@property(strong) NSNumber * outpatientType;
@property  BOOL clickable;
@property  BOOL isPlus;
@property(strong) NSNumber * appointCount;
@property(strong) NSNumber * availableCount;
@end
