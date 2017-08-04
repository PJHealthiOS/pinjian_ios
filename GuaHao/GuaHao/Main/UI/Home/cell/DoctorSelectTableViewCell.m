//
//  DoctorSelectTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/4/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DoctorSelectTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIViewBorders.h"
#import "Utils.h"

@implementation DoctorSelectTableViewCell{
    
    __weak IBOutlet UILabel *labNum;
    __weak IBOutlet UILabel *labHospital;
    __weak IBOutlet UILabel *labDesc;
    __weak IBOutlet UILabel *labName;
    __weak IBOutlet UIImageView *iconImage;
    DoctorVO* curVO;
    __weak IBOutlet UIButton *btnType;
    __weak IBOutlet UILabel *labDepartment;
    __weak IBOutlet UILabel *labState;
}

- (void)awakeFromNib {
    [iconImage roundView];
    [self addTopBorderWithHeight:6.0 andColor:[Utils bgGray]];
    [self addBottomBorderWithHeight:1.0 andColor:[Utils lineGray]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setCell:(DoctorVO*) vo
{
    curVO = vo;
    labName.attributedText = [Utils attributeString:@[vo.name,[NSString stringWithFormat:@"   %@",vo.grade]] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
    if(vo.desc){
        labDesc.attributedText = [Utils attributeString:@[@"擅长 ",vo.desc] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13], NSForegroundColorAttributeName:[UIColor blackColor]},@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12], NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
    }

    labHospital.text = vo.hospitalName;
    labNum.text = [NSString stringWithFormat:@"接诊量 %@",vo.outpatientCount];
    labDepartment.text = vo.departmentName;
    [ iconImage sd_setImageWithURL: [NSURL URLWithString:vo.img]];
    
    UIFont * tfont = [UIFont systemFontOfSize:13];
    CGSize textSize = [vo.hospitalName boundingRectWithSize:CGSizeMake(220, 26) options:NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil].size;
    labHospital.width = ceil(textSize.width);
    labHospital.x = labDepartment.x;
    btnType.x = CGRectGetMaxX(labHospital.frame)+3;
    btnType.hidden = !vo.is3AG;
}

@end
