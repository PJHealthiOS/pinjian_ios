//
//  ArticeHomeVO.m
//  GuaHao
//
//  Created by qiye on 16/10/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ArticeHomeVO.h"
#import "CategoryVO.h"

@implementation ArticeHomeVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"categories" : @"CategoryVO",
             @"articles" : @"ArticleListVO"
             };
}

-(NSArray *)getCategories
{
    NSMutableArray * arr = [NSMutableArray new];
    if(self.categories){
        for(int i = 0 ; i<self.categories.count;i++ ){
            CategoryVO * vo = self.categories[i];
            [arr addObject:vo.name];
        }
        return arr;
    }
    return nil;
}
@end
