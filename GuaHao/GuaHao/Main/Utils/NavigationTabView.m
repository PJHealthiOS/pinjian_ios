//
//  HeadTabView.m
//  Pinjian
//
//  Created by  patyang on 15/7/12.
//  Copyright (c) 2015年 fangxiang. All rights reserved.
//

#import "NavigationTabView.h"
#import "UIColor+Hex.h"

#pragma mark - HeadTabView
@interface NavigationTabView ()
{
    UIScrollView *contentView;
    NSMutableArray *itemViews;
    UIView *viewLine;
    UIView *selectedLine;
}

@end

@implementation NavigationTabView

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemWidthMax = 0;
    for (NSInteger i = 0; i < self.itemTitles.count; i++) {
        NSString *title = self.itemTitles[i];
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:self.titleFont}];
        itemWidthMax = MAX(size.width + 2 * size.height, itemWidthMax);
    }
    itemWidthMax = MAX(CGRectGetWidth(contentView.frame) / self.itemTitles.count, itemWidthMax);
    
    CGFloat itemOffsetX = 0;
    for (NSInteger i = 0; i < self.itemTitles.count; i++) {
        UILabel *btn = itemViews[i];
        NSString *title = self.itemTitles[i];
        CGRect frame = CGRectMake(itemOffsetX, 0, itemWidthMax, CGRectGetHeight(contentView.bounds));
        btn.frame = frame;
        btn.text = title;
        btn.font = self.titleFont;
        btn.textColor = self.selectedIndex != i ? self.titleNormalColor : self.titleSelectedColor;
        if (self.selectedIndex == i) {
            btn.textColor = self.titleSelectedColor;
            frame.size.height = 4.0f;
            frame.origin.y = CGRectGetMaxY(btn.frame) - frame.size.height + 2;
            selectedLine.frame = frame;
        } else {
            btn.textColor = self.titleNormalColor;
        }
        itemOffsetX += itemWidthMax;
    }
    contentView.contentSize = CGSizeMake(itemOffsetX, CGRectGetHeight(contentView.bounds));
    contentView.scrollsToTop = NO;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [self setNeedsLayout];
}
- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    [self setNeedsLayout];
}
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    [self setNeedsLayout];
}
- (void)setLineSelectedColor:(UIColor *)lineSelectedColor
{
    _lineSelectedColor = lineSelectedColor;
    selectedLine.backgroundColor = lineSelectedColor;
}
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)reloadData
{
    [self setSelectedIndex:0 animated:NO];
    [self clearItems];
    [self loadItems];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    if (selectedIndex < 0 || selectedIndex >= itemViews.count) {
        return;
    }
    UILabel *btn = itemViews[_selectedIndex];
    btn.textColor = self.titleNormalColor;
    _selectedIndex = selectedIndex;
    void (^block)(void) = ^{
        UILabel *btn = itemViews[selectedIndex];
        btn.textColor = self.titleSelectedColor;
        CGRect frame = btn.frame;
        frame.size.height = 4.0f;
        frame.origin.y = CGRectGetMaxY(btn.frame) - frame.size.height + 2;
        selectedLine.frame = frame;
    };
    if (animated) {
        [UIView animateWithDuration:0.2f animations:block];
    } else {
        block();
    }
}

#pragma mark - 
- (void)onCreate
{
    _titleNormalColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor colorWithRed:80/255.0 green:206/255.0 blue:123/255.0 alpha:1.0];
    _lineSelectedColor = [UIColor colorWithRed:80/255.0 green:206/255.0 blue:123/255.0 alpha:1.0];
    _titleFont = [UIFont systemFontOfSize:15.0f];
    CGRect frame = self.bounds;
//    frame.size.height -= 1.0f;
    contentView = [[UIScrollView alloc] initWithFrame:frame];
    contentView.autoresizingMask = 0xff;
    [self addSubview:contentView];
    
    frame.size.height = 1.0f;
    frame.origin.y = CGRectGetMaxY(self.bounds) - frame.size.height;
    viewLine = [[UIView alloc] initWithFrame:frame];
    viewLine.backgroundColor = [UIColor colorWithHex:COLOR_LINE];
    viewLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self insertSubview:viewLine belowSubview:contentView];
    
    selectedLine = [[UIView alloc] initWithFrame:CGRectZero];
    selectedLine.backgroundColor = self.lineSelectedColor;
    [contentView addSubview:selectedLine];
    
    itemViews = [[NSMutableArray alloc] init];
}
- (void)clearItems
{
    for (UIView *item in itemViews) {
        [item removeFromSuperview];
    }
    [itemViews removeAllObjects];
}
- (void)loadItems
{
    contentView.backgroundColor = self.viewColor;
    for (NSInteger i = 0; i < self.itemTitles.count; i++) {
        UILabel *btn = [[UILabel alloc] initWithFrame:CGRectZero];
        btn.userInteractionEnabled = YES;
        btn.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [btn addGestureRecognizer:recognizer];
        [contentView insertSubview:btn belowSubview:selectedLine];
        [itemViews addObject:btn];
    }
    [self setNeedsLayout];
}

#pragma mark - Event
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSInteger index = [itemViews indexOfObject:recognizer.view];
    self.selectedIndex = index;
    [self.delegate didSelectTabAtIndex:index];
}

@end