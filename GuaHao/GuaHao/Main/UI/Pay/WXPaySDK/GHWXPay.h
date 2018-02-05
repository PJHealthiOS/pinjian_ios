//
//  GHWXPay.h
//  GuaHao
//
//  Created by PJYL on 2018/1/23.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHWXPay : NSObject
/**
 *  微信支付
 */
+ (void)goToWXPayAndReViewOrderSN:(NSString *)orderSN money:(NSNumber *)money;
@end
