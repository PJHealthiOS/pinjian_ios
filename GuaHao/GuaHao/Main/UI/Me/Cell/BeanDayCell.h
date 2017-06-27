//
//  DayCell.h
//  GuaHao
//
//  Created by qiye on 16/4/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignDateVO.h"

@interface BeanDayCell : UIView
@property (weak, nonatomic) SignDateVO *dateVO;
-(void)setCell;
@end
