//
//  GHOrderCell.h
//  GuaHao
//
//  Created by 123456 on 16/8/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListVO.h"

@protocol EndCountdownDelegate <NSObject>

-(void)endCountdown:(NSIndexPath *)indexpath;

@end
typedef  void(^EndCountdownBlock)(BOOL end,NSIndexPath *indexpath);
typedef  void(^PayBlock)(BOOL end,NSIndexPath *indexpath);
typedef void(^CreateOrderAgainBlock)(NSIndexPath *indexpath);
typedef void(^DeleteBlock)(NSIndexPath *indexpath);
typedef void(^EvaluateBlock)(NSIndexPath *indexpath);

@interface GHOrderCell : UITableViewCell

@property (nonatomic, copy)EndCountdownBlock endBlock;
@property (nonatomic, copy)PayBlock payBlock;
@property (nonatomic, copy)CreateOrderAgainBlock againBlock;
@property (nonatomic, copy)DeleteBlock deleteBlock;
@property (nonatomic, copy)EvaluateBlock evaluateBlock;

-(void)setCellWithOrder:(OrderListVO *)order indexPath:(NSIndexPath *)indexPath isHistory:(BOOL)isHistory;
-(void)countdownEnd:(EndCountdownBlock)block;
-(void)pay:(PayBlock)block;
-(void)createOrderAgainBlock:(CreateOrderAgainBlock)block;
-(void)deleteRow:(DeleteBlock)block;
-(void)evaluateOrderAction:(EvaluateBlock)block;
@property (nonatomic, weak)id<EndCountdownDelegate>endDel;
@end
