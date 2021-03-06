//
//  PayViewController.m
//  GuaHao
//
//  Created by qiye on 16/8/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PayViewController.h"
#import "PaySuccessController.h"
#import "PayPageVO.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "AccOrderDetailViewController.h"
#import "OrderDetailPriceView.h"
#import "GHPayManager.h"

@interface PayViewController (){
    int countdown;
}

@property (weak, nonatomic) IBOutlet UIView *priceInfoView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderInfoViewHeight;








@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceInfoViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (strong, nonatomic)    NSTimer *countdownTimer;



@end

@implementation PayViewController{
    BOOL isDescMore;
    BOOL isPayMore;
    BOOL isWxPay;
    BOOL isSucess;
    PayPageVO * payVO;
    NSString * lastChargeID;
}


////////////
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
    if (self.isAccompany) {
        ///支付界面数据
        [[ServerManger getInstance] getAccompanyPayOrderPageData:_orderID andCallback:^(id data) {
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        
                        [ServerManger getInstance].payTime = [Utils getCurrentSecond];
                        payVO = [PayPageVO mj_objectWithKeyValues:data[@"object"]];
                        [weakSelf creatrCountDownTimer];
                        [weakSelf initView];////有错
                    }
                    
                }
            }
        }];
    }else{
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
    
    

}

-(void)initView{
    self.serialNoLabel.text = payVO.serialNo;
    self.priceInfoViewHeight.constant = payVO.orderFee.count * 44 + 90;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",payVO.actualPay.doubleValue];
    NSMutableArray *sourceArr = [NSMutableArray array];
    for (int i = 0; i< payVO.orderFee.count; i++) {
        
        NSString *str = @"0";
        if (i == payVO.orderFee.count - 1) {
            str = @"1";
        }
        NSDictionary * dic =@{@"value":[[payVO.orderFee objectAtIndex:i] objectForKey:@"value"],@"type":[[payVO.orderFee objectAtIndex:i] objectForKey:@"name"],@"hidden":str};
        [sourceArr addObject:dic];
    }
    NSDictionary * dic =@{@"value":payVO.actualPay,@"type":@"实际支付",@"hidden":@"0"};
    [sourceArr addObject:dic];
    
     OrderDetailPriceView * priceView= [[OrderDetailPriceView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, sourceArr.count * 44)];
    [priceView reloadTableViewWithSourceArr:sourceArr];
    [self.priceInfoView addSubview:priceView];
    
    
    
    
    
 
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
////////////////
- (IBAction)orderInfoAction:(UIButton *)sender {
    if (!sender.selected) {
        self.orderInfoViewHeight.constant =  44 +45;
    }else{
        self.orderInfoViewHeight.constant = 45;
    }
    sender.selected = !sender.selected;
}
- (IBAction)priceInfoAction:(UIButton *)sender {
    if (!sender.selected) {
        self.priceInfoViewHeight.constant = payVO.orderFee.count * 44 + 90;
    }else{
        self.priceInfoViewHeight.constant = 45;
    }
    sender.selected = !sender.selected;
}

- (IBAction)wxPayAction:(id)sender {
    self.wxButton.selected = YES;
    self.alipayButton.selected = NO;
    isWxPay = YES;
}

- (IBAction)alipayPayAction:(id)sender {
    self.wxButton.selected = NO;
    self.alipayButton.selected = YES;
    isWxPay = NO;
}

- (IBAction)submitAction:(id)sender {
    NSLog(@"pay....");
    NSString * type = isWxPay?@"2":@"1";
    GHPayType payType = isWxPay?GHPayTypeWX:GHPayTypeAlipay ;
    if (self.isAccompany) {
        ///陪诊支付
        __weak typeof(self) weakSelf = self;
        [[ServerManger getInstance] payAccompanyOrder:payVO.id channel:type  andCallback:^(id data) {
            [weakSelf.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    [weakSelf inputToast:@"请求支付!"];
                    if (data[@"object"] == [NSNull null]) {
//                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"PingppCallBack" object:nil];
                        PaySuccessController * view = [[PaySuccessController alloc]init];
                        view.isExpert = _isExpert;
                        view.isAccompany = YES;
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
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        [[ServerManger getInstance] payOrder:payVO.id channel:type isExpert:_isExpert andCallback:^(id data) {
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
    
    return;

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
        [[ServerManger getInstance] getAccompanyOrderPayStatus:orderID andCallback:^(id data) {
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



-(void)back{
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 30, 30);
    [rightItemButton setImage:[UIImage imageNamed:@"point_back.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)onBack:(id)sender {
    switch (_payType) {
        case OrderCreatePay:
        {
            if (self.isAccompany) {
                if (payVO.pzType.intValue == 0) {
                    AccOrderDetailViewController *view = [GHViewControllerLoader AccOrderDetailViewController];
                    view.serialNo = payVO.serialNo;
                    view.popBack = PopBackRoot;
                    [self.navigationController pushViewController:view animated:YES];
                    return;
                }else{
                    AccNewOrderDetailViewController *view = [GHViewControllerLoader AccNewOrderDetailViewController];
                    view.serialNo = payVO.serialNo;
                    view.popBack = PopBackRoot;
                    [self.navigationController pushViewController:view animated:YES];
                    return;
                }
                
            }
            
            
            
            if (_isExpert) {
                GHExpertOrderDetialViewController * view = [GHViewControllerLoader GHExpertOrderDetialViewController];
                view.orderNO = payVO.serialNo;
                view.popBack = PopBackRoot;
                view.orderType = _isExpert?1:0;
                [self.navigationController pushViewController:view animated:YES];
            }else{
                GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
                view.orderNO = payVO.serialNo;
                view.popBack = PopBackRoot;
                view.orderType = _isExpert?1:0;
                [self.navigationController pushViewController:view animated:YES];
            }
            
            break;
        }
        case OrderListPay:
        {
            break;
        }
        case OrderDescPay:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}



-(void)viewDidDisappear:(BOOL)animated{
    [self.countdownTimer invalidate];
}
- (void)dealloc
{
    self.countdownTimer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
