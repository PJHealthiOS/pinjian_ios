//
//  ChooseHospitalVC.h
//  GuaHao
//
//  Created by 123456 on 16/1/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HospitalVO;
@class DepartmentVO;

typedef void(^BlockHospitalChoose)(HospitalVO*,DepartmentVO*);

@interface ChooseHospitalVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) BlockHospitalChoose onBlockHospital;
@property (nonatomic, assign) BOOL isAccompany;
@property (nonatomic) BOOL isChildren;
@property (nonatomic) int isOppointment;
@property (nonatomic, assign) BOOL isCommon;
@property (nonatomic, assign) BOOL isPj;
@end
