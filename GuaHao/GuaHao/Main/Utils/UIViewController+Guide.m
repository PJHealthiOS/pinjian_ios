//
//  UIViewController+Guide.m
//  GuaHao
//
//  Created by PJYL on 2017/10/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "UIViewController+Guide.h"

@implementation UIViewController (Guide)

-(void)addGuidePageWithImageName:(NSString *)imageName  frame:(CGRect)imageFrame{
    NSString *key = [NSString stringWithFormat:@"guide%@",imageName];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *resultStr = [defaults objectForKey:key];
    if (resultStr) {///打开过
    }else{
        ///没打开过
        [defaults setValue:imageName forKey:key];
    
        [self addGuidePage:imageName frame:imageFrame];
        
        
    }
    
}


-(void)addGuidePage:(NSString *)imageName frame:(CGRect)imageFrame{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView * bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];;
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = imageFrame;
    imageView.userInteractionEnabled = YES;
    [bgView addSubview:imageView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];;
    [bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    
    
    
    
    
}


-(void)click:(UITapGestureRecognizer *)tap{
    UIView *bgView = tap.view;
    [bgView removeFromSuperview];
}














//-(BOOL)hasOpened:(NSString *)imageName{
//    NSString *key = [NSString stringWithFormat:@"guide%@",imageName];
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString *resultStr = [defaults objectForKey:key];
//    if (resultStr) {///打开过
//        return YES;
//    }else{
//        ///没打开过
//        [defaults setValue:imageName forKey:key];
//        return NO;
//    }
//}
//


















@end
