//
//  PonitViewController.m
//  GuaHao
//
//  Created by qiye on 16/6/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PonitViewController.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "PointVO.h"
#import "PonitTableViewCell.h"
#import "PointTicketTableCell.h"
#import "MyCouponsVO.h"
#import "DataManager.h"
#import "ExchangeDetailsVC.h"
#import "MyExchangeCouponsVO.h"
#import "MJRefresh.h"
#import "HtmlAllViewController.h"

@interface PonitViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PonitViewController{
    PointVO     * pointVO;
    MyCouponsVO * myCouponsVO;
    MyExchangeCouponsVO * myExchangeCouponsVO;
    BOOL  state;
    int page;
    NSMutableArray * myExchangeMuArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    myExchangeMuArray = [NSMutableArray new];
    self.navigationController.navigationBarHidden = NO;
    [self getInfoDesc];
    [self getOrders];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    state = YES;
    self.title = @"挂号豆专享";
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 80, 30);
    [rightItemButton setTitleColor:GHDefaultColor forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightItemButton setTitle:@"挂号豆明细>" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(exchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"PonitTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PonitTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PointTicketTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PointTicketTableCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ChangeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ChangeCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"RecordesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RecordesCell"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"ExchangeUpdate" object:nil];
}

-(void) getOrders
{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getMyExchangeCoupons:1000 page:1 andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                NSArray * arr = data[@"object"];
                for (int i = 0; i<arr.count; i++) {
                    MyExchangeCouponsVO * vo = [MyExchangeCouponsVO mj_objectWithKeyValues:arr[i]];
                    [myExchangeMuArray addObject:vo];
                }
                [_tableView reloadData];
            }else{
                [self inputToast:msg];
            }
        }
        
    }];

}

-(void)getInfoDesc
{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getPointInfo:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                pointVO = [PointVO mj_objectWithKeyValues:data[@"object"]];
                [_tableView reloadData];
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}

#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    pointVO.point = [DataManager getInstance].user.point;
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 470;
    }else {
        return 130;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        PonitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PonitTableViewCell"];
        if(pointVO){
            [cell setCell:pointVO];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        PointTicketTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PointTicketTableCell"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        [cell clickAction:^(BOOL result) {
            [self ruleAction];
        }];
        return cell;
    }
    return  nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        HtmlAllViewController *htmlVC = [[HtmlAllViewController alloc]init];
        htmlVC.mTitle = @"挂号豆商城";
        htmlVC.mUrl   = @"http://www.pjhealth.com.cn/wx/ExchangeMall/ExchangeMall.html";
        [self.navigationController pushViewController:htmlVC animated:YES];
    }
}
-(void)exchangeRecordBtn2{//兑换记录
    state = NO;
    [_tableView reloadData];
}
-(void)mallexchangeBtn3{//豆商城
    state = YES;
    [_tableView reloadData];
}
- (void)exchangeBtn:(id)sender {
    ExchangeDetailsVC * Excha=[[ExchangeDetailsVC alloc]init];
    [self.navigationController pushViewController:Excha animated:YES];
}
- (IBAction)onBack:(id)sender {
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
}
///挂号豆规则
- (void)ruleAction{
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"挂号豆规则";
    view.mUrl = pointVO.pointRuleUrl;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
