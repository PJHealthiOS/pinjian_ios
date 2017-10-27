//
//  HospitalMiniTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/6/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "BankLogViewCell.h"
#import "UIViewBorders.h"
#import "Utils.h"
#import "BankLogVO.h"
#import "UIImageView+WebCache.h"

@implementation BankLogViewCell{
    
    __weak IBOutlet UIImageView *imgIcon;
    __weak IBOutlet UILabel *labName;
    __weak IBOutlet UILabel *labCardNO;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addBottomBorderWithHeight:1.0 andColor:RGBAlpha(210,210,210,1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setCell:(BankLogVO *) vo
{
    labName.text = vo.name;
    labCardNO.text = vo.cardNo;
    [imgIcon sd_setImageWithURL: [NSURL URLWithString:vo.bankIconUrl]];
}

@end
