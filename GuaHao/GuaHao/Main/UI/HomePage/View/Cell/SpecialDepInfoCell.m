//
//  SpecialDepInfoCell.m
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SpecialDepInfoCell.h" 

@interface SpecialDepInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *depInfoLabel;


@end

@implementation SpecialDepInfoCell


-(void)layoutSubviewsInfo:(NSString *)str imageStr:(NSString *)imageStr{
    self.depInfoLabel.text = str;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"department_Defalut_icon.png"]];
}
-(void)openDepInfoAction:(OpenInfoBlock)block{
    self.myBlock = block;
}
- (IBAction)openAction:(UIButton *)sender {
     sender.selected = !sender.selected;
    self.myBlock(sender.selected);
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
