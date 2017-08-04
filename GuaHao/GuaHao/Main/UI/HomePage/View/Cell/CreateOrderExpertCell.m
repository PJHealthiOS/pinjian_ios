//
//  CreateOrderExpertCell.m
//  GuaHao
//
//  Created by PJYL on 16/9/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderExpertCell.h"

@interface CreateOrderExpertCell(){
    
}
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (assign, nonatomic) NSIndexPath *indexPath;
@end
@implementation CreateOrderExpertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)renderCell:(CreateOrderExpertCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath *)indexPath{
    cell.typeLabel.text = typeStr;
    cell.valueLabel.text = valueStr;
    cell.indexPath = indexPath;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
