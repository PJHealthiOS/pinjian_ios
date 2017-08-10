//
//  CreateOrderSubmitCell.m
//  GuaHao
//
//  Created by PJYL on 2016/11/9.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderSubmitCell.h"

@implementation CreateOrderSubmitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)submitAction:(SubmitActionBlock)block{
    self.myBlock = block;
}
- (IBAction)ruleAction:(id)sender {
    self.myBlock(NO);
    
}

- (IBAction)sureAction:(id)sender {
    self.myBlock(YES);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
