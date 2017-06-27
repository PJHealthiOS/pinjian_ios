//
//  HealthTestListViewController.m
//  GuaHao
//
//  Created by PJYL on 16/10/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "HealthTestListViewController.h"
#import "HtmlAllViewController.h"
#import "HealthTestVO.h"
#import "UITableView+MJ.h"
#import "HealthTestCell.h"
@interface HealthTestListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_sourceArr;
    int pageNumber ;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HealthTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康评测";
    _sourceArr = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"HealthTestCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HealthTestCell"];
    [self setNavigationlefttItem];
    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [_tableView.mj_header beginRefreshing];
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
        pageNumber = 1;
    }else{
        pageNumber ++;
    }
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] gethealthTestPageDataSize:6 page:pageNumber andCallback:^(id data) {
        
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (!isMore) {
                        [_sourceArr removeAllObjects];
                    }
                    for (NSDictionary *dic in arr) {
                        HealthTestVO *vo = [HealthTestVO mj_objectWithKeyValues:dic];
                        [_sourceArr addObject:vo];
                    }
                    [self.tableView reloadData];
                    
                }else{

                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH *0.5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthTestVO *vo = [_sourceArr objectAtIndex:indexPath.row];
    HealthTestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HealthTestCell"];
    [cell layoutSubviews:vo];
    return cell;
}
-(void)setNavigationlefttItem{
    UIButton *inputCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inputCodeButton.frame = CGRectMake(0, 0, 30, 30);
    [inputCodeButton setBackgroundImage:[UIImage imageNamed:@"point_back.png"] forState:UIControlStateNormal];
    [inputCodeButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:inputCodeButton]];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}
-(void)backToHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthTestVO *vo = [_sourceArr objectAtIndex:indexPath.row];
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = vo.name;
    view.isTest = YES;
    view.mUrl = vo.linkUrl;
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
