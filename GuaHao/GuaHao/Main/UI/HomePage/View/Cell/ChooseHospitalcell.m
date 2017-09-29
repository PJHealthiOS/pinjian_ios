//
//  ChooseHospitalcell.m
//  GuaHao
//
//  Created by PJYL on 2017/9/22.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "ChooseHospitalcell.h"

#import "UIImageView+WebCache.h"
#import "MapViewController.h"

@implementation ChooseHospitalcell{
    HospitalVO* hosVO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setCell:(HospitalVO*) vo{
    hosVO = vo;
    [self initCell:vo];
}

-(void)initCell:(HospitalVO*) vo{
    [ _cityImg sd_setImageWithURL: [NSURL URLWithString:vo.image]];
    _hospitName.text = vo.name;
    _className.text = vo.expert?vo.expert:@"全科";
    _place.text = vo.address;
    [self.distanceButton setTitle:vo.distance forState:UIControlStateNormal];
    _labNum.text = [NSString stringWithFormat:@"接诊量 %@",vo.outpatientCount];
    _img3ga.hidden = (vo.level.intValue == 1)?NO:YES;
}

- (IBAction)onMap:(id)sender {
    if(hosVO.address.length>0){
        self.action(hosVO);
    }
}
-(void)clickLocationAction:(LocationClickAction)action{
    self.action = action;
}

@end

