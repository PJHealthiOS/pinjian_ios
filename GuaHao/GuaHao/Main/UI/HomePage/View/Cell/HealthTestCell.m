//
//  HealthTestCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "HealthTestCell.h"

@interface HealthTestCell (){
    

}
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation HealthTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews:(HealthTestVO *)vo{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:vo.coverUrl] placeholderImage:[UIImage imageNamed:@""]];
    [self.backView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@人已测试",vo.numOfTest];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
