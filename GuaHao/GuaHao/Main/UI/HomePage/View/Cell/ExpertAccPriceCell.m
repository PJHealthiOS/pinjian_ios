//
//  ExpertAccPriceCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertAccPriceCell.h"

@implementation ExpertAccPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviewTotalPrice:(NSString *)price{
    self.priceLabel.text = price;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
