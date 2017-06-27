//
//  AccompanyOrderViewController.h
//  GuaHao
//
//  Created by PJYL on 16/10/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"
#import "HospitalVO.h"


@interface AccompanyOrderViewController : UIViewController
@property (nonatomic,assign)NSInteger accompanyType;
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic) PatientVO *patientVO;
@property (nonatomic) HospitalVO *hospital;

@property (nonatomic,assign)int accompanyPrice;
@end
