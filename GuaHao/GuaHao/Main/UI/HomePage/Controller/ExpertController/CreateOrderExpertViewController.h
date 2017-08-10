//
//  CreateOrderExpertViewController.h
//  GuaHao
//
//  Created by PJYL on 16/8/31.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertVO.h"
#import "DayVO.h"
#import "PatientVO.h"
@interface CreateOrderExpertViewController : UIViewController
@property (nonatomic) ExpertVO * expertVO;
@property (nonatomic) DayVO * dayVO;
@property (nonatomic) PatientVO * patientVO;
@property (nonatomic) NSInteger quickType;

@end
