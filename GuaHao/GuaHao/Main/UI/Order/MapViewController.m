//
//  MapViewController.m
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotationView.h>
#import "KCAnnotation.h"
#import "MKMapView+ZoomLevel.h"
#import "Utils.h"
#import <DIOpenSDK/DIOpenSDK.h>

@interface MapViewController ()<MKMapViewDelegate,DIOpenSDKDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (nonatomic,strong) CLGeocoder *geocoder;
@end

@implementation MapViewController{
    CLLocationManager *_locationManager;
    MKMapView *maMapView;
    MKAnnotationView *annotationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DIOpenSDK registerApp:@"didi636E506550433476677A3670544D4D" secret:@"31d9d2e4984ecbdf9420c05bf609b485"];
    _geocoder=[[CLGeocoder alloc]init];
    maMapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:maMapView];
    //设置代理
    maMapView.delegate=self;
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    maMapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置地图类型
    maMapView.mapType=MKMapTypeStandard;
    //添加大头针
    [self addAnnotation];
}

-(void)addAnnotation{
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(_hospitalLatitude.floatValue, _hospitalLongitude.floatValue);
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title= _hospitalName;
    annotation1.subtitle= _hospitalDesc;
    annotation1.coordinate=location1;
    [maMapView setCenterCoordinate:location1 zoomLevel:13 animated:NO];
    [maMapView addAnnotation:annotation1];
    [maMapView selectAnnotation:annotation1 animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[KCAnnotation class]]) {
        static NSString *key1=@"KCAnnotation";
        annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            [btn setBackgroundImage:[UIImage imageNamed:@"common_frist_order_payLine_image.png"] forState:UIControlStateNormal];
            [btn setTitle:@"到这去" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView=btn;//定义详情左侧视图
            annotationView.selected = YES;
        }
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=[UIImage imageNamed:@"common_map_site.png"];//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}

- (IBAction)onTurn:(id)sender {
    DIOpenSDKRegisterOptions *parms = [DIOpenSDKRegisterOptions new];
    parms.fromname = @"当前位置";
//    parms.fromaddr = @"上海市瑞金二路197号";
    parms.fromlat = _curLatitude;
    parms.fromlng = _curLongitude;
    
    parms.toname = _hospitalName;
//    parms.toaddr = @"上海市瑞金二路197号";
    parms.tolat = _hospitalLatitude;
    parms.tolng = _hospitalLongitude;
    parms.biz = @"1";
    parms.maptype = @"wgs84";
    [DIOpenSDK showDDPage:self animated:YES params:parms delegate:self];
}

-(void)turnAction:(id)sender{
    [self turnByTurn];
}
-(void)turnByTurn{
    NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    CLLocationCoordinate2D fromCoordinate   = CLLocationCoordinate2DMake(_curLatitude.floatValue,
                                                                       _curLongitude.floatValue);
    CLLocationCoordinate2D toCoordinate   = CLLocationCoordinate2DMake(_hospitalLatitude.floatValue,
                                                                       _hospitalLongitude.floatValue);
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    fromItem.name =@"当前位置";
    MKMapItem *toItem=[[MKMapItem alloc]initWithPlacemark:toPlacemark];
    toItem.name = _hospitalName;
    [MKMapItem openMapsWithItems:@[fromItem,toItem] launchOptions:options];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
