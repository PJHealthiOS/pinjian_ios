//
//  BankSelectTableCell.m
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "BankSelectTableCell.h"
#import "BankListVO.h"
#import "UIImageView+WebCache.h"

@implementation BankSelectTableCell{
    
    __weak IBOutlet UILabel *labName;
    __weak IBOutlet UIImageView *imgBank;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCell:(BankListVO*) vo
{
    labName.text = vo.name;
    [imgBank sd_setImageWithURL: [NSURL URLWithString:vo.iconUrl] placeholderImage:[UIImage imageNamed:@"share_defalt_icon.png"]];
}
@end
