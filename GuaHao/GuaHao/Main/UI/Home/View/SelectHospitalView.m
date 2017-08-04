//
//  
//  GuaHao
//
//  Created by qiye on 16/2/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SelectHospitalView.h"
#import "UIViewController+Toast.h"
#import "MJRefresh.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "HospitalMiniTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"

@interface SelectHospitalView ()<CLLocationManagerDelegate>
@end

@implementation SelectHospitalView{
    
    __weak IBOutlet UITableView *tableView;
    NSMutableArray * datas;
    int page ;
    CLLocationManager      * locManager;
    CLLocationCoordinate2D  _coordinate;
    NSString * longitude;
    NSString * latitude;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        UIView * containerView = [[[UINib nibWithNibName:@"SelectHospitalView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        [self initView];
    }
    return self;
}

-(void) initView{
    datas = [NSMutableArray new];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerNib:[UINib nibWithNibName:@"HospitalMiniTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HospitalMiniTableViewCell"];
    
    MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"已加载全部医院，将后续开通更多医院！" forState:MJRefreshStateNoMoreData];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = footer;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 1;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
    _coordinate = kCLLocationCoordinate2DInvalid;
    [locManager startUpdatingLocation];
}

-(void) loadNewData
{
    [self getHospitals:NO];
}

-(void) loadMoreData
{
    [self getHospitals:YES];
}

-(void) getHospitals:(BOOL) isMore
{
    if (!isMore) {
        [datas removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    
    [[ServerManger getInstance] getExpHospitals:@"" size:20 page:page longitude:longitude latitude:latitude andCallback:^(id data) {
        
        isMore?[tableView.mj_footer endRefreshing]:[tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (arr&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            HospitalVO *vo = [HospitalVO mj_objectWithKeyValues:arr[i]];
                            [datas addObject:vo];
                        }
                    }
                    if(arr.count==0){
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [tableView.mj_footer resetNoMoreData];
                    }
                }
                [tableView reloadData];
                
            }else{
//                [self inputToast:msg];
            }
        }
    }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locManager stopUpdatingLocation];
    
    if (newLocation) {
        _coordinate = newLocation.coordinate;
        //判断是不是属于国内范围
        if (![WGS84TOGCJ02 isLocationOutOfChina:_coordinate]) {
            //转换后的coord
            _coordinate = [WGS84TOGCJ02 transformFromWGSToGCJ:_coordinate];
        }
        NSLog(@"locationManager location: %@", newLocation);
        longitude = [NSString stringWithFormat:@"%f",_coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%f",_coordinate.latitude];
        [tableView.mj_header beginRefreshing];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    longitude = @"";
    latitude = @"";
    [tableView.mj_header beginRefreshing];
    NSLog(@"locationManager:didFailWithError  %@", error);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return datas.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HospitalMiniTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"HospitalMiniTableViewCell"];
    
    if (datas.count>0) {
        [cell setCell:indexPath.row == 0 ?nil:datas[indexPath.row-1]];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HospitalVO * vo = indexPath.row == 0 ?nil:datas[indexPath.row-1];
    if (_delegate) {
        [_delegate selectHospitalViewDelegate:vo];
    }
    [self removeFromSuperview];
}

@end
