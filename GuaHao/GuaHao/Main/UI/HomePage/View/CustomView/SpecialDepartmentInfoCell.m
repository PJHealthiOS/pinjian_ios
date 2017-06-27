//
//  SpecialDepartmentInfoCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SpecialDepartmentInfoCell.h"

@implementation SpecialDepartmentInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutWithSourceArr:(NSArray *)sourceArr{
    float originX = 10;
    int row = 0;
    for (NSString *str in sourceArr) {
        float originX_ = 10;
        originX_ = originX + str.length * 12 + 10 + 20;
        if (originX_ > SCREEN_WIDTH) {
            originX = 10;
            row = row + 1;
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(originX, row * (30 + 10) + 70, str.length * 12 + 20, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x64c77f);
        label.text = str;
        label.font = [UIFont systemFontOfSize:12];
        label.layer.cornerRadius = 10;
        label.layer.borderColor =  UIColorFromRGB(0x64c77f).CGColor;
        label.layer.borderWidth = 1;
        [self.contentView addSubview:label];
        originX = originX + str.length * 12 + 10 + 20;
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
