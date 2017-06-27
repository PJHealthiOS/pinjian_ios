//
//  HealthManagerReportModel.h
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface HealthManagerReportModel : NSObject
@property (nonatomic, copy)NSString *createDate;
@property (nonatomic, copy)NSString *reportUrl;
@property (nonatomic, copy)NSNumber *id;
@end
