//
//  AccompanyServiceCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccompanyServiceCell.h"
#import "HtmlAllViewController.h"
@interface AccompanyServiceCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionWidth;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelWidth;
@end
@implementation AccompanyServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)clickButtonReturn:(ClickReturnBlock)block{
    self.myBlock = block;
}
-(void)layoutSubviewsWithPriceStr:(NSString *)priceStr price:(NSNumber*)price  description:(NSString *)description hiddenButton:(BOOL)hidden{
    
  CGSize price_size =  [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
  _priceLabelWidth.constant = price_size.width + 2;
    
  CGSize descrip_size =  [description sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8]}];
    _descriptionWidth.constant = descrip_size.width + 2;
    
    self.priceLabel.text = priceStr;
    self.priceL.text = [NSString stringWithFormat:@"%@元",price];
    self.descriptionLabel.text = description;
    self.attentionButton.hidden = hidden;
}
- (IBAction)selectAction:(UIButton *)sender {
    self.myBlock(sender.selected);
    sender.selected = !sender.selected;
}
-(void)explainAction:(ExplainBlock)block{
    self.explainBlock = block;
}
- (IBAction)explain:(id)sender {
    self.explainBlock(YES);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
