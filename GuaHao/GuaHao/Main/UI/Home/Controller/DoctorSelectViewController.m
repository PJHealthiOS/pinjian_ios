//
//  DoctorSelectViewController.m
//  GuaHao
//
//  Created by qiye on 16/4/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "DoctorSelectViewController.h"
#import "MJRefresh.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "DoctorSelectTableViewCell.h"
#import "DoctorVO.h"
#import "ExpertInfomationViewController.h"

@interface DoctorSelectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@end

@implementation DoctorSelectViewController{
     NSMutableArray * datas;
    int page ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _labTitle.text = _department.name;
    datas = [NSMutableArray new];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView.mj_header beginRefreshing];
    if(_orderType != 2){
        _searchView.hidden = YES;
        _tableView.y = _tableView.y - 60;
        _tableView.height =  _tableView.height + 60;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void) loadNewData
{
    [self getWaiters:NO content:_searchBar.text];
}

-(void) loadMoreData
{
    [self getWaiters:YES content:_searchBar.text];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection=NO;
    self.tableView.scrollEnabled=NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    [self getWaiters:NO content:searchBar.text];
}

-(void) getWaiters:(BOOL) isMore content:(NSString*) content
{
    if (!isMore) {
        [datas removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    
    if(_orderType == 2){
        [[ServerManger getInstance] getExpDoctorList:_department.id content:content size:6 page:page andCallback:^(id data) {
            isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
            [self callbackGetDoctors:data];
        }];
    }else{
        [[ServerManger getInstance] getDoctorList:_department.id size:6 page:page andCallback:^(id data) {
            isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
            [self callbackGetDoctors:data];
        }];
    }
}

-(void) callbackGetDoctors:(id) data
{
    if (data!=[NSNull class]&&data!=nil) {
        NSNumber * code = data[@"code"];
        NSString * msg = data[@"msg"];
        if (code.intValue == 0) {
            if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                NSArray * arr = data[@"object"];
                if (arr&&arr.count>0) {
                    for (int i = 0; i<arr.count; i++) {
                        DoctorVO *vo = [DoctorVO mj_objectWithKeyValues:arr[i]];
                        [datas addObject:vo];
                    }
                }
                
                if (datas.count ==0) {
                    [self inputToast:@"没有搜索到相关医生！"];
                }
            }
            [_tableView reloadData];
            
        }else{
            [self inputToast:msg];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
    if (datas.count>0) {
      [cell setCell:datas[indexPath.row]];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorVO *vo = datas[indexPath.row];
    if(!vo){
        return;
    }
    if(_orderType == 2){
         ExpertInfomationViewController * view = [GHViewControllerLoader ExpertInfomationViewController];
        view.doctorId = vo.id;
        [self.navigationController pushViewController:view animated:YES];
    }else{
//        CreateOrderViewController * view = [[CreateOrderViewController alloc] init];
//        view.hospital = _hospital;
//        view.department = _department;
//        view.level = vo.outpatientType.integerValue;
//        [self.navigationController pushViewController:view animated:YES];
    }
}
#pragma mark - DoctorSelectDelegate
-(void) delegateDoctorSelect:(DoctorVO*) vo
{
    if(_orderType == 2){
        ExpertInfomationViewController * view = [GHViewControllerLoader ExpertInfomationViewController];
        view.doctorId = vo.id;
        [self.navigationController pushViewController:view animated:YES];
    }else{
//        CreateOrderViewController * view = [[CreateOrderViewController alloc] init];
//        view.hospital = _hospital;
//        view.department = _department;
//        view.level = vo.outpatientType.integerValue;
//        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
