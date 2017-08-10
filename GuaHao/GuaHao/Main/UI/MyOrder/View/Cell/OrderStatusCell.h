//
//  OrderStatusCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderVO.h"
#import "AccDetialVO.h"
@interface OrderStatusCell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type;
+ (instancetype)renderCell:(OrderStatusCell *)cell order:(OrderVO *)order;
+ (instancetype)AccrenderCell:(OrderStatusCell *)cell order:(AccDetialVO *)order;
@end
