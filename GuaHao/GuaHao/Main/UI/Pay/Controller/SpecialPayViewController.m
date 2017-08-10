//
//  SpecialPayViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/7/19.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SpecialPayViewController.h"
#import "PaySuccessController.h"
#import "PayPageVO.h"
#import "Pingpp.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "AccOrderDetailViewController.h"
#import "OrderDetailPriceView.h"

@interface SpecialPayViewController (){
    int countdown;
    BOOL isDescMore;
    BOOL isPayMore;
    BOOL isWxPay;
    BOOL isSucess;
    PayPageVO * payVO;
    NSString * lastChargeID;
}

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pzFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *coupunTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNumberLabel;
@property (weak, nonatomic) IBOutlet UISwitch *balanceSwitch;
@property (weak, nonatomic) IBOutlet UILabel *balanceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *endPriceLabel;






@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (strong, nonatomic)    NSTimer *countdownTimer;
@property (strong, nonatomic) UsedCouponsVO *selectCoupon;
@end

@implementation SpecialPayViewController
-(NSTimer *)countdownTimer{
    static NSTimer *countdownTimer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
        [countdownTimer fire];
        
    }) ;
    return countdownTimer;
}
-(void)countdownEvent{
    if(countdown <=0) {
        self.countDownLabel.text = @"支付时间已结束，请重新下单";
        [self countdownEventStop];
    } else {
        self.countDownLabel.text = [NSString stringWithFormat:@"支付剩余时间：%02d分%02d秒",countdown/60,countdown%60];
    }
    countdown--;
    
}
-(void)countdownEventStop{
    _countdownTimer
    
    = nil;
    _countdownTimer.fireDate = [NSDate distantPast];
}
-(void)countdownEventStart{
    _countdownTimer.fireDate = [NSDate distantFuture];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self back];
    isDescMore = !isDescMore;
    isPayMore = !isPayMore;
    isWxPay = YES;
    self.wxButton.selected = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingppCallBack:) name:@"PingppCallBack" object:nil];
    __weak typeof(self) weakSelf = self;

        [[ServerManger getInstance] getPayOrderPageData:_orderID isExpert:_isExpert andCallback:^(id data) {
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        
                        [ServerManger getInstance].payTime = [Utils getCurrentSecond];
                        payVO = [PayPageVO mj_objectWithKeyValues:data[@"object"]];
                        [weakSelf creatrCountDownTimer];
                        [weakSelf initView];
                    }
                    
                }
            }
        }];
    
    
    
    
}
-(void)back{
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 30, 30);
    [rightItemButton setImage:[UIImage imageNamed:@"point_back.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)onBack:(id)sender {

                GHExpertOrderDetialViewController * view = [GHViewControllerLoader GHExpertOrderDetialViewController];
                view.orderNO = payVO.serialNo;
                view.popBack = PopBackRoot;
                view.orderType = _isExpert?1:0;
                [self.navigationController pushViewController:view animated:YES];
}
-(void)pingppCallBack:(NSNotification *)notification{
    if (lastChargeID == nil) {
        [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];
        return;
    }
    PingppError *error = notification.object;
    if (error == nil) {
        __weak typeof(self) weakSelf = self;

            [[ServerManger getInstance] notifyOrder:lastChargeID isExpert:_isExpert  andCallback:^(id data) {
                [weakSelf.view hideToastActivity];
                if (data!=[NSNull class]&&data!=nil) {
                    NSNumber * code = data[@"code"];
                    NSString * msg = data[@"msg"];
                    if (code.intValue == 0) {
                        [weakSelf inputToast:@"支付成功!"];
                    }else{
                        isSucess = NO;
                        [weakSelf inputToast:msg];
                    }
                    [weakSelf performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];
                }
            }];
        
        
        
    } else {
        NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
        isSucess = NO;
        [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];
    }
    
}


-(void)initView{
    
    self.serialNoLabel.text = payVO.serialNo;
    

    self.orderPriceLabel.text = [NSString stringWithFormat:@"%@元",payVO.registrationFee];
    
    self.pzFeeLabel.text = [NSString stringWithFormat:@"%@元",payVO.pzFee];
    
    self.discountLabel.text = [NSString stringWithFormat:@"(%@)陪诊费%.1f折",(payVO.discountName.length> 0 ?payVO.discountName:@"非会员") ,payVO.discountRate.floatValue* 10];///
    self.discountNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",payVO.discountMoney.floatValue];///折扣的前
    
    if (payVO.couponse_pay) {
        self.selectCoupon = payVO.couponse_pay;
        self.coupunTypeLabel.text = [NSString stringWithFormat:@"%@",payVO.couponse_pay.name];
        ///优惠券的钱
        self.couponNumberLabel.text = [NSString stringWithFormat:@"-%@元",payVO.couponse_pay.money.floatValue > 0 ? payVO.couponse_pay.money :@"0"];
    }
    
    

    ///折扣后并且减去优惠券的费用
    float afterDiscountFee = payVO.registrationFee.floatValue + payVO.pzFee.floatValue - payVO.discountMoney.floatValue - payVO.couponse_pay.money.floatValue;
    if (payVO.banlance.floatValue >= afterDiscountFee) {
        ///余额可供支付
        self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",afterDiscountFee];
        
        self.totalPriceLabel.text = [NSString stringWithFormat:@"0元"];
        self.endPriceLabel.text = [NSString stringWithFormat:@"0元"];

    }else{
        self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",payVO.banlance.floatValue];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance.floatValue];
        self.endPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance.floatValue];

    }
    

    
    
    
    
}

-(void)creatrCountDownTimer{
    countdown = payVO.payRemainingTime.intValue;
    if (!_countdownTimer) {
        _countdownTimer
        = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
    }
    
    [_countdownTimer fire];
    
}













- (IBAction)switchAction:(UISwitch *)sender {
    [self reloadPayInfo];
}
-(void)reloadPayInfo{
    float afterDiscountFee = payVO.registrationFee.floatValue + payVO.pzFee.floatValue - payVO.discountMoney.floatValue - self.selectCoupon.money.floatValue;
    
    self.discountLabel.text = [NSString stringWithFormat:@"(%@)陪诊费%.1f折",payVO.discountName,payVO.discountRate.floatValue* 10];///
    self.discountNumberLabel.text = [NSString stringWithFormat:@"-%@元",payVO.discountMoney];
    
    self.coupunTypeLabel.text = self.selectCoupon.name;
    self.couponNumberLabel.text = [NSString stringWithFormat:@"-%@元",self.selectCoupon.money.floatValue > 0 ? self.selectCoupon.money :@"0"];

    if (self.balanceSwitch.isOn) {
        ///折扣后并且减去优惠券的费用
        if (payVO.banlance.floatValue >= afterDiscountFee) {
            ///余额可供支付
            self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",afterDiscountFee];
            
            self.totalPriceLabel.text = [NSString stringWithFormat:@"0元"];
            self.endPriceLabel.text = [NSString stringWithFormat:@"0元"];
            
        }else{
            self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",payVO.banlance.floatValue];
            self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance.floatValue];
            self.endPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance.floatValue];
            
        }
    }else{
        self.balanceNumberLabel.text = [NSString stringWithFormat:@"0元"];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee ];
        self.endPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee ];
    }

}
- (IBAction)discountAction:(id)sender {
    SpecialDiscountListViewController *listVC = [GHViewControllerLoader SpecialDiscountListViewController];
    [listVC selectCouponAction:^(UsedCouponsVO *selectCoupon) {
        self.selectCoupon = selectCoupon;
        ///刷新价格
        [self reloadPayInfo];
    }];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)wxAction:(id)sender {
    self.wxButton.selected = YES;
    self.alipayButton.selected = NO;
    isWxPay = YES;
}

- (IBAction)alipayAction:(id)sender {
    self.wxButton.selected = NO;
    self.alipayButton.selected = YES;
    isWxPay = NO;
}

- (IBAction)sureAction:(id)sender {
    NSLog(@"pay....");
    NSString * type = isWxPay?@"wx":@"alipay";
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] payOrder:payVO.id channel:type couponID:self.selectCoupon.id.stringValue useBalance:self.balanceSwitch.isOn andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [weakSelf inputToast:@"请求支付!"];
                if (data[@"object"] == [NSNull null]) {
                    PaySuccessController * view = [[PaySuccessController alloc]init];
                    view.isExpert = _isExpert;
                    view.orderID = _orderID;
                    [weakSelf.navigationController pushViewController:view animated:YES];
                }else{
                    lastChargeID = data[@"object"][@"id"];
                    [Pingpp createPayment:data[@"object"] viewController:weakSelf appURLScheme:@"com.pinjian.gh.pay" withCompletion:^(NSString *result, PingppError *error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PingppCallBack" object:error];
                    }];
                }
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];

    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
