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
