//
//  UpMoneyFirVO.h
//  GuaHao
//
//  Created by 123456 on 16/4/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "UpMoneyVO.h"
@interface UpMoneyFirVO : NSObject
@property(strong) NSArray     * UpMone;
@property(strong) NSString    * banlance;
@property(strong) UpMoneyVO   * rechargePackages;

@end
