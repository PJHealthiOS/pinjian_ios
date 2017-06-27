//
//  SeriousFlowViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousFlowViewController.h"

@interface SeriousFlowViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@end

@implementation SeriousFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重疾就医";
    self.imageHeight.constant = SCREEN_WIDTH * 1463.0 / 750.0;
    // Do any additional setup after loading the view.
}
- (IBAction)createSeriousOrder:(id)sender {
    [self.navigationController pushViewController:[GHViewControllerLoader CreateSeriousOrderController] animated:NO];

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
