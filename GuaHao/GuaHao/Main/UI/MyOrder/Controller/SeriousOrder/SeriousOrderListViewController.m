//
//  SeriousOrderListViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/2.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousOrderListViewController.h"
#import "UITableView+MJ.h"
#import "GHEmptyView.h"
#import "SeriousOrderDetailViewController.h"
#import "SeriousListCell.h"
#import "SeriousListModel.h"
@interface SeriousOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (assign, nonatomic) int pageNumber ;
@property (strong, nonatomic) GHEmptyView *emptyView;

@end

@implementation SeriousOrderListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重疾订单";
    self.pageNumber = 1;
    self.sourceArr = [NSMutableArray array];
    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
//    [_tableView.mj_header beginRefreshing];

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
    [[ServerManger getInstance] getSeriousListOrderSize:6 page:self.pageNumber longitude:@"" latitude:@"" andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (!isMore) {
                        [weakSelf.sourceArr removeAllObjects];
                    }
                    for (int i = 0; i<arr.count; i++) {
                        SeriousListModel * order = [SeriousListModel mj_objectWithKeyValues:arr[i]];
                        [weakSelf.sourceArr addObject:order];
                    }
                    [ServerManger getInstance].regTime = [Utils getCurrentSecond];
                    [_tableView reloadData];
                    
                    if(weakSelf.sourceArr.count == 0){
                        if (!_emptyView) {
                            _emptyView = [GHEmptyView emptyView];
                            _emptyView.button.hidden = YES;
                        }
                        [weakSelf.tableView addSubview:_emptyView];
                    }else{
                        [_emptyView removeFromSuperview];
                    }
                    
                    
                }else{
                    [weakSelf inputToast:@"亲,您还没有重疾订单～"];
                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SeriousListModel *order = [self.sourceArr objectAtIndex:indexPath.row];
    static NSString *_AccOrderListCellIdentifire = @"SeriousListCell";
    SeriousListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_AccOrderListCellIdentifire];
    [cell setCellWithModel:order];
    ///评价回调
    __weak typeof(self) weakSelf = self;
    [cell evaluateOrderAction:^(NSIndexPath *indexpath) {
        if (order.evaluated.intValue == 0) {
            EvaluateViewController *evaluateVC = [GHViewControllerLoader EvaluateViewController];
            evaluateVC._id = order.id;
            evaluateVC.orderType = [NSNumber numberWithInt:3];
            [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
        }else{
            EvaluateOKViewController *evaluateOKVC = [GHViewControllerLoader EvaluateOKViewController];
            evaluateOKVC._id = order.id;
            evaluateOKVC.orderType = [NSNumber numberWithInt:3];
            [weakSelf.navigationController pushViewController:evaluateOKVC animated:YES];
        }
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SeriousOrderDetailViewController *detailVC = [GHViewControllerLoader SeriousOrderDetailViewController];
    SeriousListModel *model = [self.sourceArr objectAtIndex:indexPath.row];
    detailVC.serialNo = model.serialNo;
    [self.navigationController pushViewController:detailVC animated:YES];
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
