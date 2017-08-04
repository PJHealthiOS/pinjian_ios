//
//  SpecialDiscountListViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/7/25.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsedCouponsVO.h"
typedef void(^CouponSelectAction)(UsedCouponsVO *selectCoupon);
@interface SpecialDiscountListViewController : UIViewController
@property (nonatomic, copy)CouponSelectAction myAction;
-(void)selectCouponAction:(CouponSelectAction)action;
@end
