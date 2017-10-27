//
//  ApplyForWithdrawCash.h
//  GuaHao
//
//  Created by 123456 on 16/2/23.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankNameVO.h"
@protocol ApplyForWithdrawCashDelegate <NSObject>
-(void)applyForMoneyDelegate;
@end

@interface ApplyForWithdrawCash : UIViewController
@property(assign) id<ApplyForWithdrawCashDelegate> delegate;
@property(nonatomic,strong) NSNumber * hasMoney;

@end
