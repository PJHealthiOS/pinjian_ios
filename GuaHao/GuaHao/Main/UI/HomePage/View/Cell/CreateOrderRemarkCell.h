//
//  CreateOrderRemarkCell.h
//  GuaHao
//
//  Created by 123456 on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderRemarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
+ (instancetype)renderCell:(CreateOrderRemarkCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr;
@end
