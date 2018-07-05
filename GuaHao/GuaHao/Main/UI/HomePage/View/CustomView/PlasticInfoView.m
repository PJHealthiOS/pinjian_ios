//
//  PlasticInfoView.m
//  GuaHao
//
//  Created by PJYL on 2018/6/12.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "PlasticInfoView.h"

@interface PlasticInfoView()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *projectsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;




@property (weak, nonatomic) IBOutlet UIView *lineViewTop;
@property (weak, nonatomic) IBOutlet UIView *lineViewBottom;


@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *operatorDescLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationDescLabelHeight;



@end

@implementation PlasticInfoView


-(instancetype)initWithFrame:(CGRect)frame order:(PlasticTypeVO *)order{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"PlasticInfoView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.scrollView.delegate = self;
        [self changeInfo:order];
        [self addShadow:self.lineViewTop];
        [self addShadow:self.lineViewBottom];

    }return self;
    
}








-(void)changeInfo:(PlasticTypeVO *)order{

    [self layoutWithSourceArr:[order.projects componentsSeparatedByString:@","]];

    ////添加人群
    self.operationLabelHeight.constant = [self addInfo:order.applicablePeople fatherView:self.operationLabel];
    
    ////添加资质
    self.operationDescLabelHeight.constant = [self addInfo:order.operatorDesc fatherView:self.operatorDescLabel];
    
    
//    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.operationLabel.frame) + 50);
 
    
}



-(CGFloat)addInfo:(NSString *)htmlStr fatherView:(UILabel *)fatherView{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];
    
    fatherView.attributedText = attStr;
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attStr.length)];
    //计算加载完成之后Label的frame
    CGSize size = [fatherView sizeThatFits:CGSizeMake(SCREEN_WIDTH - 40, 1000)];
    return  size.height;
    
}

-(void)layoutWithSourceArr:(NSArray *)sourceArr{
    ///添加项目
    [[self.projectsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float originX = 0;
    int row = 0;
    for (NSString *str in sourceArr) {
        float originX_ = 10;
        originX_ = originX + str.length * 12 + 10 + 20;
        if (originX_ > SCREEN_WIDTH) {
            originX = 0;
            row = row + 1;
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(originX, row * (30 + 10) + 0, str.length * 12 + 20, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x4c4c4c);
        label.text = str;
        label.font = [UIFont systemFontOfSize:12];
        label.layer.cornerRadius = 15;
        label.layer.masksToBounds = YES;
        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self.projectsView addSubview:label];
        originX = originX + str.length * 12 + 10 + 20;
        
    }
    self.topViewHeight.constant = row * (30 + 10) + 90;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= 0) {
        self.scrollView.scrollEnabled = NO;
        scrollView.contentOffset = CGPointZero;
    }
    
}

-(void)addShadow:(UIView *)fatherView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UIColor *colorOne = [UIColor colorWithRed:(235/255.0)  green:(235/255.0)  blue:(236/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(235/255.0)  green:(235/255.0)  blue:(236/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [view.layer insertSublayer:gradient atIndex:0];
    [fatherView addSubview:view];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
