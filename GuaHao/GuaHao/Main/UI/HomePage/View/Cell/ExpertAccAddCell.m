//
//  ExpertAccAddCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertAccAddCell.h"

@implementation ExpertAccAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews:(NSString *)address{
    self.textField.text = address;
}
- (IBAction)endEditingAction:(id)sender {
    if (self.myBlock != nil && _textField.text.length > 0) {
        self.myBlock(_textField.text);
    }
}
-(void)returnValue:(ReturnValueBlock)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
