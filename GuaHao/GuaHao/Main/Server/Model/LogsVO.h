//
//  LogsVO.h
//  GuaHao
//
//  Created by 123456 on 16/6/24.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface LogsVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * type;
@property(strong) NSString * changeValue;
@property(strong) NSString * operateDate;
@property(strong) NSString * comments;
@end
