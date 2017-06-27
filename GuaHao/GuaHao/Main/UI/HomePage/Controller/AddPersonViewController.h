//
//  AddPersonViewController.h
//  GuaHao
//
//  Created by 123456 on 16/8/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"

@protocol AddPatientDelegate <NSObject>
-(void) addComplete:(PatientVO*)vo;

@end
@interface AddPersonViewController : UIViewController
@property (assign) id<AddPatientDelegate> delegate;
@property (nonatomic) NSUInteger openType;
@property (nonatomic) BOOL isChild;
@end
