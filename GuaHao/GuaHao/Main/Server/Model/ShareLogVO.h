//
//  ShareLogVO.h
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ShareLogVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * money;
@property(strong) NSNumber * status;
@property(strong) NSString * desc;
@property(strong) NSString * name;
@property(strong) NSString * statusCn;
@property(strong) NSString * createDate;
@property BOOL withdrawal;
@end
