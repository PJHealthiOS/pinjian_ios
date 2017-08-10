//
//  EvaluateSelectView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickButtonAction)(NSInteger index);
@interface EvaluateSelectView : UIView
@property (copy, nonatomic) ClickButtonAction myAction;
@property (assign, nonatomic) BOOL canClick;
-(void)butonClickAction:(ClickButtonAction)action;
-(instancetype)initWithFrame:(CGRect)frame isSmile:(BOOL)isSmile;
-(void)updateCell:(int)index canClick:(BOOL)canClick;

@end
