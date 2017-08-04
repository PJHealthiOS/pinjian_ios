//
//  GHSettingNoticeCell.m
//  GuaHao
//
//  Created by PJYL on 16/9/2.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHSettingNoticeCell.h"

@interface GHSettingNoticeCell (){
    
}


@end
@implementation GHSettingNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)segementAction:(UISegmentedControl *)sender {
    BOOL open = YES;
    if (sender.selectedSegmentIndex != 0) {
        open = NO;
    }
    if (self.myBlock) {
        self.myBlock(open);
    }
    
}
-(void)pushStatus:(PushStatusDelegate)block{
    self.myBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
