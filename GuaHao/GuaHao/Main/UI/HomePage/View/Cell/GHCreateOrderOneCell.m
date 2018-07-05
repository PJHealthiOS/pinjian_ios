//
//  GHCreateOrderOneCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHCreateOrderOneCell.h"

@interface GHCreateOrderOneCell (){
    
}

@property (weak, nonatomic) IBOutlet UIImageView *msgRedIcon;

@property (weak, nonatomic) IBOutlet UIImageView *oneIconImage;
@property (weak, nonatomic) IBOutlet UILabel *oneTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *twoIconImage;
@property (weak, nonatomic) IBOutlet UILabel *twoTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *threeIconImage;
@property (weak, nonatomic) IBOutlet UILabel *threeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *fourIconImage;
@property (weak, nonatomic) IBOutlet UILabel *fourTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourDescLabel;




@end
@implementation GHCreateOrderOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code[button setAdjustsImageWhenHighlighted:NO];
    //为透明度设置渐变效果
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UIColor *colorOne = [UIColor colorWithRed:(235/255.0)  green:(235/255.0)  blue:(236/255.0)  alpha:0.5];
    UIColor *colorTwo = [UIColor colorWithRed:(235/255.0)  green:(235/255.0)  blue:(236/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [view.layer insertSublayer:gradient atIndex:0];
    [self addSubview:view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hxMessage:) name:@"HXMessageEvent" object:nil];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}

#pragma mark - Internal
-(void)hxMessage:(NSNotification *)notification
{
    NSString * msg = notification.object;
    if (msg&&[msg isEqualToString:@"1"] ) {
        _msgRedIcon.hidden = NO;
    }else{
        _msgRedIcon.hidden = YES;
    }
}
-(void)clickButtonReturn:(ClickReturnBlock)block{
    self.myBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
