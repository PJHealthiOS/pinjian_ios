//
//  GHCreateOrderTwoCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHCreateOrderTwoCell.h"
@interface GHCreateOrderTwoCell (){
    
}
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *accompanyButton;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftIconImage;
@property (weak, nonatomic) IBOutlet UILabel *leftOrderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIconImage;
@property (weak, nonatomic) IBOutlet UILabel *rightOrderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDescLabel;
@end
@implementation GHCreateOrderTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}





- (IBAction)buttonAction:(UIButton *)sender {
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}
-(void)clickButtonReturn:(ClickReturnBlock)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
