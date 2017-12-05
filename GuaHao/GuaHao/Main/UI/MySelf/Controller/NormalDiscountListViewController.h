//
//  NormalDiscountListViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/11/6.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsedCouponsVO.h"
typedef void(^CouponSelectAction)(UsedCouponsVO *selectCoupon);
@interface NormalDiscountListViewController : UIViewController
@property (nonatomic, copy)CouponSelectAction myAction;
-(void)selectCouponAction:(CouponSelectAction)action;
@end
