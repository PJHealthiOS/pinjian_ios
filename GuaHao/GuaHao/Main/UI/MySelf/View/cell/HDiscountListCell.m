//
//  HDiscountListCell.m
//  GuaHao
//
//  Created by PJYL on 2017/5/4.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HDiscountListCell.h"

@interface HDiscountListCell (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *discountTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLabel;

@end
@implementation HDiscountListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCell:(UsedCouponsVO *) vo{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:vo.imgUrl] placeholderImage:nil];
    self.discountTypeLabel.text = vo.name;
    self.discountRangeLabel.text = vo.desc;
    self.overdueLabel.text = [NSString stringWithFormat:@"有效期至%@", vo.endDate];
    self.remarkLeftLabel.text = vo.useCondition;
    self.remarkRightLabel.text = vo.useScope;
    self.priceLabel.text = vo.money.stringValue;
    NSString *statusStr = @"未使用";
    BOOL canUse = YES;
    if (vo.expired || vo.used) {///如果过期或者用过了就显示
        self.iconImage.hidden = NO;
        canUse = NO;
    }else{
        self.iconImage.hidden = YES;
        canUse = YES;
    }
    if (vo.used) {
         self.iconImage.image = [UIImage imageNamed:@"discount_already_icon"];
        statusStr = @"已使用";
    }
    if (vo.expired) {
        statusStr = @"已过期";
        self.iconImage.image = [UIImage imageNamed:@"discount_past_icon"];
    }
    self.statusLabel.text =statusStr;
    
    self.discountTypeLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0xa5a5a5);
    self.discountRangeLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0xa5a5a5);
    self.overdueLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0x808080);
    self.remarkLeftLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0x989898);
    self.remarkRightLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0x989898);
    self.priceLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0xa5a5a5);
    self.statusLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0x686868);
    self.priceTypeLabel.textColor = canUse ? [UIColor whiteColor] : UIColorFromRGB(0xa5a5a5);

    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
