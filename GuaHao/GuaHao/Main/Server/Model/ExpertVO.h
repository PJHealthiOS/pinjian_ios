//
//  ExpertVO.h
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "DayVO.h"

@interface ExpertVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * name;
@property(strong) NSNumber * departmentId;
@property(strong) NSNumber * hospitalId;
@property(strong) NSString * title;
@property(strong) NSString * avatar;
@property(strong) NSString * departmentName;
@property(strong) NSString * hospitalName;
@property(strong) NSString * expert;
@property(strong) NSString * resume;
@property(strong) NSNumber * outpatientCount;
@property(strong) NSArray * allDates;
@property(strong) NSArray * schedules;
@property(copy, nonatomic) NSString *iconUrl;
@property(strong) NSArray * dealArr;
@property BOOL isHave;
@property BOOL followed;
-(NSArray*) getDays:(BOOL) isAll;
-(NSArray*) getAllDays;
@end
