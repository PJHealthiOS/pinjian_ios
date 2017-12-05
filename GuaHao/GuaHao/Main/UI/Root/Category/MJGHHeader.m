//
//  MJGHHeader.m
//  GuaHao
//
//  Created by qiye on 16/8/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MJGHHeader.h"

@interface MJGHHeader()
@property (weak, nonatomic) UIImageView *logo;
@end

@implementation MJGHHeader {
    float cPercent;
}

#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=11; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=11; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_first_order_payImg"]];
//    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.hidden = YES;
    [self addSubview:logo];
    self.logo = logo;
    self.logo.hidden = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    switch (self.mjType) {
        case MJTypePJGifELME:
        {
            break;
        }
        case MJTypePJGifTaoBao:
        {
            self.logo.y = self.gifView.y - 60;
            break;
        }
        case MJTypePJGifJD:
        {
            self.gifView.x = 60;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    cPercent = pullingPercent;
    [super setPullingPercent:pullingPercent];
    
    switch (self.mjType) {
        case MJTypePJGifELME:
        {
            if(pullingPercent>0.2) self.logo.hidden = NO;
            self.gifView.y = self.gifView.height * (1-pullingPercent);
            self.logo.y = self.gifView.height * (1-pullingPercent) + 60;
            break;
        }
        case MJTypePJGifTaoBao:
        {
//            if(pullingPercent>0.2) self.logo.hidden = NO;
            self.logo.y = self.gifView.y - 60;
            break;
        }
        case MJTypePJGifJD:
        {
            self.stateLabel.hidden = NO;
            [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
            [self setTitle:@"松手刷新" forState:MJRefreshStatePulling];
            [self setTitle:@"更新中" forState:MJRefreshStateRefreshing];
            break;
        }
            
        default:
            break;
    }


//    NSLog(@"xxxxxx----   %f  ,  %f",pullingPercent,self.gifView.y);
}

@end