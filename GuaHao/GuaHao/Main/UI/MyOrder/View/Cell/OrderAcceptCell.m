//
//  OrderAcceptCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderAcceptCell.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface OrderAcceptCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *certificateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;

@end
@implementation OrderAcceptCell
+ (instancetype)renderCell:(OrderAcceptCell *)cell order:(OrderVO *)order {
    [cell.QRCodeImage sd_setImageWithURL:[NSURL URLWithString:order.getTicketQRCode] placeholderImage:nil];
    cell.nameLabel.text = order.acceptUser;
    cell.dateLabel.text = order.acceptDate;
    cell.phoneNumber.text = order.acceptorMobile;
    [cell.certificateBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:order.ticketImgUrl] forState:UIControlStateNormal];
    [cell.certificateBtn setTitle:order.visitSeq forState:UIControlStateNormal];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)callAccepterAction:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://+86%@",self.phoneNumber.text]];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction)certificationAction:(UIButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
