//
//  HospitalMiniTableViewCell.m
//  GuaHao
//
//  Created by qiye on 16/6/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "HospitalMiniTableViewCell.h"
#import "UIViewBorders.h"
#import "Utils.h"
@implementation HospitalMiniTableViewCell{
    
    __weak IBOutlet UILabel *labHospital;
    __weak IBOutlet UIButton *btnType;
    __weak IBOutlet UILabel *labContent;
    NSArray * arr;
    __weak IBOutlet UILabel *labAll;
    __weak IBOutlet UILabel *labDistance;
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
        btnType.hidden = NO;
        labHospital.text = vo.name;
        labContent.text = [NSString stringWithFormat:@"就诊量: %@ ",vo.outpatientCount];
        labDistance.text = vo.distance;
        arr = @[@"  三特",@"  三甲",@"  三乙",@"  三丙",@"  二甲",@"  二乙",@"  二丙",@"  一甲",@"  一乙",@"  一丙"];
        [btnType setTitle:arr[vo.level.intValue] forState:UIControlStateNormal];
        UIFont * tfont = [UIFont systemFontOfSize:15];
        CGSize textSize = [vo.name boundingRectWithSize:CGSizeMake(240, 22) options:NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil].size;
//        [labHospital setFrame:CGRectMake(labHospital.frame.origin.x, labHospital.frame.origin.y, ceil(textSize.width)>self.width/1.5?self.width/1.5:ceil(textSize.width), ceil(textSize.height))];
        labHospital.width = textSize.width;
        btnType.x = CGRectGetMaxX(labHospital.frame)+2;
        labAll.text = @"";
    }else{
        btnType.hidden = YES;
        labHospital.text = @"";
        labContent.text = @"";
        labAll.text = @"所有医院";
    }
}

@end
