//
//  AccOrderInfoCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccOrderInfoCell.h"

@interface AccOrderInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceFourLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureanceLabel;

@end
@implementation AccOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews:(AccDetialVO *)vo{
    self.personTypeLabel.text = vo.patientIdcard.length < 15 ? @"护照编号":@"身份证号";
    _orderNumberLabel.text = vo.serialNo;
    _typeLabel.text = vo.serviceTypeCn;
    _hospitalLabel.text = vo.hospName;
    _hospitalAddressLabel.text = vo.hospAddr;
    _takeLabel.text = vo.transferTypeCn;
    _dateLabel.text = vo.visitDate;
    _nameLabel.text = vo.patientName;
    _idCardLabel.text = vo.patientIdcard;
    _phoneLabel.text = vo.patientMobile;
    _addressLabel.text = vo.transferAddr;
    _payTypeLabel.text = vo.payTypeCn;
    _totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",vo.total_fee];
    _priceOneLabel.text = [NSString stringWithFormat:@"%@",vo.insurance_fee];
    _priceTwoLabel.text = [NSString stringWithFormat:@"%@",vo.service_fee];
    _priceThreeLabel.text = [NSString stringWithFormat:@"%@",vo.transfer_fee];
    _priceFourLabel.text = [NSString stringWithFormat:@"%@",vo.actual_pay];
    _insureanceLabel.text = vo.insured ? @"是":@"否";
    
}
-(void)openPriceDetial:(DetialPriceBlock)block{
    self.myBlock = block;
}
- (IBAction)priceDetailButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.myBlock(sender.selected);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
