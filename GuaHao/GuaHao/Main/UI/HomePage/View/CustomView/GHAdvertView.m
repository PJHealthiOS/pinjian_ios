//
//  GHAdvertView.m
//  轮播图
//
//  Created by 123456 on 16/7/29.
//  Copyright © 2016年 Sweetbox. All rights reserved.
//

#import "GHAdvertView.h"


@interface GHAdvertView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageViews;

//@property (strong, nonatomic) RSAdvertProgressBar *progressView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (copy, nonatomic) WCHomeAdvertAction action;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval interval;

@property (assign, nonatomic) NSInteger currentPage;

@end
@implementation GHAdvertView
- (void)dealloc {
    [self _stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setup];
    }
    return self;
}

#pragma mark - action

- (void)startAnimation {
    [self _startTimer];
}

- (void)stopAnimation {
    [self _stopTimer];
}

- (void)hiddenPageControl {
    [self.pageControl removeFromSuperview];
}

- (void)setAdvertInterval:(NSTimeInterval)interval {
    if (interval == 0) {
        return;
    }
    _interval = interval;
    if (_images.count) {
        //        [self _stopTimer];
        [self _startTimer];
    }
}

- (void)setAdvertAction:(WCHomeAdvertAction)action {
    if (action) {
        _action = [action copy];
    }
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    if (currentPageColor) {
        _currentPageColor = currentPageColor;
        _pageControl.currentPageIndicatorTintColor = currentPageColor;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    if (pageIndicatorTintColor) {
        _pageIndicatorTintColor = pageIndicatorTintColor;
        _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    }
}

- (void)_imageView:(UIImageView *)imageView loadImage:(id)image {
//    [imageView sd_cancelCurrentImageLoad];
    if ([image isKindOfClass:[NSString class]]) {
        NSString *imageURLString = image;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@""]];
    } else if ([image isKindOfClass:[NSURL class]]) {
        NSURL *imageURL = image;
        [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
    } else if ([image isKindOfClass:[UIImage class]]) {
        imageView.image = image;
    } else {
//        WCAssert(0 && @"image错误");
    }
}

//- (void)setAdvertisings:(NSArray *)ads {
//    if (ads.count) {
//        NSMutableArray *URLStrings = [NSMutableArray array];
//        for (WCAdvertising *advert in ads) {
//            if (advert.picUrl.length) {
//                [URLStrings addObject:advert.picUrl];
//            }
//        }
//        [self setAdvertImagesOrUrls:URLStrings];
//    }
//}

- (void)setAdvertImagesOrUrls:(NSArray *)images {
    
    if (!images.count) {
        return;
    }
    _images = images;
    [_imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageViews removeAllObjects];
    [self _stopTimer];
    
    for (int idx = 0; idx < images.count + 2; idx++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_clickImageView:)]];
        if (idx == 0) {
            [self _imageView:imageView loadImage:[images lastObject]];
            imageView.tag = images.count;
        } else if (idx == images.count + 1) {
            [self _imageView:imageView loadImage:[images firstObject]];
            imageView.tag = 0;
        } else {
            [self _imageView:imageView loadImage:images[idx - 1]];
            imageView.tag = idx - 1;
        }
        [_scrollView addSubview:imageView];
        [_imageViews addObject:imageView];
    }
    
    _pageControl.numberOfPages = images.count;
    _pageControl.currentPage = 0;
    [self _setupFrame];
    
    if (images.count < 2) {
        return;
    }
    [self _startTimer];
    //当URL是通过网络加载的时候，这个地方调用顺序慢于layoutSubviews，需要再次进行布局
}
- (void)_clickImageView:(UITapGestureRecognizer *)gesture {
    if (_action) {
        _action(gesture.view.tag);
    }
}
#pragma mark- UISrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //当展示最后一个的时候
    _currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (scrollView.contentOffset.x / scrollView.bounds.size.width >= (_imageViews.count - 1)) {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
        _currentPage = 1;
//        NSLog(@"00000000000000");

    }
    //显示位置为0，0的时候
    if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * (_imageViews.count - 2), 0) animated:NO];
        _currentPage = _imageViews.count - 2;
//        NSLog(@"1111111111111");
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _pageControl.currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width - 1;
//    NSLog(@"%ld----%f----%f",(long)_pageControl.currentPage,_scrollView.contentOffset.x,_scrollView.frame.size.width);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self _stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //等下一次runloop的时候再更新， 因为手动拖动时候scrollViewDidScroll方法里的if语句执行完后会直接来到这个方法，此时的runloop没有刷新。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _pageControl.currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width - 1;
//        NSLog(@"xxxxxxxxxxxx----------%ld----%f----%f",(long)_pageControl.currentPage,_scrollView.contentOffset.x,_scrollView.frame.size.width);
    });
    [self _startTimer];
}
#pragma mark - setup

- (void)_startAnimation:(NSTimer *)timer {
    NSDateFormatter *forMatter = [[NSDateFormatter alloc]init];
    [forMatter setDateFormat:@"HH:mm:ss yyyy-MM-dd"];
//    NSString *dateStr = [[forMatter stringFromDate:[NSDate date]] substringToIndex:5];
//    NSLog(@"%@-------------------------------------",dateStr);

    run(^{
        _currentPage += 1;
//        NSLog(@"%ld-------------------------------------",(long)_currentPage);
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width *_currentPage, 0) animated:YES];
        //        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _scrollView.bounds.size.width, 0) animated:YES];
        //        NSLog(@"====contentOffset%@", NSStringFromCGPoint(_scrollView.contentOffset));
        //        NSLog(@"===frame=%@", NSStringFromCGRect(_scrollView.frame));
    });
}

- (void)_startTimer {
    if (!_timer) {
        [self _stopTimer];
        _timer = [NSTimer timerWithTimeInterval:_interval target:self selector:@selector(_startAnimation:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)_stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _setupFrame];
}

- (void)_setupFrame {
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(_imageViews.count * _scrollView.bounds.size.width, 0);
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
    
    _pageControl.frame = CGRectMake(0, 0, 100, 20);
    _pageControl.center = CGPointMake(self.center.x, self.bounds.size.height - _pageControl.bounds.size.height + 10);
    
    for (int idx = 0; idx < _imageViews.count; idx++) {
        UIImageView *imageView = _imageViews[idx];
        imageView.frame = CGRectMake(idx * self.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
}

- (void)_setup {
    _interval = 5.0;
    [_imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _imageViews = [NSMutableArray array];
    
    [_scrollView removeFromSuperview];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
    
    [_pageControl removeFromSuperview];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageColor;
    [self addSubview:_pageControl];
}
void run(dispatch_block_t b) {
    if ([NSThread isMainThread]) {
        b();
    } else {
        dispatch_async(dispatch_get_main_queue(), b);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
