//
//  InformationVO.m
//  GuaHao
//
//  Created by qiye on 16/9/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "InformationVO.h"
#import "CommentVO.h"

@implementation InformationVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"comments" : @"CommentVO"
             };
}

-(void)caculateHeight
{
    if(_comments&&_comments.count>0){
        for(int i=0;i<_comments.count;i++){
            CommentVO * vo = _comments[i];
            [vo secondaryHeight];
        }
    }
}

@end
