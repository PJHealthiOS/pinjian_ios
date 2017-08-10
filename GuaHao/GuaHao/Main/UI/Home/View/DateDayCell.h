//
//  DayCell.h
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllDayVO.h"

@protocol DateDayCellDelegate <NSObject>
-(void) delegateDateDayCell:(ScheduleDateVO*) vo;
@end

@interface DateDayCell : UIView
@property (weak, nonatomic) AllDayVO *dayVO;
@property(assign) id<DateDayCellDelegate>  delegate;
-(void)setCell;
@end
