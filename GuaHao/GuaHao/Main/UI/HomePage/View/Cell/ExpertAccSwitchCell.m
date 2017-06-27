//
//  ExpertAccSwitchCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertAccSwitchCell.h"

@implementation ExpertAccSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviewsWithTitle:(NSString *)title {
    self.titleLabel.text = title;
;
}
- (IBAction)switchButtonAction:(UISwitch *)sender {
    self.myBlock(sender.isOn);
}
- (IBAction)infoAction:(UIButton *)sender {
    self.myAction(YES);
}
-(void)switchAction:(SwitchActionBlock)block{
    self.myBlock = block;
}
-(void)pzAction:(PZInfoAction)action{
    self.myAction = action;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
