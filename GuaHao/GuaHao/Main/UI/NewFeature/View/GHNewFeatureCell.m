#import "GHNewFeatureCell.h"
#import "GHTabBarController.h"

@interface GHNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *startButton;

@property (nonatomic, weak) UIButton *passButton;

@end

@implementation GHNewFeatureCell

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        _startButton = startBtn;
        [self addSubview:_startButton];

    }
    return _startButton;
}
- (UIButton *)passButton{
    if (_passButton == nil) {
        UIButton *passBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        passBtn.frame=CGRectMake(0, 0, 70, 25);

        [passBtn setBackgroundImage:[UIImage imageNamed:@"common_btnImg_04345.png"] forState:UIControlStateNormal];
        
        [passBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [passBtn sizeToFit];
        [passBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:passBtn];
        _passButton = passBtn;
        
    }
    return _passButton;
    
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageView = imageV;
        
        // 注意:一定要加载contentView
        [self.contentView addSubview:imageV];
        
    }
    return _imageView;
}

// 布局子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    // 开始按钮
    self.startButton.frame = CGRectMake(0, 0, 99, 30);
     self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.9);
    
    // 跳过按钮
    self.passButton.center = CGPointMake(self.width * 0.87, self.height * 0.08);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{

    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        self.startButton.hidden = NO;
    }else{ // 非最后一页，隐藏分享和开始按钮
        self.startButton.hidden = YES;
    }
}

// 点击开始时候调用
- (void)start
{
    // 进入tabBarVc
    GHTabBarController *tabBarVc = [[GHTabBarController alloc] init];
    
    // 切换根控制器:可以直接把之前的根控制器清空
    GHKeyWindow.rootViewController = tabBarVc;

}

@end
