//
//  ExpertOrderDiscountAlterView.h
//  GuaHao
//
//  Created by PJYL on 2017/7/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlterSureAction)(BOOL result);



@interface ExpertOrderDiscountAlterView : UIView

@property (copy, nonatomic)AlterSureAction myAction;
-(void)clickAction:(AlterSureAction)action;
-(instancetype)initWithFrame:(CGRect)frame descStr:(NSString *)descStr;

@end
