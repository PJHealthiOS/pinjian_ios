//
//  PurseCell.m
//  GuaHao
//
//  Created by 123456 on 16/2/4.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PurseCell.h"
#import "Utils.h"

@implementation PurseCell{
    
    __weak IBOutlet UILabel * titleLab;
    __weak IBOutlet UILabel * priceLab;
    __weak IBOutlet UILabel * descLab;
    __weak IBOutlet UILabel * dateLab;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCell:(CrashVO*) vo
{
    dateLab.text = vo.operationDate;
    descLab.text = vo.desc;
    priceLab.text = [NSString stringWithFormat:@"%@  元",vo.money];
    titleLab.text = vo.title;
}

@end
