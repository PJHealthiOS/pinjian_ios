//
//  TakeOrderTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/2/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CompleteOrderTableViewCell.h"
#import "OrderVO.h"
#import "Utils.h"

@implementation CompleteOrderTableViewCell{
    
    __weak IBOutlet UILabel * idLab;
    __weak IBOutlet UILabel * typeLab;
    __weak IBOutlet UILabel * hospitalLab;
    __weak IBOutlet UILabel * dateLab;
                    AcceptVO * curVO;
    __weak IBOutlet UILabel *departmentLab;
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
    
}

-(void)setOrder:(AcceptVO*) vo
{
    curVO = vo;
    idLab.text = vo.serialNo;
    hospitalLab.text = vo.hospitalName;
//    labDistance.text = vo.hospitalDistance;
    departmentLab.text = vo.departmentName;
    dateLab.text = vo.visitDate;
//    typeLab.text = vo.outpatientType;
    [btnState setTitle:vo.statusCn forState:UIControlStateNormal];
}

@end
