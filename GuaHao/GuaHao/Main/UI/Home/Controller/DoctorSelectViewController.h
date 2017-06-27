//
//  DoctorSelectViewController.h
//  GuaHao
//
//  Created by qiye on 16/4/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalVO.h"
#import "DepartmentVO.h"

@interface DoctorSelectViewController : UIViewController
@property (nonatomic) HospitalVO *hospital;
@property (nonatomic) DepartmentVO *department;
@property (nonatomic) NSInteger orderType;

@end
