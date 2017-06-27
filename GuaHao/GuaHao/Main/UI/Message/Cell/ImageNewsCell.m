//
//  ImageNewsCell.m
//  GuaHao
//
//  Created by 123456 on 16/1/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ImageNewsCell.h"

@implementation ImageNewsCell{
    
    __weak IBOutlet UILabel *dateLab;
    __weak IBOutlet UILabel *titleLab;
    __weak IBOutlet UILabel *contentLab;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(MessageVO*) vo
{
    dateLab.text = vo.createDate;
    contentLab.text = vo.content;
    titleLab.text = vo.title;
}

@end
