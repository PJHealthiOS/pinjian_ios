//
//  GHLocationManager.m
//  GuaHao
//
//  Created by SunAndLi on 16/8/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHLocationManager.h"
#import "WGS84TOGCJ02.h"

@interface GHLocationManager ()<CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D  _coordinate;
    NSError *_error;
}

@end
@implementation GHLocationManager

+(GHLocationManager *)shareLocation{
    static dispatch_once_t onceToken;
    static GHLocationManager *locationManager;
    dispatch_once(&onceToken, ^{
        locationManager = [[GHLocationManager alloc]init];
    });
    [locationManager location];
    return locationManager;
}
-(void)location{
    _locationManager = [[CLLocationManager alloc] init];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
//    }

    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务当前可能尚未打开，请在设置中打开！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = kCLLocationAccuracyHundredMeters;//百米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    
    if (newLocation) {
        _coordinate = newLocation.coordinate;
        //判断是不是属于国内范围
        if (![WGS84TOGCJ02 isLocationOutOfChina:_coordinate]) {
            //转换后的coord
            _coordinate = [WGS84TOGCJ02 transformFromWGSToGCJ:_coordinate];
        }
        //根据经纬度反向地理编译出地址信息
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            for (CLPlacemark * placemark in placemarks) {
                
                NSDictionary *address = [placemark addressDictionary];
                
                //  Country(国家)  State(省)  City（市）
                NSLog(@"#####%@",address);
                
                NSLog(@"%@", [address objectForKey:@"Country"]);
                
                NSLog(@"%@", [address objectForKey:@"State"]);
                
                NSLog(@"%@", [address objectForKey:@"City"]);
                
            }
            
        }];
        NSLog(@"locationManager location: %@", newLocation);
        NSString * longitude = [NSString stringWithFormat:@"%f",_coordinate.longitude];
        NSString * latitude = [NSString stringWithFormat:@"%f",_coordinate.latitude];
        if (self.myBlock) {
            self.myBlock(YES,longitude,latitude);
        }
        
    }
}
-(void)getLocationInfo:(LocationBlock)block{
    self.myBlock = block;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    _error = error;
    NSLog(@"locationManager:didFailWithError  %@", error);
    if (self.myBlock) {
        self.myBlock(NO,@"",@"");
    }
}


@end
