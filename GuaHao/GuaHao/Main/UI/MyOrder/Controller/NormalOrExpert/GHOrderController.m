//
//  GHOrderController.m
//  GuaHao
//
//  Created by 123456 on 16/8/3.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHOrderController.h"
#import "GHOrderCell.h"
#import "OrderListVO.h"
#import "WGS84TOGCJ02.h"
#import "CreateOrderNormalViewController.h"
#import "ExpertSelectViewController.h"
#import "GHEmptyView.h"
#import "PayViewController.h"
#import "UITableView+MJ.h"
@interface GHOrderController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,LoginViewDelegate,EndCountdownDelegate>{
    int pageNumber ;
    OrderGetType mType;
    NSMutableArray * patients;
    NSMutableArray * orders;
    CLLocationManager      * locManager;
    CLLocationCoordinate2D  _coordinate;
    NSString * longitude;
    NSString * latitude;
    BOOL lastPage;
    GHEmptyView *_emptyView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)    NSTimer *countdownTimer;
@end
@implementation GHOrderController

-(NSTimer *)countdownTimer{
//    static NSTimer *countdownTimer = nil;
    
    if (!_countdownTimer) {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
        [_countdownTimer fire];
    }
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
//        [_countdownTimer fire];
//    }) ;
    return _countdownTimer;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrderListPage"];//("PageOne"为页面名称，可自定义)
    
    NSLog(@"UUUUUUUUUUU %@",[ServerManger getInstance].isExpert.stringValue);
    if ([ServerManger getInstance].isExpert && [ServerManger getInstance].isExpert.intValue == 1) {
        [ServerManger getInstance].isExpert = [NSNumber numberWithInt:0];
        [self popDescBack ];
    }
    [self getLocationInfo];
}
-(void)popDescBack
{

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderListPage"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self createCountdownTimer];//先创建一个定时器，需要倒计时时开启不需要时暂停，页面消失时注销
    mType = OrderConmmonGet;
    orders = [NSMutableArray array];
    self.title = self.isExpert ? @"专家/特需号" : @"普通号";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,nil]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"UserMSGUpdate" object:nil];

    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
}

-(void)getLocationInfo{
    [_tableView.mj_header beginRefreshing];

//    [[GHLocationManager shareLocation]getLocationInfo:^(BOOL success, NSString *_longitude, NSString *_latitude) {
//            longitude = _longitude;
//            latitude = _latitude;
//            [_tableView.mj_header beginRefreshing];
//    }];
}

#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    if (notification.userInfo != nil || notification.userInfo[@"extras"][@"type"] != nil ) {
        NSInteger  type = [notification.userInfo[@"extras"][@"type"] integerValue];
        if (type == 2 ||type == 3||type == 4||type == 6||type == 12||type == 13||(type>20&&type<27)) {
            [weakSelf getLocationInfo];
        }
    }
}

-(void) loginComplete
{
    if ([DataManager getInstance].user) {
        [_tableView.mj_header beginRefreshing];
    }
}

-(void) loadNewData
{
    [self getOrders:NO];
}

-(void) loadMoreData
{
    [self getOrders:YES];
}

-(void) getOrders:(BOOL) isMore
{
    if (!isMore) {
        pageNumber = 1;
    }else{
        pageNumber ++;
    }
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getOrders:self.isExpert ? 2:1 size:6 page:pageNumber longitude:longitude latitude:latitude andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (!isMore) {
                        [orders removeAllObjects];
                    }
                    for (int i = 0; i<arr.count; i++) {
                        OrderListVO * order = [OrderListVO mj_objectWithKeyValues:arr[i]];
                        [orders addObject:order];
                    }
                    [ServerManger getInstance].regTime = [Utils getCurrentSecond];
                    [_tableView reloadData];

                    if(orders.count == 0){
                        if (!_emptyView) {
                            _emptyView = [GHEmptyView emptyView];
                        }
                        [weakSelf.tableView addSubview:_emptyView];
                    }else{
                        [_emptyView removeFromSuperview];
                    }

                    
                }else{
                    [weakSelf inputToast:@"亲,您还没有挂号～"];
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}


-(void)clearList{
    orders = [NSMutableArray array];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return orders.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 195;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderListVO *order = [orders objectAtIndex:indexPath.row];
   
    GHOrderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHOrderCell"];
    
   [[NSNotificationCenter defaultCenter] removeObserver:cell name:@"payCountdown" object:nil];
    [cell setCellWithOrder:order indexPath:indexPath isHistory:self.isExpert];
    [cell countdownEnd:^(BOOL end, NSIndexPath *indexpath) {
    }];
    __weak typeof(self) weakSelf = self;
    [cell pay:^(BOOL end, NSIndexPath *indexpath) {
        [weakSelf payOrder:indexpath];
    }];
    [cell createOrderAgainBlock:^(NSIndexPath *indexPath) {//是否是普通号
        ///专家跳专家，普通跳普通
        if ((order.orderType.intValue == 0 ? YES : NO)) {
            CreateOrderNormalViewController *view = [GHViewControllerLoader CreateOrderNormalViewController];
            [weakSelf.navigationController pushViewController:view animated:YES];
        }else{
            ExpertSelectViewController *view = [[ExpertSelectViewController alloc]init];
            [weakSelf.navigationController pushViewController:view animated:YES];
        }
    }];
    [cell deleteRow:^(NSIndexPath *indexpath) {
        [weakSelf deleteRow:indexPath];
    }];
    ///评价回调
    [cell evaluateOrderAction:^(NSIndexPath *indexpath) {
        if (order.evaluated.intValue == 0) {
            EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
            evaluateVC._id = order.id;
            evaluateVC.orderType = [NSNumber numberWithInt:order.orderType.intValue];
            [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
        }else{
            EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
            evaluateOKVC._id = order.id;
            evaluateOKVC.orderType = [NSNumber numberWithInt:order.orderType.intValue];
            [weakSelf.navigationController pushViewController:evaluateOKVC animated:YES];
        }
    }];
    return cell;
}



-(void)deleteRow:(NSIndexPath *)indexPath{
    ///删除接口
    OrderListVO * order = [orders objectAtIndex:indexPath.row];
        [MobClick event:@"click33"];
        [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
        [[ServerManger getInstance] deleteOrder:order.id andNormalType:(order.orderType.intValue == 0 ? YES : NO) andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    [weakSelf inputToast:@"删除订单成功!"];
                    [_tableView.mj_header beginRefreshing];
                }else{
                    [weakSelf inputToast:msg];
                }
            }
        }];
}

-(void)cancelOrder{
}

-(void)payOrder :(NSIndexPath *)indexPath{
    //替换新代码
    PayViewController * view = [GHViewControllerLoader PayViewController];
    OrderListVO *order = [orders objectAtIndex:indexPath.row];
    if (order.orderType.intValue == 0) {
        view.isExpert = NO;
    }else{
        view.isExpert = YES;
    }
    view.orderID = order.id;
    
    [self.navigationController pushViewController:view animated:YES];
}

-(void)orderPayCompleteDelegate:(BOOL) sucess indexPath:(NSIndexPath *)indexPath
{
    if (sucess) {
        NSArray *indexArray=[NSArray  arrayWithObject:indexPath];
        OrderListVO * order = orders[indexPath.row];
        order.paymentStatus = [NSNumber numberWithInt:1];
        order.statusCn = @"待接单";
        orders[indexPath.row] = order;
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

//创建定时器
-(void)createCountdownTimer{

    _countdownTimer = [self countdownTimer];
    [_countdownTimer fire];
}
-(void)countdownEvent{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"payCountdown" object:nil];
//    NSLog(@"定时器再走---d");
}
-(void)countdownEventStop{
    _countdownTimer.fireDate = [NSDate distantPast];
}
-(void)countdownEventStart{
    _countdownTimer.fireDate = [NSDate distantFuture];
}
-(void)viewDidDisappear:(BOOL)animated{
    [_countdownTimer invalidate];

}
- (void)dealloc
{
    self.tableView = nil;
    self.countdownTimer  = nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isExpert) {
        GHExpertOrderDetialViewController *orderDetailVC = [GHViewControllerLoader GHExpertOrderDetialViewController];
        OrderListVO *order = [orders objectAtIndex:indexPath.row];
        orderDetailVC.orderNO = order.serialNo;
        orderDetailVC.postOrder = order;
        orderDetailVC.orderType = order.orderType.intValue;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else{
        GHNormalOrderDetialViewController *orderDetailVC = [GHViewControllerLoader GHNormalOrderDetialViewController];
        OrderListVO *order = [orders objectAtIndex:indexPath.row];
        orderDetailVC.orderNO = order.serialNo;
        orderDetailVC.postOrder = order;
        orderDetailVC.orderType = order.orderType.intValue;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    
}


@end
