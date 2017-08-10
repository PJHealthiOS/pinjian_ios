//
//  DataManager.h
//  GuaHao
//
//  Created by qiye on 16/1/25.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"
#import "MessageController.h"
@interface DataManager : NSObject

@property(strong,nonatomic) UserVO * user;
@property(strong,nonatomic) NSMutableArray * patients;
@property(copy) NSString * cityId;
@property(copy) NSString * cityName;

@property  NSInteger loginState;
@property (strong,nonatomic) MessageController *messageVC;

+(DataManager *) getInstance;

-(void) saveUserData:(NSString*) name Pwd:(NSString*) pwd;
-(NSDictionary*) getUserData;

-(void) saveToken:(NSString*) token;
-(NSString*) getToken;

-(void) setLogin:(UserVO *) user;

-(void) setRegion:(NSString *) ids name:(NSString*) name;
-(void) setRegionLatitude:(NSString *) latitude longitude:(NSString*) longitude;
@end
