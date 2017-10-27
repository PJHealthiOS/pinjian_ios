//
//  LoginViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/10/16.
//  Copyright © 2017年 pinjian. All rights reserved.
//
#import <UIKit/UIKit.h>
 typedef void(^LoginAction)(BOOL result);

@protocol LoginViewDelegate <NSObject>
-(void) loginComplete;
@end

@interface LoginViewController : UIViewController
@property(assign) id<LoginViewDelegate> delegate;
@property (nonatomic, copy)LoginAction myAction;
-(void)loginAction:(LoginAction)action;
+(void)autoLogin;
@end

