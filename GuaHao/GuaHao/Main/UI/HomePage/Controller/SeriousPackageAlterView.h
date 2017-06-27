//
//  SeriousPackageAlterView.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/3.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageVO.h"

typedef void(^SelctAction)(BOOL result);
@interface SeriousPackageAlterView : UIView
@property (nonatomic, copy) SelctAction MyAction;
-(void)selectImmediately:(SelctAction)action;
-(void)layoutSubviewWithVO:(PackageVO *)vo;

@end
