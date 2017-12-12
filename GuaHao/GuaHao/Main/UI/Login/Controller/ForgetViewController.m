//
//  ForgetViewController.m
//  GuaHao
//
//  Created by qiye on 16/1/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ForgetViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "UserVO.h"
#import "DataManager.h"
#import "Validator.h"

@interface ForgetViewController ()

@property (weak, nonatomic) IBOutlet UITextField * poneTF;
@property (weak, nonatomic) IBOutlet UITextField * codeTF;
@property (weak, nonatomic) IBOutlet UITextField * passwordTF;
@property (weak, nonatomic) IBOutlet UIButton    * codeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView * contView;
@property (weak, nonatomic) IBOutlet UIView       * bottomView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end

@implementation ForgetViewController{
    
    __strong NSTimer * timer;
         int           secondes;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置登录密码";
    _poneTF.textColor = [UIColor lightGrayColor];
    
    _codeTF.textColor = [UIColor lightGrayColor];
    
    _passwordTF.textColor = [UIColor lightGrayColor];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name = [userDefaults objectForKey:@"Username"]?[userDefaults objectForKey:@"Username"]:@"";
    _poneTF.text = name;
    if (_openType == 2) {
        _labTitle.text = @"设置登录密码";
        _poneTF.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)dealloc{
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame));
}

- (IBAction)onGetSmsCode:(id)sender {
    
    if (![Validator isValidMobile:_poneTF.text]) {
        [self inputToast:@"请输入正确的手机号！"];
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

-(void)timerFired:(id) sender
{
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
        [self inputToast:@"请填写手机号！"];
        return;
    }
    if (_codeTF.text.length == 0) {
        [self inputToast:@"请填写验证码！"];
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
        [self inputToast:@"验证码不正确!"];
        return;
    }
    
    if(![Validator isValidPassword:_passwordTF.text]) {
        [self inputToast:@"至少6位，只能包含字母和数字!"];
        return;
    }

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"code"] = _codeTF.text;
    parameters[@"mobile"] = _poneTF.text;
    parameters[@"password"] = _passwordTF.text;
//    [MobClick event:@"id7"];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getPwd:parameters andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                NSDictionary * dict = data[@"object"];
                UserVO *user = [UserVO mj_objectWithKeyValues:dict];
                [DataManager getInstance].user = user;
                [DataManager getInstance].loginState = 1;
                [JPUSHService setAlias:user.id.stringValue
                      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                                object:nil];
                [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];
            }else{
                
            }
            [self inputToast:msg];
        }
    }];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSLog(@"TagsAlias回调:%@", alias);
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate) {
        self.tabBarController.selectedIndex = 0;
        UIViewController *origin = self.presentingViewController;
        [origin dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onPhoneBegin:(id)sender {
    [_poneTF becomeFirstResponder];
}

- (IBAction)onPhoneEnd:(id)sender {
    [_poneTF resignFirstResponder];
}

- (IBAction)onCodeBegin:(id)sender {
    [_codeTF becomeFirstResponder];
}

- (IBAction)onCodeEnd:(id)sender {
    [_codeTF resignFirstResponder];
}

- (IBAction)onPwdBegin:(id)sender {
    if ([_passwordTF.text isEqualToString:@"密码至少为6位，并且要包含一个字母!"]) {
        _passwordTF.text = @"";
        _passwordTF.secureTextEntry = YES;
    }
    [_passwordTF becomeFirstResponder];
}

- (IBAction)onPwdEnd:(id)sender {
    if ([_passwordTF.text isEqualToString:@""]) {
        _passwordTF.text = @"密码至少为6位，并且要包含一个字母!";
        _passwordTF.secureTextEntry = NO;
    }
    [_passwordTF resignFirstResponder];
}

@end
