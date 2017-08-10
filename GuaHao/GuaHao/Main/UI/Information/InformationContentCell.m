//
//  InformationContentCell.m
//  GuaHao
//
//  Created by qiye on 16/9/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationContentCell.h"
#import "Masonry.h"

@implementation InformationContentCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat height = [self.webView sizeThatFits:CGSizeZero].height;
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height2 = [height_str intValue];
    _cellHeight = height2;
    if(_myBlock){
        _myBlock(_cellHeight);
    }
    NSLog(@"cellHeight:%f",_cellHeight);
}

#pragma make 创建子控件
- (void) createView {
    if(!_webView){
        _cellHeight = 500.0f;
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        [self addSubview:_webView];
        _webView.scrollView.scrollEnabled = NO;
        __weak typeof (self) weakSelf = self;
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf);
        }];
    }
}

-(void)setCell:(InformationVO *) vo{
    [self createView];
    NSString *mUrl   = [NSString stringWithFormat:@"%@?token=%@",vo.linkUrl,[DataManager getInstance].user.token] ;
    NSLog(@"111111111111---mUrl----%@",mUrl);
    NSURL *url = [NSURL URLWithString:mUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
