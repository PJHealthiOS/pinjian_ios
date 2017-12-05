//
//  UITableView+MJ.h
//  GuaHao
//
//  Created by qiye on 16/8/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MJType) {
    MJTypeNone,          // 没有格式
    MJTypePJGifELME,         // 饿了么样式
    MJTypePJGifTaoBao,  // 淘宝样式
    MJTypePJGifJD   // 京东样式
};


@interface UITableView (MJ)
-(void)initMJ:(id)target type:(MJType) type newAction:(SEL) newSel moreAction:(SEL) moreSel;
@end
