//
//  AllDayVO.h
//  GuaHao
//
//  Created by qiye on 16/4/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayVO.h"
#import "ScheduleDateVO.h"

@interface AllDayVO : NSObject
@property(strong) NSString * scheduleDate;
@property(strong) DayVO * upDay;
@property(strong) DayVO * downDay;

@property(strong) ScheduleDateVO * upSDay;
@property(strong) ScheduleDateVO * downSDay;
@end
