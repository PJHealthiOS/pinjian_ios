//
//  AccOrderListViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/10/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccOrderListViewController.h"
#import "UITableView+MJ.h"
#import "AccOrderListCell.h"
#import "PayViewController.h"
#import "GHEmptyView.h"
#import "AccOrderDetailViewController.h"
@interface AccOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)    NSTimer *countdownTimer;
@property (strong, nonatomic)NSMutableArray  *orders;
@property (strong, nonatomic)GHEmptyView *_emptyView;
@property (assign, nonatomic)int pageNumber ;

@end

@implementation AccOrderListViewController
-(NSTimer *)countdownTimer{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
        [_countdownTimer fire];
        
    }) ;
    return _countdownTimer;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orders = [NSMutableArray array];
    self.title = @"陪诊预约";
    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [_tableView.mj_header beginRefreshing];
    [self createCountdownTimer];//先创建一个定时器，需要倒计时时开启不需要时暂停，页面消失时注销
    // Do any additional setup after loading the view.
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
        self.pageNumber = 1;
    }else{
        self.pageNumber ++;
    }
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getAccompanyListOrderSize:6 page:self.pageNumber longitude:@"" latitude:@"" andCallback:^(id data) {

        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (!isMore) {
                        [weakSelf.orders removeAllObjects];
                    }
                    for (int i = 0; i<arr.count; i++) {
                        OrderListVO * order = [OrderListVO mj_objectWithKeyValues:arr[i]];
                        [weakSelf.orders addObject:order];
                    }
                    [ServerManger getInstance].regTime = [Utils getCurrentSecond];
                    [_tableView reloadData];
                    
                    if(weakSelf.orders.count == 0){
                        if (!weakSelf._emptyView) {
                            weakSelf._emptyView = [GHEmptyView emptyView];
                            weakSelf._emptyView.button.hidden = YES;
                        }
                        [weakSelf.tableView addSubview:weakSelf._emptyView];
                    }else{
                        [weakSelf._emptyView removeFromSuperview];
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

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListVO *order = [self.orders objectAtIndex:indexPath.row];
    static NSString *_AccOrderListCellIdentifire = @"AccOrderListCell";
    AccOrderListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_AccOrderListCellIdentifire];
    [[NSNotificationCenter defaultCenter] removeObserver:cell name:@"payCountdown" object:nil];
    __weak typeof(self) weakSelf = self;
    [cell layoutSubviews:order andIndexPath:indexPath];
    [cell deleteRow:^(NSIndexPath *indexpath) {
        [weakSelf deleteRow:indexPath];
    }];
    [cell pay:^(BOOL end, NSIndexPath *indexpath) {
        [weakSelf payOrder:indexpath];
    }];
    ///评价回调
    [cell evaluateOrderAction:^(NSIndexPath *indexpath) {
        if (order.evaluated.intValue == 0) {
            EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
            evaluateVC._id = order.id;
            evaluateVC.orderType = [NSNumber numberWithInt:2];
            [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
        }else{
            EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
            evaluateOKVC._id = order.id;
            evaluateOKVC.orderType = [NSNumber numberWithInt:2];
            [weakSelf.navigationController pushViewController:evaluateOKVC animated:YES];
        }
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //传值
    OrderListVO *order = [self.orders objectAtIndex:indexPath.row];
    if (order.pzType.intValue == 0) {
        AccOrderDetailViewController *orderDetailVC = [GHViewControllerLoader AccOrderDetailViewController];
        orderDetailVC.serialNo = order.serialNo;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else{
        AccNewOrderDetailViewController *orderDetailVC = [GHViewControllerLoader AccNewOrderDetailViewController];
        orderDetailVC.serviceType = order.pzType.intValue;
        orderDetailVC.serialNo = order.serialNo;
        [self.navigationController pushViewController:orderDetailVC animated:YES];

    }
}
-(void)payOrder :(NSIndexPath *)indexPath{
    //替换新代码
    PayViewController * view = [GHViewControllerLoader PayViewController];
    OrderListVO *order = [self.orders objectAtIndex:indexPath.row];
    view.orderID = order.id;
    view.isAccompany = YES;
    [self.navigationController pushViewController:view animated:YES];
}
-(void)deleteRow:(NSIndexPath *)indexPath{
    ///删除接口
    OrderListVO * order = [self.orders objectAtIndex:indexPath.row];
    [MobClick event:@"click33"];
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] deleteOrder:order.id andNormalType:(order.orderType.intValue == 0 ? YES : NO) andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
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


//创建定时器
-(void)createCountdownTimer{
    _countdownTimer = [self countdownTimer];
    [_countdownTimer fire];
}

-(void)countdownEvent{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AccpayCountdown" object:nil];
        NSLog(@"定时器再走---d");
}
-(void)countdownEventStop{
    self.countdownTimer.fireDate = [NSDate distantPast];
}
-(void)countdownEventStart{
    self.countdownTimer.fireDate = [NSDate distantFuture];
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.myBlock(YES);
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"segueForAccOrderDetailViewController"]) {
//        AccOrderDetailViewController *orderDetailVC = segue.destinationViewController;
//        //传值
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        OrderListVO *order = [orders objectAtIndex:indexPath.row];
//        orderDetailVC.serialNo = order.serialNo;
////        orderDetailVC.postOrder = order;
////        orderDetailVC.orderType = order.orderType.intValue;
//    }
//}
- (void)dealloc
{
    self.countdownTimer  = nil;
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.countdownTimer invalidate];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
