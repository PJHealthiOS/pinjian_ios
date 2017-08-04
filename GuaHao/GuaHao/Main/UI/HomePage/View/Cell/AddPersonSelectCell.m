//
//  AddPersonSelectCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AddPersonSelectCell.h"

@interface AddPersonSelectCell (){
    
}

@property (assign, nonatomic) NSIndexPath *indexPath;
@end
@implementation AddPersonSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)renderCell:(AddPersonSelectCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath *)indexPath{
    cell.nameLabel.text = typeStr;
    cell.valueLabel.text = valueStr;
    cell.indexPath = indexPath;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
