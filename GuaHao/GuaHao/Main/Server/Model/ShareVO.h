//
//  ShareVO.h
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ShareVO : NSObject

@property(strong) NSNumber * totalGainMoney;
@property(strong) NSNumber * totalShareNum;
@property(strong) NSNumber * availableMoney;
@property(strong) NSString * rate;
@property(strong) NSString * invitationCode;
@property(strong) NSString * qrcodeUrl;

@property(strong) NSString * appShareLink4Wx;
@property(strong) NSString * appShareLink4Other;

@property(strong) NSArray * shareLogs;
@property(strong) NSArray * shareRules;
@property  BOOL hasUnfinishedWithdrawalLog;
@end
