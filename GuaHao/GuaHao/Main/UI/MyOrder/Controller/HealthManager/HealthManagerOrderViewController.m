//
// HealthManagerOrderViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthManagerOrderViewController.h"
#import "UITableView+MJ.h"
#import "GHEmptyView.h"
#import "HealthManagerOrderCell.h"
#import "HealthManagerReportCell.h"
#import "HealthManagerOrderModel.h"
#import "HealthManagerReportModel.h"
#import "HtmlAllViewController.h"
@interface HealthManagerOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *myOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *myReportButton;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (assign, nonatomic) int pageNumber ;
@property (strong, nonatomic) GHEmptyView *emptyView;
@property (assign, nonatomic) int serviceType;

@end

@implementation HealthManagerOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康管理";
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 42, 28);
    [rightItemButton setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [rightItemButton setTitle:@"报告样式" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
    self.pageNumber = 1;
    self.sourceArr = [NSMutableArray array];
    self.serviceType = 1;
    self.rightLineView.hidden = YES;
    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [_tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}
- (IBAction)OrderAction:(UIButton *)sender {
    self.serviceType = 1;
    [self loadNewData];
    [self.myOrderButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.myReportButton setTitleColor:UIColorFromRGB(0xC1E3DA) forState:UIControlStateNormal];
    self.leftLineView.hidden = NO;
    self.rightLineView.hidden = YES;
    
}
- (IBAction)reportAction:(UIButton *)sender {
    self.serviceType = 2;
    [self loadNewData];
    [self.myOrderButton setTitleColor:UIColorFromRGB(0xC1E3DA) forState:UIControlStateNormal];
    [self.myReportButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    self.leftLineView.hidden = YES;
    self.rightLineView.hidden = NO;
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
    [[ServerManger getInstance] getHealthListOrderSize:6 page:self.pageNumber serviceType:self.serviceType andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    if (!isMore) {
                        [weakSelf.sourceArr removeAllObjects];
                    }
                    
                    NSArray * arr = data[@"object"];
                    if (weakSelf.serviceType == 1) {
                        for (int i = 0; i<arr.count; i++) {
                            HealthManagerOrderModel * order = [HealthManagerOrderModel mj_objectWithKeyValues:arr[i]];
                            [weakSelf.sourceArr addObject:order];
                        }

                    }else{
                        for (int i = 0; i<arr.count; i++) {
                            HealthManagerReportModel * order = [HealthManagerReportModel mj_objectWithKeyValues:arr[i]];
                            [weakSelf.sourceArr addObject:order];
                        }
                    }
                    
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
    if (self.serviceType == 1) {
        return 240;
    }else{
        return 130;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.serviceType == 1) {
        return 240;
    }else{
        return 130;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.serviceType == 1) {//我的订单
        __weak typeof(self) weakSelf = self;
        HealthManagerOrderModel *modle = [self.sourceArr objectAtIndex:indexPath.row];
        HealthManagerOrderCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"HealthManagerOrderCell"];
        [cell layoutSubviewsWith:modle];
        [cell clickAction:^(BOOL result) {
            if (modle.serviceType.intValue == 1) {
                HealthManagerOrderDetailViewController * orderDetialVC = [GHViewControllerLoader HealthManagerOrderDetailViewController];
                orderDetialVC.orderID = modle.id;
                [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
            }else{
                HealthManagerReportDetailViewController * reportDetialVC = [GHViewControllerLoader HealthManagerReportDetailViewController];
                reportDetialVC.orderID = modle.id;
                [weakSelf.navigationController pushViewController:reportDetialVC animated:YES];
            }
            
        }];
        return cell;
    }else{///我的报告
        __weak typeof(self) weakSelf = self;
        HealthManagerReportModel *modle = [self.sourceArr objectAtIndex:indexPath.row];
        HealthManagerReportCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"HealthManagerReportCell"];
        [cell layoutSubviewsWith:modle];
        [cell clickAction:^(BOOL result) {
            HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
            view.mTitle = @"我的报告";
            view.mUrl = modle.reportUrl;
            view.withoutToken = YES;
            [weakSelf.navigationController pushViewController:view animated:YES];
        }];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}
-(void)ruleAction{
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"示例报告";
    view.withoutToken = YES;
    view.mUrl = @"http://192.168.1.168:8080/htmldoc/reportTemplate.pdf";
    [self.navigationController pushViewController:view animated:YES];
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
