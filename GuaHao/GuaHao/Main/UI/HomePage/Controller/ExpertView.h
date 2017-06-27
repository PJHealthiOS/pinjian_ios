//
//  ExpertView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/1.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorVO.h"
typedef void(^LongPressAction)(DoctorVO *doctor);

@interface ExpertView : UIView
@property (assign, nonatomic)BOOL close;
@property (nonatomic, copy)LongPressAction myAction;
-(void)deleteExpertAction:(LongPressAction)action;
-(void)setCell:(DoctorVO *)doctor;
@end
