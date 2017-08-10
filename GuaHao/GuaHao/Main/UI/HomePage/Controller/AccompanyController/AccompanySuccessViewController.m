//
//  AccompanySuccessViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/11/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccompanySuccessViewController.h"

@interface AccompanySuccessViewController ()

@end

@implementation AccompanySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约成功";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureAction:(id)sender {
    AccOrderDetailViewController * view = [GHViewControllerLoader AccOrderDetailViewController];

    view.serialNo = self.orderNo;
    NSLog(@"陪诊订单编号-------------%@",view.serialNo);
    view.popBack = PopBackRoot;
    [self.navigationController pushViewController:view animated:YES];
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
