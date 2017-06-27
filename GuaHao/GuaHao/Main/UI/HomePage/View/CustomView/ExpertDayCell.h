//
//  ExpertDayCell.h
//  GuaHao
//
//  Created by PJYL on 2016/11/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllDayVO.h"
#import "DayVO.h"
typedef void(^CellClickActionBlock) (DayVO *vo);

@interface ExpertDayCell : UIView

@property (nonatomic,copy)CellClickActionBlock myBlock;

@property(strong,nonatomic)AllDayVO *dayVO;

-(void)clickAction:(CellClickActionBlock)block;
-(void)loadCell;

@end
