//
//  GHRechargeViewController.m
//  GuaHao
//
//  Created by qiye on 16/9/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHRechargeViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "Pingpp.h"

@interface GHRechargeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *batPay;
@property (weak, nonatomic) IBOutlet UITextField *tfInput;
@property (weak, nonatomic) IBOutlet UIButton *btnWx;
@property (weak, nonatomic) IBOutlet UIButton *btnAlipay;

@end

@implementation GHRechargeViewController{
    NSString * payType;
    NSString * lastChargeID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户充值";
    payType = @"wx";
    _btnWx.selected = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingppCallBack:) name:@"PingppCallBack" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_batPay.frame)+47);
}

- (IBAction)onSelectType:(id)sender {
    UIButton * btn = (UIButton*) sender;
    if(btn.tag == 1001){
        payType = @"wx";
        _btnWx.selected = YES;
        _btnAlipay.selected = NO;
    }else{
        payType = @"alipay";
        _btnWx.selected = NO;
        _btnAlipay.selected = YES;
    }
}

- (IBAction)onPay:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (_tfInput.text.length ==0) {
        [self inputToast:@"请输入金额！"];
        return;
    }
    if(_tfInput.text.floatValue<10){
        return [self inputToast:@"不得低于10元!"];
    }
    if(_tfInput.text.floatValue>50000){
        return [self inputToast:@"不可高于50000元!"];
    }
    
    [[ServerManger getInstance] topdUpMoney:_tfInput.text.floatValue channel:payType andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [self inputToast:@"请求支付!"];
                if (data[@"object"] == [NSNull null]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PingppCallBack" object:nil];
                }else{
                    lastChargeID = data[@"object"][@"id"];
                    [Pingpp createPayment:data[@"object"] viewController:self appURLScheme:@"com.pinjian.gh.pay" withCompletion:^(NSString *result, PingppError *error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PingppCallBack" object:error];
                    }];
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)pingppCallBack:(NSNotification *)notification{
    if (lastChargeID == nil) {
        [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
        return;
    }
    PingppError *error = notification.object;
    if (error == nil) {
        [[ServerManger getInstance] notifyAccount:lastChargeID  andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    [self inputToast:@"充值成功!"];
                }else{
                    [self inputToast:msg];
                }
                [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
            }
        }];
    } else {
        NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
        [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
    }
    
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
