//
//  AccOrderTakeInfoCell.m
//  GuaHao
//
//  Created by PJYL on 2016/10/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccOrderTakeInfoCell.h"

@interface AccOrderTakeInfoCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIImageView *QRButton;


@end
@implementation AccOrderTakeInfoCell
-(void)layoutSubviews:(AccDetialVO *)vo{
    self.nameLabel.text = vo.waiterName;
    self.phoneNumber.text = vo.waiterMobile;
    [self.QRButton sd_setImageWithURL:[NSURL URLWithString:vo.ticketQrcode] placeholderImage:nil];
    
}
- (IBAction)buttonAction:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://+86%@",self.phoneNumber.text]];
    [[UIApplication sharedApplication] openURL:url];
    
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
