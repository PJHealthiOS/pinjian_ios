//
//  PayViewController.h
//  GuaHao
//
//  Created by qiye on 16/8/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayType){
    OrderCreatePay = 0,
    OrderListPay,
    OrderDescPay,
};

@interface PayViewController : UIViewController
@property(nonatomic) NSNumber * orderID;
@property(nonatomic) PayType payType;
@property(nonatomic) BOOL isExpert;
@property(nonatomic, assign)BOOL isAccompany;
@end
