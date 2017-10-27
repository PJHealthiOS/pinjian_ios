//
//  GeoLocationManager.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/23.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GeoLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface GeoLocationManager ()<AMapLocationManagerDelegate>{
    
}
@property (nonatomic, strong)AMapLocationManager *GeoLocationManager;

@end
@implementation GeoLocationManager
+(GeoLocationManager *)shareLocation{
    static dispatch_once_t onceToken;
    static GeoLocationManager *locationManager;
    dispatch_once(&onceToken, ^{
        locationManager = [[GeoLocationManager alloc]init];
    });
    [locationManager location];
    return locationManager;
}

-(void)location{
    self.GeoLocationManager = [[AMapLocationManager alloc]init];
    self.GeoLocationManager.delegate = self;

    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务当前可能尚未打开，请在设置中打开！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){

        
    }else{
        
    }
    //设置不允许系统暂停定位
//        [self.GeoLocationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
//        [self.GeoLocationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self.GeoLocationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    //设置逆地理超时时间
        [self.GeoLocationManager setReGeocodeTimeout:3];
    NSLog(@"开始定位时间");
    [self.GeoLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSLog(@"定位结束时间location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode );
            self.myBlock(YES,regeocode.city? regeocode.city:regeocode.province,regeocode.citycode,[NSString stringWithFormat:@"%f",location.coordinate.longitude],[NSString stringWithFormat:@"%f",location.coordinate.latitude]);
        }
    }];
    

    
}

-(void)getLocationInfo:(GeoLocationBlock)block{
    self.myBlock = block;
}

-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    self.myBlock(NO,@"",@"",@"",@"");
    NSLog(@"reGeocode--error:--%@", error);
}
@end
