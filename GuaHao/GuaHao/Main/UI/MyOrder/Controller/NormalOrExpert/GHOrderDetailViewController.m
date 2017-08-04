//
//  GHOrderDetailViewController.m
//  GuaHao
//
//  Created by 123456 on 16/8/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHOrderDetailViewController.h"
#import "OrderStatusCell.h"
#import "OrderExpertInfoCell.h"
#import "OrderPayCell.h"
#import "OrderNormalInfoCell.h"
#import "OrderPayInfoCell.h"
#import "OrderAcceptCell.h"
#import "OrderPatientRemarkCell.h"
#import "GHOrderAlterViewController.h"
#import "OrderVO.h"
#import "OrderCancelView.h"
#import "PayViewController.h"
#import "CreateOrderNormalViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "GHOrderAccompanyCellCell.h"
#import "ZoomImageView.h"
@interface GHOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    BOOL   isRefresh;
    NSTimer *countdownTimer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (strong, nonatomic) NSMutableArray *hightArr;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (strong, nonatomic) NSMutableArray *cellTypeArr;
@property (strong, nonatomic) OrderVO *orderVO;
@property (assign,nonatomic) int payRemainingTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeftSpeace;
@property (strong, nonatomic)OrderCancelView *cancelView;
@property (assign, nonatomic) CGFloat patientInfoHeight;
@end

@implementation GHOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     if (self.orderType == 0) {//普通号
         self.hightArr = [NSMutableArray arrayWithObjects:@"170",@"330",@"90", nil];
         self.cellTypeArr = [NSMutableArray arrayWithObjects:@"0",@"1",@"4", nil];
     }else{
         self.hightArr = [NSMutableArray arrayWithObjects:@"170",@"360",@"80",@"90", nil];
         self.cellTypeArr = [NSMutableArray arrayWithObjects:@"0",@"1",@"7",@"4", nil];
     }
    
    self.sourceArr = [NSMutableArray array];
    
    [self setState];
}

-(void) setState
{
    if (self.orderType == 0) {//普通号
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] getOrderStatus:_orderNO longitude:@"" latitude:@"" andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    _orderVO = [OrderVO mj_objectWithKeyValues:data[@"object"]];
                    if (self.orderType == 0) {//普通号
                        [self.cellTypeArr replaceObjectAtIndex:1 withObject:@"2"];
                        [self.hightArr replaceObjectAtIndex:1 withObject:@"300"];
                    }
                    [self changeBottomView];
                    
                    if (_orderVO.status.intValue == 1) {
                        [self createCountdownTimer];
                        self.payRemainingTime = _orderVO.payRemainingTime.intValue;
                    }else{
                        [self removeCountdownTimer];
                    }
                    [self changeOrderAlter];//进来时弹框
                    [ServerManger getInstance].descTime = [Utils getCurrentSecond];
                    [_tableView reloadData];
                    //                [self updateViewCell];
                    if (isRefresh) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderCellUpdate" object:_orderVO];
                        isRefresh = NO;
                        
                    }
                }else{
                    [self inputToast:msg];
                }
            }
        }];

    }else{
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] getOrderExpertStatus:_orderNO longitude:@"" latitude:@"" andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    _orderVO = [OrderVO mj_objectWithKeyValues:data[@"object"]];
                    if (self.orderType == 0) {//普通号
                        [self.cellTypeArr replaceObjectAtIndex:1 withObject:@"2"];
                        [self.hightArr replaceObjectAtIndex:1 withObject:@"300"];
                    }
                    [self changeBottomView];
                    
                    if (_orderVO.status.intValue == 2) {
                        [self createCountdownTimer];
                        self.payRemainingTime = _orderVO.payRemainingTime.intValue;
                    }else{
                        [self removeCountdownTimer];
                    }
                    [self changeOrderAlter];//进来时弹框
                    
                    [ServerManger getInstance].descTime = [Utils getCurrentSecond];
                    [_tableView reloadData];
                    //                [self updateViewCell];
                    if (isRefresh) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderCellUpdate" object:_orderVO];
                        isRefresh = NO;
                        
                    }
                }else{
                    [self inputToast:msg];
                }
            }
        }];

    }
    
}
-(void)changeOrderAlter{
    NSString *message = @"";
    NSString *sure = @"确定";
    NSString *cancel = @"取消";
    if (!_orderVO.acceptorOperation || _orderVO.acceptorOperation.intValue == 0) {
        return;
    }
    if (self.orderType == 0) {//普通号
        switch (_orderVO.acceptorOperation.intValue) {
            case 1:
            {
                message = @"转上午普通专家号";
            }
                break;
            case 2:
            {
                message = @"转下午普通专家号";
            }
                break;
            case 3:
            {
                message = @"转下午普通号";
            }
                break;
            case 4:
            {
                message = @"今日号满";
                cancel = nil;
            }
                break;
            case 5:
            {
                message = @"转预约";
            }
                break;
            case 6:
            {
                message = @"转挂号";
            }
                break;
            default:
                break;
        }
        
    }else{
        if (_orderVO.acceptorOperation.intValue == 1) {
            message = @"今日停诊";
            cancel = nil;
        }
    }
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:sure, nil];
    [alterView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *accept = @"";
    if (buttonIndex == 1) {
        accept = @"1";
    }else{
        accept = @"0";
    }
    ///普通号 1.转上午普通专家号 2.转下午普通专家号  3转下午普通号 4今日号满 5挂号转预约   6预约转挂号；
    if (_orderVO.acceptorOperation.intValue == 4) {///号满
        accept = @"1";
    }
    if (self.orderType == 0) {//普通号
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance]acceptChangeNormalOrder:_orderVO.id accept:accept andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
//                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
            }
        }];
    }else{
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance]acceptChangeExpertOrder:_orderVO.id accept:@"1" andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                //                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
            }
        }];
    }
}
-(void)changeOrderCallBack:(BOOL)agree{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_orderVO) {
        return 0;
    }
    return self.hightArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.hightArr objectAtIndex:indexPath.row]intValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   return [self returnCellType:[[self.cellTypeArr objectAtIndex:indexPath.row]intValue] andSource:@[] indexPath:indexPath];
}
-(UITableViewCell *)returnCellType:(NSInteger)cellType andSource:(NSArray *)source indexPath:(NSIndexPath *)indexPath{
    switch (cellType) {
        case 0:
        {
            static NSString *cellIdentifier = @"OrderStatusCell";
            OrderStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            
            if (cell == nil) {
                
                cell = [[OrderStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:_orderVO.statusLogs.count];;
            }
           
            if (_orderVO) {
                [OrderStatusCell renderCell:cell order:_orderVO];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            OrderExpertInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderExpertInfoCell"];
            if (_orderVO)[OrderExpertInfoCell renderCell:cell order:_orderVO];
            [cell openPatientInfo:^(BOOL end) {
                if (self.orderType == 0) {
                    if (end) {
                        [self.hightArr insertObject:@"100" atIndex:2];
                        [self.cellTypeArr insertObject:@"3" atIndex:2];
                        [self.tableView reloadData];
                    }else{
                        [self.hightArr removeObjectAtIndex:2];
                        [self.cellTypeArr removeObjectAtIndex:2];
                        [self.tableView reloadData];
                    }
                }else{
                    PatientRemarkViewController *PRVC = [GHViewControllerLoader PatientRemarkViewController];
                    PRVC.str = _orderVO.patientComments;
                    PRVC.arrStr = _orderVO.commentImgs;
                    [self.navigationController pushViewController:PRVC animated:YES];
                    
                }

            }];
            
            return cell;
        }
            break;
        case 2:
        {
            OrderNormalInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderNormalInfoCell"];
            if (_orderVO)[OrderNormalInfoCell renderCell:cell order:_orderVO];
            self.patientInfoHeight = [self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 0) str: _orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments fount:14].height;
            
            [cell openPatientInfo:^(BOOL end) {
                
                    if (end) {
                        [self.hightArr insertObject:[NSString stringWithFormat:@"%f",self.patientInfoHeight + 20] atIndex:2];
                        [self.cellTypeArr insertObject:@"3" atIndex:2];
                        [self.tableView reloadData];
                    }else{
                        [self.hightArr removeObjectAtIndex:2];
                        [self.cellTypeArr removeObjectAtIndex:2];
                        [self.tableView reloadData];
                    }
   
                
            }];
            return cell;
        }
            break;
        case 3:
        {
            
            OrderPatientRemarkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderPatientRemarkCell"];
            if (_orderVO){
                
                [OrderPatientRemarkCell renderCell:cell source:@[_orderVO.patientComments.length == 0 ? @"无" : _orderVO.patientComments]];
            }
            
            return cell;
        }
            break;
        case 4:
        {
            OrderPayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderPayCell"];
            NSString *str = [NSString stringWithFormat:@"%@",_orderVO.totalFee];
            if (_orderVO)[OrderPayCell renderCell:cell source:@[IS_String(str),_orderVO.payType]];
            [cell openPayInfo:^(BOOL end) {
                NSInteger index = [self.cellTypeArr indexOfObject:@"4"]+1;
                if (end) {
                    [self.hightArr insertObject:@"240" atIndex:index];
                    [self.cellTypeArr insertObject:@"5" atIndex:index];
                    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
                    [self.tableView reloadData];
                }else{
                    [self.hightArr removeObjectAtIndex:index];
                    [self.cellTypeArr removeObjectAtIndex:index];
                    [self.tableView reloadData];
                }
            }];
            return cell;
        }
            break;
        case 5:
        {
            OrderPayInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderPayInfoCell"];
            
            if (_orderVO)[OrderPayInfoCell renderCell:cell order:_orderVO];
            
            return cell;
        }
            break;
        case 6:
        {
            OrderAcceptCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderAcceptCell"];
            if (_orderVO)[OrderAcceptCell renderCell:cell order:_orderVO];
            
            return cell;
        }
            break;
        case 7:
        {
            GHOrderAccompanyCellCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHOrderAccompanyCellCell"];
            if (_orderVO)[cell layoutSubviews:_orderVO.serviceTypeCn take:_orderVO.transferTypeCn address:[NSString stringWithFormat:@"%@ 元",_orderVO.serviceFee]];
            
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}


//创建定时器
-(void)createCountdownTimer{
    
    if (!countdownTimer) {
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
        [countdownTimer fire];
    }
}
-(void)removeCountdownTimer{
    
}
-(void)countdownEvent{
    self.payRemainingTime -- ;
    if (self.payRemainingTime <= 0) {
        [self countdownEventStop];
    }
    [self returnCountStr:self.payRemainingTime];
    //    NSLog(@"定时器再走---d");
}
-(void)returnCountStr:(int)time{
    //    NSLog(@"------------------------%d",time);
    int minute = time /60 ;
    int second = time %60 ;
    NSString * str = [NSString stringWithFormat:@"去支付(还剩%02d分%02d秒)",minute,second];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, str.length - 3 )];
    [self.payBtn setAttributedTitle:attStr forState:UIControlStateNormal];
}
-(void)countdownEventStop{
    countdownTimer = nil;
    countdownTimer.fireDate = [NSDate distantPast];
}
-(void)countdownEventStart{
    countdownTimer.fireDate = [NSDate distantFuture];
}




-(void)changeBottomView{
    //如果待挂号就显示接单这信息
    if (_orderVO.acceptorMobile.length > 8) {
        if ([self.cellTypeArr indexOfObject:@"6"] == NSNotFound) {
            [self.cellTypeArr addObject:@"6"];
            [self.hightArr addObject:@"350"];
        }
        
    }
    
    
    ///1 未支付时显示取消和去支付两个按钮
    // 2 只显示取消
    //9.10 显示删除订单 和 再来一单
    /// 普通号   订单挂号状态 1.待支付 2待接单 3待挂号 4待就诊   9已完成  10已取消
    //1.专家号    1已提交待确认 2已确认待支付  3待就诊   9已完成  10已取消    订单接单状态   2待上传 3 待审核  4 审核失败 9已完成  10已取消
    
    
    if (self.orderType == 0) {//普通号
        switch (_orderVO.status.intValue) {
            case 1:
            {
                
            }
                break;
                
            case 9:
            {
                [self.cancelOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];[self.payBtn setTitle:@"再次挂号" forState:UIControlStateNormal];
            }
                break;
                
            case 10:
            {
                [self.cancelOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];[self.payBtn setTitle:@"再次挂号" forState:UIControlStateNormal];
            }
                break;
                
            default:{
                self.cancelButtonLeftSpeace.constant = SCREEN_WIDTH - 100 - 25;
                [self.cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            }
                break;
        }

    }else{//专家号
        switch (_orderVO.status.intValue) {
            case 2:
            {
                
            }
                break;
                
            case 9:
            {
                [self.cancelOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];[self.payBtn setTitle:@"再次挂号" forState:UIControlStateNormal];
            }
                break;
                
            case 10:
            {
                [self.cancelOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];[self.payBtn setTitle:@"再次挂号" forState:UIControlStateNormal];
                self.payBtn.hidden = YES;
            }
                break;
                
            default:{
                self.cancelButtonLeftSpeace.constant = SCREEN_WIDTH - 100 - 25;
                [self.cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            }
                break;
        }

    }
}

- (IBAction)cancelOrderAction:(UIButton *)sender {
    NSLog(@"取消订单");

    if (_orderVO.status.intValue == 9 || _orderVO.status.intValue == 10) {
        [self deleteOrder];
    }else{
        [self cancelOrder];
    }
    

}

-(void)cancelOrder{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] cancelOrder:_orderVO.id andNormalType:(self.orderType == 0 ? YES : NO) andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [self inputToast:@"取消订单成功!"];
                 [self setState];
                [_tableView.mj_header beginRefreshing];
            }else{
                [self inputToast:msg];
            }
        }
    }];
}
-(void)deleteOrder{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] deleteOrder:_orderVO.id andNormalType:(self.orderType == 0 ? YES : NO) andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [self inputToast:@"删除订单成功!"];
               
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self inputToast:msg];
            }
        }
    }];

}

-(void)createOrderAgain{
    CreateOrderNormalViewController *view = [GHViewControllerLoader CreateOrderNormalViewController];
    [self.navigationController pushViewController:view animated:YES];

}

- (IBAction)payAction:(UIButton *)sender {
    if (_orderVO.status.intValue == 9 || _orderVO.status.intValue == 10) {
        [self createOrderAgain];
    }
    
   if (self.orderType == 0) {//普通号
       if (_orderVO.status.intValue == 1) {
           PayViewController * view = [GHViewControllerLoader PayViewController];
           view.orderID = _orderVO.id;
           if ([_orderVO.outpatientType isEqualToString:@"普通号"]) {
               view.isExpert = NO;
           }else{
               view.isExpert = YES;
           }
           
           [self.navigationController pushViewController:view animated:YES];
           
       }
   }else{
       if (_orderVO.status.intValue == 2) {
           PayViewController * view = [GHViewControllerLoader PayViewController];
           view.orderID = _orderVO.id;
           if ([_orderVO.outpatientType isEqualToString:@"普通号"]) {
               view.isExpert = NO;
           }else{
               view.isExpert = YES;
           }
           
           [self.navigationController pushViewController:view animated:YES];
           
       }
   }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    if (countdownTimer) {
        [countdownTimer invalidate];
        countdownTimer  = nil;
    }
    
}

-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    //这里写要处理的代码
    NSArray *viewControllers = self.navigationController.viewControllers;
    if(!_popBack||_popBack==0){
        _popBack = PopBackDefalt;
    }
    NSUInteger num = viewControllers.count - _popBack;
    if(_popBack == PopBackRoot){
        num = 0;
    }
    [self.navigationController popToViewController:[viewControllers objectAtIndex:num] animated:YES];
    return YES;//返回NO 不会执行
    
}
- (CGSize)boundingRectWithSize:(CGSize)size str:(NSString *)str fount:(CGFloat)fount
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fount]};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
}

#pragma mark - 二维码点击放大
- (IBAction)zoomImageAction:(UITapGestureRecognizer *)sender {
    ZoomImageView *zoomView = [[ZoomImageView alloc]initWithFrame:self.view.frame];
    [zoomView zoomImageWith:_orderVO.getTicketQRCode];
    [self.view addSubview:zoomView];
}
#pragma mark - 评价
- (IBAction)evaluateAction:(id)sender {
    if (_orderVO.status.intValue != 9) {
        return;
    }
    if (_orderVO.evaluated.intValue == 0) {
        EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
        evaluateVC._id = _orderVO.id;
        evaluateVC.orderType = [NSNumber numberWithInt:self.orderType];
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else{
        EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
        evaluateOKVC._id = _orderVO.id;
        evaluateOKVC.orderType = [NSNumber numberWithInt:self.orderType];
        [self.navigationController pushViewController:evaluateOKVC animated:YES];
    }
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
