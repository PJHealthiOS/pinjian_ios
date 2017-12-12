//
//  SettingController.h
//  GuaHao
//
//  Created by PJYL on 2017/12/11.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AccountNumberViewDelegate <NSObject>

-(void)accountNumberViewDelegate;

@end
@interface SettingController : UITableViewController
@property(assign) id<AccountNumberViewDelegate> delegate;

@end
