//
//  ImageViewController.m
//  Pingjiang
//
//  Created by fang xiang on 15/7/1.
//  Copyright (c) 2015年 fangxiang. All rights reserved.
//

#import "ImageViewController.h"
#import "VIPhotoView.h"

@interface ImageViewController ()


@end

@implementation ImageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看图片";
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:self.image];
    photoView.backgroundColor = [UIColor clearColor];
    photoView.alpha = 1.0;
    photoView.autoresizingMask = (1 << 6) -1;
    [self.view addSubview:photoView];
    
    //---为 UIImageview 添加点击手势
    UITapGestureRecognizer * tap_Gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [tap_Gesture setNumberOfTapsRequired:1];
    
    [self.view addGestureRecognizer:tap_Gesture];
}
- (void)tapImage:(UIGestureRecognizer*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
