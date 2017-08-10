//
//  BankSelectViewController.h
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankListVO;
@protocol BankSelectViewDelegate <NSObject>
-(void) bankSelectDelegate:(BankListVO *) vo;
@end

@interface BankSelectViewController : UIViewController
@property(assign) id<BankSelectViewDelegate> delegate;
@end
