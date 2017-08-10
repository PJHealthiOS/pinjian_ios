//
//  ChildBannerController.m
//  GuaHao
//
//  Created by qiye on 16/10/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ChildBannerController.h"
#import "CreateOrderNormalViewController.h"
#import "Utils.h"

@interface ChildBannerController ()<LoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

@implementation ChildBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"儿童夜间急诊挂号";
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///登录】
-(void) login{
    
    if ([DataManager getInstance].loginState == 1) {
        
    }else{
        LoginViewController * view = [[LoginViewController alloc]init];
        view.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_middleView.frame)+15);
}

- (IBAction)onClick:(id)sender {
    [self login];
    if ([DataManager getInstance].loginState != 1) {
        return;
    }
    CreateOrderNormalViewController *view = [[CreateOrderNormalViewController alloc]init];
    view.isChildren = YES;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)loginComplete{
    
}

@end
