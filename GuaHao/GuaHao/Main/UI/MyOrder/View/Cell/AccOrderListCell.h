//
//  AccOrderListCell.h
//  GuaHao
//
//  Created by PJYL on 2016/10/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^PayBlock)(BOOL end,NSIndexPath *indexpath);
typedef void(^DeleteBlock)(NSIndexPath *indexpath);
typedef void(^EvaluateBlock)(NSIndexPath *indexpath);

@interface AccOrderListCell : UITableViewCell

@property (nonatomic, copy)PayBlock payBlock;
@property (nonatomic, copy)DeleteBlock deleteBlock;
@property (nonatomic, copy)EvaluateBlock evaluateBlock;

-(void)layoutSubviews:(OrderListVO *)vo andIndexPath:(NSIndexPath *)indexPath;
-(void)pay:(PayBlock)block;
-(void)deleteRow:(DeleteBlock)block;
-(void)evaluateOrderAction:(EvaluateBlock)block;

@end
