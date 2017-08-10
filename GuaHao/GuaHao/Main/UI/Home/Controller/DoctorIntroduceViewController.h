//
//  DoctorIntroduceViewController.h
//  GuaHao
//
//  Created by qiye on 16/4/18.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"

@interface DoctorIntroduceViewController : UIViewController
@property (nonatomic) NSNumber *doctorID;
@property (nonatomic) PatientVO * patientVO;
@property (nonatomic) NSInteger quickType;
@end
