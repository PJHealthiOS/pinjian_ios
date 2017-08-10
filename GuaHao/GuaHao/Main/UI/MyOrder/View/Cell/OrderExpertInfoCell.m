//
//  OrderExpertInfoCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderExpertInfoCell.h"

@interface OrderExpertInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *orderNomberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;

@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *remarkInfoAction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTypeLabel;


@end
@implementation OrderExpertInfoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)remarkDetailAction:(UIButton *)sender {
    self.remarkInfoAction.selected = !self.remarkInfoAction.selected;
    if (self.myBlock) {
        self.myBlock(self.remarkInfoAction.selected);
    }
}

+ (instancetype)renderCell:(OrderExpertInfoCell *)cell order:(OrderVO *)order {
    cell.personTypeLabel.text = order.patientIdcard.length < 15 ? @"护照编号":@"身份证号";
    cell.orderTypeLabel.text = order.outpatientType;
    cell.orderNomberLabel.text = order.serialNo;
    cell.hospitalLabel.text = order.hospName;
    cell.departmentLabel.text = order.deptName;
    cell.doctorLabel.text = order.doctorName;
    cell.dateLabel.text = order.visitDate;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",order.patientName,order.patientSex];
    cell.idCardLabel.text = order.patientIdcard;
    cell.phoneNumberLabel.text = order.patientMobile;
    cell.remarkLabel.text = order.patientComments;
    cell.priceLabel.text = order.registrationFee.intValue == 0 ? @"以到院实际费用为准" : [NSString stringWithFormat:@"%@ 元",order.registrationFee];
    return cell;
}
-(void)openPatientInfo:(OrderPatientInfoBlock)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
