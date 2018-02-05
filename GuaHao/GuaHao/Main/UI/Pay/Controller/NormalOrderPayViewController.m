//
//  NormalOrderPayViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/11/6.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "NormalOrderPayViewController.h"
#import "PaySuccessController.h"
#import "PayPageVO.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GHPayManager.h"
#import "GHWXPay.h"
#import "payRequsestHandler.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "AccOrderDetailViewController.h"
#import "OrderDetailPriceView.h"
@interface NormalOrderPayViewController (){
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
@property (weak, nonatomic) IBOutlet UIView *orderPriceInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderPriceInfoVIewHeight;

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

@implementation NormalOrderPayViewController
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
    __weak typeof(self) weakSelf = self;
    
    [[ServerManger getInstance] getPayNormalOrderPageData:_orderID andCallback:^(id data) {
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
    
    GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
    view.orderNO = payVO.serialNo;
    view.popBack = PopBackRoot;
    view.orderType = 0;
    [self.navigationController pushViewController:view animated:YES];
}



-(void)initView{
    
    self.serialNoLabel.text = payVO.serialNo;
//    id = 131464,
//    reg_fee = 22,
//    card_fee = 1.5,
//    payRemainingTime = 1798,
//    banlance_pay = 23.5,
//    couponse_pay = <null>,
//    serialNo = 171107131337001,
//    service_fee = 0
    
    
    
    NSMutableArray *sourceArr = [NSMutableArray array];
    NSMutableArray *sourceNameArr = [NSMutableArray array];
    if(self.isScoialCard){///如果是医保卡只有一行陪诊费
        [sourceArr addObject: payVO.service_fee];
        [sourceNameArr addObject: @"陪诊费用"];

    }else{///如果是普通号就两行挂号费和陪诊费，三行加价个工本费
        [sourceArr addObject: payVO.service_fee];
        [sourceArr addObject: payVO.reg_fee];
        [sourceNameArr addObject: @"陪诊费用"];
        [sourceNameArr addObject: @"挂号费用"];

        if(payVO.card_fee.floatValue > 0){
            [sourceArr addObject: payVO.card_fee];
            [sourceNameArr addObject: @"工本费用"];
        }
    }

    self.orderPriceInfoVIewHeight.constant = sourceArr.count * 25;
    for (int i  = 0; i < sourceArr.count; i++) {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, i * 25, 60, 20)];
        UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, i * 25, 150, 20)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.font = [UIFont systemFontOfSize:12];
        NSNumber *valuestr = [sourceArr objectAtIndex:i];
        valueLabel.text = [NSString stringWithFormat:@"%.2f元",valuestr.floatValue];
        nameLabel.text = [sourceNameArr objectAtIndex:i];

        [self.orderPriceInfoView addSubview:nameLabel];
        [self.orderPriceInfoView addSubview:valueLabel];
        
    }
    
    
    

    
    
    if (payVO.couponse_pay) {
        self.selectCoupon = payVO.couponse_pay;
        self.coupunTypeLabel.text = [NSString stringWithFormat:@"%@",payVO.couponse_pay.name];
        ///优惠券的钱
        self.couponNumberLabel.text = [NSString stringWithFormat:@"-%@元",payVO.couponse_pay.money.floatValue > 0 ? payVO.couponse_pay.money :@"0"];
    }
    
    
    
    ///折扣后并且减去优惠券的费用
    float afterDiscountFee = (self.isScoialCard ? 0 : payVO.reg_fee.floatValue) + payVO.service_fee.floatValue  - payVO.couponse_pay.money.floatValue;
    if (payVO.banlance_pay.floatValue >= afterDiscountFee) {
        ///余额可供支付
        self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",afterDiscountFee];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"0元"];
        self.endPriceLabel.text = [NSString stringWithFormat:@"0元"];
        
    }else{
        self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",payVO.banlance_pay.floatValue];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance_pay.floatValue];
        self.endPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance_pay.floatValue];
        
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
    float afterDiscountFee =  (self.isScoialCard ? 0 : payVO.reg_fee.floatValue) + payVO.service_fee.floatValue  - payVO.couponse_pay.money.floatValue;
    
    
    self.coupunTypeLabel.text = self.selectCoupon.name;
    self.couponNumberLabel.text = [NSString stringWithFormat:@"-%@元",self.selectCoupon.money.floatValue > 0 ? self.selectCoupon.money :@"0"];
    
    if (self.balanceSwitch.isOn) {
        ///折扣后并且减去优惠券的费用
        if (payVO.banlance_pay.floatValue >= afterDiscountFee) {
            ///余额可供支付
            self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",afterDiscountFee];
            
            self.totalPriceLabel.text = [NSString stringWithFormat:@"0元"];
            self.endPriceLabel.text = [NSString stringWithFormat:@"0元"];
            
        }else{
            self.balanceNumberLabel.text = [NSString stringWithFormat:@"-%.2f元",payVO.banlance_pay.floatValue];
            self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance_pay.floatValue];
            self.endPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee -  payVO.banlance_pay.floatValue];
            
        }
    }else{
        self.balanceNumberLabel.text = [NSString stringWithFormat:@"0元"];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee ];
        self.endPriceLabel.text = [NSString stringWithFormat:@"%.2f元",   afterDiscountFee ];
    }
    
}
- (IBAction)discountAction:(id)sender {
    NormalDiscountListViewController *listVC = [GHViewControllerLoader NormalDiscountListViewController];
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
    NSString * type = isWxPay?@"2":@"1";
    __weak typeof(self) weakSelf = self;
    GHPayType payType = isWxPay?GHPayTypeWX:GHPayTypeAlipay ;

    [[ServerManger getInstance] payNormalOrder:payVO.id channel:type couponID:self.selectCoupon.id.stringValue useBalance:self.balanceSwitch.isOn andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [weakSelf inputToast:@"请求支付!"];
                if (data[@"object"] == [NSNull null]) {
                    PaySuccessController * view = [[PaySuccessController alloc]init];
                    view.isExpert = NO;
                    view.orderID = _orderID;
                    [weakSelf.navigationController pushViewController:view animated:YES];
                }else{
                    lastChargeID = data[@"object"][@"id"];
                    [[GHPayManager sharePayManager] getPayWithPayType:payType parameters:[data objectForKey:@"object"]  action:^(NSString *orderID, NSInteger errorCode) {
                        NSLog(@"%ld",(long)errorCode);
                        [weakSelf payBackAction:errorCode parameters:[data objectForKey:@"object"]];
                    }];

                }
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
    
    
    
}





-(void)payBackAction:(NSInteger)errorCode parameters:(NSDictionary *)parameters{
    if (errorCode == 0) {///成功
//        [self inputToast:@"支付成功!"];
        
        [self accountPayPolling:parameters[@"out_trade_no"] parameters:parameters];
        
    }else if (errorCode == 1){///取消
        [self inputToast:@"取消支付!"];
    }else{//错误
        [self inputToast:@"支付失败!"];
        
    }
    
    
}


-(void)accountPayPolling:(NSString *)orderID parameters:(NSDictionary *)parameters{
    __weak typeof(self) weakSelf = self;
    __block int countTimes = 0;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        [self.view makeToastActivity:CSToastPositionCenter];

        //在这里执行事件
        [[ServerManger getInstance] getNormalOrderPayStatus:orderID andCallback:^(id data) {
            [weakSelf.view hideToasts];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                //                NSString * msg = data[@"msg"];
                
                if (code.intValue == 0) {
                    
                    // 取消定时器
                    dispatch_cancel(_timer);
                    _timer = nil;
                    [weakSelf inputToast:@"支付成功!"];
                    [weakSelf performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];

                    
                }
                if (code.intValue != 0 && countTimes > 15) {
                    dispatch_cancel(_timer);
                    _timer = nil;
                    [weakSelf inputToast:@"支付异常!"];
                    [weakSelf performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];

                }
                
                
                
                countTimes ++;
                
            }
        }];
        
    });
    
    dispatch_resume(_timer);
    
    
    
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

