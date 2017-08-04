//
//  HealthManagerReportCell.h
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthManagerReportModel.h"

typedef void(^DetailClickAction)(BOOL result);
@interface HealthManagerReportCell : UITableViewCell
@property (copy,nonatomic)DetailClickAction myAction;

-(void)clickAction:(DetailClickAction)action;
-(void)layoutSubviewsWith:(HealthManagerReportModel *)model;
@end
