//
//  AccountNumberViewController.m
//  GuaHao
//
//  Created by 123456 on 16/1/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "FixedPhoneNumber.h"
#import "AccountNumberVC.h"
#import "ForgetViewController.h"
#import "DataManager.h"
#import "UserVO.h"
#import <JPush/JPUSHService.h>
#import "ServerManger.h"
#import "UIViewController+Toast.h"
@interface AccountNumberVC ()
@property (weak, nonatomic) IBOutlet UILabel * phoneNumberLab;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *contView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomBtn;

@end

@implementation AccountNumberVC{
    UserVO * user;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomBtn.frame)+30);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInf];
    [_segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)getUserInf{
    user = [DataManager getInstance].user;
    _phoneNumberLab.text  = user.mobile;
    _segmentedControl.selectedSegmentIndex = user.acceptOrderPush.integerValue == 1 ?0:1;
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [self setPush:@"1"];
            break;
        case 1:
            [self setPush:@"0"];
            break;
        default:
            break;
    }
}

-(void)setPush:(NSString*)push
{
    [[ServerManger getInstance] editPush:push andCallback:^(id data) {

        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                NSDictionary * dict = data[@"object"];
                UserVO *users = [UserVO mj_objectWithKeyValues:dict];
                [DataManager getInstance].user = users;
                [self getUserInf];
            }else{
                
            }
        }
    }];
}

- (IBAction)fixedPhoneNumber:(id)sender {
    
    FixedPhoneNumber * FPN = [[FixedPhoneNumber alloc]init];
    [self.navigationController pushViewController:FPN animated:YES];
    
}

- (IBAction)backPBunton:(id)sender {
    
    ForgetViewController * view = [[ForgetViewController alloc]init];
    view.openType = 2;
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)onLogOut:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要退出账户?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) return;
    if (_delegate) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Password"];
        [JPUSHService setAlias:@""
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearAllCell" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
        [_delegate accountNumberViewDelegate];
    }
}
- (IBAction)gotoAppstoreBtn:(id)sender {
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1088129186" ];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1088129186"];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
