//
//  GHSettingPayPasswordViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHSettingPayPasswordViewController.h"

@interface GHSettingPayPasswordViewController ()<UITextFieldDelegate>{

    int countdown;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *authCodeText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (strong, nonatomic)    NSTimer *countdownTimer;
@end

@implementation GHSettingPayPasswordViewController
-(NSTimer *)countdownTimer{
    static NSTimer *countdownTimer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
        //        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [countdownTimer fire];
        
    }) ;
    return countdownTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = [DataManager getInstance].user.mobile;
    // Do any additional setup after loading the view.
}
- (IBAction)commitAction:(id)sender {
    [self.view endEditing:YES];
    if (_authCodeText.text.length != 6) {
        [self inputToast:@"请输入正确的验证码！"];
        return;
    }
    if (_passwordText.text.length != 6) {
        [self inputToast:@"请输入正确的密码！"];
        return;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"code"] = _authCodeText.text;
    parameters[@"mobile"] = [DataManager getInstance].user.mobile;
    parameters[@"password"] = _passwordText.text;
    //    [MobClick event:@"id7"];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] setPayPassWord:parameters andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                NSDictionary * dict = data[@"object"];
                [self inputToast:msg];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                
            }
            [self inputToast:msg];
            
        }
    }];

    
}
- (IBAction)getCodeAction:(UIButton *)sender {
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getSMSCode:[DataManager getInstance].user.mobile andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                countdown = 60;
                self.getCodeButton.userInteractionEnabled = NO;
                self.getCodeButton.backgroundColor = UIColorFromRGB(0x888888);
                if (!_countdownTimer) {
                    _countdownTimer
                    = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
                }
                
                [_countdownTimer fire];
                [self inputToast:msg];
                
            }else{
                
            }
            [self inputToast:msg];
        }
    }];


    countdown = 60;
    

}
-(void)countdownEvent{
    if(countdown <=0) {
        self.getCodeButton.userInteractionEnabled =  YES;
        [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getCodeButton.backgroundColor = UIColorFromRGB(0x45c768);
        [self countdownEventStop];
    } else {
        NSString * title = [NSString stringWithFormat:@"(%ds)后重发", countdown];
        [self.getCodeButton setTitle:title forState:UIControlStateNormal];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    _countdownTimer = nil;
    
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
