//
//  AccountNumberVC.h
//  GuaHao
//
//  Created by 123456 on 16/1/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountNumberViewDelegate <NSObject>

-(void)accountNumberViewDelegate;

@end

@interface AccountNumberVC : UIViewController

@property(nonatomic,copy) NSString * _phoneN;

@property(assign) id<AccountNumberViewDelegate> delegate;
@end
