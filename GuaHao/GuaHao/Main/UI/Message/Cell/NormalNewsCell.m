//
//  NormalNewsCell.m
//  GuaHao
//
//  Created by 123456 on 16/1/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "NormalNewsCell.h"
#import "Utils.h"

@implementation NormalNewsCell{
    
    __weak IBOutlet UILabel *titleLab;
    __weak IBOutlet UILabel *descLab;
    __weak IBOutlet UILabel *dateLab;
    __weak IBOutlet UILabel *lookLab;
    __weak IBOutlet UIImageView *img;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 
-(void) setCell:(MessageVO*) vo
{
    descLab.text = vo.content;
    dateLab.text = vo.createDate;
    lookLab.text = @"查看详情";
    img.image = [UIImage imageNamed:@"common_gray_push_btn.png"];
    if (vo.type.intValue == 6 ||vo.type.intValue == 9 ||(vo.type.intValue>13&&vo.type.intValue<21)) {
        lookLab.text = @"暂无详情";
        img.image = [UIImage imageNamed:@""];
    }
    titleLab.attributedText = [Utils attributeString:@[vo.title] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:vo.readed?[UIColor grayColor]:[UIColor blackColor]}]];
}

@end
