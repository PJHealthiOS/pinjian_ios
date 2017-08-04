//
//  OrderDetailPriceCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/10.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "OrderDetailPriceCell.h"

@interface OrderDetailPriceCell (){
    

}
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@end
@implementation OrderDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadCellWith:(NSString *)typeStr valueStr:(NSString *)valueStr hidden:(BOOL)hidden{
    self.typeLabel.text = typeStr;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f元",valueStr.doubleValue];
    self.lineView.hidden = hidden;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
