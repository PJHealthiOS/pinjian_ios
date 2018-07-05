//
//  ServerManger.m
//  GuaHao
//
//  Created by qiye on 16/1/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ServerManger.h"
#import "DataManager.h"
#import "Utils.h"
#import "LoginViewController.h"
#import "UIDevice+FCUUID.h"
#import <CommonCrypto/CommonCrypto.h>
#import "AFAppDotNetAPIClient.h"
static ServerManger * instance;

@implementation ServerManger

+(ServerManger *) getInstance {
    
    if(instance == nil) {
        instance = [[ServerManger alloc] init];
    }
    
    return instance;
}
+ (AFSecurityPolicy*)customSecurityPolicy
{
    
    
    
    
    
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"pinjian" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
-(void) getHttp:(NSString *)URLString
     parameters:(id)parameters
        version:(NSString*)apt
    andCallback: (void (^)(id  data))callback
{
    NSLog(@"城市编码------------------%@",[DataManager getInstance].cityId);

    NSLog(@"URLString--token-%@--->>>%@",[DataManager getInstance].user.token ,URLString);
    AFAppDotNetAPIClient *manager = [AFAppDotNetAPIClient sharedClient];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//     [manager setSecurityPolicy:[ServerManger customSecurityPolicy]];
    
    if(apt){
        [manager.requestSerializer setValue:apt forHTTPHeaderField:@"apt-version"];
    }
    [manager.requestSerializer setValue:[DataManager getInstance].cityId forHTTPHeaderField:@"rc"];
    [manager.requestSerializer setValue:[DataManager getInstance].user.token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"client_type"];
    [manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"client_ver"];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *dateStr = [NSString stringWithFormat:@"%llu",recordTime];
    [manager.requestSerializer setValue:dateStr forHTTPHeaderField:@"timestamp"];
    
    NSString *token = [DataManager getInstance].user.token?[DataManager getInstance].user.token:@"";
    NSString *MD5Str = [NSString stringWithFormat:@"apt-version%@authorization%@timestamp%llu%@",apt,token,recordTime,@"900150983cd24fb0d6963f7d28e17f72"];
    NSString *urlFirst = [[URLString componentsSeparatedByString:@"?"] firstObject];
    NSString *urlMid = [urlFirst substringFromIndex:[ServerManger getInstance].serverURL.length-1];
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",urlMid,MD5Str];
    NSString *result = [self stringToMD5:finalStr];
    [manager.requestSerializer setValue:result forHTTPHeaderField:@"sign"];

    NSLog(@"finalStr---%@\nMD5Str---%@",finalStr,result);
    
    
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)responseObject;
//        NSLog(@"%ld",(long)responses.statusCode);
        NSLog(@"JSON: %@", responseObject);
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        
        
        
        //如果请求失败，先判断是不是token过期
        
        
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        //通讯协议状态码
        NSInteger statusCode = response.statusCode;
        NSLog(@"%ld",statusCode);
        if (statusCode == 401) {
            callback(@{@"code":@"-1011",@"msg":@"请重新登录！"});
                    [[DataManager getInstance] saveToken:nil];
                    UIViewController * result = [Utils topViewController:nil];
            LoginViewController * view = [GHViewControllerLoader LoginViewController];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
                    [result.navigationController  presentViewController:nav animated:YES completion:nil];
        }else{
            callback([self getErrorCode:error]);
        }
        
        
        
        
        
        
        
        
        
    }];
}

-(void) postHttp:(NSString *)URLString
     parameters:(id)parameters
        version:(NSString*)apt
    andCallback: (void (^)(id  data))callback
{
    NSLog(@"URLString------>>>%@",URLString);
    NSLog(@"城市编码------------------%@",[DataManager getInstance].cityId);
    AFAppDotNetAPIClient *manager = [AFAppDotNetAPIClient sharedClient];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//     [manager setSecurityPolicy:[ServerManger customSecurityPolicy]];
    
    /////////////////////////
    if(apt){
        [manager.requestSerializer setValue:apt forHTTPHeaderField:@"apt-version"];
    }
    [manager.requestSerializer setValue:[DataManager getInstance].cityId forHTTPHeaderField:@"rc"];

    [manager.requestSerializer setValue:[DataManager getInstance].user.token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"client_type"];
    [manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"client_ver"];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *dateStr = [NSString stringWithFormat:@"%llu",recordTime];
    [manager.requestSerializer setValue:dateStr forHTTPHeaderField:@"timestamp"];
    NSString *token = [DataManager getInstance].user.token?[DataManager getInstance].user.token:@"";
    NSString *MD5Str = [NSString stringWithFormat:@"apt-version%@authorization%@timestamp%llu%@",apt,token,recordTime,@"900150983cd24fb0d6963f7d28e17f72"];
    NSString *urlFirst = [[URLString componentsSeparatedByString:@"?"] firstObject];
    NSString *urlMid = [urlFirst substringFromIndex:[ServerManger getInstance].serverURL.length-1];
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",urlMid,MD5Str];
    NSString *result = [self stringToMD5:finalStr];
    [manager.requestSerializer setValue:result forHTTPHeaderField:@"sign"];
    
    /////////////////////
    
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        //如果请求失败，先判断是不是token过期
        
        
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        //通讯协议状态码
        NSInteger statusCode = response.statusCode;
        NSLog(@"%ld",statusCode);
        if (statusCode == 401) {
            callback(@{@"code":@"-1011",@"msg":@"请重新登录！"});
            [[DataManager getInstance] saveToken:nil];
            UIViewController * result = [Utils topViewController:nil];
            LoginViewController * view = [GHViewControllerLoader LoginViewController];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
            [result.navigationController  presentViewController:nav animated:YES completion:nil];
        }else{
            callback([self getErrorCode:error]);
        }

    }];
}

-(void) putHttp:(NSString *)URLString
      parameters:(id)parameters
         version:(NSString*)apt
     andCallback: (void (^)(id  data))callback
{
    NSLog(@"URLString------>>>%@",URLString);
    NSLog(@"城市编码------------------%@",[DataManager getInstance].cityId);
AFAppDotNetAPIClient *manager = [AFAppDotNetAPIClient sharedClient];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//     [manager setSecurityPolicy:[ServerManger customSecurityPolicy]];
    if(apt){
        [manager.requestSerializer setValue:apt forHTTPHeaderField:@"apt-version"];
    }
    [manager.requestSerializer setValue:[DataManager getInstance].cityId forHTTPHeaderField:@"rc"];
    [manager.requestSerializer setValue:[DataManager getInstance].user.token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"client_type"];
    [manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"client_ver"];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *dateStr = [NSString stringWithFormat:@"%llu",recordTime];
    [manager.requestSerializer setValue:dateStr forHTTPHeaderField:@"timestamp"];
    NSString *token = [DataManager getInstance].user.token?[DataManager getInstance].user.token:@"";
    NSString *MD5Str = [NSString stringWithFormat:@"apt-version%@authorization%@timestamp%llu%@",apt,token,recordTime,@"900150983cd24fb0d6963f7d28e17f72"];    NSString *urlFirst = [[URLString componentsSeparatedByString:@"?"] firstObject];
    NSString *urlMid = [urlFirst substringFromIndex:[ServerManger getInstance].serverURL.length-1];
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",urlMid,MD5Str];
    NSString *result = [self stringToMD5:finalStr];
    [manager.requestSerializer setValue:result forHTTPHeaderField:@"sign"];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        //如果请求失败，先判断是不是token过期
        
        
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        //通讯协议状态码
        NSInteger statusCode = response.statusCode;
        NSLog(@"%ld",statusCode);
        if (statusCode == 401) {
            callback(@{@"code":@"-1011",@"msg":@"请重新登录！"});
            [[DataManager getInstance] saveToken:nil];
            UIViewController * result = [Utils topViewController:nil];
            LoginViewController * view = [GHViewControllerLoader LoginViewController];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
            [result.navigationController  presentViewController:nav animated:YES completion:nil];
        }else{
            callback([self getErrorCode:error]);
        }

    }];
}

-(void) postHttpWithImage:(NSString *)URLString
     parameters:(id)parameters
         images:(NSMutableArray*)images
        version:(NSString*)apt
    andCallback: (void (^)(id  data))callback
{
    NSLog(@"URLString------>>>%@",URLString);
    NSLog(@"城市编码------------------%@",[DataManager getInstance].cityId);

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFAppDotNetAPIClient *manager = [AFAppDotNetAPIClient sharedClient];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//     [manager setSecurityPolicy:[ServerManger customSecurityPolicy]];
    if(apt){
        [manager.requestSerializer setValue:apt forHTTPHeaderField:@"apt-version"];
    }
    [manager.requestSerializer setValue:[DataManager getInstance].cityId forHTTPHeaderField:@"rc"];
    [manager.requestSerializer setValue:[DataManager getInstance].user.token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"client_type"];
    [manager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"client_ver"];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *dateStr = [NSString stringWithFormat:@"%llu",recordTime];
    [manager.requestSerializer setValue:dateStr forHTTPHeaderField:@"timestamp"];
    NSString *token = [DataManager getInstance].user.token?[DataManager getInstance].user.token:@"";
    NSString *MD5Str = [NSString stringWithFormat:@"apt-version%@authorization%@timestamp%llu%@",apt,token,recordTime,@"900150983cd24fb0d6963f7d28e17f72"];    NSString *urlFirst = [[URLString componentsSeparatedByString:@"?"] firstObject];
    NSString *urlMid = [urlFirst substringFromIndex:[ServerManger getInstance].serverURL.length-1];
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",urlMid,MD5Str];
    NSString *result = [self stringToMD5:finalStr];
    [manager.requestSerializer setValue:result forHTTPHeaderField:@"sign"];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        if(images&&images.count>0){
            for (int i=0; i<images.count; i++) {
                NSData *imageData = UIImageJPEGRepresentation(images[i][@"image"], 0.5);
                [formData appendPartWithFileData: imageData name:images[i][@"file"] fileName:images[i][@"name"] mimeType:@"image/jpeg"];
            }
        }else{
            NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"application/json; charset=UTF-8",@"Content-Type", @"form-data; name=\"registration\"",@"Content-Disposition", nil];
            NSData * da = [NSData new];
            [formData appendPartWithHeaders:headers body:da];
        }
    } progress:^(NSProgress * _Nonnull downloadProgress) {
         
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        callback(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //如果请求失败，先判断是不是token过期
        
        
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)operation.response;
        //通讯协议状态码
        NSInteger statusCode = response.statusCode;
        NSLog(@"%ld",statusCode);
        if (statusCode == 401) {
            callback(@{@"code":@"-1011",@"msg":@"请重新登录！"});
            [[DataManager getInstance] saveToken:nil];
            UIViewController * result = [Utils topViewController:nil];
            LoginViewController * view = [GHViewControllerLoader LoginViewController];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
            [result.navigationController  presentViewController:nav animated:YES completion:nil];
        }else{
            callback([self getErrorCode:error]);
        }

    }];
}

-(void) getSMSCode:(NSString *) phone andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@common/getVerifyCode?mobile=%@",[ServerManger getInstance].serverURL,phone]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) codeLogin:(NSString *) name code:(NSString *)pwd andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@user/loginByCode?mobile=%@&code=%@&deviceType=ios&deviceNo=%@",[ServerManger getInstance].serverURL,name,pwd,[UIDevice currentDevice].uuid];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) wxLogin:(NSString *)code andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@user/weixin?code=%@&isApp=1&deviceType=ios&deviceNo=%@",[ServerManger getInstance].serverURL,code,[UIDevice currentDevice].uuid];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) userRegister:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/register",[ServerManger getInstance].serverURL]];
    [self postHttp:URL.absoluteString parameters:dic version:nil andCallback:callback];
}

-(void) fixedPhoneNumber:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/bindMobile",[ServerManger getInstance].serverURL]];
    [self postHttp:URL.absoluteString parameters:dic version:@"3" andCallback:callback];
}

-(void) bindWX:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/bindMobile4Wx",[ServerManger getInstance].serverURL]];
    [self postHttp:URL.absoluteString parameters:dic version:@"3" andCallback:callback];
}

-(void) getPwd:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/changePassword",[ServerManger getInstance].serverURL]];
    [self postHttp:URL.absoluteString parameters:dic version:@"3" andCallback:callback];
}
////设置支付密码
-(void) setPayPassWord:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@account/setPayPwd?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) userLogin:(NSString *) name password:(NSString*)pwd andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/login?loginName=%@&password=%@&deviceType=ios&deviceNo=%@",[ServerManger getInstance].serverURL,name,pwd,[UIDevice currentDevice].uuid]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getPersonalCenterInfo: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/personalCenter",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///会员中心接口
-(void) getMemberCenterInfo: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@member/center",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}
-(void) createOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//提交爱心订单
-(void) createLoveOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@loveOrder?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:nil andCallback:callback];
}

//提交专家订单
-(void) createExpertOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order/createPjOrder?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//提交专家(new)订单
-(void) createExpertNewOrder:(NSDictionary *) dic imgs:(NSMutableArray*) imgs andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pjOrder?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *array = nil;
    if(imgs&&imgs.count>0){
        array = [NSMutableArray new];
        for(int i=0;i<imgs.count;i++){
            NSMutableDictionary * img1 = [NSMutableDictionary new];
            [img1 setObject:imgs[i] forKey:@"image"];
            [img1 setObject:@"imgs" forKey:@"file"];
            [img1 setObject:@"me" forKey:@"name"];
            [array addObject:img1];
        }
    }
    
    [self postHttpWithImage:urlString parameters:nil images:array version:@"3" andCallback:callback];
}

-(void) feedback:(int) type msg:(NSString*) msg andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@feedback?content=%@&osVersion=1.2.0",[ServerManger getInstance].serverURL,msg];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
// 我的挂号
-(void) getOrders:(int) type size:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/myRegistrationOrders?type=%d&pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,type,size,page]];
    if (longitude.length >0) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/myRegistrationOrders?type=%d&pageSize=%d&pageNo=%d&longitude=%@&latitude=%@",[ServerManger getInstance].serverURL,type,size,page,longitude,latitude]];
    }
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///陪诊列表
-(void) getAccompanyListOrderSize:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pzOrder/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"2" andCallback:callback];
}

// 我的特需号
-(void) getExpertOrders:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@pjOrder/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@&longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}
// 我的优惠券1.2.0
-(void) getCouponslistPageNo:(int)pageNo  andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@userCoupons/list?pageSize=10&pageNo=%d",[ServerManger getInstance].serverURL,pageNo]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///特需号优惠券
-(void) getSpecialCouponslistPageNo:(int)pageNo orderID:(NSString *)orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pjOrder/couponsList?pageSize=10&pageNo=%d&orderId=%@",[ServerManger getInstance].serverURL,pageNo,orderID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"4" andCallback:callback];
}
///普通号优惠券
-(void) getNormalCouponslistPageNo:(int)pageNo  andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/couponsList?pageSize=10&pageNo=%d",[ServerManger getInstance].serverURL,pageNo]];
    [self getHttp:URL.absoluteString parameters:nil version:@"4" andCallback:callback];
}
-(void) cancelRealnameAuth:(NSNumber*) patientID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@patient/%@/cancelRealnameAuth",[ServerManger getInstance].serverURL,patientID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getPatients:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@patient/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"4" andCallback:callback];
}
//增加就诊人
-(void) createPatient:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@patient?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
     urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getHospitals:(NSString*) msg isAccompany:(NSString *)serviceType size:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback: (void (^)(id  data))callback
{
    msg = msg.length>0 ? [NSString stringWithFormat:@"&keywords=%@",msg ]:@"";
    NSString * urlString = [NSString stringWithFormat:@"%@hospital/%@?pageSize=%d&pageNo=%d%@",[ServerManger getInstance].serverURL,serviceType,size,page,msg];
    if (longitude.length>0) {
        urlString = [NSString stringWithFormat:@"%@&longitude=%@&latitude=%@",urlString,longitude,latitude];
    }
    NSLog(@"urlString------urlString------->%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getHospitals:(NSString*) msg serviceType:(NSString *)serviceType oppointment:(int)oppointment size:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude orderBy:(NSInteger)orderBy cityId:(NSString *)cityId andCallback: (void (^)(id  data))callback
{


    NSMutableString *urlString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@hospital/%@?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,serviceType,size,page]];
    
    //关键字
    [urlString appendString:[NSString stringWithFormat:@"&keywords=%@",msg.length > 0 ? msg:@""]];
    //预约或挂号
    if (oppointment) {
        [urlString appendString:[NSString stringWithFormat:@"&oppointment=%d",oppointment]];
    }
    //排序方式
    [urlString appendString:[NSString stringWithFormat:@"&orderBy=%d",orderBy]];
    //经纬度
    if (longitude.length>0) {
        [urlString appendString:[NSString stringWithFormat:@"&longitude=%@&latitude=%@",longitude,latitude]];
    }
    //区县
    if (cityId) {
        [urlString appendString:[NSString stringWithFormat:@"&regionId=%@",cityId]];
    }
    [self getHttp:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil version:@"3" andCallback:callback];




}

//特需号 医院列表
-(void) getExpHospitals:(NSString*) msg size:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback: (void (^)(id  data))callback
{
    msg = msg.length>0 ? [NSString stringWithFormat:@"&keywords=%@",msg ]:@"";
    NSString * urlString = [NSString stringWithFormat:@"%@hospital/list4Pj?pageSize=%d&pageNo=%d%@",[ServerManger getInstance].serverURL,size,page,msg];
    if (longitude.length>0) {
        urlString = [NSString stringWithFormat:@"%@&longitude=%@&latitude=%@",urlString,longitude,latitude];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getNearByHospitals:(int) size page:(int) page longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@hospital/nearbyHospital?pageSize=%d&pageNo=%d&longitude=%@&latitude=%@",[ServerManger getInstance].serverURL,size,page,longitude,latitude];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
// 一级科室列表
-(void) getFirstDepartment:(NSNumber*) hosID oppointment:(int)oppointment  isChildEmergency:(BOOL)isChildEmergency andCallback:(void (^)(id  data))callback
{
    NSString * str = isChildEmergency?@"1":@"0";
    NSString * urlStr = [NSString stringWithFormat:@"%@department/firstGradeList4Normal?isChildEmergency=%@",[ServerManger getInstance].serverURL, str];
    if(hosID){
        urlStr = [NSString stringWithFormat:@"%@&hospitalId=%@",urlStr,hosID];
    }
    if (oppointment == 0 || oppointment == 1) {
        NSString *oppointmentStr = [NSString stringWithFormat:@"&visitType=%d",oppointment];
        urlStr = [urlStr stringByAppendingString:oppointmentStr];
    }
    NSLog(@"getFirstDepartment------urlString------->%@",urlStr);
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

-(void) getSecondDepartment:(NSNumber*) hosId oppointment:(int)oppointment departmentId:(NSNumber*) depId isChildEmergency:(BOOL)isChildEmergency andCallback:(void (^)(id  data))callback
{
    NSString * str = isChildEmergency?@"1":@"0";
    NSString * urlStr = [NSString stringWithFormat:@"%@department/secondGradeList4Normal?hospitalId=%@&departmentTypeId=%@&pageSize=20&isChildEmergency=%@",[ServerManger getInstance].serverURL,hosId,depId,str];
//    NSURL *URL = [NSURL URLWithString:urlStr];
    if (oppointment == 0 || oppointment == 1) {
        NSString *oppointmentStr = [NSString stringWithFormat:@"&visitType=%d",oppointment];
        urlStr = [urlStr stringByAppendingString:oppointmentStr];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

// 专家一级科室列表
-(void) getFirstExpDepartment:(NSNumber*) hosID andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@department/firstGradeList4Expert",[ServerManger getInstance].serverURL ];
    if(hosID){
        urlStr = [NSString stringWithFormat:@"%@?hospitalId=%@",urlStr,hosID];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

-(void) getSecondExpDepartment:(NSNumber*) hosId departmentId:(NSNumber*) depId andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@department/secondGradeList4Expert?hospitalId=%@&departmentTypeId=%@&pageSize=20",[ServerManger getInstance].serverURL,hosId,depId]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) verification:(NSDictionary *) dic me:(UIImage*) me front:(UIImage*) image opposite:(UIImage*) oppImage andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@user/submitVefifyInfo?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@[@{@"image":image,@"file":@"files",@"name":@"me"}]];
    [array addObject:@[@{@"image":image,@"file":@"files",@"name":@"front"}]];
    [array addObject:@[@{@"image":image,@"file":@"files",@"name":@"opposite"}]];
    NSMutableDictionary * img1 = [NSMutableDictionary new];
    [img1 setObject:me forKey:@"image"];
    [img1 setObject:@"files" forKey:@"file"];
    [img1 setObject:@"me" forKey:@"name"];
    [array addObject:img1];
    NSMutableDictionary * img2 = [NSMutableDictionary new];
    [img2 setObject:image forKey:@"image"];
    [img2 setObject:@"files" forKey:@"file"];
    [img2 setObject:@"front" forKey:@"name"];
    [array addObject:img2];
    NSMutableDictionary * img3 = [NSMutableDictionary new];
    [img3 setObject:oppImage forKey:@"image"];
    [img3 setObject:@"files" forKey:@"file"];
    [img3 setObject:@"opposite" forKey:@"name"];
    [array addObject:img3];
    [self postHttpWithImage:urlString parameters:nil images:array version:@"3" andCallback:callback];
}


-(void) verificationPatient:(NSNumber*) _id  front:(UIImage*) image opposite:(UIImage*) oppImage andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@patient/%@/submitRealnameAuth",[ServerManger getInstance].serverURL,_id];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * img1 = [NSMutableDictionary new];
    [img1 setObject:image forKey:@"image"];
    [img1 setObject:@"files" forKey:@"file"];
    [img1 setObject:@"front" forKey:@"name"];
    [array addObject:img1];
    NSMutableDictionary * img2 = [NSMutableDictionary new];
    [img2 setObject:oppImage forKey:@"image"];
    [img2 setObject:@"files" forKey:@"file"];
    [img2 setObject:@"opposite" forKey:@"name"];
    [array addObject:img2];
    [self postHttpWithImage:urlString parameters:nil images:array version:@"3" andCallback:callback];
}
//提交就诊人护照
-(void) passportPatient:(NSNumber*) _id  front:(UIImage*) image  andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@patient/%@/submitRealnameAuth",[ServerManger getInstance].serverURL,_id];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * img1 = [NSMutableDictionary new];
    [img1 setObject:image forKey:@"image"];
    [img1 setObject:@"files" forKey:@"file"];
    [img1 setObject:@"front" forKey:@"name"];
    [array addObject:img1];
    [self postHttpWithImage:urlString parameters:nil images:array version:@"3" andCallback:callback];
}


-(void) editPatient:(NSNumber*) _id patient:(NSDictionary*) dic andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@patient/%@",[ServerManger getInstance].serverURL,_id]];
    [self putHttp:URL.absoluteString parameters:dic version:@"3" andCallback:callback];
}

//编辑用户信息1.1.0
-(void) editUserView:(NSDictionary*) dic  andCallback:(void (^)(id  data))callback{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user",[ServerManger getInstance].serverURL]];
    [self putHttp:URL.absoluteString parameters:dic version:@"3" andCallback:callback];
}
//编辑用户信息1.2.0
-(void) editUser:(NSDictionary*) dic front:(UIImage*) image andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/update",[ServerManger getInstance].serverURL]];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * img1 = [NSMutableDictionary new];
    [img1 setObject:image forKey:@"image"];
    [img1 setObject:@"file" forKey:@"file"];
    [img1 setObject:@"front" forKey:@"name"];
    [array addObject:img1];
    [self postHttpWithImage:URL.absoluteString parameters:dic images:array version:@"3" andCallback:callback];
}
//编辑用户信息1.2.0
-(void) editUserr:(NSDictionary*) dic  andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/update",[ServerManger getInstance].serverURL]];
    [self postHttpWithImage:URL.absoluteString parameters:dic images:nil version:@"3" andCallback:callback];
}


//实名认证
-(void) realNameUser:(NSDictionary*) dic andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/realnameAuth",[ServerManger getInstance].serverURL]];
    [self putHttp:URL.absoluteString parameters:dic version:nil andCallback:callback];
}

-(void) waitingList:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/waitingList?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:nil andCallback:callback];
}

-(void) acceptOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/%@/accept",[ServerManger getInstance].serverURL,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///接单专家号
-(void) acceptExpertOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pjOrder/%@/submit",[ServerManger getInstance].serverURL,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
// 万家我的接单   企业/2b/pjorder/acceptedOrder/list 专员端接单列表

-(void) myAcceptedOrders:(int) size page:(int) page type:(NSInteger) type longitude:(NSString*)longitude latitude:(NSString*)latitude hospitalId:(NSString*)hospitalId andCallback: (void (^)(id  data))callback
{
    NSString * urlStr;
    NSString *version = @"3";
    if (type == 5) {//万家
        urlStr = [NSString stringWithFormat:@"%@order/acceptedOrders?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    }else if (type == 6) {//企业
        version = @"1";
        urlStr = [NSString stringWithFormat:@"%@2b/pjorder/acceptedOrder/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    }else{
       urlStr = [NSString stringWithFormat:@"%@order/myAcceptedOrders?pageSize=%d&pageNo=%d&type=%ld",[ServerManger getInstance].serverURL,size,page,(long)type];
    }
    
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@&longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    if (hospitalId && (type != 5 && type!= 6)) {
        urlStr = [NSString stringWithFormat:@"%@&hospitalId=%@",urlStr,hospitalId];
    }
    [self getHttp:urlStr parameters:nil version:version andCallback:callback];
}
// 取消订单----------------------------
-(void) cancelOrder:(NSNumber*) orderID andNormalType:(BOOL)orderType andCallback: (void (^)(id  data))callback
{
    NSString *typeStr = orderType ? @"order" : @"pjOrder";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/cancel",[ServerManger getInstance].serverURL,typeStr,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

// 取消专家订单
-(void) cancelExpertOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pjOrder/%@/cancel",[ServerManger getInstance].serverURL,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
// 取消陪诊订单
-(void) cancelAccompanyOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pzOrder/%@/cancel",[ServerManger getInstance].serverURL,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"2" andCallback:callback];
}
// 删除订单-----------------------------
-(void) deleteOrder:(NSNumber*) orderID andNormalType:(BOOL)orderType andCallback: (void (^)(id  data))callback
{
    NSString *typeStr = orderType ? @"order" : @"pjOrder";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/delete",[ServerManger getInstance].serverURL,typeStr,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///1.普通用户主动发起 2.普通接单员主动发起 在线排队查询的推送订单-----------------------------/pjOrder/pushMsg/{orderId}
-(void) inquireCurrentProgress:(NSNumber*) orderID fromType:(int)orderType andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/order/pushMsg/%@?type=%d",[ServerManger getInstance].serverURL,orderID,orderType]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///1.普通用户主动发起 2.普通接单员主动发起 在线排队查询的推送订单-----------------------------/pjOrder/pushMsg/{orderId}
-(void) expertInquireCurrentProgress:(NSNumber*) orderID fromType:(int)orderType andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pjOrder/pushMsg/%@?type=%d",[ServerManger getInstance].serverURL,orderID,orderType]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
// 删除专家订单
-(void) deleteExpertOrder:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pjOrder/%@/delete",[ServerManger getInstance].serverURL,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) bindHospital:(NSNumber*) hosID andCallback: (void (^)(id  data))callback
{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/bindHospital?hospitalId=%@",[ServerManger getInstance].serverURL,hosID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
//充值套餐
-(void) getUpMoneyList:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@account/rechargePackages",[ServerManger getInstance].serverURL];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//充值 支付方式：1支付宝 2微信APP 3微信公众号 4支付宝沙箱
-(void) topdUpMoney:(float) money channel:(NSString*) channel andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@account/recharge?amount=%.2f&payId=%@&transactionType=APP",[ServerManger getInstance].serverURL,money,channel];
    [self postHttp:orderURL parameters:nil version:@"4" andCallback:callback];
}
//充值回调
-(void) notifyAccount:(NSString*) chargeid andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@account/notify?chargeid=%@",[ServerManger getInstance].serverURL,chargeid]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///普通号支付
-(void) payOrder:(NSNumber*) orderID channel:(NSString*) channel isExpert:(BOOL)isExpert andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/pay?channel=%@",[ServerManger getInstance].serverURL,orderID,channel];
    [self postHttp:orderURL parameters:nil version:@"3" andCallback:callback];
}
///专家号支付
-(void) payOrder:(NSNumber*) orderID channel:(NSString*) channel couponID:(NSString *)couponID useBalance:(BOOL)useBalance andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@pjOrder/%@/pay?payId=%@&useBalance=%@&transactionType=APP",[ServerManger getInstance].serverURL,orderID,channel,useBalance?@"1":@"0"];
    if (couponID.length > 1) {
        orderURL = [NSString stringWithFormat:@"%@&couponseId=%@",orderURL,couponID];
    }
    [self postHttp:orderURL parameters:nil version:@"5" andCallback:callback];
}
///新普通号号支付
-(void) payNormalOrder:(NSNumber*) orderID channel:(NSString*) channel couponID:(NSString *)couponID useBalance:(BOOL)useBalance andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/pay?payId=%@&useBalance=%@&transactionType=APP",[ServerManger getInstance].serverURL,orderID,channel,useBalance?@"1":@"0"];
    if (couponID.length > 1) {
        orderURL = [NSString stringWithFormat:@"%@&couponseId=%@",orderURL,couponID];
    }
    [self postHttp:orderURL parameters:nil version:@"5" andCallback:callback];
}
///普通挂号详情
-(void) getOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@order/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"4" andCallback:callback];
}
//陪诊挂号详情
-(void) getAccDetailOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@pzOrder/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"2" andCallback:callback];
}
///专家号详情
-(void) getOrderExpertStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@pjOrder/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"4" andCallback:callback];
}
//改变订单普通号用户是否同意
-(void) acceptChangeNormalOrder:(NSNumber*) orderID accept:(NSString *) accept andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/doFeedback?isAgree=%@",[ServerManger getInstance].serverURL,orderID,accept];
    [self postHttp:orderURL parameters:nil version:@"4" andCallback:callback];
}
//改变订单专家用户是否同意
-(void) acceptChangeExpertOrder:(NSNumber*) orderID accept:(NSString *) accept andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@pjOrder/%@/doFeedback?isAgree=%@",[ServerManger getInstance].serverURL,orderID,accept];
    [self postHttp:orderURL parameters:nil version:@"3" andCallback:callback];
}
///普通接单人转号操作
-(void) launchChangeNormalOrder:(NSNumber*) orderID operation:(NSNumber*) operation  andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/doOperation?operation=%@",[ServerManger getInstance].serverURL,orderID,operation];
    [self postHttp:orderURL parameters:nil version:@"3" andCallback:callback];

}
///专家接单人转号操作
-(void) launchChangeExpertOrder:(NSNumber*) orderID operation:(NSNumber*) operation andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@pjOrder/%@/doOperation?operation=%@",[ServerManger getInstance].serverURL,orderID,operation];
    [self postHttp:orderURL parameters:nil version:@"3" andCallback:callback];

}
///专家号陪诊结束
-(void) expertOrderAccompanyFinish:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@pjOrder/%@/complete",[ServerManger getInstance].serverURL,orderID];
    [self postHttp:orderURL parameters:nil version:@"3" andCallback:callback];
    
}
///专家接单人转号操作 /pjOrder/doPrivilege/{orderId}
-(void) openOnlineServiceAction:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@pjOrder/doPrivilege/%@",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:orderURL parameters:nil version:@"3" andCallback:callback];
    
}

/////普通号接单详情页
-(void) getNormalOrderDetail:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@order/acceptinfo/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

////专家号结单详情页
-(void) getOrderDetailStatus:(NSString*) serialNo andNormalType:(BOOL)orderType longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString *typeStr = orderType ? @"order/acceptinfo" : @"pjOrder/myAcceptedOrders";
    NSString * urlStr = [NSString stringWithFormat:@"%@%@/%@",[ServerManger getInstance].serverURL,typeStr,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

/////万家接单详情页
-(void) getWJOrderDetail:(NSString*) orderID  andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@order/acceptedOrder/%@",[ServerManger getInstance].serverURL,orderID];
    
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}
/////企业接单详情页/2b/pjorder/acceptedOrder/{order_id}
-(void) getCompanyOrderDetail:(NSString*) orderID  andCallback:(void (^)(id  data))callback;

{
    NSString * urlStr = [NSString stringWithFormat:@"%@2b/pjorder/acceptedOrder/%@",[ServerManger getInstance].serverURL,orderID];
    
    [self getHttp:urlStr parameters:nil version:@"1" andCallback:callback];
}
///万家订单专员操作/api/pjOrder/{order_id}/operation
-(void)wjOrderOperation:(NSNumber*) orderID operationID:(NSNumber*) operationID  andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/operation?operation=%@",[ServerManger getInstance].serverURL,orderID,operationID];
    [self postHttp:orderURL parameters:nil version:@"3" andCallback:callback];
}
///企业订单专员操作/2b/pjorder/acceptedOrder/{order_id}/operation
-(void)companyOrderOperation:(NSNumber*) orderID operationID:(NSNumber*) operationID  andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@2b/pjorder/acceptedOrder/%@/operation?operation=%@",[ServerManger getInstance].serverURL,orderID,operationID];
    [self postHttp:orderURL parameters:nil version:@"1" andCallback:callback];
}
-(void) getExpertOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@pjOrder/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

-(void) getLoveOrderStatus:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@loveOrder/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:nil andCallback:callback];
}

-(void) notifyOrder:(NSString*) chargeid isExpert:(BOOL)isExpert andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/notify?chargeid=%@",[ServerManger getInstance].serverURL,isExpert?@"pjOrder":@"order",chargeid]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getAccount:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@account?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}


-(void) withdrawCrash:(NSNumber*) bankID amount:(float) amo andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@share/withdrawal?userBankInfoId=%@&amount=%.2f",[ServerManger getInstance].serverURL,bankID,amo];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) withAddBankCard:(NSDictionary*) dic andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@bank/addBankCard?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:dic version:@"3" andCallback:callback];
}
// 获得银行名称列表
-(void) getBankList: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@bank/list",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getBankListName:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@bank/bankCardList",[ServerManger getInstance].serverURL];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
// 校正登录密码
-(void) vallidLoginPassword:(NSString*) passwordr andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@account/validLoginPassword?password=%@",[ServerManger getInstance].serverURL,passwordr]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

// 校正支付密码
-(void) vallidPayPassword:(NSString*) passwordr andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@account/validPayPassword?password=%@",[ServerManger getInstance].serverURL,passwordr]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

//系统消息列表
-(void) getNotices:(NSNumber*) userId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/notify/list?userId=%@&pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,userId,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
///普通号上传凭证
-(void)normalOrderUploadTicket:(NSNumber *) _id visitSeq:(NSString *)visitSeq currentVisitSeq:(NSString *)currentVisitSeq currentVisitTime:(NSString *)currentVisitTime front:(UIImage*) image isNormalOrder:(BOOL)isNormal andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@/%@/uploadTicket?visitSeq=%@",[ServerManger getInstance].serverURL,isNormal?@"order":@"pjOrder",_id,visitSeq];
    if (currentVisitSeq.length > 0) {
        urlString = [NSString stringWithFormat:@"%@&currentVisitSeq=%@",urlString,currentVisitSeq];
    }
    if (currentVisitTime.length > 0) {
        urlString = [NSString stringWithFormat:@"%@&currentVisitTime=%@",urlString,currentVisitTime];
    }
    
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray array];
    if (image) {
        NSMutableDictionary * img1 = [NSMutableDictionary new];
        [img1 setObject:image forKey:@"image"];
        [img1 setObject:@"ticketFile" forKey:@"file"];
        [img1 setObject:@"front" forKey:@"name"];
        [array addObject:img1];
    }
    
    [self postHttpWithImage:urlString parameters:nil images:array version:@"3" andCallback:callback];
}
///专家号上传凭证
-(void)ExpertUploadTicket:(NSNumber *) _id visitSeq:(NSString *)visitSeq front:(UIImage*) image andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pjOrder/%@/uploadTicket?visitSeq=%@",[ServerManger getInstance].serverURL,_id,visitSeq];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary * img1 = [NSMutableDictionary new];
    [img1 setObject:image forKey:@"image"];
    [img1 setObject:@"ticketFile" forKey:@"file"];
    [img1 setObject:@"front" forKey:@"name"];
    [array addObject:img1];
    [self postHttpWithImage:urlString parameters:nil images:array version:@"3" andCallback:callback];
}
-(void) getOrderBid:(NSString*) serialNo andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@orderBid/%@",[ServerManger getInstance].serverURL,serialNo]];
    [self getHttp:URL.absoluteString parameters:nil version:nil andCallback:callback];
}

-(void) putOrderPrice:(NSNumber*) orderID price:(NSString*) value andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@orderBid/%@?value=%@",[ServerManger getInstance].serverURL,orderID,value]];
    [self postHttp:URL.absoluteString parameters:nil version:nil andCallback:callback];
}

-(void) getSysParameter:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@common/sysParameter/list",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getAppVersion:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@appVersion?versionId=%@&platform=ios",[ServerManger getInstance].serverURL,APP_VERSION]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) editPush:(NSString*) isPush andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/isAcceptOrderPush?value=%@",[ServerManger getInstance].serverURL,isPush]];
    [self putHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) clearMessage:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@notify/clearAll",[ServerManger getInstance].serverURL]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getOrderDesc:(NSNumber*) ids andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@notify/%@/read",[ServerManger getInstance].serverURL,ids]];
    [self postHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getMSGNewOrder:(NSNumber*) ids andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@notify/%@/orderinfo",[ServerManger getInstance].serverURL,ids]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getHistoryOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/patientHistoryOrder?patientId=%@",[ServerManger getInstance].serverURL,orderID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getDoctorList:(NSNumber*) departmentID size:(int) size page:(int) page andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@doctor/listByDepartmentId?pageSize=%d&pageNo=%d&departmentId=%@",[ServerManger getInstance].serverURL,size,page,departmentID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getExpDoctorList:(NSNumber*) departmentID content:(NSString*) content size:(int) size page:(int) page andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@doctor/listByDepartmentTypeId?pageSize=%d&pageNo=%d&departmentTypeId=%@",[ServerManger getInstance].serverURL,size,page,departmentID];
    if(content.length>0){
        urlString = [NSString stringWithFormat:@"%@&keywords=%@",urlString,content];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getExpDoctor:(NSNumber*) expID andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@doctor/%@",[ServerManger getInstance].serverURL,expID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getExpInfo:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@order/getPageData4PjOrderCreate",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getExpNewInfo:(NSNumber *)doctorId scheduleId:(NSNumber *)scheduleId andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pjOrder/getCreatePageData?doctorId=%@&scheduleId=%@",[ServerManger getInstance].serverURL,doctorId,scheduleId]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getOrderTags:(NSNumber*) depID andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@department/getTagsByDepartmentType?departmentTypeId=%@",[ServerManger getInstance].serverURL,depID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getExpOrderTags:(NSNumber*) depID andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@department/getTagsByHospitalDepartment?hospitalDepartmentId=%@",[ServerManger getInstance].serverURL,depID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
////专家号支付
-(void) getPayOrderPageData:(NSNumber*) orderID isExpert:(BOOL)isExpert andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@/%@/getPayOrderPageData",[ServerManger getInstance].serverURL,isExpert?@"pjOrder":@"order",orderID];
    [self getHttp:urlString parameters:nil version:isExpert?@"4":@"3" andCallback:callback];
}
////专家号新版本支付
-(void) getPayExpertOrderPageData:(NSNumber*) orderID andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pjOrder/%@/getPayOrderPageData",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:urlString parameters:nil version:@"4" andCallback:callback];
}
////普通号新版本支付
-(void) getPayNormalOrderPageData:(NSNumber*) orderID andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/getPayOrderPageData",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:urlString parameters:nil version:@"4" andCallback:callback];
}
-(void) fillInvitationCode:(NSString*) ids andCallback:(void (^)(id  data))callback
{
    NSString *urlString = [[NSString stringWithFormat:@"%@user/fillInvitationCode?referrercode=%@",[ServerManger getInstance].serverURL,ids] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getSysParameterListByGroup:(NSString*) content andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@common/getSysParameterListByGroup?groupName=%@",[ServerManger getInstance].serverURL,content]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) setCancelReason:(NSNumber*) ids reason:(NSString*) reason andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/setCancelReason?cancelReason=%@",[ServerManger getInstance].serverURL,ids,reason];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getBannerList:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@common/mainPage",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getOrderInfo:(NSString*) longitude latitude:(NSString*) latitude isChildEmergency:(BOOL)isChildEmergency andCallback:(void (^)(id  data))callback
{
    NSString * str = isChildEmergency?@"1":@"0";
    NSString *urlStr = [NSString stringWithFormat:@"%@order/getPageData4OrderCreate?visitType=%@",[ServerManger getInstance].serverURL,str];
    if (longitude.length>0) {
        urlStr = [NSString stringWithFormat:@"%@order/getPageData4OrderCreate?longitude=%@&latitude=%@&visitType=%@",[ServerManger getInstance].serverURL,longitude,latitude,str];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

-(void) getLoveOrderInfo:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@loveOrder/getPageData4OrderCreate",[ServerManger getInstance].serverURL]];
    if (longitude.length>0) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@loveOrder/getPageData4OrderCreate?longitude=%@&latitude=%@",[ServerManger getInstance].serverURL,longitude,latitude]];
    }
    [self getHttp:URL.absoluteString parameters:nil version:nil andCallback:callback];
}

-(void) getExpertDoctorList:(NSNumber*) hospitalID departmentID:(NSNumber*) departmentID filterDate:(NSString*) date apm:(NSNumber*)apm type:(NSNumber*)type keywords:(NSString*) keywords size:(int) size page:(int) page andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@doctor/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    if (hospitalID) urlString = [NSString stringWithFormat:@"%@&hospitalId=%@",urlString,hospitalID];
    if (departmentID) urlString = [NSString stringWithFormat:@"%@&departmentId=%@",urlString,departmentID];
    if (date) urlString = [NSString stringWithFormat:@"%@&filterDate=%@",urlString,date];
    if (apm) urlString = [NSString stringWithFormat:@"%@&apm=%@",urlString,apm];
    if (type) urlString = [NSString stringWithFormat:@"%@&type=%@",urlString,type];
    if (keywords) urlString = [NSString stringWithFormat:@"%@&keywords=%@",urlString,keywords];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

// 获取专家日期列表
-(void) getListFilterDates:(NSNumber*) hospitalID departmentID:(NSNumber*) departmentID andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@doctor/listFilterDates",[ServerManger getInstance].serverURL ];
    if(hospitalID) urlStr = [NSString stringWithFormat:@"%@?hospitalId=%@",urlStr,hospitalID];
    if(departmentID) urlStr = [NSString stringWithFormat:@"%@&departmentId=%@",urlStr,departmentID];
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}
///搜医生common/search
-(void) getExpSearchInHomage:(NSString*) content size:(int) size page:(int) page andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@common/search?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    if(content.length>0){
        urlString = [NSString stringWithFormat:@"%@&keywords=%@",urlString,content];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
-(void) getExpSearch:(NSString*) content size:(int) size page:(int) page andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@doctor/search?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    if(content.length>0){
        urlString = [NSString stringWithFormat:@"%@&keywords=%@",urlString,content];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//获取特需号手机验证码
-(void) getExpSMSCode:(NSString *) phone andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@common/getVerifyCode4PjOrderCreate?mobile=%@",[ServerManger getInstance].serverURL,phone]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

// 验证特需手机号 是否正确
-(void) estimateExpSms:(NSString*) ids mobile:(NSString*) mobile smsCode:(NSString*) smsCode andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@patient/%@/updateMobile?mobile=%@&smsCode=%@",[ServerManger getInstance].serverURL,ids,mobile,smsCode];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//获取挂号豆详情
-(void) getPointInfo: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@point",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getExchangeDetails:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@point/userPointLogs?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) getMyExchangeCoupons:(int) size page:(int) page andCallback: (void (^)(id  data))callback{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@point/myExchangeCoupons?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
//设置是否开启推送
-(void) setSignWarn:(NSString*) isOpen andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@point/setSignWarn?isOpenSignWarn=%@",[ServerManger getInstance].serverURL,isOpen];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//签到
-(void) signBean:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@point/sign",[ServerManger getInstance].serverURL];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}


-(void) exchangeCoupons:(NSNumber*) couponsId andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@point/exchangeCoupons?couponsId=%@",[ServerManger getInstance].serverURL,couponsId];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//检测医院是否要传  医院就诊卡号
-(void) checkMedicalCardIsMatchHospital:(NSNumber*) patientId hospitalID:(NSNumber*) hospitalId andCallback: (void (^)(id  data))callback
{
    NSString *urlStr = [NSString stringWithFormat:@"%@order/checkMedicalCardIsMatchHospital?patientId=%@&hospitalId=%@",[ServerManger getInstance].serverURL,patientId,hospitalId];
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

// 我的分享
-(void) share:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@share?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    [self getHttp:urlStr parameters:nil version:@"4" andCallback:callback];
}


// 我的分享日志
-(void) shareLogs:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@share/myShareIncomes?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

// 我的分享排行
-(void) shareRanks:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@share/rankingList?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

//银行列表
-(void) bankList: (void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@share/bankList",[ServerManger getInstance].serverURL];
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

//提现
-(void) withDrawal:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@share/withdrawal?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:dic version:@"3" andCallback:callback];
}

//银行卡历史列表
-(void) cardLogList: (void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@share/bankCardList",[ServerManger getInstance].serverURL];
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

//管理员确认 完成订单
-(void) completeTicket:(NSNumber *) _id andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/uploadTicket",[ServerManger getInstance].serverURL,_id];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//查看病人详情
-(void) getPatient:(NSNumber*) patientID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@patient/%@",[ServerManger getInstance].serverURL,patientID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

//查看流水详情
-(void) getBankInfo:(NSNumber*) bankID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@share/withdrawalInfo/%@/",[ServerManger getInstance].serverURL,bankID]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}
//扫码列表(专员端)接口
-(void) waiterOrders:(NSString*) msg size:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    msg = msg.length>0 ? [NSString stringWithFormat:@"&keywords=%@",msg ]:@"";
    NSString * urlString = [NSString stringWithFormat:@"%@order/waiterHistoryOrders?pageSize=%d&pageNo=%d%@",[ServerManger getInstance].serverURL,size,page,msg];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

/////扫一扫订单详情页(专员端)接口
-(void) getScaninfo:(NSString*) serialNo longitude:(NSString*) longitude latitude:(NSString*) latitude andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@order/scaninfo/%@",[ServerManger getInstance].serverURL,serialNo];
    if (longitude.length >0) {
        urlStr = [NSString stringWithFormat:@"%@?longitude=%@&latitude=%@",urlStr,longitude,latitude];
    }
    [self getHttp:urlStr parameters:nil version:@"3" andCallback:callback];
}

//管理员确认 完成领单
-(void) completeGetTicket:(NSNumber *) _id andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/getTicket",[ServerManger getInstance].serverURL,_id];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
///陪诊余额支付成功页
-(void) getAccompanyPaySuccessPageData:(NSNumber*) orderID andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder/%@/paySuccessPageData",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:urlString parameters:nil version:@"2" andCallback:callback];
}
-(void) getPaySuccessPageData:(NSNumber*) orderID isExpert:(BOOL)isExpert andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@/%@/paySuccessPageData",[ServerManger getInstance].serverURL,isExpert?@"pjOrder":@"order",orderID];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getCity:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@region/list?pageSize=20&pageNo=1",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

-(void) bindCity:(NSNumber *) _id andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@region/%@/bind",[ServerManger getInstance].serverURL,_id];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

-(void) getArticle:(NSNumber*) articleID size:(int) size page:(int) page andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@article/%@?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,articleID,size,page];
    [self getHttp:urlString parameters:nil version:@"1" andCallback:callback];
}

-(void) getGroupMsg:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@notify/group",[ServerManger getInstance].serverURL];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}

//系统消息列表
-(void) getTypeNotices:(NSNumber*) groupId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/notify/list?userId=%@&pageSize=%d&pageNo=%d&groupId=%@",[ServerManger getInstance].serverURL,[DataManager getInstance].user.id,size,page,groupId]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

//新闻首页
-(void) getHomeArticle:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@article/index?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}

//获取id新闻列表
-(void) getHomeList:(NSNumber*) categoryId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@article/list?categoryId=%@&pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,categoryId,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}

//获取评论列表
-(void) getCommendList:(NSNumber*) articleId size:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@article/comment/list?articleId=%@&pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,articleId,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}

//点赞评论
-(void) praiseComment:(NSNumber*) _id andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@article/comment/%@/praise",[ServerManger getInstance].serverURL,_id]];
    [self postHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}

//点赞文章
-(void) praiseArticle:(NSNumber*) _id andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@article/%@/praise",[ServerManger getInstance].serverURL,_id]];
    [self postHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}

//评论文章
-(void) commentArticle:(NSMutableDictionary*) dic ariticleID:(NSNumber*) _id andCallback: (void (^)(id  data))callback
{
    NSString* urlString = [NSString stringWithFormat:@"%@article/%@/doComment?%@",[ServerManger getInstance].serverURL,_id,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"1" andCallback:callback];
}

-(NSDictionary*) getErrorCode:(NSError*) error
{
    NSDictionary *dic = error.userInfo;
    NSLog(@"%@",[dic objectForKey:@"NSUnderlyingError"]);
    
    if (error.code == -1009) {
        return @{@"code":@"-1009",@"msg":@"网络连接失败，请检查您是否开启网络连接！"};
    }
    if (error.code == -1002) {
        return @{@"code":@"-1002",@"msg":@"网络连接失败，请检查您是否开启网络连接！"};
    }
    if (error.code == -1011) {
//        [[DataManager getInstance] saveToken:nil];
//        UIViewController * result = [Utils topViewController:nil];
//        LoginViewController * view = [GHViewControllerLoader LoginViewController];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
//        [result.navigationController  presentViewController:nav animated:YES completion:nil];
        return @{@"code":@"-1011",@"msg":@"请稍候再试！"};
        
    }
    if (error.code == -1004) {
        return @{@"code":@"-1004",@"msg":@"未能连接到服务器，请检查您是否开启网络连接！"};
    }
    return @{@"code":@"-1012",@"msg":@"系统错误，请稍候再试！"};
}
///陪诊页数据
-(void)getAccompanyVCDataCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder/index",[ServerManger getInstance].serverURL];
    [self getHttp:urlString parameters:nil version:@"2" andCallback:callback];
}
///陪诊介绍页数据
-(void)getAccompanyFlowVCData:(int)type andCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder/introduction?serviceType=%d",[ServerManger getInstance].serverURL,type];
    [self getHttp:urlString parameters:nil version:@"2" andCallback:callback];
}
///创建陪诊订单
-(void)createAccompanyOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"2" andCallback:callback];

}
//AccompanyOrderViewController 数据请求
-(void)getAccompanyOrderVCData:(int)type andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder/getCreatePageData?serviceType=%d",[ServerManger getInstance].serverURL,type ];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"2" andCallback:callback];
    
}
///支付界面数据
-(void) getAccompanyPayOrderPageData:(NSNumber*) orderID  andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder/%@/getPayOrderPageData",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:urlString parameters:nil version:@"2" andCallback:callback];
}
///陪诊支付
-(void) payAccompanyOrder:(NSNumber*) orderID channel:(NSString*) channel  andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@pzOrder/%@/pay?payId=%@&transactionType=APP",[ServerManger getInstance].serverURL,orderID,channel];
    [self postHttp:orderURL parameters:nil version:@"5" andCallback:callback];
}
///陪诊支付回调
-(void) notifyAccompanyOrder:(NSString*) chargeid andCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@pzOrder/notify?chargeid=%@",[ServerManger getInstance].serverURL,chargeid]];
    [self getHttp:URL.absoluteString parameters:nil version:@"2" andCallback:callback];
}

///健康评测
-(void) gethealthTestPageDataSize:(int) size page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/assessment/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}

//关注
-(void) follow:(NSNumber*) _id andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@follow/%@/follow",[ServerManger getInstance].serverURL,_id];
    [self postHttp:orderURL parameters:nil version:@"1" andCallback:callback];
}

//取消关注
-(void) unfollow:(NSNumber*) _id andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@follow/%@/unfollow",[ServerManger getInstance].serverURL,_id];
    [self postHttp:orderURL parameters:nil version:@"1" andCallback:callback];
}

//关注列表
-(void) followList:(int) size page:(int) page andCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@follow/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page];
    [self getHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
//特色科室
-(void)specialDepListDataCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@featureddept/list",[ServerManger getInstance].serverURL];
    [self getHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
//特色科室科室详情
-(void) specialDepInfo:(NSNumber*) _id andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@featureddept/%@",[ServerManger getInstance].serverURL,_id];
    [self getHttp:orderURL parameters:nil version:@"1" andCallback:callback];
}
-(NSString*) getFormString:(NSDictionary*) formData
{
    //设置请求体中内容
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    
    
    for (int i= (int)[[formData allKeys]count]-1; i>=0; i--) {
        
        NSString *key = [formData allKeys][i];
        NSString *value = [formData allValues][i];
        [bodyString appendFormat:@"%@=%@&",key,value];
    }
    return bodyString;
}
///
-(void)getVisitTypePageDataCallback:(void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@common/getVisitTypeDocData",[ServerManger getInstance].serverURL]];
    [self getHttp:URL.absoluteString parameters:nil version:@"3" andCallback:callback];
}

///特色科室医生筛选
-(void) specialDepDoctorSelect:(NSString *)kewWord size:(int)size page:(int)page _id:(NSNumber*) _id parameter:(NSMutableDictionary *)parameter andCallback:(void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@featureddept/%@/doctorlist?pageSize=%d&pageNo=%d&keywords=%@",[ServerManger getInstance].serverURL,_id,size,page,kewWord];
//    if(kewWord.length>0){
//        urlString = [NSString stringWithFormat:@"%@&keywords=%@",urlString,kewWord];
//    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"特色科室医生筛选urlString-----%@",urlString);

    [self getHttp:urlString parameters:parameter version:@"1" andCallback:callback];
}
///修改个人信息
-(void) fixPersonInfoWithID:(NSNumber*) patientID parameter:(NSMutableDictionary *)parameter andCallback: (void (^)(id  data))callback
{

    NSString* urlString = [NSString stringWithFormat:@"%@patient/%@?%@",[ServerManger getInstance].serverURL,patientID,[self getFormString:parameter]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"3" andCallback:callback];
 
}
///获得支付二维码信息
-(void)getQRPayInfoWithID:(NSNumber*) patientID isNormal:(BOOL)isNormal channel:(NSString *)channel andCallback: (void (^)(id  data))callback
{
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%@/qrpay?channel=%@",[ServerManger getInstance].serverURL,isNormal ? @"order":@"pjOrder",patientID,channel];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"5" andCallback:callback];
    
}
///轮询支付结果
-(void) getNormalOrderPayStatus:(NSNumber*) _id isNormal:(BOOL)isNormal andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@%@/%@/paystatus/polling",[ServerManger getInstance].serverURL,isNormal ? @"order":@"pjOrder",_id];
    [self getHttp:orderURL parameters:nil version:@"3" andCallback:callback];
}

///重疾所有套餐/critical/illness/packageList
-(void) getPackageDataCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@critical/illness/packageList",[ServerManger getInstance].serverURL];
    [self postHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
///重疾所有套餐/critical/illness/getCreatePageData
-(void) getPackagePersonListCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@critical/illness/getCreatePageData",[ServerManger getInstance].serverURL];
    [self postHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
///提交重疾(new)订单/critical/illness
-(void) createSeriousOrder:(NSDictionary *) dic imgs:(NSMutableArray*) imgs andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@critical/illness?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *array = nil;
    if(imgs&&imgs.count>0){
        array = [NSMutableArray new];
        for(int i=0;i<imgs.count;i++){
            NSMutableDictionary * img1 = [NSMutableDictionary new];
            [img1 setObject:imgs[i] forKey:@"image"];
            [img1 setObject:@"files" forKey:@"file"];
            [img1 setObject:@"me" forKey:@"name"];
            [array addObject:img1];
        }
    }
    
    [self postHttpWithImage:urlString parameters:nil images:array version:@"1" andCallback:callback];
}
///重疾列表/critical/illness/criticalIllnessOrderList
-(void) getSeriousListOrderSize:(int) size page:(int) page longitude:(NSString*)longitude latitude:(NSString*)latitude andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@critical/illness/criticalIllnessOrderList?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}
///重疾订单详情/critical/illness/{serialNo}
-(void) getSeriosOrderDetail:(NSString*) serialNo andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@critical/illness/%@",[ServerManger getInstance].serverURL,serialNo];
    [self getHttp:urlStr parameters:nil version:@"1" andCallback:callback];
}
/// 取消重疾订单----------/critical/illness/{id}/cancel
-(void) cancelSeriousOrder:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@critical/illness/%@/cancel",[ServerManger getInstance].serverURL,orderID]];
    [self postHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
}
///创建取药或报告订单
-(void)createMedicineOrReportOrder:(NSDictionary *) dic imgs:(NSMutableArray*) imgs andCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@pzOrder?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *array = nil;
    if(imgs&&imgs.count>0){
        array = [NSMutableArray new];
        for(int i=0;i<imgs.count;i++){
            NSMutableDictionary * img1 = [NSMutableDictionary new];
            [img1 setObject:imgs[i] forKey:@"image"];
            [img1 setObject:@"files" forKey:@"file"];
            [img1 setObject:@"me" forKey:@"name"];
            [array addObject:img1];
        }
    }
    
    [self postHttpWithImage:urlString parameters:nil images:array version:@"2" andCallback:callback];
}
///创建评价
-(void)createEvaluate:(NSDictionary *) dic orderID:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/createEvaluation?%@",[ServerManger getInstance].serverURL,orderID,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
///评价页详情/order/{id}/showEvaluation
-(void)getEvaluate:(NSDictionary *) dic orderID:(NSNumber*) orderID  andCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/showEvaluation?%@",[ServerManger getInstance].serverURL,orderID,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
///获得城市区县/region/{id}/childRegions
-(void) getContyInfoWithCityCode:(NSString *)cityCode andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@region/%@/childRegions",[ServerManger getInstance].serverURL,cityCode];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"3" andCallback:callback];
}
///健康管理创建订单页/health/order/getCreatePageData 1 基础健康管理套餐 2 定制化增值服务
-(void) getHealthOrderPageData:(NSString *)serviceType  Callback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@health/order/getCreatePageData?serviceType=%@",[ServerManger getInstance].serverURL,serviceType];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
///创建取健康管理订单 /health/order
-(void)createHealthManagerOrder:(NSDictionary *) dic andCallback: (void (^)(id  data))callback{
    NSString * urlString = [NSString stringWithFormat:@"%@health/order?%@",[ServerManger getInstance].serverURL,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
///健康管理列表/health/order/list
-(void) getHealthListOrderSize:(int) size page:(int) page serviceType:(int)type andCallback: (void (^)(id  data))callback
{
    
    if (type == 1) {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@health/order/list?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
        [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
    }else{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@health/order/reports?pageSize=%d&pageNo=%d",[ServerManger getInstance].serverURL,size,page]];
        [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
    }
    
}
////健康预约详情health/order/{id}
-(void) getHealthOrderDetialOrderID:(NSNumber*)orderID andCallback:(void (^)(id  data))callback
{
    NSString * urlStr = [NSString stringWithFormat:@"%@health/order/%@",[ServerManger getInstance].serverURL,orderID];

    [self getHttp:urlStr parameters:nil version:@"1" andCallback:callback];
}
///普通号挂号单号满
-(void) normalOrderFullAction:(NSNumber*) orderID andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/noMore",[ServerManger getInstance].serverURL,orderID];
    [self postHttp:orderURL parameters:nil version:@"4" andCallback:callback];
    
}
///普通号预约完成预约
-(void) normalOrderCompleteRegAction:(NSNumber*) orderID dateStr:(NSString *)dateStr andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/completeReg?recommendVisitTime=%@",[ServerManger getInstance].serverURL,orderID,dateStr];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"4" andCallback:callback];
    
}
///普通号操作
-(void) normalOrderOperationAction:(NSNumber*)orderID Operation:(NSString *)operation andCallback: (void (^)(id  data))callback
{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/%@/%@",[ServerManger getInstance].serverURL,orderID,operation];
    [self postHttp:orderURL parameters:nil version:@"4" andCallback:callback];
    
}
///充值支付结果
-(void) getAccountRechargePayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@account/recharge/query?out_trade_no=%@",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:orderURL parameters:nil version:@"4" andCallback:callback];
}

////普通号支付结果查询
-(void) getNormalOrderPayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@order/pay/query?out_trade_no=%@",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:orderURL parameters:nil version:@"5" andCallback:callback];
}

////专家特需号支付结果查询/pjOrder/pay/query
-(void) getSpecialOrderPayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@pjOrder/pay/query?out_trade_no=%@",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:orderURL parameters:nil version:@"5" andCallback:callback];
}

////陪诊号支付结果查询/pjOrder/pay/query
-(void) getAccompanyOrderPayStatus:(NSString*) orderID  andCallback: (void (^)(id  data))callback{
    NSString * orderURL = [NSString stringWithFormat:@"%@pzOrder/pay/query?out_trade_no=%@",[ServerManger getInstance].serverURL,orderID];
    [self getHttp:orderURL parameters:nil version:@"5" andCallback:callback];
}
///专家号结束陪诊评价页面
-(void) expertEndFeedBack:(NSDictionary *) dic orderID:(NSString*) orderID andCallback: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@pjOrder/%@/feedback?%@",[ServerManger getInstance].serverURL,orderID,[self getFormString:dic]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postHttp:urlString parameters:nil version:@"5" andCallback:callback];
}

///整形界面/plastic/list
-(void) plasticHomeBack: (void (^)(id  data))callback
{
    NSString * urlString = [NSString stringWithFormat:@"%@/plastic/list",[ServerManger getInstance].serverURL];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getHttp:urlString parameters:nil version:@"1" andCallback:callback];
}
///医生列表/plastic/{id}/doctors
-(void) getPlasticDoctorsWithId:(NSInteger)idStr page:(int) page andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@plastic/%ld/doctors?pageSize=10&pageNo=%d",[ServerManger getInstance].serverURL,(long)idStr,page]];
        [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
    
}

///医院列表/plastic/{id}/hospitals
-(void) getPlasticHospitalsWithId:(NSInteger)idStr andCallback: (void (^)(id  data))callback
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@plastic/%ld/hospitals",[ServerManger getInstance].serverURL,(long)idStr]];
    [self getHttp:URL.absoluteString parameters:nil version:@"1" andCallback:callback];
    
}



@end
