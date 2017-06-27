//
//  CancelReasonDetCell.m
//  GuaHao
//
//  Created by 123456 on 16/4/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CancelReasonDetCell.h"

@implementation CancelReasonDetCell{
    
    __weak IBOutlet UIView *upLine;
    __weak IBOutlet UIView *lineView;
}

- (void)awakeFromNib {
}

-(void)setLine:(int) type
{
    upLine.hidden = NO;
    lineView.hidden = NO;
    if (type == 0) {
        upLine.hidden = YES;
    }
    if (type == 2) {
        lineView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
