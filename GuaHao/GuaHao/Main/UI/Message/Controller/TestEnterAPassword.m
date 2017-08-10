//
//  TestEnterAPassword.m
//  GuaHao
//
//  Created by 123456 on 16/2/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "UIViewController+Toast.h"
#import "TestEnterAPassword.h"
#import "ServerManger.h"
#import "DataManager.h"
#import "Utils.h"

@interface TestEnterAPassword ()
@property (weak, nonatomic) IBOutlet UITextField * passwordTF;

@end

@implementation TestEnterAPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)certainBtn:(id)sender {
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] vallidPayPassword:_passwordTF.text andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg  = data[@"msg"];
            if (code.intValue == 0) {
            [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
            }else{
                 
            }
            [self inputToast:msg];
        }
    }];
    
}
-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate) {
        [_delegate testEnterAPasswordDelegate];
    }

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
