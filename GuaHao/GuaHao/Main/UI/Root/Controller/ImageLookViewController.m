//
//  ImageLookViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "ImageLookViewController.h"

@interface ImageLookViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation ImageLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看图片";
    self.imageView.image= self.image;
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)deleteAction:(id)sender {
    self.myAction(YES);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteImage:(DeleteImageAction)action{
    self.myAction = action;
}
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
