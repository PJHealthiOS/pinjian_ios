//
//  PackageViewController.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageVO.h"

typedef void(^PackageSelectBlock)(PackageVO *selectVO);
@interface PackageViewController : UIViewController
@property (nonatomic, copy)PackageSelectBlock myBlock;
-(void)packgeSelectAction:(PackageSelectBlock)block;
@end
