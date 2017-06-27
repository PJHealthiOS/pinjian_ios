//
//  SeriousListModel.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface SeriousListModel : NSObject
@property(strong) NSNumber * id;
@property(copy) NSString * serialNo;
@property(copy) NSString * processStatus;
@property(copy) NSString * packageName;
@property(copy) NSString * patient;
@property(copy) NSString * mobile;
@property(strong) NSNumber * orderStatus;
@property(strong) NSNumber * statusevaluated;
@property(strong) NSNumber *evaluated;
@end
