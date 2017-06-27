//
//  HospitalMiniTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/6/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "HospitalTakeTableViewCell.h"
#import "UIViewBorders.h"
#import "Utils.h"
@implementation HospitalTakeTableViewCell{
    
    __weak IBOutlet UILabel *labHospital;
    __weak IBOutlet UILabel *labContent;
    NSArray * arr;
    __weak IBOutlet UILabel *labAll;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addBottomBorderWithHeight:1.0 andColor:RGBAlpha(210,210,210,1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setCell:(HospitalVO *) vo
{
    if(vo){
        labHospital.text = vo.name;
        labContent.text = [NSString stringWithFormat:@"%@",vo.distance];
        labAll.text = @"";
    }else{
        labHospital.text = @"";
        labContent.text = @"";
        labAll.text = @"所有医院";
    }
}

@end
