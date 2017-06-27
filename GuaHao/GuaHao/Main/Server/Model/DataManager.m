//
//  DataManager.m
//  GuaHao
//
//  Created by qiye on 16/1/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DataManager.h"

static DataManager * instance;

@implementation DataManager

+(DataManager *) getInstance
{
    if(instance == nil)
    {
        instance = [[DataManager alloc] init];
        [instance getToken];
    }
    
    return instance;
}

-(void) saveUserData:(NSString*) name Pwd:(NSString*) pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"Password"];
}

-(NSDictionary*) getUserData
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name = [userDefaults objectForKey:@"Username"]?[userDefaults objectForKey:@"Username"]:@"";
    NSString* pwd = [userDefaults objectForKey:@"Password"]?[userDefaults objectForKey:@"Password"]:@"";
    [dic setObject:name forKey:@"Username"];
    [dic setObject:pwd forKey:@"Password"];
    return dic;
}

-(void) saveToken:(NSString*) token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    if(!token){
        _loginState = 0;
        _user = nil;
    }
}

-(NSString*) getToken
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDefaults objectForKey:@"token"]?[userDefaults objectForKey:@"token"]:nil;
    self.cityName = [userDefaults objectForKey:@"cityName"]?[userDefaults objectForKey:@"cityName"]:@"上海市";
    self.cityId = [userDefaults objectForKey:@"cityId"]?[userDefaults objectForKey:@"cityId"]:@"021";

    if(token){
        _loginState = 1;
        if(!_user){
            _user = [UserVO new];
            _user.token = token;
            _user.id = [userDefaults objectForKey:@"userId"];
            _user.acceptOrderPush = [NSNumber numberWithInt:1];
            _user.loginName = [userDefaults objectForKey:@"loginName"];
            _user.sex =[userDefaults objectForKey:@"sex"];
            _user.verifyStatus = [userDefaults objectForKey:@"verifyStatus"];
            _user.mobile = [userDefaults objectForKey:@"mobile"];
            _user.banlance = [userDefaults objectForKey:@"banlance"];
            _user.hxPassword = [userDefaults objectForKey:@"hxPassword"];
            _user.hospName = [userDefaults objectForKey:@"hospName"];
            _user.hospId = [userDefaults objectForKey:@"hospId"];
            _user.avatar = [userDefaults objectForKey:@"avatar"];
            _user.nickName = [userDefaults objectForKey:@"nickName"];
            _user.point = [userDefaults objectForKey:@"point"];
            _user.hxUsername = [userDefaults objectForKey:@"hxUsername"];
            _user.selfcode = [userDefaults objectForKey:@"selfcode"];


            _user.latitude = [userDefaults objectForKey:@"latitude"];
            _user.longitude = [userDefaults objectForKey:@"longitude"];
            
        }
    }
    return token;
}

-(void) setLogin:(UserVO *) user
{
    _user = user;
    _loginState = 1;
    
    [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.acceptOrderPush forKey:@"acceptOrderPush"];
    [[NSUserDefaults standardUserDefaults] setObject:user.loginName forKey:@"loginName"];
    [[NSUserDefaults standardUserDefaults] setObject:user.sex forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults] setObject:user.verifyStatus forKey:@"verifyStatus"];
    [[NSUserDefaults standardUserDefaults] setObject:user.mobile forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setObject:user.banlance forKey:@"banlance"];
    [[NSUserDefaults standardUserDefaults] setObject:user.hxPassword forKey:@"hxPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:user.hospName forKey:@"hospName"];
    [[NSUserDefaults standardUserDefaults] setObject:user.hospId forKey:@"hospId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.avatar forKey:@"avatar"];
    [self saveToken:user.token];
    [[NSUserDefaults standardUserDefaults] setObject:user.nickName forKey:@"nickName"];
    [[NSUserDefaults standardUserDefaults] setObject:user.point forKey:@"point"];
    [[NSUserDefaults standardUserDefaults] setObject:user.hxUsername forKey:@"hxUsername"];
    [[NSUserDefaults standardUserDefaults] setObject:user.selfcode forKey:@"selfcode"];

    
    
    
    
}
-(void) setRegionLatitude:(NSString *) latitude longitude:(NSString*) longitude
{
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"longitude"];
}
-(void) setRegion:(NSString *) ids name:(NSString*) name
{
    [[NSUserDefaults standardUserDefaults] setObject:ids forKey:@"cityId"];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"cityName"];
}
@end
