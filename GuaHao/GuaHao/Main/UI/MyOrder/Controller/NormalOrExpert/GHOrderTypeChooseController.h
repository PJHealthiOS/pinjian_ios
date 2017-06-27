//
//  GHOrderTypeChooseController.h
//  GuaHao
//
//  Created by qiye on 16/9/9.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OrderTypeChooseBlock)(BOOL change);
@interface GHOrderTypeChooseController : UIViewController
@property (nonatomic, copy)OrderTypeChooseBlock myBlock;
@property (nonatomic, copy)NSNumber *openStatus;
@end
