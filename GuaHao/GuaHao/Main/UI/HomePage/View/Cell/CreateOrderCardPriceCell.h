//
//  CreateOrderCardPriceCell.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/20.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderCardPriceCell : UITableViewCell
+ (instancetype)renderCell:(CreateOrderCardPriceCell *)cell typeStr:(NSString *)typeStr descStr:(NSString *)descStr valueStr:(NSString *)valueStr;
@end
