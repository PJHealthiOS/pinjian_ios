//
//  FilterDateVO.h
//  GuaHao
//
//  Created by qiye on 16/6/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "ScheduleDateVO.h"

@interface FilterDateVO : NSObject
@property(strong) NSArray * titleDates;
@property(strong) NSArray * filterDates;
-(NSArray*) getDays:(int) type;
@end
