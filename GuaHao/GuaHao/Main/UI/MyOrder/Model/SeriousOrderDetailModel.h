//
//  SeriousOrderDetailModel.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "OrderListVO.h"
#import "StatusLogVO.h"
#import "SeriousDetailModel.h"
@interface SeriousOrderDetailModel : NSObject
@property(strong) NSArray * illnessImgs;
@property(strong) NSArray * statusLogs;
@property(copy) NSString * remarkedDoctor;
@property(copy) NSString * mobile;
@property(copy) NSString * cardID;
@property(copy) NSString * operationWishDate;
@property(copy) NSString * serialNo;
@property(copy) NSString * packageName;
@property(copy) NSNumber * patientCardType;
@property(strong) NSArray * doctors;
@property(copy) NSString * illnessDesc;
@property(copy) NSString * patient;
@property(copy) NSNumber *id;
@property(copy) NSNumber *orderStatus;
@property(copy) NSNumber *evaluated;
@end
