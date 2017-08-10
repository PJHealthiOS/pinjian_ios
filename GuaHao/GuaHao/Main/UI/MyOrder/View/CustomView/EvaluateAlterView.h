//
//  EvaluateAlterView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/22.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopAction)(BOOL result);
@interface EvaluateAlterView : UIView
@property (copy, nonatomic)ShopAction myAction;
-(void)clickShopAction:(ShopAction)action;
@end
