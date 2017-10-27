//
//  GHAcceptOrderViewController.m
//  GuaHao
//
//  Created by PJYL on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHAcceptOrderViewController.h"
#import "GHAcceptOrderCell.h"
#import "GHAcceptDetailViewController.h"
#import "DataManager.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "UITableView+MJ.h"
#import "AcceptVO.h"
#import "GHEmptyView.h"
#import "GHHospitalChangeViewController.h"


@interface GHAcceptOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int page ;
    GHEmptyView *_emptyView;
    NSString * isShowAllData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *alterView;
@property (weak, nonatomic) IBOutlet UIImageView *IDCardImageUP;
@property (weak, nonatomic) IBOutlet UIImageView *IDCardImageDown;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (strong, nonatomic)    NSTimer *countdownTimer;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@end

@implementation GHAcceptOrderViewController
-(NSDictionary *)getdefaultSelectHospital{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultSelectHospital"];
    return dic;
    
}
-(NSTimer *)countdownTimer{
    static NSTimer *countdownTimer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
        [countdownTimer fire];

    }) ;
    return countdownTimer;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = NO;
    self.title = self.titleStr;
    
    self.sourceArr = [NSMutableArray array];
    page = 1;
    [self createCountdownTimer];
    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [_tableView.mj_header beginRefreshing];
}




-(void) loadNewData
{
    [self getWaiters:NO];
}

-(void) loadMoreData
{
    [self getWaiters:YES];
}

-(void) getWaiters:(BOOL) isMore
{
    if (!isMore) {
        [_sourceArr removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
            __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] myAcceptedOrders:6 page:page type:_contentType longitude:@"" latitude:@""  hospitalId: [DataManager getInstance].user.hospId ? [NSString stringWithFormat:@"%@" ,[DataManager getInstance].user.hospId]: @""    andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        AcceptVO *vo = [AcceptVO mj_objectWithKeyValues:arr[i]];
                        [_sourceArr addObject:vo];
                    }

                    
                }
                if(_sourceArr.count == 0){
                    if (!_emptyView) {
                        _emptyView = [GHEmptyView emptyView];
                    }
                    [weakSelf.tableView addSubview:_emptyView];
                    _emptyView.button.hidden = YES;
                    _emptyView.label.text = @"您还没有接到订单";
                }else{
                    [_emptyView removeFromSuperview];
                }

                [ServerManger getInstance].acceptTime = [Utils getCurrentSecond];
                [_tableView reloadData];
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.contentType == ContentType_order_Finish ? 190 : 250;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GHAcceptOrderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHAcceptOrderCell"];
    [[NSNotificationCenter defaultCenter] removeObserver:cell name:@"AcceptOrderpayCountdown" object:nil];
    if(_sourceArr.count > 0){
        if ( self.contentType == ContentType_order_Wanjia || self.contentType == ContentType_order_Company) {
            [cell setWJCell:_sourceArr[indexPath.row] indexPath:indexPath];

        }else{
            [cell setCell:_sourceArr[indexPath.row] type:_contentType indexPath:indexPath];

        }
        __weak typeof(self) weakSelf = self;
        cell.onBlockAccept = ^(int type ,NSNumber * orderID){
            if (weakSelf.contentType == ContentType_order_Wanjia || weakSelf.contentType == ContentType_order_Company) {
                [weakSelf operation:2 orderID:orderID];
            }else{
                [weakSelf onDealAcceptOrder:type orderID:orderID];
            }
        };
        [cell certificateBlock:^(AcceptVO *vo) {
            [weakSelf certificateAction:vo];
        }];
    }
    return cell;
}
////选中之前执行
//-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    AcceptVO * vo = _sourceArr[indexPath.row];
//    
//    if (vo.type.intValue == 1) {//普通号  ///订单挂号状态 1.待支付 2待接单 3待挂号 4待就诊   9已完成  10已取消
//        if (vo.status.intValue == 1) {
//            return nil;
//        }
//    }
//        return indexPath;
//    
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.contentType == ContentType_order_Wait) {
        
    }else if (self.contentType == ContentType_order_Wanjia) {
        GHAcceptWJDetailViewController *acceptDetailVC = [GHViewControllerLoader GHAcceptWJDetailViewController];
        //传值
        acceptDetailVC.order = _sourceArr[indexPath.row];
        [self.navigationController pushViewController:acceptDetailVC animated:YES];
    }else if (self.contentType == ContentType_order_Company) {
        GHAcceptCompanyDetailViewController *acceptDetailVC = [GHViewControllerLoader GHAcceptCompanyDetailViewController];
        //传值
        acceptDetailVC.order = _sourceArr[indexPath.row];
        [self.navigationController pushViewController:acceptDetailVC animated:YES];
    }else{
        GHAcceptDetailViewController *acceptDetailVC = [GHViewControllerLoader GHAcceptDetailViewController];
        //传值
        acceptDetailVC.order = _sourceArr[indexPath.row];
        [self.navigationController pushViewController:acceptDetailVC animated:YES];

    }
}
-(void)operation:(int)opID orderID:(NSNumber*) orderID{
    [self.view makeToastActivity:CSToastPositionCenter];
    if (self.contentType == ContentType_order_Company) {///企业订单
        [[ServerManger getInstance] companyOrderOperation:orderID operationID:[NSNumber numberWithInt:opID] andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                            if (code.intValue == 0) {
                [self getWaiters:NO];
                            }
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                
            }
        }];
    }else{
        [[ServerManger getInstance] wjOrderOperation:orderID operationID:[NSNumber numberWithInt:opID] andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                            if (code.intValue == 0) {
                [self getWaiters:NO];
                            }
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                
            }
        }];
    }

    
}
-(void)onDealAcceptOrder:(int)type orderID:(NSNumber*) orderID
{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    
    BOOL isnormal = type ==1;
    if (isnormal) {
        [[ServerManger getInstance] acceptOrder:orderID andCallback:^(id data) {
            
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [weakSelf inputToast:msg];
                [_tableView.mj_header beginRefreshing];
                if (code.intValue == 0) {
                    [weakSelf performSelector:@selector(takeOrderBack) withObject:nil afterDelay:1.0];
                }else{
                    
                }
            }
        }];

    }else{
        [[ServerManger getInstance] acceptExpertOrder:orderID andCallback:^(id data) {
            
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [weakSelf inputToast:msg];
                [_tableView.mj_header beginRefreshing];
                if (code.intValue == 0) {
                    [weakSelf performSelector:@selector(takeOrderBack) withObject:nil afterDelay:1.0];
                }else{
                    
                }
            }
        }];

    }
    
}

-(void)takeOrderBack{
    //弹出新界面
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"segueForAcceptDetailViewController"]) {
//        GHAcceptDetailViewController *acceptDetailVC = segue.destinationViewController;
//        //传值
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        acceptDetailVC.order = _sourceArr[indexPath.row];
//    }
//}


//创建定时器
-(void)createCountdownTimer{
    _countdownTimer = [self countdownTimer];
    [_countdownTimer fire];
}

-(void)countdownEvent{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AcceptOrderpayCountdown" object:nil];
//        NSLog(@"countdownEvent定时器再走---d");
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
    _countdownTimer  = nil;
}
////点击认证方法
- (IBAction)certificateAction:(AcceptVO *)sender {
    self.alterView.frame = [UIScreen mainScreen].bounds;
    self.alterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//    self.topSpace.constant = SCREEN_HEIGHT/6.0;
    if (sender.cardType.intValue == 2) {
        [self.IDCardImageUP sd_setImageWithURL:[NSURL URLWithString:sender.passportImg] placeholderImage:nil];
    }else{
        
        [self.IDCardImageUP sd_setImageWithURL:[NSURL URLWithString:sender.idcardFrontImg] placeholderImage:nil];
        [self.IDCardImageDown sd_setImageWithURL:[NSURL URLWithString:sender.idcardBackImg] placeholderImage:nil];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alterView];
    
}

- (IBAction)sureButtonAction:(id)sender {
    [self.alterView removeFromSuperview];
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
