//
//  OrderPatientRemarkCell.m
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "OrderPatientRemarkCell.h"

@interface OrderPatientRemarkCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *InfoLabel;

@end
@implementation OrderPatientRemarkCell
+ (instancetype)renderCell:(OrderPatientRemarkCell *)cell source:(NSArray *)source {
    
    
    cell.InfoLabel.text = [source firstObject];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
