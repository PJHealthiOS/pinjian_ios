//
//  InformationCommentCell.m
//  GuaHao
//
//  Created by qiye on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationCommentCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "UIViewBorders.h"
#import <QuartzCore/QuartzCore.h>
#import "InformationSencondCell.h"
#import "CommentFloorVO.h"

@implementation InformationCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _icon = [[UIImageView alloc]init];
    [self addSubview:_icon];
    _labName = [[UILabel alloc]init];
    _labName.font = [UIFont systemFontOfSize:12];
    [self addSubview:_labName];
    _labDate = [[UILabel alloc]init];
    _labDate.font = [UIFont systemFontOfSize:9];
    _labDate.textColor = [UIColor grayColor];
    [self addSubview:_labDate];
    _labContent = [[UILabel alloc]init];
    _labContent.font = [UIFont systemFontOfSize:12];
    _labContent.numberOfLines = 0;
    [self addSubview:_labContent];
    
    _msgIcon = [[UIImageView alloc]init];
    _msgIcon.image = [UIImage imageNamed:@"information_msg.png"];
    [self addSubview:_msgIcon];
    _labMsg = [[UILabel alloc]init];
    _labMsg.font = [UIFont systemFontOfSize:11];
    _labMsg.textColor = [UIColor grayColor];
    [self addSubview:_labMsg];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[InformationSencondCell class] forCellReuseIdentifier:@"InformationSencondCell"];
    [self addSubview:self.tableView];
    self.tableView.scrollEnabled =NO;
    [self addBottomBorderWithHeightX: 1.0 siteX:66.0 andColor:[Utils lineGray]];
    [self fitSize];
    
    UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msgClick:)];
    [_msgIcon setUserInteractionEnabled:YES];
    [_msgIcon addGestureRecognizer:tapGuesture1];
}

-(void) msgClick:(UITapGestureRecognizer *) tap{
    NSLog(@"msg click");
    if(_myblock){
        if(_commentVO.creatorId==nil)return;
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setObject:@"2" forKey:@"type"];
        [dic setObject:_commentVO.id forKey:@"topCommentId"];
        [dic setObject:_commentVO.creatorId forKey:@"replyToUserId"];
        [dic setObject:_commentVO.creatorName forKey:@"creatorName"];
        CommentFloorVO * vo = [CommentFloorVO new];
        vo.creatorName = [DataManager getInstance].user.nickName;
        vo.replyToName = _commentVO.creatorName;
        NSMutableArray * arr;
        arr = _commentVO.childComments?[NSMutableArray arrayWithArray:_commentVO.childComments]:[NSMutableArray new];
        [arr addObject:vo];
        _commentVO.childComments = [NSArray arrayWithArray:arr];
        _myblock(dic,_commentVO);
    }
}

-(float) getCellHeight{
    return 150;
}

-(void)fitSize
{
    __weak typeof (self) weakSelf = self;
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(27);
        make.left.mas_offset(17);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        weakSelf.icon.layer.masksToBounds = YES;
        weakSelf.icon.layer.cornerRadius = 17;
    }];
    [_labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(66);
        make.top.mas_offset(27);
    }];
    
    [_labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(66);
        make.right.mas_offset(-10);
        make.top.mas_offset(46);
    }];
    [_labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labContent.mas_bottom).offset(8);
        make.left.mas_offset(66);
    }];
    
    
    [_msgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-50);
        make.top.equalTo(weakSelf.labContent.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    [_labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labContent.mas_bottom).offset(8);
        make.right.equalTo(weakSelf.msgIcon).offset(6);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labDate.mas_bottom).offset(6);
        make.left.mas_offset(66);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-5);
        
    }];
}

-(void) setCell:(CommentVO *) vo
{
    _commentVO = vo;
    [ _icon sd_setImageWithURL: [NSURL URLWithString:vo.avatar] placeholderImage:[UIImage imageNamed:@"user_icon.png"]];
    _labName.text = vo.creatorName;
    _labDate.text = [Utils formateStrToMD:vo.replyTime];
    _labContent.text = vo.content;
    _floors = vo.childComments;
    _labMsg.text = vo.replyCount.stringValue;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_floors){
        return _floors.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    InformationSencondCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InformationSencondCell"];
    if(_floors){
        [cell setCell:_floors[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_floors){
        CommentFloorVO * vo = _floors[indexPath.row];
        return vo.cellHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_floors){
        CommentFloorVO * vo = _floors[indexPath.row];
        if(_myblock){
            if(vo.creatorId==nil)return;
            NSMutableDictionary * dic = [NSMutableDictionary new];
            [dic setObject:@"2" forKey:@"type"];
            [dic setObject:_commentVO.id forKey:@"topCommentId"];
            [dic setObject:vo.creatorId forKey:@"replyToUserId"];
            [dic setObject:vo.creatorName forKey:@"creatorName"];
            
            CommentFloorVO * vo2 = [CommentFloorVO new];
            vo2.creatorName = [DataManager getInstance].user.nickName;
            vo2.replyToName = vo.creatorName;
            NSMutableArray * arr;
            arr = _commentVO.childComments?[NSMutableArray arrayWithArray:_commentVO.childComments]:[NSMutableArray new];
            [arr addObject:vo2];
            _commentVO.childComments = [NSArray arrayWithArray:arr];
            _myblock(dic,_commentVO);
        }
        
    }
}
@end
