//
//  LoginViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/10/16.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginPwdViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "UserVO.h"
#import "DataManager.h"
#import "Validator.h"
#import "WXBindPhoneView.h"
#import "HtmlAllViewController.h"
//微信SDK头文件
#import "EMSDK.h"
@interface LoginViewController ()<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UITextField  * poneTF;
@property (weak, nonatomic) IBOutlet UITextField  * passwordTF;
@property (weak, nonatomic) IBOutlet UIScrollView * contView;
@property (weak, nonatomic) IBOutlet UIView       * bottomView;
@property (weak, nonatomic) IBOutlet UILabel *labRule;
@property (weak, nonatomic) IBOutlet UILabel *labCode;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@end

@implementation LoginViewController{
    __strong NSTimer * timer;
    int           secondes;
    WXBindPhoneView * phoneView;
    UserVO *wxUser;
}

static LoginViewController *_loginVC = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    _poneTF.textColor = [UIColor lightGrayColor];
    _passwordTF.textColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLogin:) name:@"WxLoginBack" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    NSDictionary * dic = [[DataManager getInstance] getUserData];
    if (![dic[@"Username"] isEqualToString:@""]) {
        _poneTF.text = dic[@"Username"];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame));
}

- (IBAction)onSure:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (![Validator isValidMobile:_poneTF.text]) {
        [self inputToast:@"请输入正确的手机号码！"];
        return;
    }
    if (_passwordTF.text.length != 6) {
        [self inputToast:@"请输入6位数验证码！"];
        return;
    }
    [MobClick event:@"click49"];
    [[DataManager getInstance] saveUserData:_poneTF.text Pwd:_passwordTF.text];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] codeLogin:_poneTF.text code:_passwordTF.text andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                NSDictionary * dict = data[@"object"];
                UserVO *user = [UserVO mj_objectWithKeyValues:dict];
                [[DataManager getInstance] setLogin:user];
                
                NSNumber *unreadMsgNum = [dict objectForKey:@"unreadMsgNum"];
                if (unreadMsgNum.intValue > 0) {
                    [DataManager getInstance].messageVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",unreadMsgNum];
                }else{
                    [DataManager getInstance].messageVC.tabBarItem.badgeValue = nil;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserMSGUpdate" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdate" object:nil];
                [JPUSHService setAlias:user.id.stringValue
                      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                                object:nil];
                [self performSelector:@selector(onBack:) withObject:nil afterDelay:1.0];
            }else{
                
            }
        }
    }];
}

#pragma mark - Internal
-(void)wxLogin:(NSNotification *)notification
{
    if (notification.object) {
        NSString * code = notification.object;
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] wxLogin:code andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                if (code.intValue == 0) {
                    NSDictionary * dict = data[@"object"];
                    wxUser = [UserVO mj_objectWithKeyValues:dict];
                    [DataManager getInstance].user = [UserVO new];
                    [DataManager getInstance].user.token = wxUser.token;
                    
                    
                    NSNumber *unreadMsgNum = [dict objectForKey:@"unreadMsgNum"];
                    if (unreadMsgNum.intValue > 0) {
                        [DataManager getInstance].messageVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",unreadMsgNum];
                    }else{
                        [DataManager getInstance].messageVC.tabBarItem.badgeValue = nil;
                    }
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserMSGUpdate" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdate" object:nil];
                    if(wxUser.mobile&&wxUser.mobile.length>5){
                        [[DataManager getInstance] setLogin:wxUser];
                        [self wxBlock:YES];
                        return ;
                    }
                    [[DataManager getInstance] setLogin:wxUser];
                    [self wxBlock:YES];
                    return ;
                    //                    CGRect frame = self.view.frame;
                    //                    if(!phoneView){
                    //                        phoneView = [[WXBindPhoneView alloc] initWithFrame:frame];
                    //                        __weak typeof(self) weakSelf = self;
                    //                        phoneView.myBlock = ^(BOOL isYes){
                    //                            [weakSelf wxBlock:isYes];
                    //                        };
                    //                    }
                    //                    [self.view addSubview:phoneView];
                }else{
                    
                }
            }
        }];
    }
}

-(void)wxBlock:(BOOL) sucess{
    if(sucess){
        [JPUSHService setAlias:wxUser.id.stringValue
              callbackSelector:nil
                        object:nil];
        [self onBack:nil];
        
    }else{
        [DataManager getInstance].user = nil;
    }
    
}

+(void)autoLogin
{
    NSDictionary * dic = [[DataManager getInstance] getUserData];
    if (![dic[@"Username"] isEqualToString:@""]&&![dic[@"Password"] isEqualToString:@""]) {
        [[ServerManger getInstance] userLogin:dic[@"Username"] password:dic[@"Password"] andCallback:^(id data) {
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                if (code.intValue == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserMSGUpdate" object:nil];
                    NSDictionary * dict = data[@"object"];
                    UserVO *user = [UserVO mj_objectWithKeyValues:dict];
                    [[DataManager getInstance] setLogin:user];
                    [JPUSHService setAlias:user.id.stringValue
                          callbackSelector:nil
                                    object:nil];
                }else{
                    
                }
            }
        }];
    }
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSLog(@"TagsAlias回调:%@", alias);
}

- (IBAction)onBack:(id)sender {
    if (self.myAction) {
        self.myAction(YES);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_delegate) {
        [_delegate loginComplete];
    }
}

- (IBAction)onRule:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"用户协议";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/userAgreement.html",[ServerManger getInstance].serverURL];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)onWx:(id)sender {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = @"ea16e78fac44a4ae56030663b2a6352c";
    req.openID = @"xxx";
    
    [WXApi sendAuthReq:req
        viewController:self
              delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        [self managerDidRecvAuthResponse:authResp];
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        
    }
}


- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        
    }
}

- (IBAction)onGetCode:(id)sender {
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
                if (!timer) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
                }
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
        _labCode.text = @"重新获取";
    } else {
        NSString * title = [NSString stringWithFormat:@"(%ds)后重发", secondes];
        _labCode.text = title;
    }
    secondes--;
}

- (IBAction)onPwdLogin:(id)sender {
    LoginPwdViewController *view = [[LoginPwdViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"取消登录"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:@"您取消了微信登录！"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
@end

