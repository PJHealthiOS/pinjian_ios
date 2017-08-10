//
//  CreateOrderRemarkCell.m
//  GuaHao
//
//  Created by 123456 on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderRemarkCell.h"

@interface CreateOrderRemarkCell (){
    
}


@end
@implementation CreateOrderRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)renderCell:(CreateOrderRemarkCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr{
    cell.typeLabel.text = typeStr;
    cell.valueLabel.text = valueStr;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
