//
//  UIView+Shadow.m
//  LHDatePickerView
//
//  Created by PJYL on 2017/7/18.
//  Copyright © 2017年 PJYL. All rights reserved.
//

#import "UIView+Shadow.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Shadow)
-(void)addShadowWithRadius:(float)radius{
    self.layer.shadowOpacity = 0.3; ///阴影透明度
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;///阴影颜色
    self.layer.shadowRadius = radius;///阴影扩散控制范围
    self.layer.shadowOffset = CGSizeMake(0, 5);///阴影范围
    self.layer.cornerRadius = radius;///圆角弧度
    self.backgroundColor = [UIColor whiteColor];///设置背景颜色
    
}

-(void)springAnimation{
    CASpringAnimation * spring = [CASpringAnimation animation];
    spring.keyPath = @"position.x";
    spring.fromValue = @(self.center.x );
    spring.toValue = @(self.center.x +5);
    spring.mass = 30;
    spring.stiffness = 50;
    spring.damping = 5;
    spring.initialVelocity = 0;
    spring.duration = spring.settlingDuration;
    [self.layer addAnimation:spring forKey:@""];
    
    
    
   
}

-(void)addSpringAnimation{
    CABasicAnimation *springAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    springAnimation.duration = 2;
    springAnimation.fromValue = @(SCREEN_WIDTH - self.width/2);
    springAnimation.toValue = @(SCREEN_WIDTH - self.width/2 + 10);
    springAnimation.repeatCount = 3;
    springAnimation.autoreverses = YES;
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:springAnimation forKey:@""];
    
}

@end
