//
//  ChooseHospitalcell.m
//  GuaHao
//
//  Created by 123456 on 16/1/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertSweepCell.h"
#import "SweepVO.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"

@implementation ExpertSweepCell{
    SweepVO* hosVO;
    __weak IBOutlet UILabel *labType;
    __weak IBOutlet UILabel *labNo;
    __weak IBOutlet UILabel *labHospital;
    __weak IBOutlet UILabel *labDepartment;
    __weak IBOutlet UILabel *labDate;
    __weak IBOutlet UILabel *labResultDate;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCell:(SweepVO*) vo{
    hosVO = vo;
    [self initCell:vo];
}

-(void)initCell:(SweepVO*) vo{
    labNo.text = [NSString stringWithFormat:@"-预约编号 %@",vo.serialNo];
    labType.text = vo.outpatientType;
    labHospital.text = vo.hospitalName;
    labDepartment.text = vo.departmentName;
    labDate.text = vo.visitDate;
    labResultDate.text = vo.imgUploadDate;
}

@end
