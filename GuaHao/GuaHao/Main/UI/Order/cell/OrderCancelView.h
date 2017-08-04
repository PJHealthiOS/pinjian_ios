//
//  OrderSureView.h
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"
@protocol OrderCancelDelegate <NSObject>
-(void)orderCancelDelegate:(int) type;
@end
@interface OrderCancelView : UIView
@property(assign) id<OrderCancelDelegate> delegate;
-(void)setTitles:(NSString*) title button:(NSString*) content;
@end
