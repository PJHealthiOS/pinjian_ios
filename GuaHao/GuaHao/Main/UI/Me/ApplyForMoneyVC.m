//
//  ApplyForMoneyVC.m
//  GuaHao
//
//  Created by 123456 on 16/1/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ApplyForMoneyVC.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"

@interface ApplyForMoneyVC ()
@property (weak, nonatomic) IBOutlet UITextField * nameTF;
@property (weak, nonatomic) IBOutlet UITextField * cardIDTF;
@property (weak, nonatomic) IBOutlet UITextField * bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField * cityTF;
@property (weak, nonatomic) IBOutlet UITextField * otherTF;
@property (weak, nonatomic) IBOutlet UITextField * moneyTF;
@property (weak, nonatomic) IBOutlet UITextView  * tipTF;
@property (weak, nonatomic) IBOutlet UIScrollView * contScrollView;
@property (weak, nonatomic) IBOutlet UIView       * boomView;
@end

@implementation ApplyForMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_boomView.frame));
}

    
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
    
- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onCommit:(id)sender {
    if (_nameTF.text.length == 0) {
        [self inputToast:@"请填写姓名！"];
        return;
    }
    
    if (_cardIDTF.text.length == 0) {
        [self inputToast:@"请填写银行卡号！"];
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic[@"name"]      = _nameTF.text;
    dic[@"cardNo"]    = _cardIDTF.text;
    dic[@"bankName"]  = _bankNameTF.text;
    dic[@"cityName"]  = _cityTF.text;
    dic[@"branchBank"] = _otherTF.text;
    dic[@"amount"]     = _moneyTF.text;
    dic[@"comments"]   = _tipTF.text;
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] withAddBankCard:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg  = data[@"msg"];
            [self inputToast:msg];
            
            if (code.intValue == 0) {
                [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
            }
        }

        }];
    
    
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate) {
        [_delegate applyForMoneyDelegate];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.tipTF.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        self.tipTF.hidden = NO;
    }
}

@end
