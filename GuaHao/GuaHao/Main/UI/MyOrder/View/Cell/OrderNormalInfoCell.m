//
//  OrderNormalInfoCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderNormalInfoCell.h"

@interface OrderNormalInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *orderNomberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *remarkInfoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *personTypeLabel;

@end
@implementation OrderNormalInfoCell
- (IBAction)remarkInfoAction:(UIButton *)sender {
    self.remarkInfoBtn.selected = !self.remarkInfoBtn.selected;
    if (self.myBlock) {
        self.myBlock(self.remarkInfoBtn.selected);
    }
}
-(void)openPatientInfo:(OrderPatientInfoBlock)block{
    self.myBlock = block;
}
+ (instancetype)renderCell:(OrderNormalInfoCell *)cell order:(OrderVO *)order{
        cell.personTypeLabel.text = order.patientIdcard.length < 15 ? @"护照编号":@"身份证号";
//    NSDictionary * dic = @{@"0":@"普通号",@"1":@"专家号",@"2":@"特需号"};
    cell.orderTypeLabel.text = order.outpatientType ;
    cell.orderNomberLabel.text = order.serialNo;
    cell.hospitalLabel.text = order.hospName;
    cell.departmentLabel.text = order.deptName;
    cell.dateLabel.text = order.visitDate;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",order.patientName,order.patientSex];
    cell.idCardLabel.text = order.patientIdcard;
    cell.phoneNumberLabel.text = order.patientMobile;
    cell.remarkLabel.text = order.patientComments;

    
    
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
