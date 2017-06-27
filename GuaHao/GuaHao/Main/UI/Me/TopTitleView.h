//
//  TopTitleView.h
//  GuaHao
//
//  Created by 123456 on 16/6/27.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol topTitleViewDelegate <NSObject>
-(void)setTopTitleViewDelegate:(int) type;
@end

@interface TopTitleView : UIView
@property(assign) id<topTitleViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end
