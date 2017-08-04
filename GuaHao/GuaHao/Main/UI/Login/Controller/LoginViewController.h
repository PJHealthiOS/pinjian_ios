//
//  LoginViewController.h
//  GuaHao
//
//  Created by qiye on 16/1/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>
-(void) loginComplete;
@end

@interface LoginViewController : UIViewController
@property(assign) id<LoginViewDelegate> delegate;
+(void)autoLogin;
@end
