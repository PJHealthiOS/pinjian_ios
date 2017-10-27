//
//  ApplyForMoneyVC.h
//  GuaHao
//
//  Created by 123456 on 16/1/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyForMoneyDelegate <NSObject>
-(void) applyForMoneyDelegate;
@end

@interface ApplyForMoneyVC : UIViewController
@property(assign) id<ApplyForMoneyDelegate> delegate;

@end
