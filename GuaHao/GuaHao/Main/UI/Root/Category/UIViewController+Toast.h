//
//  UIViewController+Toast.h
//  GuaHao
//
//  Created by qiye on 16/1/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Toast/UIView+Toast.h>
typedef NS_ENUM(NSInteger,PopBackType) {
    PopBackDefalt = 2,
    PopBackTwo,
    PopBackThree,
    PopBackRoot,
};

typedef NS_ENUM(NSInteger,OrderType) {
    OrderCommon = 1,
    OrderExpert,
};

@interface UIViewController (Toast)
- (void)inputToast:(NSString *)message;
@end
