//
//  SeriousExpertSelectVC.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectExpertAction)(NSArray *selectArr);
@interface SeriousExpertSelectVC : UIViewController
@property (strong, nonatomic) NSMutableArray *selectArr;
@property (nonatomic, copy) SelectExpertAction myAction;
-(void)selectAction:(SelectExpertAction)action;
@end
