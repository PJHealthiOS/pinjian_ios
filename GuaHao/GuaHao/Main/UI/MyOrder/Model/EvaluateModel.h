//
//  EvaluateModel.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/22.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface EvaluateModel : NSObject
@property(copy) NSString * comment;
@property(copy) NSNumber * qualityEvaluation;
@property(copy) NSNumber * mannerEvaluation;
@property(copy) NSNumber * timeEvaluation;
@property(copy) NSNumber * totalEvaluation;
@end
