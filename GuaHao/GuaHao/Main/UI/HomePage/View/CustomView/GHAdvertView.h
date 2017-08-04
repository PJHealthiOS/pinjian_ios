//
//  GHAdvertView.h
//  轮播图
//
//  Created by 123456 on 16/7/29.
//  Copyright © 2016年 Sweetbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHAdvertView : UIView
typedef void (^WCHomeAdvertAction)(NSInteger idx);

@property (strong, nonatomic, readonly) NSArray *images;

@property (strong, nonatomic) UIColor *currentPageColor;
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;
void run(dispatch_block_t b);

//设置模型
- (void)setAdvertisings:(NSArray *)ads;

//设置url或者图片
- (void)setAdvertImagesOrUrls:(NSArray *)images;

- (void)setAdvertAction:(WCHomeAdvertAction)action;

/**
 *  default 3.0
 */
- (void)setAdvertInterval:(NSTimeInterval)interval;

- (void)startAnimation;

- (void)stopAnimation;

- (void)hiddenPageControl;

















@end
