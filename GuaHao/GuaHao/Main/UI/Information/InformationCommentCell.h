//
//  InformationCommentCell.h
//  GuaHao
//
//  Created by qiye on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentVO.h"
#import "CommentFloorVO.h"

typedef void (^CommentBlock)(NSMutableDictionary *comment,CommentVO *vo);

@interface InformationCommentCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *msgIcon;
@property (nonatomic, strong) UILabel *labMsg;

@property (nonatomic, strong) NSArray *floors;

@property (nonatomic,copy) CommentBlock myblock;

@property (nonatomic, strong) CommentVO *commentVO;

-(float) getCellHeight;
-(void) setCell:(CommentVO *) vo;

@end
