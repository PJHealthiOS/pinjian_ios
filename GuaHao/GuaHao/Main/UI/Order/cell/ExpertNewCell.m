//
//  MyOrderCell.m
//  GuaHao
//
//  Created by qiye on 16/1/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertNewCell.h"
#import "ExpertOrderVO.h"
#import "Utils.h"

@implementation ExpertNewCell{

    __weak IBOutlet UILabel * labNO;
    __weak IBOutlet UILabel * labState;
    __weak IBOutlet UILabel * labHospital;
    __weak IBOutlet UILabel * ladDepartment;
    __weak IBOutlet UILabel * labDoctor;
    ExpertOrderVO * curVO;
    __weak IBOutlet UILabel * labDistance;
    __weak IBOutlet UILabel * labPatient;
    __weak IBOutlet UILabel * labDate;
    __weak IBOutlet UIImageView *imgState;
}

-(void) setOrder:(ExpertOrderVO*) order
{
    labNO.text = order.serialNo;
    labState.text = order.statusCn;
    labHospital.text = order.hospitalName;
    ladDepartment.text = order.departmentName;
    labDoctor.text = order.doctorName;
    labDistance.text = order.hospitalDistance;
    labPatient.text = [NSString stringWithFormat:@"%@ (%@)",order.patientName,order.patientSex];
    labDate.text = order.visitDate;
    [imgState setImage:[UIImage imageNamed:order.orderStatus.intValue == 1?@"order_expert_cell_green_image.png":@"order_expert_cell_gray_bg.png"]];
}

@end
