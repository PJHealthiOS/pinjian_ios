//
//  AccompanyCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccompanyCell.h"

@interface AccompanyCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@end
@implementation AccompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews:(NSString *)type value:(NSString *)value discounPrice:(int)price isFirst:(BOOL)first indexPath:(NSIndexPath *)indexPath {
    self.typeLabel.text = type;
    self.valueLabel.text = value;
    if (indexPath.row == 1) {
        _valueLabel.textColor = UIColorFromRGB(0xff6600);
        self.valueLabel.text = [NSString stringWithFormat:@"%d元",first ? value.intValue - price :   value.intValue];
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(原价%@)",value] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),}];
        self.oldPriceLabel.attributedText = attrStr;
        if (first) {
            _discountLabel.hidden = NO;
            _oldPriceLabel.hidden = NO;
        }else{
            _oldPriceLabel.hidden = YES;
            _discountLabel.hidden = YES;
        }
        
    }else{
        _valueLabel.textColor = UIColorFromRGB(0x888888);
        _oldPriceLabel.hidden = YES;
        _discountLabel.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
