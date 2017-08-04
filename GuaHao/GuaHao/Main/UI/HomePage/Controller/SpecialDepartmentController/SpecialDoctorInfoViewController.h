//
//  SpecialDoctorInfoViewController.h
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialDoctorInfoViewController : UIViewController
@property(copy,nonatomic)NSNumber *doctorId;
@property(strong,nonatomic)PatientVO *patientVO;
@property(nonatomic) NSInteger quickType;
@end
