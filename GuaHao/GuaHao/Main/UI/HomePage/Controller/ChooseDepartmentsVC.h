//
//  ChooseDepartmentsVC.h
//  GuaHao
//
//  Created by 123456 on 16/1/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalVO.h"

@class DepartmentVO;

typedef void(^BlockDepartmentChoose)(DepartmentVO*);


@interface ChooseDepartmentsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) BlockDepartmentChoose onBlockDepartment;
@property (nonatomic) HospitalVO *hospital;
@property (nonatomic) PopBackType popBackType;
@property (nonatomic) BOOL isChildren;
@property (nonatomic) int isOppointment;

-(void)setDepartmentVO:(HospitalVO*)vo;

@end
