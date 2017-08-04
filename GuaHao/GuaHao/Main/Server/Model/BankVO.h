//
//  BankVO.h
//  GuaHao
//
//  Created by qiye on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface BankVO : NSObject
@property(strong) NSString * bankName;
@property(strong) NSString * cardNo;
@property(strong) NSString * createDate;
@property(strong) NSString * serialNo;
@property(strong) NSString * statusCn;
@property(strong) NSNumber * amount;
@property(strong) NSArray * statusLogs;

-(NSString*)getBankNameAndCard;
@end
