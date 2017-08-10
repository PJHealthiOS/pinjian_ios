//
//  OrderPayCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderPayCell.h"

@interface OrderPayCell (){
}
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceInfoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@end
@implementation OrderPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)orderPriceAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.myBlock) {
        self.myBlock(sender.selected);
    }
    if (sender.selected) {
        self.backImageView.image = [UIImage imageNamed:@"order_accept_cell_between_bg_image.png"];
    }else{
        self.backImageView.image = [UIImage imageNamed:@"order_accept_cell_down_image.png"];
    }
}
+ (instancetype)renderCell:(OrderPayCell *)cell source:(NSArray *)source {
    
    cell.PriceLabel.text = [NSString stringWithFormat:@"¥ %@",[source firstObject]];
    cell.payTypeLabel.text = [source lastObject];
    
    
    return cell;
}
-(void)openPayInfo:(OrderPayInfoBlock)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
