//
//  GHAcceptOrderInfoCell.m
//  GuaHao
//
//  Created by PJYL on 16/8/31.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHAcceptOrderInfoCell.h"

@interface GHAcceptOrderInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *orderNomberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;

@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *remarkInfoAction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *personTypeLabel;
@end
@implementation GHAcceptOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)renderCell:(GHAcceptOrderInfoCell *)cell order:(AcceptOrderVO *)order{
    cell.personTypeLabel.text = order.patientIdcard.length < 15 ? @"护照编号":@"身份证号";
    cell.orderTypeLabel.text = order.outpatientType;
    cell.orderNomberLabel.text = order.serialNo;
    cell.hospitalLabel.text = order.hospName;
    cell.departmentLabel.text = order.deptName;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",order.totalFee];
    cell.dateLabel.text = order.visitDate;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",order.patientName,order.patientSex];
    cell.idCardLabel.text = order.patientIdcard;
    
    [cell.phoneNumberLabel setTitle:order.patientMobile forState:UIControlStateNormal]; ;
    cell.remarkLabel.text = order.patientComments;
   ///此处有问题
    cell.certificateLabel.text = order.patientStatus.intValue > 0 ? @"已认证" : @"未认证";
    
    return cell;
}
- (IBAction)remarkDetailAction:(UIButton *)sender {
    self.remarkInfoAction.selected = !self.remarkInfoAction.selected;
    if (self.myBlock) {
        self.myBlock(self.remarkInfoAction.selected);
    }
}

-(void)openPatientInfo:(OrderPatientInfoBlock)block{
    self.myBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)callAction:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://+86%@",self.phoneNumberLabel.titleLabel.text]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
