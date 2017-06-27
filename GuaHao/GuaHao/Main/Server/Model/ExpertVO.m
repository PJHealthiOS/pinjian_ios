//
//  ExpertVO.m
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertVO.h"
#import "AllDayVO.h"

@implementation ExpertVO

+ (NSDictionary *)objectClassInArray{
    return @{
             @"schedules" : @"DayVO"             };
}

-(NSArray*) getDays:(BOOL) isAll
{
    NSMutableArray * arr = [NSMutableArray new];
    if (_allDates) {
        for (int i=0; i<_allDates.count; i++) {
            AllDayVO* vo = [AllDayVO new];
            vo.scheduleDate = _allDates[i];
            if (_schedules) {
                for (int n=0; n<_schedules.count; n++) {
                    DayVO* cur = _schedules[n];
                    if ([cur.scheduleDate isEqualToString:vo.scheduleDate]) {
                        if (cur.outpatientType.intValue == 1&&isAll) {
                            if ([cur.apm isEqualToString:@"上午"]) {
                                vo.upDay = cur;
                            }else{
                                vo.downDay = cur;
                            }
                            _isHave = YES;
                        }else if(cur.outpatientType.intValue == 2&&!isAll){
                            if ([cur.apm isEqualToString:@"上午"]) {
                                vo.upDay = cur;
                            }else{
                                vo.downDay = cur;
                            }
                            _isHave = NO;
                        }
                    }
                }
            }
            [arr addObject:vo];
        }
        _dealArr = [NSArray arrayWithArray:arr];
    }
    return _dealArr;
}

-(NSArray*) getAllDays
{
    NSMutableArray * arr = [NSMutableArray new];
    if (_allDates) {
        for (int i=0; i<_allDates.count; i++) {
            AllDayVO* vo = [AllDayVO new];
            vo.scheduleDate = _allDates[i];
            if (_schedules) {
                for (int n=0; n<_schedules.count; n++) {
                    DayVO* cur = _schedules[n];
                    if ([cur.scheduleDate isEqualToString:vo.scheduleDate]) {
                        if ([cur.apm isEqualToString:@"上午"]) {
                            vo.upDay = cur;
                        }else{
                            vo.downDay = cur;
                        }
                    }
                }
            }
            [arr addObject:vo];
        }
        _dealArr = [NSArray arrayWithArray:arr];
    }
    return _dealArr;
}

@end
