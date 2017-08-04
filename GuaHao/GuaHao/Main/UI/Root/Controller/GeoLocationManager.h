//
//  GeoLocationManager.h
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/23.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GeoLocationBlock)(BOOL success,NSString * _cityNmae , NSString * _cityCode,NSString *_longitude,NSString *_latitude);
@interface GeoLocationManager : NSObject
@property (nonatomic, copy)GeoLocationBlock myBlock;
+(GeoLocationManager *)shareLocation;
-(void)getLocationInfo:(GeoLocationBlock)block;
@end
