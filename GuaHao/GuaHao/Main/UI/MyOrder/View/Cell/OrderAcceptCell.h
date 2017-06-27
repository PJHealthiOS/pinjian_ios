//
//  OrderAcceptCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderVO.h"
@interface OrderAcceptCell : UITableViewCell
+ (instancetype)renderCell:(OrderAcceptCell *)cell order:(OrderVO *)order;
@end
