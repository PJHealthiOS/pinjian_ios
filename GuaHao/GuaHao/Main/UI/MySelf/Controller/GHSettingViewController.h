//
//  GHSettingViewController.h
//  GuaHao
//
//  Created by PJYL on 16/9/2.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AccountNumberViewDelegate <NSObject>

-(void)accountNumberViewDelegate;

@end
@interface GHSettingViewController : UIViewController
@property(assign) id<AccountNumberViewDelegate> delegate;
@end
