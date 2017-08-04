//
//  MemberAlterView.h
//  GuaHao
//
//  Created by PJYL on 2017/7/24.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SureAction)(BOOL result);
@interface MemberAlterView : UIView
@property (copy, nonatomic)SureAction myAction;
-(void)clickShopAction:(SureAction)action;

-(instancetype)initWithFrame:(CGRect)frame memberLevel:(int)memberLevel discountRate:(float)discountRate curAvailableTimes:(int)curAvailableTimes;
@end
