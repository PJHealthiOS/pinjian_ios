//
//  GHAcceptOrderWJInfoCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/4/12.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GHAcceptOrderWJInfoCell.h"

@interface GHAcceptOrderWJInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNoButton;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;

@end
@implementation GHAcceptOrderWJInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)renderCell:(AcceptOrderVO *)order{
    self.serialNoLabel.text = order.serialNo;
    self.hospitalLabel.text = order.hospitalName;
    self.departmentLabel.text = order.departmentName;
    self.priceLabel.text = @"到院支付";
    self.dateLabel.text = order.visitDate;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",order.patientName];
    self.idCardLabel.text = order.patientIdcard;
    [self.phoneNoButton setTitle:order.patientMobile forState:UIControlStateNormal]; ;
    ///此处有问题
    self.certificateLabel.text = order.patientStatus.intValue > 0 ? @"已认证" : @"未认证";
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
