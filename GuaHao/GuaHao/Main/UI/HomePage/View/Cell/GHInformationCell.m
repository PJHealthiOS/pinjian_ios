//
//  GHInformationCell.m
//  GuaHao
//
//  Created by PJYL on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHInformationCell.h"

@interface GHInformationCell (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookTimes;
@property (weak, nonatomic) IBOutlet UILabel *clickLabel;


@end
@implementation GHInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews:(ArticleListVO *)vo{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:vo.coverUrl] placeholderImage:nil];
    self.titleLabel.text = vo.title;
    self.descriptionLabel.text = vo.desc;
    self.lookTimes.text = [NSString stringWithFormat:@"%@",vo.viewCount];
    self.clickLabel.text = [NSString stringWithFormat:@"%@",vo.praiseCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
