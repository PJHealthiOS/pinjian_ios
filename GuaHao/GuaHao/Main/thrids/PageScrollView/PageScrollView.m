//
//  PageScrollView.m
//  Pinjian
//
//  Created by Patrick Yang on 14-7-5.
//  Copyright (c) 2014年 sungrow. All rights reserved.
//

#import "PageScrollView.h"
#import "UIImageView+WebCache.h"

@interface PageScrollView () <UIScrollViewDelegate>
{
    UIScrollView *contentView;
    NSMutableArray *itemPages;
    UIPageControl *pageControl;
    NSInteger      scrollIndex;
    NSTimer *_autoScrollTimer;
}
@end

@implementation PageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self onCreate];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self onCreate];
    }
    return self;
}
- (void)dealloc
{
    contentView.delegate = nil;
    
    [itemPages removeAllObjects];
}
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if ((currentIndex < 0 || currentIndex > self.itemImages.count)&&self.finishMode != PageScrollFinishNoLimit) {
        return;
    }
    if(self.finishMode == PageScrollFinishNoLimit&&(currentIndex < 0 || currentIndex > self.itemImages.count+1)){
        return;
    }
    _currentIndex = currentIndex;
    pageControl.numberOfPages = currentIndex;
    if(self.finishMode == PageScrollFinishNoLimit&&itemPages.count == currentIndex-1){
        pageControl.numberOfPages = 0;
    }
    contentView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds) * currentIndex, CGRectGetHeight(self.bounds));
}
- (void)setFinishMode:(PageScrollFinishMode)finishMode
{
    _finishMode = finishMode;

    if (finishMode == PageScrollFinishScroll) {
        CGSize size = contentView.contentSize;
        size.width = CGRectGetWidth(self.bounds) * (pageControl.numberOfPages + 1);
        contentView.contentSize = size;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect frame = self.bounds;
    for (NSInteger i = 0; i < itemPages.count; i++) {
        UILabel *page = itemPages[i];
        page.frame = frame;
        frame.origin.x += CGRectGetWidth(self.bounds);
    }
    if (self.finishMode == PageScrollFinishScroll) {
        frame.origin.x += CGRectGetWidth(self.bounds);
    }
    if(self.finishMode == PageScrollFinishNoLimit){
        frame.origin.x += CGRectGetWidth(self.bounds);
    }
    contentView.contentSize = CGSizeMake(CGRectGetMinX(frame), CGRectGetHeight(frame));
}

- (void)reloadData
{
    [self clearPages];
    [self loadPages];
    [self setNeedsLayout];
}

#pragma mark - 
- (void)onCreate
{
    itemPages = [[NSMutableArray alloc] init];
    
    self.backgroundColor = [UIColor clearColor];
    contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    contentView.autoresizingMask = 0xff;
    contentView.pagingEnabled = YES;
    contentView.contentSize = [self bounds].size;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.scrollsToTop = NO;
    contentView.delegate = self;
    contentView.bounces = NO;
    [self addSubview:contentView];
    
    CGRect frame = self.bounds;
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    pageControl.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 18);
    [pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    pageControl.numberOfPages = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:53/255.0 green:206/158 blue:128/255.0 alpha:1.0];
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:pageControl];
}

#pragma mark -
- (void)clearPages
{
    for (UIView *page in itemPages) {
        [page removeFromSuperview];
    }
    [itemPages removeAllObjects];
}

- (void)loadPages
{
    for (NSInteger i = 0; i < self.itemImages.count; i++) {
        
        UIView * view = [self getUiview:i];
        
        view.frame = self.bounds;
        
        view.userInteractionEnabled = YES;
//        view.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [view addGestureRecognizer:recognizer];
        [itemPages addObject:view];
        [contentView addSubview:view];

    }
    
    if(self.finishMode == PageScrollFinishNoLimit){
        UIView * view = [self getUiview:0];;
        [itemPages addObject:view];
        [contentView addSubview:view];
    }
    
    
    pageControl.numberOfPages = self.itemImages.count;
//    if(self.finishMode == PageScrollFinishNoLimit){
//        pageControl.numberOfPages = self.itemImages.count -1;
//    }
    pageControl.hidesForSinglePage = YES;
//    pageControl.currentPage = self.currentIndex;
}

-(UIView*)getUiview:(NSInteger) index
{
    UIView * view = nil;
    
    if([self.itemImages[index] isKindOfClass:[UIView class]])
    {
        view = self.itemImages[index];
        
    } else {
        
        NSString * strImg = self.itemImages[index];
        
        UIImageView *page = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        if([strImg hasPrefix:@"http"])
        {
            [page sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:nil];
            
        } else {
            page.image = [UIImage imageNamed:strImg];
        }
        
        view = page;
    }
    return view;
}

- (void)handleTap:(UIGestureRecognizer *)recognizer
{
    NSInteger index = [itemPages indexOfObject:recognizer.view];
//    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(pageScrollView:didSelectedAtIndex:)]) {
        [self.delegate pageScrollView:self didSelectedAtIndex:index];
    }
}
- (void)pageChanged
{
    NSInteger count = pageControl.currentPage;
    if(self.finishMode == PageScrollFinishNoLimit){
        count = _currentIndex;
    }
    NSInteger xOffset = CGRectGetWidth(self.bounds) * count;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    contentView.contentOffset = CGPointMake(xOffset, 0);
    [UIView commitAnimations];
}

-(void)didStopAnimation
{
    if(self.finishMode == PageScrollFinishNoLimit&&_currentIndex == itemPages.count-1){
        contentView.contentOffset = CGPointMake(0, 0);
        _currentIndex = 0;
    }
}

-(void)showPageControl:(BOOL) show
{
    pageControl.hidden = !show;
}

- (void)show:(BOOL)animation
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    if(animation) {
        self.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, self.frame.origin.y);
        CGContextRef context=UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3];
        self.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
}
- (void)finishOperation
{
    self.hidden = YES;
    if (self.finishMode == PageScrollFinishScroll) {
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.3];
    } else {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:1.0f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeSelf];
        }];
    }

    if([self.delegate respondsToSelector:@selector(pageScrollViewDidFinished:)]) {
        [self.delegate pageScrollViewDidFinished:self];
    }
}

- (void)removeSelf
{
    [self removeFromSuperview];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage = (scrollView.contentOffset.x + CGRectGetWidth(self.frame) / 2) / CGRectGetWidth(self.frame);
    if (self.finishMode == PageScrollFinishScroll) {
        pageControl.hidden = pageControl.currentPage == pageControl.numberOfPages - 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.finishMode != PageScrollFinishNever && (contentView.contentOffset.x + CGRectGetWidth(self.bounds) / 2) / CGRectGetWidth(self.bounds) > itemPages.count) {
        [self finishOperation];
    }
    if (self.finishMode == PageScrollFinishNoLimit) {
        _currentIndex = (scrollView.contentOffset.x + CGRectGetWidth(self.frame) / 2) / CGRectGetWidth(self.frame);
    }
}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart)  //开启自动翻页
    {
        if (!_autoScrollTimer) {
            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
        }
    }
    else   //关闭自动翻页
    {
        if (_autoScrollTimer.isValid) {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

#pragma mark 展示下一页
-(void)autoShowNextImage
{
    if (_currentIndex == itemPages.count-1) {
        _currentIndex = 0;
    }else{
        _currentIndex ++;
    }
    pageControl.currentPage = _currentIndex;
    [self pageChanged];
}

@end

