//
//  GHWXPay.m
//  GuaHao
//
//  Created by PJYL on 2018/1/23.
//  Copyright © 2018年 pinjian. All rights reserved.
//

#import "GHWXPay.h"

@implementation GHWXPay
/**
 *  微信支付
 */
+ (void)goToWXPayAndReViewOrderSN:(NSString *)orderSN money:(NSNumber *)money{
    if (![WXApi isWXAppInstalled]) {
//        [RSProgressHUD showErrorWithStatus:@"您未安装微信客户端"];
        return;
    };
    
    PayReq *request = [[PayReq alloc]init];
    
    
    
    
    [WXApi sendReq:request];

}



@end
