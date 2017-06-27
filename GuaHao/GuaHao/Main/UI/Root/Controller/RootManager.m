//
//  RootManager.m
//  GuaHao
//
//  Created by qiye on 16/1/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "RootManager.h"
#import "GHTabBarController.h"
#import "GHNewFeatureController.h"
#import "ServerManger.h"
#import "VersionVO.h"

#define GHVersionKey @"version"

@implementation RootManager

+ (void)chooseRootViewController:(UIWindow *)window
{
    NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:@"pjgh"];
    if ([value isEqualToString:@"1"]) {
        GHTabBarController *tabBarVc = [[GHTabBarController alloc] init];
        // 切换根控制器:可以直接把之前的根控制器清空
        window.rootViewController = tabBarVc;
    }else{
        // 进入新特性界面
        // 如果有新特性，进入新特性界面
        [[NSUserDefaults standardUserDefaults] setObject:@"021" forKey:@"cityId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"上海市" forKey:@"cityName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pjgh"];
        GHNewFeatureController *vc = [[GHNewFeatureController alloc] init];
        window.rootViewController = vc;
    }
}
@end
