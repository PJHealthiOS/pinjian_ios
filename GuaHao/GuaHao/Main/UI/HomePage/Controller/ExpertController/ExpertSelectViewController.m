//
//  ExpertSelectViewController.m
//  GuaHao
//
//  Created by qiye on 16/6/12.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExpertSelectViewController.h"
#import "MJRefresh.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "DoctorSelectTableViewCell.h"
#import "DoctorVO.h"
#import "ExpertInfomationViewController.h"
#import "SelectHospitalView.h"
#import "SelectDepartmentView.h"
#import "SelectDateView.h"
#import "SearchVO.h"

@interface ExpertSelectViewController ()<SelectDepartmentViewDelegate,SelectDateViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnHospital;
@property (weak, nonatomic) IBOutlet UIButton *btnDepartment;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *changeView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@end

@implementation ExpertSelectViewController{
    NSMutableArray * datas;
    NSMutableArray * searchData;
    int page ;
    int tagSelect;
    __strong SelectHospitalView * hospitalView;
    __strong SelectDepartmentView * departmentView;
    __strong SelectDateView * dateView;
    NSNumber * hospitalID;
    NSNumber * depaertmentID;
    ScheduleDateVO*  dateVO;
    UISearchDisplayController *searchDisplayController;
    int hosPage;
    BOOL isCancel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnUp.hidden = YES;
    datas = [NSMutableArray new];
    searchData = [NSMutableArray new];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView.mj_header beginRefreshing];
    
    searchDisplayController =  [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    [searchDisplayController.searchResultsTableView  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xtxxcell"];
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _searchBar.backgroundColor=[UIColor clearColor];
    for (UIView *view in self.searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    searchDisplayController.searchResultsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData2)];
    searchDisplayController.searchResultsTableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData2)];
}

#pragma mark  search start

-(void) loadNewData2
{
    [self geHospitals:NO content:_searchBar.text];
}

-(void) loadMoreData2
{
    
    [self geHospitals:YES content:_searchBar.text];
}

-(void) geHospitals:(BOOL) isMore content:(NSString*) txt
{
    if (!isMore) {
        [searchData removeAllObjects];
        hosPage = 1;
    }else{
        hosPage ++;
    }
    if(txt.length == 0){
        isMore?[searchDisplayController.searchResultsTableView.mj_footer endRefreshing]:[searchDisplayController.searchResultsTableView.mj_header endRefreshing];
        return;
    }
    [[ServerManger getInstance] getExpSearch:txt size:20 page:hosPage andCallback:^(id data) {
        
        isMore?[searchDisplayController.searchResultsTableView.mj_footer endRefreshing]:[searchDisplayController.searchResultsTableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if ((arr == nil||arr.count==0)&&!isMore) {
                        [self inputToast:@"没有搜索到相关医院！"];
                    }
                    for (int i = 0; i<arr.count; i++) {
                        SearchVO *hos = [SearchVO mj_objectWithKeyValues:arr[i]];
                        [searchData addObject:hos];
                    }
//                    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                    [searchDisplayController.searchResultsTableView reloadData];
                }
                
            }else{
                [self inputToast:msg];//高
            }
        }
    }];
}

#pragma mark 搜索框的代理方法，搜索输入框获得焦点（聚焦）
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = YES;
//    [searchDisplayController.searchResultsTableView.mj_header beginRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchDisplayController.searchResultsTableView.mj_header beginRefreshing];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if (!isCancel&&searchBar.text.length==0) {
        _searchBar.hidden = YES;
        _btnSearch.hidden = NO;
    }
    isCancel = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
//    [self.view endEditing:YES];
    [searchDisplayController.searchResultsTableView.mj_header beginRefreshing];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isCancel = YES;
    searchBar.text = @"";
    _searchBar.hidden = YES;
    _btnSearch.hidden = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
//    [searchBar resignFirstResponder];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark  search end

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void) loadNewData
{
    [self getDoctors:NO];
}

-(void) loadMoreData
{
    [self getDoctors:YES];
}

-(void) getDoctors:(BOOL) isMore
{
    if (!isMore) {
        [datas removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    
    [[ServerManger getInstance] getExpertDoctorList:hospitalID departmentID:depaertmentID filterDate:dateVO.scheduleDate apm:dateVO.apm type:dateVO.clinicType keywords:nil size:6 page:page andCallback:^(id data) {

        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
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
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == searchDisplayController.searchResultsTableView){
        return 44;
    }
    return 144;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == searchDisplayController.searchResultsTableView){
        return searchData.count;
    }
    return datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == searchDisplayController.searchResultsTableView){

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xtxxcell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:240.0f /255.0f blue:238.0f/255.0f alpha:1.0f];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        if(searchData.count>0){
            SearchVO * vo = searchData[indexPath.row];
            cell.textLabel.text = vo.name ;
            cell.textLabel.font =  [UIFont fontWithName:@"Arial" size:14.0f];
        }

        return cell;
    }
    
    DoctorSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
    if (datas.count>0) {
        [cell setCell:datas[indexPath.row]];
        _btnUp.hidden = indexPath.row < 9;
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == searchDisplayController.searchResultsTableView){
        if(searchData.count>0){
            SearchVO * vo = searchData[indexPath.row];
            if(vo.type.intValue == 1){
                
                ExpertInfomationViewController *view = [GHViewControllerLoader ExpertInfomationViewController ];
                
                view.doctorId = vo.id;
                [self.navigationController pushViewController:view animated:YES];
            }else{
                hospitalID = vo.id;
                depaertmentID = nil;
                dateVO = nil;
                HospitalVO * hosvo = [HospitalVO new];
                hosvo.id = vo.id;
                hosvo.name = vo.name;
                _searchBar.hidden = YES;
                _btnSearch.hidden = NO;
                [searchDisplayController setActive:NO];
                [self selectHospitalViewDelegate:hosvo];
            }
        }
    }else{
        if (datas.count > 0) {
            ExpertInfomationViewController *view = [GHViewControllerLoader ExpertInfomationViewController ];
            DoctorVO * vo = datas[indexPath.row];
            view.doctorId = vo.id;
            [self.navigationController pushViewController:view animated:YES];
        }
        
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSearch:(id)sender {
    _searchBar.hidden = NO;
    _btnSearch.hidden = YES;
    [searchDisplayController setActive:YES];
    [_searchBar becomeFirstResponder];
}

- (IBAction)onTypeChange:(id)sender {
    UIButton * btn = (UIButton*) sender;
//    if(tagSelect == btn.tag&&btn.selected ) return;
    tagSelect = (int)btn.tag;
    _btnHospital.selected = NO;
    _btnDepartment.selected = NO;
    _btnDate.selected = NO;
    btn.selected = YES;
    
    if(_changeView.subviews.count > 0)
    {
        [_changeView.subviews[0] removeFromSuperview];
    }
    switch (tagSelect) {
        case 101:
        {
            
            ChooseHospitalVC* hospitalVC = [[ChooseHospitalVC alloc]init];
            __weak typeof(self) weakSelf = self;
            hospitalVC.isPj = YES;
            hospitalVC.onBlockHospital = ^(HospitalVO * vo,DepartmentVO * dvo){
               
                [weakSelf selectHospitalViewDelegate:vo];
            };
            [self.navigationController pushViewController:hospitalVC animated:YES];
            

        }
            break;
        case 102:
        {
            if(hospitalID==nil){
                _btnDepartment.selected = NO;
                [self inputToast:@"请先选择医院～"];
                return;
            }
            _changeView.hidden = NO;
            if(departmentView == nil) {
                departmentView =  [[SelectDepartmentView alloc] initWithFrame:CGRectMake(0, 0, _changeView.width, _changeView.height)];
                departmentView.delegate = self;
            }
            departmentView.hospitalID = hospitalID;
            [departmentView updateView];
            departmentView.frame = _changeView.bounds;
            [_changeView addSubview:departmentView];
        }
            break;
        case 103:
        {
            if(dateView == nil) {
                dateView =  [[SelectDateView alloc] initWithFrame:CGRectMake(0, 0, _changeView.width, _changeView.height)];

                dateView.delegate = self;
            }
            dateView.hospitalID = hospitalID;
            dateView.departmentID = depaertmentID;
            [dateView updateView];
            _changeView.hidden = NO;
            dateView.frame = _changeView.bounds;
            [_changeView addSubview:dateView];
        }
            break;
            
        default:
            break;
    }
    
}

-(void) selectHospitalViewDelegate:(HospitalVO*) vo
{

    if(vo == nil){
        [_btnHospital setTitle:@"所有医院" forState:UIControlStateNormal];
        [_btnHospital setTitle:@"所有医院" forState:UIControlStateSelected];
    }else{
        [_btnHospital setTitle:vo.name forState:UIControlStateNormal];
        [_btnHospital setTitle:vo.name forState:UIControlStateSelected];
    }
    [_btnHospital setImage:nil forState:UIControlStateNormal];
    [_btnHospital setImage:nil forState:UIControlStateSelected];
    
    [_btnDepartment setTitle:@"科室" forState:UIControlStateNormal];
    [_btnDepartment setTitle:@"科室" forState:UIControlStateSelected];
    [_btnDepartment setImage:[UIImage imageNamed:@"order_expert_down_image0.png"] forState:UIControlStateNormal];
    [_btnDepartment setImage:[UIImage imageNamed:@"order_expert_up_images.png"] forState:UIControlStateSelected];
    
    [_btnDate setTitle:@"日期" forState:UIControlStateNormal];
    [_btnDate setTitle:@"日期" forState:UIControlStateSelected];
    [_btnDate setImage:[UIImage imageNamed:@"order_expert_down_image0.png"] forState:UIControlStateNormal];
    [_btnDate setImage:[UIImage imageNamed:@"order_expert_up_images.png"] forState:UIControlStateSelected];
    
    _btnHospital.selected = NO;
    _btnDepartment.selected = NO;
    _btnDate.selected = NO;
    _changeView.hidden = YES;
    hospitalID = vo.id;
    depaertmentID = nil;
    dateVO = nil;
    [_tableView.mj_header beginRefreshing];
}

-(void) selectDepartmentViewDelegate:(DepartmentVO*) vo
{
    [_btnDepartment setTitle:vo.name forState:UIControlStateNormal];
    [_btnDepartment setTitle:vo.name forState:UIControlStateSelected];
    [_btnDepartment setImage:nil forState:UIControlStateNormal];
    [_btnDepartment setImage:nil forState:UIControlStateSelected];
    
    [_btnDate setTitle:@"日期" forState:UIControlStateNormal];
    [_btnDate setTitle:@"日期" forState:UIControlStateSelected];
    [_btnDate setImage:[UIImage imageNamed:@"order_expert_down_image0.png"] forState:UIControlStateNormal];
    [_btnDate setImage:[UIImage imageNamed:@"order_expert_up_images.png"] forState:UIControlStateSelected];
    
    _btnHospital.selected = NO;
    _btnDepartment.selected = NO;
    _btnDate.selected = NO;
    _changeView.hidden = YES;
    depaertmentID = vo.id;
    dateVO = nil;
    [_tableView.mj_header beginRefreshing];
}

-(void) selectDateViewDelegate:(ScheduleDateVO*) vo
{
    NSString * date = [vo.scheduleDate substringWithRange:NSMakeRange(5,5)];
    [_btnDate setTitle:date forState:UIControlStateNormal];
    [_btnDate setTitle:date forState:UIControlStateSelected];
    [_btnDate setImage:nil forState:UIControlStateNormal];
    [_btnDate setImage:nil forState:UIControlStateSelected];
    _btnHospital.selected = NO;
    _btnDepartment.selected = NO;
    _btnDate.selected = NO;
    _changeView.hidden = YES;
    dateVO = vo;
    [_tableView.mj_header beginRefreshing];
}

- (IBAction)onUp:(id)sender {
    _btnUp.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
