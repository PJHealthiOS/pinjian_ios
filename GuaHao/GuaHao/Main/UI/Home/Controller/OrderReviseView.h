//
//  OrderSureView.h
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"
@protocol OrderReviseDelegate <NSObject>
-(void)orderReviseDelegate:(PatientVO*) vo;
@end

@interface OrderReviseView : UIView

@property(assign) id<OrderReviseDelegate> delegate;
-(void)setPatient:(PatientVO*) _patient;

@end
