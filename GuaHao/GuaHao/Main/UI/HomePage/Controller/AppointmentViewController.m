//
//  AppointmentViewController.m
//  GuaHao
//
//  Created by qiye on 16/9/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AppointmentViewController.h"
#import "UIViewController+BackButtonHandler.h"

@implementation AppointmentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约成功";
}
- (IBAction)sureAction:(id)sender {
    [self navigationShouldPopOnBackButton];
}

-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    //这里写要处理的代码
    NSLog(@"sweweweewew");
    GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
    view.orderType = 0;
    view.orderNO = _orderNO;
    view.popBack = PopBackRoot;
    [self.navigationController pushViewController:view animated:YES];
    return YES;//返回NO 不会执行
    
}
@end
