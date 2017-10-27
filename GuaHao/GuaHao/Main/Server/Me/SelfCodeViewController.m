//
//  SelfCodeViewController.m
//  GuaHao
//
//  Created by qiye on 16/4/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SelfCodeViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"

@interface SelfCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfCode;

@end

@implementation SelfCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)button:(id)sender {
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSure:(id)sender {
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (_tfCode.text.length == 0) {
        [self inputToast:@"邀请码不能为空！"];
        return;
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] fillInvitationCode:_tfCode.text andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                [self performSelector:@selector(button:) withObject:nil afterDelay:1.0f];
                
            }else{
                
            }
        }
    }];
}

@end
