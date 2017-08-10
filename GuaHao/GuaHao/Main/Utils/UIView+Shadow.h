//
//  UIView+Shadow.h
//  LHDatePickerView
//
//  Created by PJYL on 2017/7/18.
//  Copyright © 2017年 PJYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)
////添加阴影和边框
-(void)addShadowWithRadius:(float)radius;
///添加动画
-(void)springAnimation;
-(void)addSpringAnimation;
@end
