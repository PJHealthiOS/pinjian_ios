//
//  NewsView.m
//  LHNewsTest
//
//  Created by zymobi on 16/7/12.
//  Copyright © 2016年 zymobi. All rights reserved.
//

#import "NewsView.h"

#define WCHomeNewsImageViewWH 15

@interface NewsView (){
    
}
@property (nonatomic,strong) NSMutableArray *newsArray;
@property (nonatomic,copy)   void(^clickAction)(NSInteger index);
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSTimeInterval interval;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *showLabel;
@property (nonatomic,strong) UILabel *bottomLabel;
@property (assign, nonatomic) NSInteger showIndex;
@property (assign, nonatomic) NSInteger willShowIndex;
@property (strong, nonatomic) UIButton *moreButton;

@end

@implementation NewsView


- (void)dealloc
{
    [self stopAnimation];
}

- (void)stopAnimation {
    [_timer invalidate];
    _timer = nil;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];
    }
    return self;
}
-(void)_setup{
    self.clipsToBounds = YES;
    _interval = 4.0;
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor clearColor];

    
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@""];
  
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat space = 5;
    

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(space, 7, 65, 30)];
    label.text = @"品简通知:";
//    _imageView.frame = CGRectMake(space, 12, 75, 20);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];//加粗
    
    _moreButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTintColor:[UIColor grayColor]];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_moreButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (height - 20)/2.0, 1, 20)];
    lineView.backgroundColor = [UIColor grayColor];
    [_moreButton addSubview:lineView];
    
    _moreButton.frame = CGRectMake(width - 50, 0, 50, height);
    _contentView.frame = CGRectMake(CGRectGetMaxX(label.frame) + space,0 , width - space *3 - CGRectGetWidth(_imageView.frame) - CGRectGetWidth(_moreButton.frame), height);
    [self addSubview:_moreButton];
    
    [self addSubview:_contentView];
    [self addSubview:label];
    

   
    _showLabel = [self _createLabel];
    _bottomLabel = [self _createLabel];
    [_contentView addSubview:_showLabel];
    [_contentView addSubview:_bottomLabel];
    
    
}
-(void)more{
    NSLog(@"更多");
}

-(void)setHideMore{
    _moreButton.hidden = YES;
    _contentView.frame = CGRectMake(_contentView.x,0 , _contentView.width + CGRectGetWidth(_moreButton.frame), _contentView.height);
}

- (void)setNewArray:(NSArray *)array clickAction:(void (^)(NSInteger))action {
    if (!array.count) {
        return;
    }
    _newsArray = [array mutableCopy];
    // 根据数据源显示起始内容
    _showIndex = 0;
    _willShowIndex = (_showIndex + 1) % array.count;
    
    [self _updateLabels];
    [self startAnimation];
    if (action) {
        _clickAction = [action copy];
    }
}



- (void)setNewsTextColor:(UIColor *)color {
    if (color) {
        _showLabel.textColor = color;
        _bottomLabel.textColor = color;
    }
}

- (void)setNewsFont:(UIFont *)font {
    if (font) {
        _bottomLabel.font = font;
        _showLabel.font = font;
    }
}

- (void)setNewsImageName:(NSString *)imageName {
    if (imageName.length) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            _imageView.image = image;
        }
    }
}

- (void)setAnimationTimerInterval:(NSTimeInterval)interval {
    if (interval > 0) {
        _interval = interval;
    }
}

- (void)_timerFireMethod {
    _showIndex ++ ;
    _willShowIndex ++ ;
    _showIndex = _showIndex % _newsArray.count;
    _willShowIndex = _willShowIndex % _newsArray.count;
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat height = -_contentView.bounds.size.height;
        _showLabel.transform = CGAffineTransformMakeTranslation(0, height);
        _bottomLabel.transform = CGAffineTransformMakeTranslation(0, height);
    } completion:^(BOOL finished) {
        _showLabel.text = _newsArray[_showIndex];
        _showLabel.transform = CGAffineTransformIdentity;
        _bottomLabel.text = _newsArray[_willShowIndex];
        _bottomLabel.transform = CGAffineTransformIdentity;
    }];
}

- (void)startAnimation {
    if (_newsArray.count) {
        if (!self.timer) {
            _timer = [NSTimer timerWithTimeInterval:_interval target:self selector:@selector(_timerFireMethod) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }
}


- (void)_updateLabels {
    _showLabel.text = _newsArray[_showIndex];
    _bottomLabel.text = _newsArray[_willShowIndex];
}

- (UILabel *)_createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = RGB(238.0, 105.0, 38.0);
    label.userInteractionEnabled = YES;
    label.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_labelClicked)];
    [label addGestureRecognizer:gesture];
    return label;
}

- (void)_labelClicked {
    if (_clickAction) {
        _clickAction (_showIndex);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = _contentView.frame;
    _showLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _bottomLabel.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
}
















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
