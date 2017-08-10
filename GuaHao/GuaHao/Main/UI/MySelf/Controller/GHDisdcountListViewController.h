//
//  GHDisdcountListViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/5/4.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsedCouponsVO.h"
typedef void(^CouponSelectAction)(UsedCouponsVO *selectCoupon);
@interface GHDisdcountListViewController : UIViewController
@property (nonatomic, assign) BOOL isExpert;
@property (nonatomic, copy)CouponSelectAction myAction;
-(void)selectCouponAction:(CouponSelectAction)action;
@end
