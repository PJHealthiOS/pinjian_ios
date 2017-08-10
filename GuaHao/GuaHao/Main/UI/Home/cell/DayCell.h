//
//  DayCell.h
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayVO.h"
#import "AllDayVO.h"
@protocol DayCellDelegate <NSObject>
-(void) delegateSelectDayCell:(DayVO*) vo;
@end

@interface DayCell : UIView
@property (weak, nonatomic) AllDayVO *dayVO;
@property(assign) id<DayCellDelegate>  delegate;
-(void)setCell;
@end
