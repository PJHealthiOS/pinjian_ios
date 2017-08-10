//
//  SeriousExpertInfoViewController.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/3.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertVO.h"
#import "DoctorVO.h"
typedef void(^SureExpertAction)(DoctorVO *doctorVO);
@interface SeriousExpertInfoViewController : UIViewController
@property (strong, nonatomic)DoctorVO *doctorVO;
@property (copy, nonatomic)SureExpertAction myAction;
-(void)sureExpert:(SureExpertAction)action;
@end
