//
//  TakeOrderTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/2/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "TakeOrderTableViewCell.h"
#import "OrderVO.h"
#import "Utils.h"
#import "UILabel+DownTime.h"
#import "ServerManger.h"

@implementation TakeOrderTableViewCell{
    
    __weak IBOutlet UILabel * idLab;
    __weak IBOutlet UILabel * typeLab;
    __weak IBOutlet UILabel * hospitalLab;
    __weak IBOutlet UILabel * nameLab;
    __weak IBOutlet UILabel * descLab;
    __weak IBOutlet UILabel * dateLab;
    __weak IBOutlet UILabel * priceLab;
                    AcceptVO * curVO;
    __weak IBOutlet UILabel *departmentLab;
    __weak IBOutlet UILabel *doctorLab;
    __weak IBOutlet UILabel *labDistance;
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
//    labDistance.text = vo.hospitalDistance;

    if(vo.remainingTime){
        if(vo.remainingTime.intValue < 0){
            descLab.text = @"";
        }else{
            NSString* curTime = [Utils getCurrentSecond];
            int pass = curTime.intValue - [ServerManger getInstance].acceptTime.intValue;
            NSNumber * time = [NSNumber numberWithInt:vo.remainingTime.intValue - pass];
            [descLab startTime:@"" second:time type:[NSNumber numberWithInt:3]];
        }

    }else{
        [descLab stopTime];
        descLab.text = @"";
    }
    departmentLab.text = vo.departmentName;
    nameLab.text = vo.patientName;
    dateLab.text = vo.visitDate;
//    priceLab.text = [NSString stringWithFormat:@"%@  元",vo.price];
//    doctorLab.text = vo.doctorName?vo.doctorName:@"无";
    
//    typeLab.text = vo.outpatientType;
   
}

@end
