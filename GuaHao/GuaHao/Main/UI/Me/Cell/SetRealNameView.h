//
//  SetRealNameView.h
//  GuaHao
//
//  Created by 123456 on 16/6/7.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SetRealNameViewDelegate <NSObject>
-(void)setRealNameViewDelegate:(int) type;
@end

@interface SetRealNameView : UIView

@property(assign) id<SetRealNameViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel * titleLab;

@end
