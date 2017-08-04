//
//  AccNewOrderDetailViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/9.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "AccNewOrderDetailViewController.h"
#import "AccDetialVO.h"
#import "ZoomImageView.h"
#import "UIButton+EMWebCache.h"
#import "ImageViewController.h"
#import "OrderDetailPriceView.h"
#import "EvaluateViewController.h"
@interface AccNewOrderDetailViewController (){
    AccDetialVO *_orderVO;
}
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *serialNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accompanyNameLabel
;
@property (weak, nonatomic) IBOutlet UILabel *accompanyPhoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (strong, nonatomic)     OrderDetailPriceView *orderPriceView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation AccNewOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.serviceType == 1 ? @"代取报告":@"代取药品";
    self.orderDateLabel.text = self.serviceType == 1 ? @"取报告时间":@"取药时间";
    [self getData];

    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]getAccDetailOrderStatus:self.serialNo longitude:@"" latitude:@"" andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                _orderVO = [AccDetialVO mj_objectWithKeyValues:data[@"object"]];
                [self loadSubView];

                if (_orderVO.canBeCancelled.intValue == 1) {
                    self.cancelButton.hidden = YES;
                }else{
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}

-(void)loadSubView{
    [self addStatus];
    [self loadSelectImages];
    self.serialNoLabel.text = _orderVO.serialNo;
    self.hospitalLabel.text = _orderVO.hospName;
    self.dateLabel.text = _orderVO.visitDate;
    self.acceptPersonLabel.text = _orderVO.receiverName;
    self.acceptPhoneLabel.text = _orderVO.receiverMobile;
    self.personLabel.text = _orderVO.patientName;
    self.IDCardLabel.text = _orderVO.patientIdcard;
    self.phoneLabel.text = _orderVO.patientMobile;
    self.accompanyNameLabel.text = _orderVO.waiterName.length > 1 ? _orderVO.waiterName : @"暂未信息";
    self.accompanyPhoneLabel.text = _orderVO.waiterMobile.length > 1 ? _orderVO.waiterMobile : @"暂无信息";
    self.statusImageView.image = [UIImage imageNamed:@"order_detail_status_accept"];
    self.statusLabel.text = _orderVO.statusCn;
    self.statusDescLabel.text = _orderVO.statusDesc;
    self.totalFeeLabel.text = [NSString stringWithFormat:@"%.2f元",_orderVO.total_fee.doubleValue];
    self.addressLabel.text = _orderVO.transferAddr;
    
    NSArray *MedicineSourceArr = @[@{@"type":@"代取服务",@"value":_orderVO.service_fee,@"hidden":@"0"},@{@"type":@"药品费用",@"value":_orderVO.drugFee,@"hidden":@"1"},@{@"type":@"优惠券",@"value":_orderVO.couponse_pay.money,@"hidden":@"0"},@{@"type":@"余额支付",@"value":_orderVO.banlance_pay,@"hidden":@"1"},@{@"type":@"实际支付",@"value":_orderVO.actual_pay,@"hidden":@"0"}];
    NSArray *reportSourceArr = @[@{@"type":@"代取服务",@"value":_orderVO.service_fee,@"hidden":@"1"},@{@"type":@"优惠券",@"value":_orderVO.couponse_pay.money,@"hidden":@"0"},@{@"type":@"余额支付",@"value":_orderVO.banlance_pay,@"hidden":@"1"},@{@"type":@"实际支付",@"value":_orderVO.actual_pay,@"hidden":@"0"}];
     self.orderPriceView= [[OrderDetailPriceView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 5 * 44)];
    [self.orderPriceView reloadTableViewWithSourceArr:_orderVO.pzType.intValue == 1 ? reportSourceArr : MedicineSourceArr];
    [self.priceView addSubview:self.orderPriceView];
    self.orderPriceView.hidden = YES;

}

- (IBAction)priceInfoAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.priceViewHeight.constant = 50 + 44 *5;
        self.orderPriceView.hidden = NO;
    }else{
        self.priceViewHeight.constant = 50;
        self.orderPriceView.hidden = YES;
    }
}
- (IBAction)callAction:(id)sender {
    if (_orderVO.waiterMobile.length > 3) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:+86%@",_orderVO.waiterMobile];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    }
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
-(void)addStatus{
    [self.statusView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = _orderVO.statusLogs.count;
    CGFloat originX = SCREEN_WIDTH /(count * 2.0);
    CGFloat space = SCREEN_WIDTH /count;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(originX, 40, space * (count - 1), 2)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.statusView addSubview:lineView];
    for (int i = 0; i < count; i++) {
        StatusLogVO *vo = [_orderVO.statusLogs objectAtIndex:i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.center = CGPointMake(originX + space * i, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = vo.name;
        label.textColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0x888888);
        label.font = [UIFont systemFontOfSize:12];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 41, 10, 10)];
        view.backgroundColor = vo.isChecked ? UIColorFromRGB(0x45c768) :UIColorFromRGB(0x888888);
        view.center = CGPointMake(originX + space * i, 41);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.statusView addSubview:label];
        [self.statusView addSubview:view];
    }
    
}
-(void)loadSelectImages{
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 0;
    for (int i = 0; i < _orderVO.imgs.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX , 5, 60, 60);
        [button sd_setBackgroundImageWithURL:[[_orderVO.imgs objectAtIndex:i] objectForKey:@"imgUrl"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageScrollView addSubview:button];
        originX = originX + 5 + 60;
    }
    self.imageScrollView.contentSize = CGSizeMake(originX + 80, CGRectGetHeight(self.imageScrollView.frame));
    
}
#pragma mark - 二维码点击放大
- (IBAction)zoomImageAction:(UITapGestureRecognizer *)sender {
    ZoomImageView *zoomView = [[ZoomImageView alloc]initWithFrame:self.view.frame];
    [zoomView zoomImageWith:_orderVO.ticketQrcode];
    [self.view addSubview:zoomView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)lookAction:(UIButton *)sender{
    ImageViewController * view = [[ImageViewController alloc]init];
    view.image = sender.currentBackgroundImage;
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]cancelAccompanyOrder:_orderVO.id andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [weakSelf inputToast:@"取消订单成功!"];
                weakSelf.cancelButton.hidden = YES;
                [weakSelf getData];
                sender.hidden = YES;
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
///评价
- (IBAction)evaluateAction:(id)sender {
    if (_orderVO.status.intValue != 9) {
        return;
    }
    if (_orderVO.evaluated.intValue == 0) {
        EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
        evaluateVC._id = _orderVO.id;
        evaluateVC.orderType = [NSNumber numberWithInt:2];
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else{
        EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
        evaluateOKVC._id = _orderVO.id;
        evaluateOKVC.orderType = [NSNumber numberWithInt:2];
        [self.navigationController pushViewController:evaluateOKVC animated:YES];
    }
    
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
