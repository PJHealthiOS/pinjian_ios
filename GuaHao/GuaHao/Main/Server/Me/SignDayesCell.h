//
//  SignDayesCell.h
//  GuaHao
//
//  Created by 123456 on 16/6/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointVO.h"
#import "LogsVO.h"

@interface SignDayesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * timeLab;
@property (weak, nonatomic) IBOutlet UILabel * numberLab;
@property (weak, nonatomic) IBOutlet UILabel * detailsLab;

-(void)setCell:(LogsVO*)vo;

@end
