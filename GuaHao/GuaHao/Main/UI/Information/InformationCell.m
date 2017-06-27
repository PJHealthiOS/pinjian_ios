//
//  InformationCell.m
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "UIViewBorders.h"

@implementation InformationCell

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
    _labTitle = [[UILabel alloc]init];
    _labTitle.font = [UIFont systemFontOfSize:15];
    [self addSubview:_labTitle];
    _labDate = [[UILabel alloc]init];
    _labDate.font = [UIFont systemFontOfSize:11];
    _labDate.textColor = [UIColor grayColor];
    [self addSubview:_labDate];
    _labContent = [[UILabel alloc]init];
    _labContent.font = [UIFont systemFontOfSize:13];
    _labContent.numberOfLines = 2;
    _labContent.textColor = [UIColor grayColor];
    [self addSubview:_labContent];
    
    _eyeIcon = [[UIImageView alloc]init];
    _eyeIcon.image = [UIImage imageNamed:@"homepage_eye.png"];
    [self addSubview:_eyeIcon];
    _labEye = [[UILabel alloc]init];
    _labEye.font = [UIFont systemFontOfSize:11];
    _labEye.textColor = [UIColor grayColor];
    [self addSubview:_labEye];
    
    _goodIcon = [[UIImageView alloc]init];
    _goodIcon.image = [UIImage imageNamed:@"homepage_click.png"];
    [self addSubview:_goodIcon];
    _labGood = [[UILabel alloc]init];
    _labGood.font = [UIFont systemFontOfSize:11];
    _labGood.textColor = [UIColor grayColor];
    [self addSubview:_labGood];
    
    __weak typeof (self) weakSelf = self;
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(22);
        make.left.mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(106, 66));
    }];
    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(133);
        make.right.mas_offset(-2);
        make.top.mas_offset(22);
    }];
    [_labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-16);
        make.left.mas_offset(133);
    }];
    [_labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(133);
        make.right.mas_offset(-10);
        make.top.mas_offset(44);
    }];
    [self addTopBorderWithHeight:5.0 andColor:[Utils lineGray]];
    
    [_goodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-50);
        make.bottom.mas_offset(-16);
        make.size.mas_equalTo(CGSizeMake(12, 10));
    }];
    
    [_labGood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodIcon).offset(13);
        make.bottom.mas_offset(-14);
    }];
    
    [_eyeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-100);
        make.bottom.mas_offset(-16);
        make.size.mas_equalTo(CGSizeMake(12, 10));
    }];
    
    [_labEye mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.eyeIcon).offset(13);
        make.bottom.mas_offset(-14);
    }];
}

-(void)setCell:(ArticleListVO*)vo
{
    [ _icon sd_setImageWithURL: [NSURL URLWithString:vo.coverUrl]];
    _labTitle.text = vo.title;
    _labDate.text = vo.updateAt;
    _labContent.text = vo.desc;
    _labEye.text = vo.viewCount?vo.viewCount.stringValue:@"0";
    _labGood.text = vo.praiseCount?vo.praiseCount.stringValue:@"0";
}
@end
