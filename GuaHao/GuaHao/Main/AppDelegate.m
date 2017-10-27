//
//  AppDelegate.m
//  GuaHao
//
//  Created by qiye on 16/1/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ServerManger.h"
#import "RootManager.h"
#import "EMSDK.h"
#import "EaseUI.h"
#import "XHLaunchAd.h"
#import "AppVersionVO.h"
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate{
    NSTimer  * time;
    BOOL     isOpen;
    AppVersionVO  *versionVO;
    NSString  * musicName;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    isOpen = YES;
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:@"pjgh"];
    [RootManager chooseRootViewController:self.window];
    [ServerManger getInstance].serverURL = @HOST;
    

    // 显示窗口
    [self.window makeKeyAndVisible];
    #pragma mark - 向高德地图注册
     [AMapServices sharedServices].apiKey = @"ed4b0c770646026dacce863d9b2aa4b2";

    #pragma mark - 向极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
#pragma mark - 向微信注册
    //向微信注册
    [WXApi registerApp:@"wx696fa79565c46811" withDescription:@"pjgh"];
    [ShareSDK registerApp:@"10daf2d424989"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"791196924"
                                           appSecret:@"25db4ff84f35dae94c5a244ddcee9fdd"
                                         redirectUri:@"http://www.pjhealth.com.cn:8080/AppDownload.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx696fa79565c46811"
                                       appSecret:@"ea16e78fac44a4ae56030663b2a6352c"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105139103"
                                      appKey:@"i2vPN6RzJtG2NUn4"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    
#pragma mark - 短信
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
#pragma mark - 友盟
    UMConfigInstance.appKey = @"56cefadae0f55a3e05000eeb";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"pinjian#pjgh"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:@"pinjian#pjgh"
                                       apnsCertName:@"istore_dev"
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    [[DataManager getInstance] getToken];
    NSLog(@"id --- ===%@",[DataManager getInstance].user.id);
    //要注视 XXXXXXX

//    [ServerManger getInstance].serverURL =  @"http://192.168.1.172:8080/";///孟立测试rbd665  pgd606
//    [ServerManger getInstance].serverURL =  @"http://192.168.1.168:8080/";//段超本地
//    [ServerManger getInstance].serverURL =  @"http://139.196.220.224:8090/";///测试
    [[ServerManger getInstance] getAppVersion:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    versionVO = [AppVersionVO mj_objectWithKeyValues:data[@"object"]];
                    [ServerManger getInstance].serverURL = versionVO.version.serverUrl;
                    //要注视 XXXXXXX
                    //要注视 XXXXXXX

//                        [ServerManger getInstance].serverURL =  @"http://192.168.1.172:8080/";///孟立测试
//                       [ServerManger getInstance].serverURL =  @"http://192.168.1.168:8080/";//段超本地
//                    [ServerManger getInstance].serverURL =  @"http://139.196.220.224:8090/";///测试
                    
//                    if (![APP_VERSION isEqualToString:version.version.versionId] &&version.version.isForceUpdate) {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示" message:@"获取最新号源信息，立刻更新！" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"再等等...", nil];
//                        [alertView show];
//                    }
                    
//                    [self updateApp:versionVO.version.versionId];
                    
                   
                    
                    
                    
                    
                    if(versionVO.advImgUrl&&versionVO.advImgUrl.length>0&&value&&[value isEqualToString:@"1"]){
                        
                        //1.显示启动广告
                        [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
                            
                            //未检测到广告数据,启动页停留时间,默认3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
                            //launchAd.noDataDuration = 4;
                            
                            //广告图片地址
                            NSString *imgUrl = versionVO.advImgUrl;
                            //广告停留时间
                            NSInteger duration = 6;
                            //广告点击跳转链接
                            NSString *openUrl = versionVO.advLinkUrl;
                            
                            //2.设置广告数据
                            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                                
                                //异步加载图片完成回调,若需根据图片尺寸,刷新广告frame,可在这里操作
                                //launchAd.adFrame = ...;
                                
                            } click:^{
                                if(openUrl&&openUrl.length>0){
                                    //广告点击事件
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                                }

                            }];
                            
                        } showFinish:^{
                            
                            [RootManager chooseRootViewController:self.window];
                            
                        }];
                    }
                }
                
            }else{
                [ServerManger getInstance].serverURL = @HOST;
            }
        }
    }];
    
    return YES;
}
-(void)updateApp:(NSString *)versionId{
    if (versionVO.version.isForceUpdate) {
        if (![APP_VERSION isEqualToString:versionId] ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示" message:@"获取最新号源信息，立刻更新！" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        if (![APP_VERSION isEqualToString:versionId] ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示" message:@"获取最新号源信息，立刻更新！" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"再等等...", nil];
            [alertView show];
        }
    }
    
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){///左边按钮
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionVO.version.downloadUrl]];
        [self updateApp:versionVO.version.versionId];

    }else if (buttonIndex == 1){
        
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService setBadge:0];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PingppCallBack" object:error];
        
    }];
    if(result){
        return YES;
    }
    BOOL wechatBool = [WXApi handleOpenURL:url delegate:self];
    if(wechatBool){
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL wechatBool = [WXApi handleOpenURL:url delegate:self];
    if(wechatBool){
        return YES;
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL wechatBool = [WXApi handleOpenURL:url delegate:self];
    if(wechatBool){
        return YES;
    }
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PingppCallBack" object:error];
        
    }];
    return canHandleURL;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    //    [ProgressHUD showSuccess:[NSString stringWithFormat:@"登录成功：%@",resp.code]];
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *rep = (SendAuthReq*)resp;
        NSLog(@"%@",rep.code);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WxLoginBack" object:rep.code];
        //        [self otherLogin:rep.code type:2];
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        
    }
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
     NSLog(@"ios6一下收到通知111:%@", [self logDic:userInfo]);
    [JPUSHService handleRemoteNotification:userInfo];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserMSGUpdate" object:nil userInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"----------->5555555555<--------%@-",userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7以上--收到通知222:%@", [self logDic:userInfo]);
///跳转到消息页
    
//    NSLog(@"收到通知222:%@", [self logDic:userInfo]);

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserMSGUpdate" object:nil userInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




-(void)startPlaySystemSound
{
    if (isOpen) {
        isOpen = NO;
        time = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
}

-(void)scrollTimer
{
    isOpen = YES;
    [time invalidate];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music2" ofType:@"aac"];
    NSLog(@"xxxx:%@",musicName);
    //组装并播放音效
    if(([musicName isEqualToString:@"neworder"]||[musicName isEqualToString:@"music"])&&path){
        SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }else{
        AudioServicesPlaySystemSound (1007);
    }
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserMSGUpdate" object:nil userInfo:userInfo];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    NSNumber *type = [userInfo objectForKey:@"type"];
    if (type.intValue != 100) {
        int number = [DataManager getInstance].messageVC.tabBarItem.badgeValue.intValue + 1;
        if (number > 0) {
            [DataManager getInstance].messageVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",number];
        }else{
            [DataManager getInstance].messageVC.tabBarItem.badgeValue = nil;
        }
        [[DataManager getInstance].messageVC loadNewData];
//        [DataManager getInstance].messageVC.tabBarController.selectedIndex = 1;
    }
    
    
}
///程序关闭后通过点击推送通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
                                                                                                                                                                                                                                                                                                                     
        [JPUSHService handleRemoteNotification:userInfo];
       NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
    
     [DataManager getInstance].messageVC.tabBarController.selectedIndex = 1;
}
#endif

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    if(dic[@"extras"]&&dic[@"extras"][@"sound"]){
        musicName = dic[@"extras"][@"sound"];
    }else if(dic[@"aps"]&&dic[@"aps"][@"sound"]){
        musicName = dic[@"aps"][@"sound"];
    }else{
        musicName = @"";
    }
    [self startPlaySystemSound];
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
@end
