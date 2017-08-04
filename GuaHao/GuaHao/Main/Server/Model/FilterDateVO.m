//
//  FilterDateVO.m
//  GuaHao
//
//  Created by qiye on 16/6/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "FilterDateVO.h"
#import "ScheduleDateVO.h"
#import "AllDayVO.h"

@implementation FilterDateVO

+ (NSDictionary *)objectClassInArray{
    return @{
             @"filterDates" : @"ScheduleDateVO"
             };
}

-(NSArray*) getDays:(int) type
{
    NSMutableArray * arr = [NSMutableArray new];
    if (_titleDates) {
        for (int i=0; i<_titleDates.count; i++) {
            AllDayVO * vo = [AllDayVO new];
            vo.scheduleDate = _titleDates[i];
            if (_filterDates) {
                for (int n=0; n<_filterDates.count; n++) {
                    ScheduleDateVO* cur = _filterDates[n];
                    if ([cur.scheduleDate isEqualToString:vo.scheduleDate]) {
                        if (type == 1&&cur.clinicType.intValue!=2 ) {
                            if (cur.apm.intValue == 1) {
                                vo.upSDay = cur;
                            }else{
                                vo.downSDay = cur;
                            }
                        }else if(type == 2&&cur.clinicType.intValue!=1 ){
                            if (cur.apm.intValue == 1) {
                                vo.upSDay = cur;
                            }else{
                                vo.downSDay = cur;
                            }
                        }else if(type == 3 ){
                            if (cur.apm.intValue == 1) {
                                vo.upSDay = cur;
                            }else{
                                vo.downSDay = cur;
                            }
                        }
                    }
                }
            }
            [arr addObject:vo];
        }
    }
    return [NSArray arrayWithArray:arr];
}
@end
