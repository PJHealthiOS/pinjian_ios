//
//  GHOrderAlterViewController.m
//  GuaHao
//
//  Created by 123456 on 16/8/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHOrderAlterViewController.h"

@interface GHOrderAlterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation GHOrderAlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)changeOrderBlock:(ChangeOrderBlock)block{
    self.myBlock = block;
}
- (IBAction)cancelAction:(id)sender {
    if (self.myBlock) {
        self.myBlock(NO);
    }
}
- (IBAction)changOrderAction:(id)sender {
    if (self.myBlock) {
        self.myBlock(YES);
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
