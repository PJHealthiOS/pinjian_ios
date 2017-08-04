//
//  AccompanyMenuViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "AccompanyMenuViewController.h"

@interface AccompanyMenuViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@end

@implementation AccompanyMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"陪诊";
    self.imageViewHeight.constant = SCREEN_WIDTH * 1264.0 /750.0;
    // Do any additional setup after loading the view.
}
- (IBAction)accompanyAction:(id)sender {
    [self pushToFlowerVC:wholeAccompany];
}
- (IBAction)reportAction:(id)sender {
    [self pushToFlowerVC:reportAccompany];
}
- (IBAction)medicineAction:(id)sender {
    [self pushToFlowerVC:medicineAccompany];
}
-(void)pushToFlowerVC:(AccompanyType)type{
    NewAccompanyFlowerViewController *newFlower = [GHViewControllerLoader NewAccompanyFlowerViewController];
    newFlower.accompanyType = type;
    [self.navigationController pushViewController:newFlower animated:YES];

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
