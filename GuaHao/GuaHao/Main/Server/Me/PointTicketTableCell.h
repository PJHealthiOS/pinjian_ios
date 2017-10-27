//
//  PointTicketTableCell.h
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponsVO.h"

typedef void(^ClickPeanAction)(BOOL result);
@interface PointTicketTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton * exchangeBtn;
-(void)setCell:(MyCouponsVO*)vo bg:(BOOL)isBg;
@property (nonatomic, copy)ClickPeanAction MyAction;
-(void)clickAction:(ClickPeanAction)action;
@end
