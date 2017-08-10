//
//  OrderSureView.m
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "FixPhoneView.h"
#import "Validator.h"
#import <Toast/UIView+Toast.h>
#import "UIViewBorders.h"
#import "ServerManger.h"

@interface FixPhoneView ()

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnSms;
@property (weak, nonatomic) IBOutlet UILabel *labCode;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;

@end

@implementation FixPhoneView{
    __strong NSTimer *timer;
    int secondes;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"FixPhoneView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_bgView setUserInteractionEnabled:YES];
        [_bgView addGestureRecognizer:tapGuesture1];
    }
    return self;
}


-(void)setPhone:(NSString*) _phone
{
    _tfPhone.text = _phone;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (IBAction)onSure:(id)sender {
    if (![Validator isValidMobile:_tfPhone.text]) {
        [self makeToast:@"请填写正确的手机号码！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] estimateExpSms:_patientID mobile:_tfPhone.text smsCode:_tfCode.text andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if(timer != nil)
                {
                    [timer invalidate];
                    timer = nil;
                }
                secondes = 0;
                _labCode.text = @"获取验证码";
                _tfCode.text = @"";
                if (_delegate) {
                    [_delegate fixPhoneDelegate:YES phone:_tfPhone.text];
                }
            }else{
                [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
            }
        }
    }];
}

- (IBAction)onGetSms:(id)sender {
    if (![Validator isValidMobile:_tfPhone.text]) {
        [self makeToast:@"手机号码不符合规则！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    [self makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getSMSCode:_tfPhone.text andCallback:^(id data) {
        [self hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                secondes= 60;
                _btnSms.enabled = NO;
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
                [timer fire];
            }else{
                
            }
            [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
        }
    }];
}

-(void)timerFired:(id) sender{
    
    if(secondes <=0) {
        _btnSms.enabled = YES;
        _labCode.text = @"重新获取";
    } else {
        NSString * title = [NSString stringWithFormat:@"(%ds)后重发", secondes];
        _labCode.text = title;
    }
    secondes--;
}

- (void)dealloc
{
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)onClose:(id)sender {
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    secondes = 0;
    _labCode.text = @"获取验证码";
    _tfCode.text = @"";
    if (_delegate) {
        [_delegate fixPhoneDelegate:NO phone:_tfPhone.text];
    }
}

-(void) func1:(UITapGestureRecognizer *) tap{
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    secondes = 0;
    _labCode.text = @"获取验证码";
    _tfCode.text = @"";
    if (_delegate) {
        [_delegate fixPhoneDelegate:NO phone:_tfPhone.text];
    }
}

@end
