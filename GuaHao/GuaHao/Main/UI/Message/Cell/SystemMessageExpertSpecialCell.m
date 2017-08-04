//
//  SystemMessageExpertSpecialCell.m
//  GuaHao
//
//  Created by 123456 on 16/5/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SystemMessageExpertSpecialCell.h"
#import "Utils.h"

@implementation SystemMessageExpertSpecialCell{
    __weak IBOutlet UILabel *titleLab;
    __weak IBOutlet UILabel *descLab;
    __weak IBOutlet UILabel *dateLab;
    __weak IBOutlet UILabel *lookLab;
    __weak IBOutlet UIImageView *img;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void) setCell:(MessageVO*) vo
{
    descLab.text = vo.content;
    dateLab.text = vo.createDate;
    lookLab.text = @"查看详情";
    img.image = [UIImage imageNamed:@"common_gray_push_btn.png"];
    titleLab.attributedText = [Utils attributeString:@[vo.title] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16], NSForegroundColorAttributeName:vo.readed?[UIColor grayColor]:[UIColor blackColor]}]];
}

@end
