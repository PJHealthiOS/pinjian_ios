//
//  CustomUIActionSheet.h
//  helpers
//
//  Created by fang xiang on 15/4/3.
//  Copyright (c) 2015年 fangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUIActionSheet : UIView

@property(assign)BOOL cannotDissmissSelf;


-(void) setActionView:(UIView *) view;

-(void) showInView:(UIView *) parentView;

-(void) dissmiss;

-(void) animationDidStop;
@end
