//
//  CommentFloorVO.h
//  GuaHao
//
//  Created by qiye on 16/10/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface CommentFloorVO : NSObject

@property(strong) NSNumber * creatorId;

@property(strong) NSString * creatorName;
@property(strong) NSString * replyToName;
@property(strong) NSString * replyTime;
@property(strong) NSString * content;

@property(nonatomic) float cellHeight;

@end
