//
//  SeriousListCell.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriousListModel.h"
typedef void(^EvaluateBlock)(NSIndexPath *indexpath);

@interface SeriousListCell : UITableViewCell
@property (nonatomic, copy)EvaluateBlock evaluateBlock;
-(void)evaluateOrderAction:(EvaluateBlock)block;

-(void)setCellWithModel:(SeriousListModel *)model;
@end
