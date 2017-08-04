//
//  NewsView.h
//  LHNewsTest
//
//  Created by zymobi on 16/7/12.
//  Copyright © 2016年 zymobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsView : UIView

/**
 *  设置数据 nsstring 类型
 */
- (void)setNewArray:(NSArray *)array clickAction:(void (^)(NSInteger index))action;

- (void)setNewsTextColor:(UIColor *)color;

- (void)setNewsFont:(UIFont *)font;

- (void)setNewsImageName:(NSString *)imageName;

- (void)setAnimationTimerInterval:(NSTimeInterval)interval;

-(void)setHideMore;
- (void)startAnimation;
- (void)stopAnimation;
@end
