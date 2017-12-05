//
//  GHLocationManager.h
//  GuaHao
//
//  Created by SunAndLi on 16/8/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationBlock)(BOOL success,NSString * _longitude , NSString * _latitude);
@interface GHLocationManager : NSObject
@property (nonatomic, copy)LocationBlock myBlock;
+(GHLocationManager *)shareLocation;
-(void)getLocationInfo:(LocationBlock)block;
@end
