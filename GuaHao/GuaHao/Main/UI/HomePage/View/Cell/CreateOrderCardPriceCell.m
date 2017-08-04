//
//  CreateOrderCardPriceCell.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "CreateOrderCardPriceCell.h"

@interface CreateOrderCardPriceCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
@implementation CreateOrderCardPriceCell
+ (instancetype)renderCell:(CreateOrderCardPriceCell *)cell typeStr:(NSString *)typeStr descStr:(NSString *)descStr valueStr:(NSString *)valueStr{
    cell.typeLabel.text = typeStr;
//    cell.descLabel.text = descStr;
    cell.valueLabel.text = [NSString stringWithFormat:@"%@元",valueStr];
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
