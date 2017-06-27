//
//  BankStatusVO.h
//  GuaHao
//
//  Created by qiye on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface BankStatusVO : NSObject
@property(strong) NSString * operateDate;
@property(strong) NSString * desc;
@property BOOL isChecked;
@end
