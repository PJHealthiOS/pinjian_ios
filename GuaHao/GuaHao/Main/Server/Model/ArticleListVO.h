//
//  ArticleListVO.h
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ArticleListVO : NSObject

@property(strong) NSNumber * id;
@property(strong) NSNumber * viewCount;
@property(strong) NSNumber * praiseCount;

@property(strong) NSString * title;
@property(strong) NSString * desc;
@property(strong) NSString * updateAt;
@property(strong) NSString * coverUrl;

@property BOOL hot;
@end
