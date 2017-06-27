//
//  MessageTableCell.m
//  GuaHao
//
//  Created by qiye on 16/10/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MessageTableCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "UIViewBorders.h"
#import "Message3VO.h"

@implementation MessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)initView{
    _icon = [[UIImageView alloc]init];
    [self addSubview:_icon];
    _labTitle = [[UILabel alloc]init];
    _labTitle.font = [UIFont systemFontOfSize:15];
    [self addSubview:_labTitle];
    _labDate = [[UILabel alloc]init];
    _labDate.font = [UIFont systemFontOfSize:12];
    _labDate.textColor = [UIColor grayColor];
    [self addSubview:_labDate];
    _labContent = [[UILabel alloc]init];
    _labContent.font = [UIFont systemFontOfSize:13];
    _labContent.textColor = [UIColor grayColor];
    [self addSubview:_labContent];

    _redIcon = [[UIImageView alloc]init];
    _redIcon.image = [UIImage imageNamed:@"message_red.png"];
    [_icon addSubview:_redIcon];
    
    _labNum = [[UILabel alloc]init];
    _labNum.font = [UIFont systemFontOfSize:9];
    _labNum.textColor = [UIColor whiteColor];
    [_redIcon addSubview:_labNum];
    
    __weak typeof (self) weakSelf = self;
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(13);
        make.left.mas_offset(11);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_redIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(3);
        make.right.mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [_labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.redIcon);
    }];
    
    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(72);
        make.top.mas_offset(19);
    }];
    [_labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(19);
        make.right.mas_offset(-20);
    }];
    [_labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(72);
        make.right.mas_offset(-10);
        make.top.mas_offset(42);
    }];
    if(self.grayLine){
        [self.grayLine removeFromSuperview];
    }
    self.grayLine = [self addBottomBorderWithHeightX:1.0 siteX:72 andColor:[Utils lineGray]];
}

-(void)addFullLine
{
    self.grayLine = [self addBottomBorderWithHeight:1.0 andColor:[Utils lineGray]];
}

-(void) setCell:(Message3VO *) vo
{
    [ _icon sd_setImageWithURL: [NSURL URLWithString:vo.icon] placeholderImage:[UIImage imageNamed:@"message_exaple.png"]];
    _labTitle.text = vo.title;
    if(vo.unreadNum.intValue==0){
        _labNum.text = @"";
        _redIcon.hidden = YES;
    }else{
        _labNum.text = vo.unreadNum.stringValue;
        _redIcon.hidden = NO;
    }
    _labDate.text = [Utils formateStrToMD:vo.recentDate];
    _labContent.text = vo.remark.length > 0 ? vo.remark:@"暂无描述";
}
@end
