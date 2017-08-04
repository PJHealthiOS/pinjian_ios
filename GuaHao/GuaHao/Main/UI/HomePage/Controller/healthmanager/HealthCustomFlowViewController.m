//
//  HealthCustomFlowViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/25.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthCustomFlowViewController.h"

@interface HealthCustomFlowViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@end

@implementation HealthCustomFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制化套餐";
    self.imageHeight.constant = SCREEN_WIDTH * 4014.0/750.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAction:(id)sender {
    HealthCustomOrderViewController *view = [GHViewControllerLoader HealthCustomOrderViewController];
    [self.navigationController pushViewController:view animated:YES];
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
