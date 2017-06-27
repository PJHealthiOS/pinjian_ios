//
//  GHAcceptOrderManagerCell.m
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHAcceptOrderManagerCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface GHAcceptOrderManagerCell (){

        AcceptOrderVO *_orderVO;
}
@property (weak, nonatomic) IBOutlet UIButton *certificateButton;
@property (weak, nonatomic) IBOutlet UIImageView *QRcodeImage;
@property (weak, nonatomic) IBOutlet UIButton *normalOrder;
@property (weak, nonatomic) IBOutlet UIButton *changeAMExpertOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *changePMExpertOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *changeAMNormalOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *fullOrderButton;
@property (weak, nonatomic) IBOutlet UIImageView * proveImage;

@end
@implementation GHAcceptOrderManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)renderCell:(GHAcceptOrderManagerCell *)cell order:(AcceptOrderVO *)order{

    if (order.ticketImgUrl.length > 2) {
        [cell.certificateButton sd_setBackgroundImageWithURL:[NSURL URLWithString:order.ticketImgUrl] forState:UIControlStateNormal];
    }
    if (order.status.intValue == 2 || order.status.intValue == 3) {
        cell.certificateButton.userInteractionEnabled = YES;
    }else{
        cell.certificateButton.userInteractionEnabled = NO;
    }
    
    return cell;
}
-(void)uploadcertificate:(UploadcertificateBlock)block{
    self.myblock = block;
}
///上传凭证
- (IBAction)certificateUploadAction:(UIButton *)sender {
    
        if(_orderVO.ticketImgUrl.length > 2){
            ///重新上传
            if (self.myblock) {
                self.myblock(1);
            }
        }else{
            //直接上传
            if (self.myblock) {
                self.myblock(2);
            }

        }
    
}
///转上午专家号
- (IBAction)changeAMExpertOrder:(UIButton *)sender {

    
}
///转下午专家号
- (IBAction)changePMExpertOrderAction:(UIButton *)sender {

    
}
///转下午普通号
- (IBAction)changeAMNormalOrderAction:(UIButton *)sender {

    
}
///今日号满
- (IBAction)fullOrderAction:(UIButton *)sender {

    
}
#pragma mark - UIActionSheetDelegate



@end
