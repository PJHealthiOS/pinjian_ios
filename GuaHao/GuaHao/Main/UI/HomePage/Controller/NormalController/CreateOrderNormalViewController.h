//
//  CreateOrderNormalViewController.h
//  GuaHao
//
//  Created by 123456 on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalVO.h"
#import "DepartmentVO.h"
#import "PatientVO.h"

@interface CreateOrderNormalViewController : UIViewController
@property (nonatomic) HospitalVO *hospital;
@property (nonatomic) DepartmentVO *department;
@property (nonatomic) PatientVO *patientVO;
@property (nonatomic) NSInteger quickType;
@property (nonatomic) NSString* level;

@property (nonatomic) BOOL isChildren;
@property (nonatomic) BOOL isHomeCome;
@end
