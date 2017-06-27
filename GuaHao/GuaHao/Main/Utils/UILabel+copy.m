//
//  UILabel+copy.m
//  GuaHao
//
//  Created by qiye on 16/4/27.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "UILabel+copy.h"

@implementation UILabel (copy)

//- (BOOL)canBecomeFirstResponder{
//    return YES;
//}
//
////"反馈"关心的功能
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return (action == @selector(copy:));
//}
////针对于copy的实现
//-(void)copy:(id)sender{
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    pboard.string = self.text;
//}
//
////UILabel默认是不接收事件的，我们需要自己添加touch事件
//-(void)attachTapHandler{
//    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self addGestureRecognizer:touch];
//}
////绑定事件
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self attachTapHandler];
//    }
//    return self;
//}
////同上
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self attachTapHandler];
//}
//
//-(void)handleTap:(UIGestureRecognizer*) recognizer{
//    UILabel * label = (UILabel*)recognizer.view;
//    if (label.tag != 101) {
//        return;
//    }
//    [self becomeFirstResponder];
//    UIMenuController *menu = [UIMenuController sharedMenuController];
//    [menu setTargetRect:self.frame inView:self.superview];
//    [menu setMenuVisible:YES animated:YES];
//}

@end
