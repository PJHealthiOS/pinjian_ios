//
//  SpecialHomeCell.m
//  GuaHao
//
//  Created by PJYL on 2016/11/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SpecialHomeCell.h"

@interface SpecialHomeCell (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation SpecialHomeCell
-(instancetype)initWithFrame:(CGRect)frame icon:(NSString *)imageUrl title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
       
        
    }return self;
}
-(void)layoutWithIcon:(NSString *)imageUrl title:(NSString *)title{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"department_Defalut_icon"]];
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
