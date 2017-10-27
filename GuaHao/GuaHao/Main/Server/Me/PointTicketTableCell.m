//
//  PointTicketTableCell.m
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PointTicketTableCell.h"
#import "Utils.h"
#import "UIViewController+Toast.h"
#import "DataManager.h"
@implementation PointTicketTableCell{
    
    __weak IBOutlet UIImageView * imgBg;
    __weak IBOutlet UILabel     * labPrice;
    __weak IBOutlet UILabel     * labMount;
    MyCouponsVO * myCouponsVO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCell:(MyCouponsVO*)vo bg:(BOOL)isBg
{
    myCouponsVO = vo;
    [imgBg setImage:[UIImage imageNamed:isBg?@"point_blue.png":@"point_green.png"]];
    labPrice.text = vo.money.stringValue;
    labMount.text = vo.exchangePoint.stringValue;
}
- (IBAction)peanRuleAction:(id)sender {
    self.MyAction(YES);
}
-(void)clickAction:(ClickPeanAction)action{
    self.MyAction = action;
}
- (IBAction)onExchange:(id)sender {
    if ([DataManager getInstance].user.point.intValue < myCouponsVO.exchangePoint.intValue) {
        [self makeToast:@"您的挂号豆不足，请继续签到哦！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
}
@end
