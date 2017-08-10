//
//  CrateOrderSuccessView.h
//  GuaHao
//
//  Created by PJYL on 2017/4/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OkAction)(BOOL result);
@interface CrateOrderSuccessView : UIView
@property (copy, nonatomic)OkAction myAction;
-(void)clickShopAction:(OkAction)action;


@property (weak, nonatomic) IBOutlet UILabel *descripLabel;

@end
