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
-(void)loadCellWith:(NSString *)typeStr valueStr:(NSString *)valueStr hidden:(BOOL)hidden gary:(BOOL)gary{
    self.typeLabel.text = typeStr;
    self.valueLabel.text = valueStr;
    if (gary) {
        self.typeLabel.textColor = [UIColor grayColor];
        self.valueLabel.textColor = [UIColor grayColor];
    }else{
        self.typeLabel.textColor = [UIColor blackColor];
        self.valueLabel.textColor = UIColorFromRGB(0xFEA44E);
    }
    
    
    self.lineView.hidden = hidden;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
