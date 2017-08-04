//
//  InformationContentCell.h
//  GuaHao
//
//  Created by qiye on 16/9/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationVO.h"

typedef void(^InformationCellBlock)(float);

@interface InformationContentCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic,copy) InformationCellBlock myBlock;

@property (nonatomic) float cellHeight;

-(void)setCell:(InformationVO *) vo;
@end
