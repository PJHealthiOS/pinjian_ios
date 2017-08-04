//
//  InformationVO.h
//  GuaHao
//
//  Created by qiye on 16/9/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "CommentVO.h"

@interface InformationVO : NSObject
@property(strong) NSNumber * id;
@property(strong) NSString * source;
@property(strong) NSString * title;
@property(strong) NSString * author;
@property(strong) NSString * createAt;
@property(strong) NSString * linkUrl;

@property(strong) NSArray * comments;

@property(nonatomic) BOOL  praised;

@property(nonatomic) float cellHeight;

-(void)caculateHeight;
@end
