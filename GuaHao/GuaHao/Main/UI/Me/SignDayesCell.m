//
//  SignDayesCell.m
//  GuaHao
//
//  Created by 123456 on 16/6/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SignDayesCell.h"
#import "ServerManger.h"
#import "DataManager.h"
#import "UIViewController+Toast.h"

@implementation SignDayesCell{
    PointVO * pointVO;
    LogsVO * logesVO;
}
-(void)setCell:(LogsVO*)vo{
    logesVO = vo;
    _timeLab.text = vo.operateDate;
    _detailsLab.text = vo.comments;
    if (vo.type.intValue == 1) {
        _numberLab.textColor = [UIColor colorWithRed:53.0f/255.0f green:206.0f /255.0f blue:128.0f/255.0f alpha:1.0f];
        _numberLab.text = [NSString stringWithFormat:@"+%@",vo.changeValue];
    }else if (vo.type.intValue == 2){
        _numberLab.textColor = [UIColor colorWithRed:241.0f/255.0f green:185.0f /255.0f blue:114.0f/255.0f alpha:1.0f];
        _numberLab.text = vo.changeValue;
    }else if (vo.type.intValue == 0){
        _numberLab.textColor = [UIColor colorWithRed:53.0f/255.0f green:206.0f /255.0f blue:128.0f/255.0f alpha:1.0f];
        _numberLab.text = vo.changeValue;

    }else{
        _numberLab.textColor = [UIColor colorWithRed:53.0f/255.0f green:206.0f /255.0f blue:128.0f/255.0f alpha:1.0f];
        _numberLab.text = vo.changeValue;
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
