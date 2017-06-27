//
//  HealthManagerViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/25.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthManagerViewController.h"

@interface HealthManagerViewController (){
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageHeight;

@end
@implementation HealthManagerViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"团体健康管理";
    
    self.topImageHeight.constant = SCREEN_WIDTH * 550.0 /750.0;
    
    self.midImageHeight.constant = SCREEN_WIDTH * 646.0 /754.0;
    
    self.bottomImageHeight.constant = SCREEN_WIDTH * 716.0 /750.0;
    
    
}
///基础套餐
- (IBAction)basicAction:(id)sender {
    HealthBasicFlowViewController *view = [GHViewControllerLoader HealthBasicFlowViewController];
    [self.navigationController pushViewController:view animated:YES];
}
///定制化
- (IBAction)customTap:(id)sender {
    HealthCustomFlowViewController *view = [GHViewControllerLoader HealthCustomFlowViewController];
    [self.navigationController pushViewController:view animated:YES];
}

@end
