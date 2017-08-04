//
//  PaymentsuccessVC.m
//  GuaHao
//
//  Created by 123456 on 16/5/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PaymentsuccessVC.h"
#import "ServerManger.h"
#import "OrderVO.h"

@interface PaymentsuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *labPayTip;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end

@implementation PaymentsuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_isExpert) {
        _labTitle.text = @"支付成功";
        _labContent.text = [NSString stringWithFormat:@"您的订单：%@已支付成功，等待接单员接单！",_serialNo];
    }else{
        _labTitle.text = @"预约提交成功";
        _labContent.text = [NSString stringWithFormat:@"您的订单：%@已预约成功，稍后品简客服人员将会与您联系，请保持手机畅通！",_serialNo];
        _btnBack.hidden = YES;
        _labPayTip.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)pop:(id)sender {
    
    if (!_isExpert) {
        GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
        view.orderType = 1;
        view.orderNO = _serialNo;
        view.popBack = PopBackRoot;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        GHExpertOrderDetialViewController * view = [GHViewControllerLoader GHExpertOrderDetialViewController];
        view.orderType = 1;
        view.orderNO = _serialNo;
        view.popBack = PopBackRoot;
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
