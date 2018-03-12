//
//  FeedbackViewController.h
//  GuaHao
//
//  Created by PJYL on 2018/3/6.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FeedBackAction)(BOOL successful);

@interface FeedbackViewController : UIViewController
@property (copy ,nonatomic) NSString *orderID;
@property (copy, nonatomic) FeedBackAction myAction;
-(void)feedBackSuccess:(FeedBackAction)action;
@end
