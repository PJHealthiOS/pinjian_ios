//
//  PatientVO.m
//  GuaHao
//
//  Created by qiye on 16/1/29.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PatientVO.h"

@implementation PatientVO

-(NSString *) getStatus{
    NSString * str = @"";
    switch (_status.intValue) {
        case 0:
            str = @"未认证";
            break;
        case 1:
            str = @"待审核";
            break;
        case 2:
            str = @"已认证";
            break;
        case 3:
            str = @"认证失败";
            break;
        default:
            break;
    }
    return str;
}
@end
