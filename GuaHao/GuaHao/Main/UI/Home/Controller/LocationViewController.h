//
//  LocationViewController.h
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteVO.h"

@protocol TakeOrderViewDelegate <NSObject>
-(void) takeOrderViewDelegate:(SiteVO*) vo;
@end

@interface LocationViewController : UIView
@property(assign) id<TakeOrderViewDelegate> delegate;
@end
