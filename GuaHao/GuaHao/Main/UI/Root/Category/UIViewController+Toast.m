//
//  UIViewController+Toast.m
//  GuaHao
//
//  Created by qiye on 16/1/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "UIViewController+Toast.h"

@implementation UIViewController (Toast)

- (void)inputToast:(NSString *)message {
    [self.view makeToast:message duration:1.0 position:CSToastPositionCenter style:nil];
}
@end
