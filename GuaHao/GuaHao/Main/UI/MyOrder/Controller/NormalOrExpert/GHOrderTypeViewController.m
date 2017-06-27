//
//  GHOrderTypeViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GHOrderTypeViewController.h"
#import "PersonCommonCell.h"
@interface GHOrderTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sourceArr;

@end

@implementation GHOrderTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCommonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCommonCell"];
    self.sourceArr = [NSMutableArray arrayWithObjects:@{@"title":@"普通挂号订单",@"icon":@"person_icon_order.png",@"number":@"2"},@{@"title":@"专家/特需订单",@"icon":@"person_icon_order.png"}, @{@"title":@"暖心陪诊订单",@"icon":@"person_icon_order.png"},@{@"title":@"重疾直通订单",@"icon":@"person_icon_order.png"},nil];

    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCommonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCommonCell"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [self.sourceArr objectAtIndex:indexPath.row ]];
    cell.isMyOrder = YES;
    [cell setCell:dic indexPth:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[@"normalOrder",@"expertOrder",@"AcceptOrder",@"seriousOrder",@"CreateSeriousOrder"];
    NSString *select = [arr objectAtIndex:indexPath.row];
    [self performSelectorOnMainThread:NSSelectorFromString(select) withObject:nil waitUntilDone:NO];
    
}
///普通
-(void)normalOrder{
    GHOrderController *order = [GHViewControllerLoader GHOrderController];
    order.isExpert = NO;
    [self.navigationController pushViewController:order animated:YES];

}
///专家
-(void)expertOrder{
    GHOrderController *order = [GHViewControllerLoader GHOrderController];
    order.isExpert = YES;
    [self.navigationController pushViewController:order animated:YES];
}
///陪诊
-(void)AcceptOrder{
    AccOrderListViewController *acc = [GHViewControllerLoader AccOrderListViewController];
    [self.navigationController pushViewController:acc animated:NO];
}
///重疾
-(void)seriousOrder{
    [self.navigationController pushViewController:[GHViewControllerLoader SeriousOrderListViewController] animated:NO];
}
///暂时的入口
-(void)CreateSeriousOrder{
    [self.navigationController pushViewController:[GHViewControllerLoader SeriousFlowViewController] animated:NO];
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
