//
//  MessageTableCell.h
//  GuaHao
//
//  Created by qiye on 16/10/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message3VO;

@interface MessageTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *redIcon;
@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labContent;

@property (nonatomic, strong) UIView *grayLine;

-(void) setCell:(Message3VO *) vo;
-(void)addFullLine;

@end
