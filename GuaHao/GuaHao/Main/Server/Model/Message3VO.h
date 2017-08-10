//
//  Message3VO.h
//  GuaHao
//
//  Created by qiye on 16/10/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface Message3VO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSNumber * unreadNum;
@property(strong) NSNumber * totalNum;

@property(strong) NSString * title;
@property(strong) NSString * remark;
@property(strong) NSString * icon;
@property(strong) NSString * recentDate;

@end
