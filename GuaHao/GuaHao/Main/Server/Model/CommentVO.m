//
//  CommentVO.m
//  GuaHao
//
//  Created by qiye on 16/10/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CommentVO.h"
#import "Utils.h"
#import "CommentFloorVO.h"

@implementation CommentVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"childComments" : @"CommentFloorVO"
             };
}

+(float) commentHeight:(NSString*) text length:(float) length size:(int) size;
{
    if(text==nil || text.length == 0){
        return 0;
    }
    CGRect tmpRect2 = [text boundingRectWithSize:CGSizeMake(length, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:size],NSFontAttributeName, nil] context:nil];
    CGFloat contentH2 = ceil(tmpRect2.size.height);

    return contentH2;
}

-(void) secondaryHeight
{
    self.cellH = self.cellHeight = [CommentVO commentHeight:self.content length:SCREEN_WIDTH-76 size:12] + 80;
    
    if(_childComments&&_childComments.count>0){
        for(int i=0;i<_childComments.count;i++){
            CommentFloorVO * vo = _childComments[i];
            NSString * content = [NSString stringWithFormat:@"%@ 回复%@ :%@",vo.creatorName,vo.replyToName,vo.content];
            vo.cellHeight = [CommentVO commentHeight:content length:SCREEN_WIDTH-92 size:11] + 4;
            self.cellHeight = self.cellHeight + vo.cellHeight;
        }
    }
}

@end
