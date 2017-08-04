//
//  TakeOrderTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/2/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DealOrderTableViewCell.h"
#import "OrderVO.h"
#import "Utils.h"

@implementation DealOrderTableViewCell{
    
    __weak IBOutlet UILabel * idLab;
    __weak IBOutlet UILabel * typeLab;
    __weak IBOutlet UILabel * hospitalLab;
    __weak IBOutlet UILabel * nameLab;
    __weak IBOutlet UILabel * ageLab;
    __weak IBOutlet UILabel * dateLab;
    __weak IBOutlet UILabel * priceLab;
                    AcceptVO * curVO;
    __weak IBOutlet UILabel *departmentLab;
    __weak IBOutlet UILabel *doctorLab;
    __weak IBOutlet UILabel *labDistance;
    __weak IBOutlet UIButton *btnState;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onRecept:(id)sender {
    if (_delegate) {
        [_delegate takeOrderComplete:curVO];
    }
}

-(void)setOrder:(AcceptVO*) vo
{
    curVO = vo;
    idLab.text = vo.serialNo;
    hospitalLab.text = vo.hospitalName;
    labDistance.text = @"";
//    if([vo.status isEqualToString:@"上传凭证"]){
//        labDistance.text = vo.hospitalDistance;
//    }
//    ageLab.text = vo.patientBirthday;
    departmentLab.text = vo.departmentName;
    nameLab.text = [NSString stringWithFormat:@"%@  (%@)",vo.patientName,vo.patientSex];
    dateLab.text = vo.visitDate;
//    priceLab.text = [NSString stringWithFormat:@"%@  元",vo.price];
//    doctorLab.text = vo.doctorName?vo.doctorName:@"无";
//    
//    typeLab.text = vo.outpatientType;
    [btnState setTitle:vo.status forState:UIControlStateNormal];
   
}

@end
