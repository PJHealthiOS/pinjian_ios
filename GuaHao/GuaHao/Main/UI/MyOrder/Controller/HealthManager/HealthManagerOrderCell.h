//
//  HealthManagerOrderCell.h
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthManagerOrderModel.h"

typedef void(^DetailClickAction)(BOOL result);
@interface HealthManagerOrderCell : UITableViewCell
@property (copy,nonatomic)DetailClickAction myAction;

-(void)clickAction:(DetailClickAction)action;
-(void)layoutSubviewsWith:(HealthManagerOrderModel *)modle;
@end
