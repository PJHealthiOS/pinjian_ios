//
//  InformationSencondCell.m
//  GuaHao
//
//  Created by qiye on 16/10/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationSencondCell.h"
#import "Masonry.h"
#import "Utils.h"

@implementation InformationSencondCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self initView];
    }
    return self;
}

-(void)initView{
    _labTitle = [[UILabel alloc]init];
    _labTitle.font = [UIFont systemFontOfSize:11];
    [self addSubview:_labTitle];
    _labTitle.numberOfLines = 0;
    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(6);
        make.right.mas_offset(-2);
        make.top.mas_offset(4);
    }];
}

-(void)setCell:(CommentFloorVO*)vo
{
    if(vo.creatorName == nil ||vo.replyToName== nil || vo.content == nil) return;
    _labTitle.attributedText = [Utils attributeString:@[vo.creatorName,@" 回复 ",vo.replyToName,@": ",vo.content] attributes:@[@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor grayColor]},
  @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor blackColor]},
  @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor grayColor]},
  @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor blackColor]},
  @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11], NSForegroundColorAttributeName:[UIColor blackColor]}]];
}
@end
