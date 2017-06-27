//
//  HealthBasicFlowViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/25.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthBasicFlowViewController.h"

@interface HealthBasicFlowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@end

@implementation HealthBasicFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团体健康管理";
    
    self.imageHeight.constant = SCREEN_WIDTH * 3508.0/750.0;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAction:(id)sender {
    HealthBasicOrderViewController *view = [GHViewControllerLoader HealthBasicOrderViewController];
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
