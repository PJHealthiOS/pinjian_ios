//
//  HealthManagerOrderCell.m
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthManagerOrderCell.h"
@interface HealthManagerOrderCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
@implementation HealthManagerOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviewsWith:(HealthManagerOrderModel *)modle{
    self.nameLabel.text = modle.patientName;
    self.phoneLabel.text = modle.patientMobile;
    self.typeLabel.text = modle.packageName;
}
- (IBAction)detailAction:(id)sender {
    self.myAction(YES);
}
-(void)clickAction:(DetailClickAction)action{
    self.myAction = action;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
