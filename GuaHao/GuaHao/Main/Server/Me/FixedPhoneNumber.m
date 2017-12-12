//
//  FixedPhoneNumber.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "UIViewController+Toast.h"
#import "FixedPhoneNumber.h"
#import "ServerManger.h"
#import "DataManager.h"
#import "Validator.h"
#import "UserVO.h"
#import "HtmlAllViewController.h"

@interface FixedPhoneNumber ()

@property (weak, nonatomic) IBOutlet UIScrollView * contView;
@property (weak, nonatomic) IBOutlet UIView       * bottomView;
@property (weak, nonatomic) IBOutlet UIButton     * agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton     * codeBtn;
@property (weak, nonatomic) IBOutlet UITextField  * poneTF;
@property (weak, nonatomic) IBOutlet UITextField  * codeTF;
@property (weak, nonatomic) IBOutlet UITextField  * passwordTF;
@property BOOL isSelected;

@end

@implementation FixedPhoneNumber{
    
    __strong NSTimer *timer;
    int secondes;
}
- (void)dealloc
{
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定";
    self.navigationController.navigationBarHidden = NO;
    _isSelected = YES;
}
- (IBAction)onRule:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"品简挂号用户协议";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/userAgreement.html",[ServerManger getInstance].serverURL];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)onGetSmsCode:(id)sender {
    
    if (![Validator isValidMobile:_poneTF.text]) {
        [self inputToast:@"手机号码为11数字！"];
        return;
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getSMSCode:_poneTF.text andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                secondes= 60;
                _codeBtn.enabled = NO;
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
                [timer fire];
            }else{
                
            }
            [self inputToast:msg];
        }
    }];
    
}

-(void)timerFired:(id) sender{
    
    if(secondes <=0) {
        _codeBtn.enabled = YES;
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    } else {
        NSString * title = [NSString stringWithFormat:@"(%ds)后重发", secondes];
        [_codeBtn setTitle:title forState:UIControlStateNormal];
    }
    secondes--;
}

- (IBAction)onSure:(id)sender {
    
    if (_poneTF.text.length == 0) {
        [self inputToast:@"请输入手机号！"];
        return;
    }
    if (_codeTF.text.length == 0) {
        [self inputToast:@"请输入验证码！"];
        return;
    }
    if (_passwordTF.text.length == 0) {
        [self inputToast:@"请设置密码！"];
        return;
    }

    if (![Validator isValidMobile:_poneTF.text]) {
        [self inputToast:@"请输入正确的手机号！"];
        return;
    }
    
    if(![Validator isValidSMSCode:_codeTF.text]) {
        [self inputToast:@"验证码为6位数字!"];
        return;
    }
    
    if(![Validator isValidPassword:_passwordTF.text]) {
        [self inputToast:@"密码至少为6位，并且要包含一个字母!"];
        return;
    }
    
    if(!_isSelected) {
        [self inputToast:@"请勾选同意挂号协议!"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"code"] = _codeTF.text;
    dic[@"mobile"] = _poneTF.text;
    dic[@"password"] = _passwordTF.text;
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] fixedPhoneNumber:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                NSDictionary * dict = data[@"object"];
                UserVO *user = [UserVO mj_objectWithKeyValues:dict];
                [DataManager getInstance].user = user;
                [DataManager getInstance].loginState = 1;
                [self performSelector:@selector(button:) withObject:nil afterDelay:1.0];
            }else{
                
            }
            [self inputToast:msg];
        }
    }];
    
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame));
}

- (IBAction)onAgree:(id)sender {
    _isSelected   = !_isSelected;
    NSString* url = _isSelected?@"frist_order_tickBtnSelect":@"frist_order_tickBtn";
    [_agreeBtn setImage:[UIImage imageNamed:url] forState:UIControlStateNormal];
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
