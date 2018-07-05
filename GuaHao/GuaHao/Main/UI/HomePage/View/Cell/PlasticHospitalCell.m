//
//  PlasticHospitalCell.m
//  GuaHao
//
//  Created by PJYL on 2018/6/13.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "PlasticHospitalCell.h"
@interface PlasticHospitalCell(){
    
}

@property (weak, nonatomic) IBOutlet UIImageView *hospitalIcon;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLevel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddress;
@property (weak, nonatomic) IBOutlet UIView *hospitalDepView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *depViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *hospitalDesc;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIButton *operationButton;

@property (nonatomic , strong) NSIndexPath *indexPath;


@end
@implementation PlasticHospitalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCell:(PlasticHospitalModel*)hospital indexPath:(NSIndexPath *)indexPath operationStr:(NSString *)operationStr{
    self.indexPath = indexPath;
    [self.hospitalIcon sd_setImageWithURL:[NSURL URLWithString:hospital.image] placeholderImage:nil];
    self.hospitalName.text = hospital.name;
    self.hospitalLevel.text = hospital.level;
    self.hospitalAddress.text = hospital.address;
    self.hospitalDesc.text = [NSString stringWithFormat:@"科室简介：%@", hospital.deptComments];
    [self.operationButton setTitle:operationStr forState:UIControlStateNormal];
    
    [self addShadow:self.shadowView];
    
    [self layoutWithSourceArr:[hospital.deptName componentsSeparatedByString:@","]];


}



-(void)addShadow:(UIView *)fatherView{
    if (fatherView.subviews.count > 0) {
        return;
    }
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
    [fatherView addSubview:view];
    
}



-(void)layoutWithSourceArr:(NSArray *)sourceArr{
    ///添加项目
    [[self.hospitalDepView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float originX = 0;
    int row = 0;
    for (NSString *str in sourceArr) {
        float originX_ = 10;
        originX_ = originX + str.length * 12 + 10 + 20;
        if (originX_ > self.hospitalDepView.frame.size.width) {
            originX = 0;
            row = row + 1;
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(originX, row * (20 + 10) + 0, str.length * 12 + 20, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x4c4c4c);
        label.text = str;
        label.font = [UIFont systemFontOfSize:11];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self.hospitalDepView addSubview:label];
        originX = originX + str.length * 12 + 10 + 20;
        
    }
    self.depViewHeight.constant = row * (20 + 10) + 20;
    
    
}




- (IBAction)operationAction:(UIButton *)sender {
  
    self.myAction(self.indexPath);
    
}



-(void)operationClick:(OperationAction)action{
    self.myAction = action;
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
