//
//  InformationSencondCell.h
//  GuaHao
//
//  Created by qiye on 16/10/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFloorVO.h"

@interface InformationSencondCell : UITableViewCell
@property (nonatomic, strong) UILabel *labTitle;

-(void)setCell:(CommentFloorVO*)vo;
@end
