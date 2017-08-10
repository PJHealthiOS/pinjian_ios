//
//  AddPersonFootCell.m
//  GuaHao
//
//  Created by PJYL on 2017/6/13.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "AddPersonFootCell.h"

@implementation AddPersonFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)submitAction:(id)sender {
    self.myAction(YES);
}
-(void)buttonSelectAction:(SubmitAction)action{
    self.myAction=action;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
