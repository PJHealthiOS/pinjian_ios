//
//  GHEmptyView.h
//  GuaHao
//
//  Created by 123456 on 16/8/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHEmptyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

+ (instancetype)emptyView;
- (void)setShowContent:(NSString *)content;
@end
