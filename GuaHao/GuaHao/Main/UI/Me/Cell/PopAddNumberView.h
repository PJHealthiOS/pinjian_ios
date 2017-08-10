//
//  PopAddNumberView.h
//  GuaHao
//
//  Created by 123456 on 16/6/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopAddNumberViewDelegate <NSObject>
-(void)setPopAddNumberViewDelegate:(int) type;
@end

@interface PopAddNumberView : UIView

@property(assign) id<PopAddNumberViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *addNumberF;

@end
