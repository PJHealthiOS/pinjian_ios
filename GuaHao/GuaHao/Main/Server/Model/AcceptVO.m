//
//  AcceptVO.m
//  GuaHao
//
//  Created by qiye on 16/5/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AcceptVO.h"

@implementation AcceptVO

-(NSString *)typeCN
{
    return _type.intValue==1?@"普通号":@"专家号";
}

@end
