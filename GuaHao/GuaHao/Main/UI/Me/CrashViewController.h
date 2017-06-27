//
//  CrashViewController.h
//  GuaHao
//
//  Created by qiye on 16/7/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CrashViewDelegate <NSObject>
-(void) crashViewDelegate:(BOOL) isSucces;
@end
@interface CrashViewController : UIViewController
@property(assign) id<CrashViewDelegate> delegate;
@end
