//
//  SpecialPayViewController.h
//  GuaHao
//
//  Created by PJYL on 2017/7/19.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialPayViewController : UIViewController
@property(nonatomic) NSNumber * orderID;
@property(nonatomic) PayType payType;
@property(nonatomic) BOOL isExpert;
@property(nonatomic, assign)BOOL isAccompany;
@end
