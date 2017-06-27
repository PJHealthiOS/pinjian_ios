//
//  GHTabBar.m
//  GuaHao
//
//  Created by PJYL on 2016/12/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHTabBar.h"
#import "UIView+Extension.h"
@interface GHTabBar (){
    
}
@property (nonatomic, strong)UIImageView *tabbBarImageView;
@property (nonatomic, strong)UIButton *plusButon;
@end
@implementation GHTabBar

-(instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        [self createPlusButton];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


-(void)createPlusButton{
    UIImageView *tabbBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plus_tabBar_image"]];
    tabbBarImageView.frame = CGRectMake(0, 0, 60, 55);
    tabbBarImageView.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    tabbBarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plusClick)];
    [tabbBarImageView addGestureRecognizer:tap];
    [self addSubview:tabbBarImageView];
    self.tabbBarImageView = tabbBarImageView;
    
}
-(void)plusClick{
    self.myBlock(YES);
}
-(void)plusBtnClickAction:(PlusClickActionBlock)block{
    self.myBlock = block;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tabbBarImageView.centerX = self.width*0.5;
    self.tabbBarImageView.centerY = self.height *0.3;
    ///设置其他tabbar的frame
    CGFloat tabbarBtnW = self.width / 5;
    CGFloat tabIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.x = tabbarBtnW * tabIndex;
            child.width = tabbarBtnW;
            tabIndex++;
            if (tabIndex == 2) {
                tabIndex++;
            }
        }
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
