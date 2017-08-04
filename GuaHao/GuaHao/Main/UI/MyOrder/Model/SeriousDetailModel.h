//
//  SeriousDetailModel.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface SeriousDetailModel : NSObject
@property(strong) NSNumber * id;
@property(copy) NSString * doctorName;
@property(copy) NSString * avatar;
@property(copy) NSString * grade;
@property(copy) NSString * hospitalName;
@property(copy) NSString * departmentName;
@end
