//
//  OrderSureView.h
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomerAlterAction)(BOOL result);

@interface OrderSureView : UIView
@property(nonatomic, copy) CustomerAlterAction myAction;
-(void)clickSureAction:(CustomerAlterAction)action;
-(void)setName:(NSString*) _name content:(NSString*) _content fromNormal:(BOOL)isNormal;
@end
