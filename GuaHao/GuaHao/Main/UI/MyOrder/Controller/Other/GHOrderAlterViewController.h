//
//  GHOrderAlterViewController.h
//  GuaHao
//
//  Created by 123456 on 16/8/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChangeOrderBlock)(BOOL change);
@interface GHOrderAlterViewController : UIViewController
@property (nonatomic, copy)ChangeOrderBlock myBlock;
-(void)changeOrderBlock:(ChangeOrderBlock)block;
@end
