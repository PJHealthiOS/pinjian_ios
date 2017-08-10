//
//  GHAcceptDetailViewController.h
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptVO.h"

@class AcceptOrderVO;
@interface GHAcceptDetailViewController : UIViewController
@property (strong,nonatomic)AcceptVO *order;
@property (strong,nonatomic)AcceptOrderVO *acceptVO;
@property BOOL isSweep;
@property (nonatomic, assign) BOOL isNormal;
@property (nonatomic, copy) NSString *serialNo;

@end
