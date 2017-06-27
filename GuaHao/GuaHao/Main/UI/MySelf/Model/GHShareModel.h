//
//  GHShareModel.h
//  GuaHao
//
//  Created by PJYL on 16/10/18.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
@interface GHShareModel : NSObject
@property (nonatomic, copy)NSString *appShareLink4Wx;
@property (nonatomic, copy)NSString *appShareLink4Other;
@property (nonatomic, copy)NSString *wxShareLink;
@property (nonatomic, copy)NSString *qrcodeUrl;
@property (nonatomic, copy)NSString *invitationCode;
@property (nonatomic, copy)NSNumber *totalNumOfPeople;
@property (nonatomic, copy)NSNumber *totalNumOfCoupons;
@property (nonatomic, copy)NSString *resultDesc;
@property (nonatomic, copy)NSString *descLink;
@property (nonatomic, copy)NSString *docLink;
@end
