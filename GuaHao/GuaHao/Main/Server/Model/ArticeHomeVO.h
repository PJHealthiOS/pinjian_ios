//
//  ArticeHomeVO.h
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ArticeHomeVO : NSObject

@property(strong) NSArray * categories;
@property(strong) NSArray * articles;

-(NSArray *)getCategories;
@end
