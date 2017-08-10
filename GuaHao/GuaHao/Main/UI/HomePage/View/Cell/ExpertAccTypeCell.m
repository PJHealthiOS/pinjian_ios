//
//  ExpertAccTypeCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertAccTypeCell.h"

@interface ExpertAccTypeCell (){
    NSInteger _buttonIndex;

}
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (weak, nonatomic) IBOutlet UIButton *childrenButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;
@property (weak, nonatomic) IBOutlet UIButton *oldButton;

@end
@implementation ExpertAccTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialization code
}
-(void)layoutSubviews:(NSInteger)index{
    _buttonIndex = index;
    [self reloadSubViews];
}
-(void)reloadSubViews{
    UIColor *gray = UIColorFromRGB(0x888888);

    [self.normalButton setTitleColor:(_buttonIndex == 1 ? GHDefaultColor : gray) forState:UIControlStateNormal];
    [self.childrenButton setTitleColor:(_buttonIndex == 2 ? GHDefaultColor : gray)forState:UIControlStateNormal];
    [self.womenButton setTitleColor:(_buttonIndex == 3 ? GHDefaultColor : gray)forState:UIControlStateNormal];
    [self.oldButton setTitleColor:(_buttonIndex == 4 ? GHDefaultColor : gray)forState:UIControlStateNormal];
}
- (IBAction)typeSelectAction:(UIButton *)sender {
    self.myBlock(sender.tag  - 2100);
    _buttonIndex = sender.tag - 2100;
    [self reloadSubViews];
    
}
-(void)typeSelect:(TypeIndexSelectBolck)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
