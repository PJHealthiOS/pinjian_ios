//
//  OrderSureView.h
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderSureDelegate <NSObject>
-(void)orderSureDelegate:(BOOL) isSure;
@end

@interface OrderSureView : UIView
@property(assign) id<OrderSureDelegate> delegate;
-(void)setName:(NSString*) _name content:(NSString*) _content;
@end
