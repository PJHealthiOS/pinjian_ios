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
-(void)layoutSubviewsWithTitle:(NSString *)title leftValue:(NSString *)leftStr rightValue:(NSString *)rightStr{
    self.titleLabel.text = title;
    self.leftValueLabel.text = leftStr;
    self.rightValueLabel.text = rightStr;
    [self changeLabel:self.rightValueLabel withTextColor:UIColorFromRGB(0xFC4E05)];
;
}
- (void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color {
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
    NSString *content = label.text;
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
        }
        
    }
    //完成查找数字，最后将带有字体下划线的字符串显示在UILabel上
    label.attributedText = attributeString;
    

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
