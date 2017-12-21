//
//  AFAppDotNetAPIClient.h
//  GuaHao
//
//  Created by PJYL on 2017/12/21.
//  Copyright © 2017年 pinjian. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
