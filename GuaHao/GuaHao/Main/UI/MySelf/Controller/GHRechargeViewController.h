//
//  GHRechargeViewController.h
//  GuaHao
//
//  Created by qiye on 16/9/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateSuccessAction)(BOOL result);

@interface GHRechargeViewController : UIViewController
@property (nonatomic, copy)UpdateSuccessAction myAction;
-(void)updateLevelAction:(UpdateSuccessAction)action;
@end
