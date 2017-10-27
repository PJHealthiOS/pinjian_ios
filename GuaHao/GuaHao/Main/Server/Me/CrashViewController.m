//
//  CrashViewController.m
//  GuaHao
//
//  Created by qiye on 16/7/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CrashViewController.h"
#import "BankSelectViewController.h"
#import "BankListVO.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "BankLogViewView.h"
#import "BankLogVO.h"

@interface CrashViewController ()<BankSelectViewDelegate,BankLogViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfCardNo;
@property (weak, nonatomic) IBOutlet UILabel *labBankName;
@property (weak, nonatomic) IBOutlet UITextField *tfMoney;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *lineVIew;

@end

@implementation CrashViewController{
    BankListVO * selectVO;
    BankLogViewView * cardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onPayType:(id)sender {
}

- (IBAction)onSelectBank:(id)sender {
    BankSelectViewController * view = [[BankSelectViewController alloc]init];
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)onSelectLog:(id)sender {
    CGRect frame = self.view.frame;
    if(!cardView){
        cardView = [[BankLogViewView alloc] initWithFrame:CGRectMake(0, 175, frame.size.width, 158)];
        cardView.delegate = self;
        [self.view addSubview:cardView];
    }else{
        [cardView removeFromSuperview];
        cardView = nil;
    }
}

-(void) bankSelectDelegate:(BankListVO *) vo
{
    _labBankName.text = vo.name;
    selectVO =vo;
}

- (IBAction)onCrash:(id)sender {
    if(_tfName.text.length<1){
        [self inputToast:@"姓名不能为空！"];
        return;
    }
    if(_tfCardNo.text.length<10){
        [self inputToast:@"卡号格式不正确！"];
        return;
    }
    if(selectVO== nil){
        [self inputToast:@"请选择开户银行！"];
        return;
    }
    if(_tfMoney.text.length == 0){
        [self inputToast:@"金额不能为空！"];
        return;
    }
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"name"] = _tfName.text;
    dic[@"cardNo"] = _tfCardNo.text;
    dic[@"bankId"] = [NSString stringWithFormat:@"%@",selectVO.id];
    dic[@"amount"] = _tfMoney.text;

    [[ServerManger getInstance] withDrawal:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            
            if (code.intValue == 0) {
                [self inputToast:@"您的提现申请提交成功，正在审核中，请耐心等待！"];
                if(_delegate){
                    [_delegate crashViewDelegate:YES];
                }
                [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(cardView){
        [cardView removeFromSuperview];
    }
}

-(void) bankLogViewDelegate:(BankLogVO*) vo
{
    if(vo == nil){
        cardView = nil;
        return;
    }
    selectVO = [BankListVO new];
    selectVO.id = vo.bankId;
    selectVO.name = vo.bankName;
    _tfName.text = vo.name;
    _tfCardNo.text = vo.cardNo;
    _labBankName.text = vo.bankName;
    cardView = nil;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
