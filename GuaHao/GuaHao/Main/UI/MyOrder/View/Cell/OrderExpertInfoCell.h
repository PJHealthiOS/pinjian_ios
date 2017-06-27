//
//  OrderExpertInfoCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderVO.h"
typedef  void(^OrderPatientInfoBlock)(BOOL end);
@interface OrderExpertInfoCell : UITableViewCell
@property (nonatomic, copy)OrderPatientInfoBlock myBlock;
-(void)openPatientInfo:(OrderPatientInfoBlock)block;
+ (instancetype)renderCell:(OrderExpertInfoCell *)cell order:(OrderVO *)order;
@end
