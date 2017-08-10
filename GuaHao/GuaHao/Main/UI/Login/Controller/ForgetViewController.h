//
//  ForgetViewController.h
//  GuaHao
//
//  Created by qiye on 16/1/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgetViewDelegate <NSObject>
-(void) forgetComplete;
@end

@interface ForgetViewController : UIViewController
@property(assign) id<ForgetViewDelegate> delegate;
@property (nonatomic) NSInteger openType;
@end
