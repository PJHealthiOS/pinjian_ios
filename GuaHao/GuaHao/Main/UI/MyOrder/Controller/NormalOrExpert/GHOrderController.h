//
//  GHOrderController.h
//  GuaHao
//
//  Created by 123456 on 16/8/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,OrderGetType) {
    OrderConmmonGet = 1,
    OrderExpertGet ,
    OrderHistoryGet ,
};

@interface GHOrderController : UIViewController
@property (assign, nonatomic)BOOL isExpert;
@end
