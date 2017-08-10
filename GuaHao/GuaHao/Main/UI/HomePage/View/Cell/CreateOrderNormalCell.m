//
//  CreateOrderNormalCell.m
//  GuaHao
//
//  Created by 123456 on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderNormalCell.h"

@interface CreateOrderNormalCell (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation CreateOrderNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)renderCell:(CreateOrderNormalCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr {
    NSArray *arr = @[@"请选择就诊科室",@"请选择就诊医院",@"请选择时间",@"手机号",@"请选择就诊人",@"请选择挂号方式"];
    BOOL isBlack = YES;
    for (NSString *str in arr) {
        if ([valueStr isEqualToString:str]) {
            isBlack = NO;
             cell.nameLabel.textColor = UIColorFromRGB(0x888888);
        }
    }
    if (isBlack) {
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    cell.iconImage.image = [UIImage imageNamed:typeStr];
    cell.nameLabel.text = valueStr;

    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
