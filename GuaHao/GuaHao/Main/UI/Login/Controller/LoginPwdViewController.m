//
//  LoginPwdViewController.m
//  GuaHao
//
//  Created by qiye on 16/9/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "LoginPwdViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "UserVO.h"
#import "DataManager.h"
#import "Validator.h"
#import <JPush/JPUSHService.h>
#import "EMSDK.h"

@interface LoginPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField  * poneTF;
@property (weak, nonatomic) IBOutlet UITextField  * passwordTF;
@end

@implementation LoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码登录";
    [self.navigationController setNavigationBarHidden:NO];
    _poneTF.textColor = [UIColor lightGrayColor];
    _passwordTF.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSDictionary * dic = [[DataManager getInstance] getUserData];
    if (![dic[@"Username"] isEqualToString:@""]) {
        _poneTF.text = dic[@"Username"];
    }
    if (![dic[@"Password"] isEqualToString:@""]) {
        _passwordTF.text = dic[@"Password"];
        _passwordTF.secureTextEntry = YES;
    }
}

- (IBAction)onSure:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (![Validator isValidMobile:_poneTF.text]) {
        [self inputToast:@"请输入正确的手机号码！"];
        return;
    }
    if (_passwordTF.text.length == 0) {
        [self inputToast:@"请输入密码！"];
        return;
    }
    [MobClick event:@"click49"];
    [[DataManager getInstance] saveUserData:_poneTF.text Pwd:_passwordTF.text];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] userLogin:_poneTF.text password:_passwordTF.text andCallback:^(id data) {
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

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSLog(@"TagsAlias回调:%@", alias);
}

- (IBAction)onBack:(id)sender {
    self.tabBarController.selectedIndex = 0;
    UIViewController *origin = self.presentingViewController;
    [origin dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
