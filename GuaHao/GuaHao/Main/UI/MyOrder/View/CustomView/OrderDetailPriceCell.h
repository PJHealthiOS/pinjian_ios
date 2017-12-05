//
//  OrderDetailPriceCell.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/10.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailPriceCell : UITableViewCell
-(void)loadCellWith:(NSString *)typeStr valueStr:(NSString *)valueStr hidden:(BOOL)hidden gary:(BOOL)gary;
@end
