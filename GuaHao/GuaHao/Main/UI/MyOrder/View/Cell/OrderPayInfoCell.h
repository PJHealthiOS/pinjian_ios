//
//  OrderPayInfoCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderVO.h"

@interface OrderPayInfoCell : UITableViewCell
+ (instancetype)renderCell:(OrderPayInfoCell *)cell order:(OrderVO *)order;
@end
