//
//  LocationViewController.m
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaceDetailVO.h"
#import "WGS84TOGCJ02.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "SiteVO.h"
#import "LocationTableViewCell.h"

@interface LocationViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView      * bgView;
@property (weak, nonatomic) IBOutlet UITableView * table;
@end

@implementation LocationViewController{
    CLLocationManager      * locManager;
    CLLocationCoordinate2D  _coordinate;
    PlaceDetailVO  * _place;
    NSMutableArray * sites;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"LocationViewController" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        sites = [NSMutableArray new];
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        locManager.distanceFilter = 1;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [locManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        }
        _coordinate = kCLLocationCoordinate2DInvalid;
        [_table registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LocationTableViewCell"];
        [self startLocation];
        
        UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
        [_bgView setUserInteractionEnabled:YES];
        [_bgView addGestureRecognizer:tapGuesture1];
    }
    return self;
}

- (void)startLocation
{
//    [self makeToastActivity:CSToastPositionCenter];
    sites = [NSMutableArray new];
    [locManager startUpdatingLocation];
}
- (void)stopLocation
{
    [locManager stopUpdatingLocation];
}

-(void) func1:(UITapGestureRecognizer *) tap{
    if (_delegate) {
        [_delegate takeOrderViewDelegate:nil];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self stopLocation];
    
    if (newLocation) {
        _coordinate = newLocation.coordinate;
        //判断是不是属于国内范围
        if (![WGS84TOGCJ02 isLocationOutOfChina:_coordinate]) {
            //转换后的coord
            _coordinate = [WGS84TOGCJ02 transformFromWGSToGCJ:_coordinate];
        }
        NSLog(@"locationManager location: %@", newLocation);
        
        [[ServerManger getInstance] getNearByHospitals:10 page:0 longitude:[NSString stringWithFormat:@"%f",_coordinate.longitude] latitude:[NSString stringWithFormat:@"%f",_coordinate.latitude]  andCallback:^(id data) {
            
            [self hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                 [self makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        NSArray * arr = data[@"object"];
                        for (int i = 0; i<arr.count; i++) {
                            SiteVO *vo = [SiteVO mj_objectWithKeyValues:arr[i]];
                            [sites addObject:vo];
                        }
                        [_table reloadData];
                    }
                }else{
                    
                }
            }
        }];
        

    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:didFailWithError  %@", error);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sites.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell"];
    if (sites.count>0) {
        [cell setCell:sites[indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate) {
        [_delegate takeOrderViewDelegate:sites[indexPath.row]];
    }
}

- (IBAction)onReset:(id)sender {
    [self startLocation];
}

@end
