//
//  CreateOrderNormalCell.h
//  GuaHao
//
//  Created by 123456 on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderNormalCell : UITableViewCell
+ (instancetype)renderCell:(CreateOrderNormalCell *)cell typeStr:(NSString *)typeStr valueStr:(NSString *)valueStr;
@end
