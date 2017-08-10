//
//  OrderSureView.h
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"
@protocol AuthenticationDelegate <NSObject>
-(void)authenticationDelegate:(int) type;
@end
@interface AuthenticationView : UIView
@property(assign) id<AuthenticationDelegate> delegate;
@end
