//
//  CreateQRPayView.m
//  GuaHao
//
//  Created by PJYL on 2016/11/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateQRPayView.h"
#import "QRCodeGenerator.h"
@interface CreateQRPayView (){
    
}
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *alipaPay;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (strong, nonatomic)    NSTimer *countdownTimer;

@end
@implementation CreateQRPayView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"CreateQRPayView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
       
    }return self;
}
///获得支付码
-(void)getPayInfoWithType:(NSString *)typeStr{

    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getQRPayInfoWithID:self.orderID isNormal:self.isNormal  channel:typeStr andCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    weakSelf.qrImageView.image = [QRCodeGenerator qrImageForString:data[@"object"] imageSize:200];

                }
                
            }else{
//                [weakSelf inputToast:msg];
            }
        }
    }];

}
-(void)createTimer{

    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getPayStatus) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    //        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self.countdownTimer fire];

}
///轮询支付结果
-(void)getPayStatus{
__weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getNormalOrderPayStatus:self.orderID isNormal:self.isNormal andCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSNumber *result = data[@"object"][@"qrPaidStatus"];
                    NSLog(@"result---------------->%@",result);
                    if (result.intValue == 0) {//移除不管了
                        [self.countdownTimer invalidate];
                        [weakSelf removeFromSuperview];
                    }else if (result.intValue == 1){
                        
                    }else if (result.intValue == 2){
                        NSLog(@"支付成功了---------");
                        [weakSelf.countdownTimer invalidate];
                        weakSelf.myBlock(YES);
                        [self.countdownTimer invalidate];
                        [weakSelf removeFromSuperview];

                        ///已经支付
                    }
                    
                }
                
            }else{
                //                [weakSelf inputToast:msg];
            }
        }
    }];
}




-(void)returnPayStatus:(PaySuccessActionBlock)block{
    self.myBlock = block;
}

- (IBAction)backAction:(id)sender {
    [self.countdownTimer invalidate];
    [self removeFromSuperview];
}



- (IBAction)wechatPayAction:(UIButton *)sender {
    sender.selected = YES;
    self.alipaPay.selected = NO;
    self.leftView.hidden = NO;
    self.rightView.hidden = YES;
    [self getPayInfoWithType:@"wx_pub_qr"];
}
- (IBAction)alipayAction:(UIButton *)sender {
    sender.selected = YES;
    self.wechatButton.selected = NO;
    self.leftView.hidden = YES;
    self.rightView.hidden = NO;
    [self getPayInfoWithType:@"alipay_qr"];
}
- (void)dealloc
{
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
