//
//  PatientCertificationVC.h
//  GuaHao
//
//  Created by 123456 on 16/6/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientVO.h"
typedef void(^CertificateInfoBlock) (BOOL result);
@protocol CertificationDelegate <NSObject>
-(void) addComplete:(PatientVO*)vo;

@end

@interface PatientCertificationVC : UIViewController

@property (assign) id<CertificationDelegate> delegate;
@property (nonatomic, copy)CertificateInfoBlock myBlock;

@property (nonatomic) PatientVO * patientVO;


@property (nonatomic) NSUInteger openType;
-(void)certificateAction:(CertificateInfoBlock)block;
@end

