//
//  HomeVO.h
//  GuaHao
//
//  Created by qiye on 16/9/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface HomeVO : NSObject
@property(strong) NSArray * banners;//轮播
@property(strong) NSArray * sysRollMsgs;///滚动
@property(strong) NSArray * assessments;///评测
@property(strong) NSArray * featuredDepts;///特色科室
@property(strong) NSArray * articles;///文章
@property(strong) NSArray * regionCodes;///城市数组
@property(strong) NSNumber * unreadMsgNum;
@property(strong) NSString * appDownLoadUrl;
@end
