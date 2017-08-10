//
//  TakeOrderTableViewCell.h
//  GuaHao
//
//  Created by qiye on 16/2/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptVO.h"

@protocol TakeOrderCellDelegate <NSObject>
-(void)takeOrderComplete:(AcceptVO*) order;
@end

@interface TakeOrderTableViewCell : UITableViewCell

@property (assign) id<TakeOrderCellDelegate> delegate;

-(void)setOrder:(AcceptVO*) vo;

@end
