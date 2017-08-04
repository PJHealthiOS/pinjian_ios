//
//  BankVO.m
//  GuaHao
//
//  Created by qiye on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "BankVO.h"

@implementation BankVO
+ (NSDictionary *)objectClassInArray{
    return @{
             @"statusLogs" : @"BankStatusVO"
             };
}

-(NSString*)getBankNameAndCard
{
    NSString * STR = [_cardNo substringWithRange:NSMakeRange(_cardNo.length-4,4)];
    return [NSString stringWithFormat:@"%@(%@)",_bankName,STR];
}
@end
