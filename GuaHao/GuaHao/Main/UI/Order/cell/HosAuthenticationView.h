//
//  OrderSureView.h
//  GuaHao
//
//  Created by 123456 on 16/2/17.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"

@interface HosAuthenticationView : UIView
@property (nonatomic) PatientVO * patient;
@property (nonatomic) NSString * hosName;

typedef void(^BlockAuthentication)(int);
@property (nonatomic, copy) BlockAuthentication blockAuthentication;
-(void)setTitle;
@end
