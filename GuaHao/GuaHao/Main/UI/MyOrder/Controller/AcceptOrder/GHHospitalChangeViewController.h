//
//  GHHospitalChangeViewController.h
//  GuaHao
//
//  Created by PJYL on 16/9/9.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalVO.h"
typedef void(^HospitalSelectBlock)(HospitalVO *vo);


@interface GHHospitalChangeViewController : UIViewController
@property (nonatomic,copy)HospitalSelectBlock myBlock;
-(void)hospitalSelect:(HospitalSelectBlock)block;
@end
