//
//  GHDisdcountListViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/5/4.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GHDisdcountListViewController.h"
#import "HDiscountListCell.h"
#import "UITableView+MJ.h"
#import "HtmlAllViewController.h"
@interface GHDisdcountListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (assign, nonatomic)int pageNumber ;

@end

@implementation GHDisdcountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 60, 30);
    [rightItemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightItemButton setTitle:@"使用说明" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)loadNewData{
    self.pageNumber = 1;
    [self getCoupon];
    
}
-(void)loadMoreData{
    self.pageNumber ++;
    [self getCoupon];
}

-(void) getCoupon
{
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getCouponslistPageNo:self.pageNumber andCallback:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (weakSelf.pageNumber == 1) {
                        [_tableView.mj_header endRefreshing];
                    }else{
                        [_tableView.mj_footer endRefreshing];
                        
                    }
                    if (arr.count > 0) {
                        if (weakSelf.pageNumber == 1) {
                            
                            weakSelf.sourceArr = [NSMutableArray array];
                            for (int i = 0; i<arr.count; i++) {
                                
                                UsedCouponsVO * vo = [UsedCouponsVO mj_objectWithKeyValues:arr[i]];
                                [weakSelf.sourceArr addObject:vo];
                            }
                            
                            [weakSelf.tableView reloadData];
                        }else{
                            
                            for (int i = 0; i<arr.count; i++) {
                                
                                UsedCouponsVO * vo = [UsedCouponsVO mj_objectWithKeyValues:arr[i]];
                                [weakSelf.sourceArr addObject:vo];
                            }
                            
                            [weakSelf.tableView reloadData];
                            
                        }
                        
                        
                        
                        
                        
                    }else{
                        [weakSelf inputToast:@"没有更多了"];
                    }
                    
                }
            }else{
                
            }
        }
    }];

    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HDiscountListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HDiscountListCell"];
    if(self.sourceArr.count >0){
        [cell setCell:self.sourceArr[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isExpert) {
        self.myAction(self.sourceArr[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)selectCouponAction:(CouponSelectAction)action{
    self.myAction = action;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ruleAction{
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"我的优惠券";
    view.mUrl = @"http://www.pjhealth.com.cn/htmldoc/couponsUrl.html";
    [self.navigationController pushViewController:view animated:YES];
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
