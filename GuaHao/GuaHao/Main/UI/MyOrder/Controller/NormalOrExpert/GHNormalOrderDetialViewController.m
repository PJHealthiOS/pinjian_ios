//
//  GHNormalOrderDetialViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/6/1.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GHNormalOrderDetialViewController.h"
#import "OrderVO.h"
#import "ZoomImageView.h"
#import "PayViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "OrderDetailPriceView.h"





@interface GHNormalOrderDetialViewController ()<UIAlertViewDelegate>{
    BOOL   isRefresh;
    NSTimer *countdownTimer;
}

@property (weak, nonatomic) IBOutlet UIView *order_Info_view;
@property (weak, nonatomic) IBOutlet UIView *accepter_info_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accepter_view_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accepter_info_height;





@property (weak, nonatomic) IBOutlet UIImageView *status_icon_imageView;
@property (weak, nonatomic) IBOutlet UILabel *status_title_label;
@property (weak, nonatomic) IBOutlet UILabel *status_info_label;
@property (weak, nonatomic) IBOutlet UIView *status_info_view;
@property (weak, nonatomic) IBOutlet UILabel *status_progress_label;



@property (weak, nonatomic) IBOutlet UILabel *serialNo_label;
@property (weak, nonatomic) IBOutlet UILabel *hospital_label;
@property (weak, nonatomic) IBOutlet UILabel *department_label;
@property (weak, nonatomic) IBOutlet UILabel *order_date_label;

@property (weak, nonatomic) IBOutlet UILabel *patient_name_label;
@property (weak, nonatomic) IBOutlet UILabel *patient_card_label;
@property (weak, nonatomic) IBOutlet UILabel *patient_phone_label;
@property (weak, nonatomic) IBOutlet UILabel *patient_remark_label;
@property (weak, nonatomic) IBOutlet UIButton *remark_info_button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remark_label_height;

@property (weak, nonatomic) IBOutlet UILabel *pay_type_label;

@property (weak, nonatomic) IBOutlet UILabel *price_label;
@property (weak, nonatomic) IBOutlet UIButton *price_info_button;
@property (weak, nonatomic) IBOutlet UIView *price_info_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *price_info_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_info_height;


@property (weak, nonatomic) IBOutlet UILabel *accepter_name;
@property (weak, nonatomic) IBOutlet UILabel *accepter_date_label;
@property (weak, nonatomic) IBOutlet UILabel *accepter_phone_label;
@property (weak, nonatomic) IBOutlet UIButton *accepter_call_button;
@property (weak, nonatomic) IBOutlet UIButton *accepter_certificate_button;
@property (weak, nonatomic) IBOutlet UIButton *confirm_imageView;


@property (weak, nonatomic) IBOutlet UIButton *left_bottom_button;
@property (weak, nonatomic) IBOutlet UIButton *right_bottom_button;





@property (strong, nonatomic) OrderVO *orderVO;
@property (assign,nonatomic) int payRemainingTime;
@property (strong, nonatomic) OrderDetailPriceView *orderPriceView;





@end

@implementation GHNormalOrderDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    [self getData];
    
    // Do any additional setup after loading the view.
}

-(void)getData
{

        [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
        [[ServerManger getInstance] getOrderStatus:_orderNO longitude:@"" latitude:@"" andCallback:^(id data) {
            [weakSelf.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    weakSelf.orderVO = [OrderVO mj_objectWithKeyValues:data[@"object"]];
             
                    
                    if (weakSelf.orderVO.status.intValue == 1) {
                        [weakSelf createCountdownTimer];
                        weakSelf.payRemainingTime = weakSelf.orderVO.payRemainingTime.intValue;
                    }else{
                        [weakSelf removeCountdownTimer];
                    }
                    [weakSelf changeOrderAlter];//进来时弹框
                    [ServerManger getInstance].descTime = [Utils getCurrentSecond];
                    if (isRefresh) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderCellUpdate" object:weakSelf.orderVO];
                        isRefresh = NO;
                        
                    }
                    [weakSelf reloadInfoView];
                }else{
                    [weakSelf inputToast:msg];
                }
            }
        }];
        
        
}

-(void)reloadInfoView{
    
     NSDictionary *dic = @{@"1":@"order_detail_status_pay.png",@"2":@"order_detail_status_accept.png",@"3":@"order_detail_status_accept.png",@"4":@"order_detail_status_accept.png",@"9":@"order_detail_status_end.png",@"10":@"order_detail_status_end.png"};
    self.status_icon_imageView.image = [UIImage imageNamed:[dic objectForKey:[NSString stringWithFormat:@"%@",self.orderVO.status]]];
    self.status_title_label.text = self.orderVO.statusCn;
    self.status_info_label.text = self.orderVO.statusDesc;

    
    
    if (self.orderVO.visitSeqNotice.length > 0 && self.orderVO.status.intValue == 4) {
        
        self.status_progress_label.backgroundColor = UIColorFromRGB(0xf0f0f0);
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.orderVO.visitSeqNotice dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.status_progress_label.attributedText = attrStr;
    }else{
        self.status_progress_label.backgroundColor = [UIColor whiteColor];

    }
    
    [self addStatus];
    
    self.serialNo_label.text = self.orderVO.serialNo;
    self.hospital_label.text = self.orderVO.hospName;
    self.department_label.text = self.orderVO.deptName;
    self.order_date_label.text = self.orderVO.visitDate;
    self.patient_name_label.text = [NSString stringWithFormat:@"%@(%@)",self.orderVO.patientName,self.orderVO.patientSex];
    self.patient_card_label.text = self.orderVO.patientIdcard;
    self.patient_phone_label.text = self.orderVO.patientMobile;
    self.patient_remark_label.text = self.orderVO.patientComments;
    self.price_label.text = [NSString stringWithFormat:@"%@ 元",self.orderVO.totalFee];;
    self.pay_type_label.text = self.orderVO.payType;
    
    
    //如果待挂号就显示接单这信息
    if (_orderVO.acceptorMobile.length > 8) {
        self.accepter_info_view.hidden = NO;
        self.accepter_view_top.constant = 5;
        self.accepter_info_height.constant = 300;
        
    }else{
        self.accepter_info_view.hidden = YES;
        self.accepter_view_top.constant = 0;
        self.accepter_info_height.constant = 0;
    }

    
    
    self.accepter_name.text = self.orderVO.acceptUser;
    self.accepter_date_label.text = self.orderVO.acceptDate;
    self.accepter_phone_label.text = self.orderVO.acceptorMobile;
    self.serialNo_label.text = self.orderVO.serialNo;
    [self.accepter_certificate_button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.orderVO.ticketImgUrl] forState:UIControlStateNormal];
    [self.confirm_imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:self.orderVO.getTicketQRCode] forState:UIControlStateNormal];
    [self.accepter_certificate_button setTitle:self.orderVO.visitSeq forState:UIControlStateNormal];
    
    
    
    
    
    
    ///1 未支付时显示取消和去支付两个按钮
    // 2 只显示取消
    //9.10 显示删除订单 和 再来一单
    /// 普通号   订单挂号状态 1.待支付 2待接单 3待挂号 4待就诊   9已完成  10已取消
    self.left_bottom_button.width =  SCREEN_WIDTH - 230;
    switch (_orderVO.status.intValue) {
            
        case 2:
        {
            self.right_bottom_button.hidden = YES;
            CGRect frame = self.left_bottom_button.frame;
            self.left_bottom_button.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH - 20, frame.size.height);
        }
            break;
        case 3:
        {
            self.right_bottom_button.hidden = YES;
            CGRect frame = self.left_bottom_button.frame;
            self.left_bottom_button.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH - 20, frame.size.height);
        }
            break;
        case 4:
        {
            if (self.orderVO.onlineQueue) {
                [self.right_bottom_button setTitle:@"候诊查询" forState:UIControlStateNormal];
            }else{
                self.right_bottom_button.hidden = YES;
                CGRect frame = self.left_bottom_button.frame;
                self.left_bottom_button.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH - 20, frame.size.height);
            }
        }
            break;
            
        case 9:
        {
            [self.left_bottom_button setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.right_bottom_button setTitle:@"再次挂号" forState:UIControlStateNormal];
        }
            break;
            
        case 10:
        {
            [countdownTimer invalidate];
            [self.left_bottom_button setTitle:@"删除订单" forState:UIControlStateNormal];[self.right_bottom_button setTitle:@"再次挂号" forState:UIControlStateNormal];
        }
            break;
            
        default:{
//            self.cancelButtonLeftSpeace.constant = SCREEN_WIDTH - 100 - 25;
            [self.left_bottom_button setTitle:@"取消订单" forState:UIControlStateNormal];
        }
            break;
    }

    
    
    
    
    
    
    
}
-(void)addStatus{
    [self.status_info_view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = _orderVO.statusLogs.count;
    CGFloat originX = (SCREEN_WIDTH - 56) /(count * 2.0);
    CGFloat space = (SCREEN_WIDTH - 56) /count;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(originX, 40, space * (count - 1), 2)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.status_info_view addSubview:lineView];
    for (int i = 0; i < count; i++) {
        StatusLogVO *vo = [_orderVO.statusLogs objectAtIndex:i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.center = CGPointMake(originX + space * i, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = vo.name;
        label.textColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0xacacac);
        label.font = [UIFont systemFontOfSize:12];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 41, 10, 10)];
        view.backgroundColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0xacacac);
        view.center = CGPointMake(originX + space * i, 41);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.status_info_view addSubview:label];
        [self.status_info_view addSubview:view];
    }
    
}

- (IBAction)remark_info_action:(UIButton *)sender {
    CGFloat patientInfoHeight = [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 172, 0) str: _orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments fount:14].height;
    
    if (sender.selected) {
        self.remark_label_height.constant = 17;
        self.order_info_height.constant = self.order_info_height.constant - patientInfoHeight + 17;
    }else{
        self.remark_label_height.constant = patientInfoHeight;
        self.order_info_height.constant = self.order_info_height.constant + patientInfoHeight - 17;
    }
    sender.selected = !sender.selected;
}


- (IBAction)price_info_action:(UIButton *)sender {
    
    if (sender.selected) {
        self.price_info_height.constant = 0;
        self.price_info_view.hidden = YES;
        self.order_info_height.constant = self.order_info_height.constant - 230;
        [self.orderPriceView removeFromSuperview];
    }else{
        self.price_info_height.constant = 220;
        self.price_info_view.hidden = NO;
        self.order_info_height.constant = self.order_info_height.constant + 230;
        NSString *serviceFee = [NSString stringWithFormat:@"%@",[[_orderVO.orderFeeFrom objectAtIndex:0] objectForKey:@"value"]];
        NSString *orderFee = [NSString stringWithFormat:@"%@",[[_orderVO.orderFeeFrom objectAtIndex:1] objectForKey:@"value"]];
        NSString *couponsePay = [NSString stringWithFormat:@"%@",[[_orderVO.orderFeeTo objectAtIndex:0] objectForKey:@"value"]];
        NSString *discountPay = [NSString stringWithFormat:@"%@",[[_orderVO.orderFeeTo objectAtIndex:1] objectForKey:@"value"]];
        NSString *actualPay = [NSString stringWithFormat:@"%@",_orderVO.actualPay];
        NSArray *reportSourceArr = @[@{@"type":[[_orderVO.orderFeeFrom objectAtIndex:0] objectForKey:@"name"],@"value":serviceFee,@"hidden":@"0"},@{@"type":[[_orderVO.orderFeeFrom objectAtIndex:1] objectForKey:@"name"],@"value":orderFee,@"hidden":@"1"},@{@"type":[[_orderVO.orderFeeTo objectAtIndex:0] objectForKey:@"name"],@"value":couponsePay,@"hidden":@"0"},@{@"type":[[_orderVO.orderFeeTo objectAtIndex:1] objectForKey:@"name"],@"value":discountPay,@"hidden":@"1"},@{@"type":@"实际支付",@"value":actualPay,@"hidden":@"0"}];
        self.orderPriceView = [[OrderDetailPriceView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 5 * 44)];
        [self.orderPriceView reloadTableViewWithSourceArr:reportSourceArr];
        [self.price_info_view addSubview:self.orderPriceView];
    }

    
    sender.selected = !sender.selected;

}


- (IBAction)call_action:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://+86%@",_orderVO.acceptorMobile]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)certificate_button_action:(UIButton *)sender {
    
    
}

- (IBAction)confirm_button_action:(UIButton *)sender {
    ZoomImageView *zoomView = [[ZoomImageView alloc]initWithFrame:self.view.frame];
    [zoomView zoomImageWith:_orderVO.getTicketQRCode];
    [self.view addSubview:zoomView];

}

- (IBAction)evaluate_action:(id)sender {
    if (_orderVO.status.intValue != 9) {
        [self inputToast:@"订单未完成不能评价"];
        return;
    }
    if (_orderVO.evaluated.intValue == 0) {
        EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
        evaluateVC._id = _orderVO.id;
        evaluateVC.orderType = [NSNumber numberWithInt:self.orderType];
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else{
        EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
        evaluateOKVC._id = _orderVO.id;
        evaluateOKVC.orderType = [NSNumber numberWithInt:self.orderType];
        [self.navigationController pushViewController:evaluateOKVC animated:YES];
    }

}


- (IBAction)left_bottom_action:(UIButton *)sender {
    if (_orderVO.status.intValue == 9 || _orderVO.status.intValue == 10) {
        [self deleteOrder];
    }else{
        [self cancelOrder];
    }
}
-(void)cancelOrder{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] cancelOrder:_orderVO.id andNormalType:(self.orderType == 0 ? YES : NO) andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [weakSelf inputToast:@"取消订单成功!"];
                [weakSelf getData];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
-(void)deleteOrder{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] deleteOrder:_orderVO.id andNormalType:(self.orderType == 0 ? YES : NO) andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [self inputToast:@"删除订单成功!"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}
- (IBAction)right_bottom_action:(UIButton *)sender {
    if (_orderVO.status.intValue == 4) {//待就诊
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance]inquireCurrentProgress:_orderVO.id fromType:1 andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    [self inputToast:@"已发起请求请稍后在消息中查看!"];
                    
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }
    
    if (_orderVO.status.intValue == 9 || _orderVO.status.intValue == 10) {
        CreateOrderNormalViewController *view = [GHViewControllerLoader CreateOrderNormalViewController];
        [self.navigationController pushViewController:view animated:YES];

    }

    if (_orderVO.status.intValue == 1) {
        PayViewController * view = [GHViewControllerLoader PayViewController];
        view.orderID = _orderVO.id;
        view.isExpert = NO;
        
        
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
    
}










-(void)changeOrderAlter{
    NSString *message = @"";
    NSString *sure = @"确定";
    NSString *cancel = @"取消";
    if (!_orderVO.acceptorOperation || _orderVO.acceptorOperation.intValue == 0) {
        return;
    }
    if (self.orderType == 0) {//普通号
        switch (_orderVO.acceptorOperation.intValue) {
            case 1:
            {
                message = @"转上午普通专家号";
            }
                break;
            case 2:
            {
                message = @"转下午普通专家号";
            }
                break;
            case 3:
            {
                message = @"转下午普通号";
            }
                break;
            case 4:
            {
                message = @"今日号满";
                cancel = nil;
            }
                break;
            case 5:
            {
                message = @"转预约";
            }
                break;
            case 6:
            {
                message = @"转挂号";
            }
                break;
            default:
                break;
        }
        
    }else{
        if (_orderVO.acceptorOperation.intValue == 1) {
            message = @"今日停诊";
            cancel = nil;
        }
    }
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:sure, nil];
    [alterView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *accept = @"";
    if (buttonIndex == 1) {
        accept = @"1";
    }else{
        accept = @"0";
    }
    ///普通号 1.转上午普通专家号 2.转下午普通专家号  3转下午普通号 4今日号满 5挂号转预约   6预约转挂号；
    if (_orderVO.acceptorOperation.intValue == 4) {///号满
        accept = @"1";
    }
    if (self.orderType == 0) {//普通号
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance]acceptChangeNormalOrder:_orderVO.id accept:accept andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                //                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
            }
        }];
    }else{
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance]acceptChangeExpertOrder:_orderVO.id accept:@"1" andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                //                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
            }
        }];
    }
}







//创建定时器
-(void)createCountdownTimer{
    
    if (!countdownTimer) {
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
        [countdownTimer fire];
    }
}
-(void)removeCountdownTimer{
    if (countdownTimer) {
         [self countdownEventStop];
    }
}
-(void)countdownEvent{
    self.payRemainingTime -- ;
    if (self.payRemainingTime <= 0) {
        [self countdownEventStop];
    }
    [self returnCountStr:self.payRemainingTime];
    //    NSLog(@"定时器再走---d");
}
-(void)returnCountStr:(int)time{
    //    NSLog(@"------------------------%d",time);
    int minute = time /60 ;
    int second = time %60 ;
    NSString * str = [NSString stringWithFormat:@"去支付(还剩%02d分%02d秒)",minute,second];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, str.length - 3 )];
    [self.right_bottom_button setAttributedTitle:attStr forState:UIControlStateNormal];
}
-(void)countdownEventStop{
    countdownTimer = nil;
    countdownTimer.fireDate = [NSDate distantPast];
}
-(void)countdownEventStart{
    countdownTimer.fireDate = [NSDate distantFuture];
}





-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    //这里写要处理的代码
    NSArray *viewControllers = self.navigationController.viewControllers;
    if(!_popBack||_popBack==0){
        _popBack = PopBackDefalt;
    }
    NSUInteger num = viewControllers.count - _popBack;
    if(_popBack == PopBackRoot){
        num = 0;
    }
    [self.navigationController popToViewController:[viewControllers objectAtIndex:num] animated:YES];
    return YES;//返回NO 不会执行
    
}
- (CGSize)boundingRectWithSize:(CGSize)size str:(NSString *)str fount:(CGFloat)fount
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fount]};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
}







-(void)viewDidDisappear:(BOOL)animated{
    [countdownTimer invalidate];
    
}
- (void)dealloc
{
    countdownTimer  = nil;
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
