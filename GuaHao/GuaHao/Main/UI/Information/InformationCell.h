//
//  InformationCell.h
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListVO.h"
@interface InformationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labContent;

@property (nonatomic, strong) UIImageView *eyeIcon;
@property (nonatomic, strong) UILabel *labEye;
@property (nonatomic, strong) UIImageView *goodIcon;
@property (nonatomic, strong) UILabel *labGood;

-(void)setCell:(ArticleListVO*)vo;
@end
