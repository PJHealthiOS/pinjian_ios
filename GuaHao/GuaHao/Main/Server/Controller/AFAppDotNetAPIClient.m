//
//  AFAppDotNetAPIClient.m
//  GuaHao
//
//  Created by PJYL on 2017/12/21.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient
+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化HTTP Client的base url，此处为@"https://api.app.net/"
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.pjhealth.com.cn/"]];
        // 设置HTTP Client的安全策略为AFSSLPinningModeNone
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}
@end
