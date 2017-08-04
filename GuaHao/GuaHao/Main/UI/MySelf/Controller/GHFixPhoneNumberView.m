//
//  GHFixPhoneNumberView.m
//  GuaHao
//
//  Created by PJYL on 2016/11/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHFixPhoneNumberView.h"
#import "Validator.h"
#import <Toast/UIView+Toast.h>

@interface GHFixPhoneNumberView (){
   int countdown;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic)    NSTimer *countdownTimer;
@end
@implementation GHFixPhoneNumberView
//-(NSTimer *)countdownTimer{
//    static NSTimer *countdownTimer = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
//        
//        [[NSRunLoop currentRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
//        [countdownTimer fire];
//        
//    }) ;
//    return countdownTimer;
//}
-(void)countdownEvent{
    if(countdown <=0) {
        self.codeButton.userInteractionEnabled =  YES;
        [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeButton.backgroundColor = UIColorFromRGB(0x45c768);
        [self countdownEventStop];
    } else {
        NSString * title = [NSString stringWithFormat:@"(%ds)后重发", countdown];
        [self.codeButton setTitle:title forState:UIControlStateNormal];
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


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"GHFixPhoneNumberView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
    }
    return self;
}

-(void)fixPhoneNumber:(FixPhoneNumberBlock)block{
    self.myBlock = block;
}
- (IBAction)codeButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    
    
    NSString *phoneNum = _phoneNumberTextField.text;
    if (![Validator isValidMobile:phoneNum]) {
        [self makeToast:@"请填写正确的手机号码！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getSMSCode:_phoneNumberTextField.text andCallback:^(id data) {
        [weakSelf hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                countdown = 60;
                weakSelf.codeButton.userInteractionEnabled = NO;
                [weakSelf.codeButton setTintColor:UIColorFromRGB(0x888888)];
                if (!_countdownTimer) {
                    _countdownTimer
                    = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(countdownEvent) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
                }
                
                [_countdownTimer fire];
                [weakSelf makeToast:msg];

            }else{
                
            }
            [weakSelf makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
        }
    }];




}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self removeFromSuperview];
}

- (IBAction)cancelAction:(id)sender {
    [self endEditing:YES];

    [self removeFromSuperview];
}
- (IBAction)sureAction:(id)sender {
     [self endEditing:YES];
    NSString *phoneNum = _phoneNumberTextField.text;
    NSString *code  = self.codeTextField.text;
    if (![Validator isValidMobile:phoneNum]) {
        [self makeToast:@"请填写正确的手机号码！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    NSLog(@"patientID = %@",self.patientID);
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] estimateExpSms:self.patientID mobile:phoneNum smsCode:code andCallback:^(id data) {
        [weakSelf hideToastActivity];
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [weakSelf makeToast:msg];
            if (code.intValue == 0) {
                [_countdownTimer invalidate];
                
                if (weakSelf.phoneNumberTextField.text.length > 0) {
                    weakSelf.myBlock(phoneNum);
                }
                [weakSelf endEditing:YES];
                
                [weakSelf removeFromSuperview];
                
                
            }else{
                [weakSelf makeToast:msg];
            }
        }
    }];
    
    countdown = 60;

    
    
    
    

    
    
    
    
    
    
}
- (IBAction)tapAction:(id)sender {
    [self endEditing:YES];
    [self removeFromSuperview];
}
-(void)dealloc{
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
