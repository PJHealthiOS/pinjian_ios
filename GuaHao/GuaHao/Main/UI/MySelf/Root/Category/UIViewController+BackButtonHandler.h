//
//  UIViewController+BackButtonHandler.h
//  GuaHao
//
//  Created by qiye on 16/9/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end
@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>
@end
