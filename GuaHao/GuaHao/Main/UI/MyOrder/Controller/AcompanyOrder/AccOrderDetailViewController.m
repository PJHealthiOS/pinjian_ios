//
//  AccOrderDetailViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/10/21.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccOrderDetailViewController.h"
#import "AccOrderInfoCell.h"
#import "AccOrderTakeInfoCell.h"
#import "OrderStatusCell.h"
#import "AccDetialVO.h"
#import "UIViewController+BackButtonHandler.h"
#import "ZoomImageView.h"
@interface AccOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _infoCellHeight;
    AccDetialVO *_orderVO;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation AccOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoCellHeight = 470;
    self.title = @"陪诊详情";
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]getAccDetailOrderStatus:self.serialNo longitude:@"" latitude:@"" andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                _orderVO = [AccDetialVO mj_objectWithKeyValues:data[@"object"]];
                if (_orderVO.status.intValue == 9 || _orderVO.status.intValue == 10) {
                    self.tableViewBottom.constant = 0;
                    self.cancelButton.hidden = YES;
                    
                }else{
                    self.tableViewBottom.constant = 60;
                }
                [self.tableView reloadData];
            }else{
                [self inputToast:msg];
            }
        }
    }];

}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 170;
    }else if (indexPath.row == 1){
        return _infoCellHeight;
    }else if (indexPath.row == 2){
        return 350;
    }
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"OrderStatusCell";
        OrderStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:3];
        }

        if (_orderVO) {
            [OrderStatusCell AccrenderCell:cell order:_orderVO];
        }
        
        return cell;

    }else if (indexPath.row == 1){
        AccOrderInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccOrderInfoCell"];
        [cell layoutSubviews:_orderVO];
        __weak typeof(self) weakSelf = self;
        [cell openPriceDetial:^(BOOL open) {
            [weakSelf reload:open];
        }];
        return cell;
    }else{
        AccOrderTakeInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccOrderTakeInfoCell"];
        [cell layoutSubviews:_orderVO];
        return cell;
    }

    
    
}
-(void)reload:(BOOL)open{
    if (!open) {
        _infoCellHeight = 470;
    }else{
        _infoCellHeight = 630;
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelOrderAction:(UIButton *)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]cancelAccompanyOrder:_orderVO.id andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [self inputToast:@"取消订单成功!"];
                self.cancelButton.hidden = YES;
                self.tableViewBottom.constant = 0;
                sender.hidden = YES;
                [_tableView.mj_header beginRefreshing];
            }else{
                [self inputToast:msg];
            }
        }
    }];

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
#pragma mark - 二维码点击放大
- (IBAction)zoomImageAction:(UITapGestureRecognizer *)sender {
    ZoomImageView *zoomView = [[ZoomImageView alloc]initWithFrame:self.view.frame];
    [zoomView zoomImageWith:_orderVO.ticketQrcode];
    [self.view addSubview:zoomView];
}
- (IBAction)evaluateAction:(id)sender {
    if (_orderVO.status.intValue != 9) {
        return;
    }
    if (_orderVO.evaluated.intValue == 0) {
        EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
        evaluateVC._id = _orderVO.id;
        evaluateVC.orderType = [NSNumber numberWithInt:2];
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else{
        EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
        evaluateOKVC._id = _orderVO.id;
        evaluateOKVC.orderType = [NSNumber numberWithInt:2];
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
