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
#import "GHPayManager.h"
#import "MemberAlterView.h"
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
    GHPayType payType;
    NSString * lastChargeID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户充值";
    payType = GHPayTypeWX;
    _btnWx.selected = YES;
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
        payType = GHPayTypeWX;
        _btnWx.selected = YES;
        _btnAlipay.selected = NO;
    }else{
        payType = GHPayTypeAlipay;
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
    if(_tfInput.text.floatValue < 10){
        return [self inputToast:@"不得低于10元!"];
    }
    if(_tfInput.text.floatValue>50000){
        
        return [self inputToast:@"不可高于50000元!"];
    }
    __weak typeof(self) weakSelf = self ;
    ///请求后台支付方式：1支付宝 2微信APP 3微信公众号 4支付宝沙箱
    [[ServerManger getInstance] topdUpMoney:_tfInput.text.floatValue channel:[NSString stringWithFormat:@"%ld",(long)payType] andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [weakSelf inputToast:@"请求支付!"];
                if (data[@"object"] == [NSNull null]) {
                }else{
//                    lastChargeID = data[@"object"][@"out_trade_no"];
                    [[GHPayManager sharePayManager] getPayWithPayType:payType parameters:[data objectForKey:@"object"]  action:^(NSString *orderID, NSInteger errorCode) {
                        NSLog(@"%ld",(long)errorCode);
                        [weakSelf payBackAction:errorCode parameters:[data objectForKey:@"object"]];
                    }];
                    

                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}


-(void)payBackAction:(NSInteger)errorCode parameters:(NSDictionary *)parameters{
    if (errorCode == 0) {///成功
        [self inputToast:@"充值成功!"];

        [self accountRechargePolling:parameters[@"out_trade_no"] parameters:parameters];
        
    }else if (errorCode == 1){///取消
        [self inputToast:@"取消支付!"];
    }else{//错误
        [self inputToast:@"充值失败!"];
        
    }
    
    
}


-(void)accountRechargePolling:(NSString *)orderID parameters:(NSDictionary *)parameters{
    __weak typeof(self) weakSelf = self;
   __block int countTimes = 0;

    dispatch_queue_t queue = dispatch_get_main_queue();
    __block dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        [self.view makeToastActivity:CSToastPositionCenter];

        //在这里执行事件
        [[ServerManger getInstance] getAccountRechargePayStatus:orderID andCallback:^(id data) {
            [weakSelf.view hideToasts];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                //                NSString * msg = data[@"msg"];
                
                if (code.intValue == 0) {
                    
                    // 取消定时器
                    dispatch_cancel(_timer);
                    _timer = nil;
                    [weakSelf inputToast:@"充值成功!"];
                    [weakSelf rechargeSuccessful:parameters];

                    
                }
                if (code.intValue != 0 && countTimes > 15) {
                    dispatch_cancel(_timer);
                    _timer = nil;
                    [weakSelf inputToast:@"充值异常!"];
                    [weakSelf.navigationController popViewControllerAnimated:NO];

                }
                
                
                
                countTimes ++;

            }
        }];
        
    });
    
    dispatch_resume(_timer);
    
    
    
}











-(void)rechargeSuccessful:(NSDictionary *)parameters{
            __weak typeof(self) weakSelf = self;

    NSDictionary * dict = parameters;
    UserVO *user = [UserVO mj_objectWithKeyValues:dict];
    if (user.memberLevel.intValue > [DataManager getInstance].user.memberLevel.intValue) {
        ////升级了
        [[DataManager getInstance] setLogin:user];
        MemberAlterView *successAlter = [[MemberAlterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) memberLevel:user.memberLevel.intValue discountRate:user.discountRate.floatValue  curAvailableTimes:user.curAvailableTimes.intValue];
        if (weakSelf.myAction) {
            weakSelf.myAction(YES);///通知上那个页面
        }
        [successAlter clickShopAction:^(BOOL result) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];
        [weakSelf.view addSubview:successAlter];
        
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"充值成功" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}



-(void)updateLevelAction:(UpdateSuccessAction)action{
    self.myAction = action;
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

@end
