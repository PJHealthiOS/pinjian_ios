//
//  GHPersonTypeCell.m
//  GuaHao
//
//  Created by qiye on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHPersonTypeCell.h"

@implementation GHPersonTypeCell{
    
    __weak IBOutlet UIButton *btnAdult;
    __weak IBOutlet UIButton *btnKid;
    __weak IBOutlet UIView *lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClick:(id)sender {
}
@end
