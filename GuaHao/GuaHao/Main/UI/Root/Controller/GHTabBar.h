//
//  GHTabBar.h
//  GuaHao
//
//  Created by PJYL on 2016/12/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlusClickActionBlock)(BOOL result);
@interface GHTabBar : UITabBar
@property (nonatomic, copy)PlusClickActionBlock myBlock;
-(void)plusBtnClickAction:(PlusClickActionBlock)block;
@end
