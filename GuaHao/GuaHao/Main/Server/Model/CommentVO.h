//
//  CommentVO.h
//  GuaHao
//
//  Created by qiye on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface CommentVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSNumber * creatorId;
@property(strong) NSNumber * floor;
@property(strong) NSNumber * praiseCount;
@property(strong) NSNumber * replyCount;

@property(strong) NSString * avatar;
@property(strong) NSString * creatorName;
@property(strong) NSString * replyTime;
@property(strong) NSString * content;

@property(strong) NSArray * childComments;

@property(nonatomic) float cellHeight;
@property(nonatomic) float cellH;

+(float) commentHeight:(NSString*) text length:(float) length size:(int) size;
-(void) secondaryHeight;

@end
