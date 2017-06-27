//
//  ChooseHospitalVC.m
//  GuaHao
//
//  Created by 123456 on 16/1/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ChooseHospitalVC.h"
#import "ChooseHospitalcell.h"
#import "ChooseHospitalOnlineCell.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "HospitalVO.h"
#import "MJRefresh.h"
#import "ChooseDepartmentsVC.h"
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"
#import "MapViewController.h"
#import "SortSelectTableView.h"
#import "DataManager.h"
#import "GHLocationManager.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface ChooseHospitalVC (){
    
    NSMutableArray * hospitals;
    __weak IBOutlet UITableView *showHospitalTview;
    __weak IBOutlet UISearchBar *searchBar;
    int page ;
    
    int orderBy;
    NSString * regionId;
    NSString * longitude;
    NSString * latitude;
}
@property (weak, nonatomic) IBOutlet UIButton *LocationButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (nonatomic, strong)SortSelectTableView *locationSelectTableView;
@property (nonatomic, strong)SortSelectTableView *sortSelectTableView;
@property (nonatomic, strong)NSMutableArray *countyArray;

@end

@implementation ChooseHospitalVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"选择医院";
    self.navigationController.navigationBarHidden = NO;
}
- (IBAction)locationSelectAction:(UIButton *)sender {
    
    self.locationSelectTableView.hidden = sender.selected;
    sender.selected = !sender.selected;
    self.sortSelectTableView.hidden = YES;
    if (sender.selected) {
        [self getConty];

    }

    
    
    
}
- (IBAction)sortSelectAction:(UIButton *)sender {
    self.sortSelectTableView.hidden = sender.selected;
     sender.selected = !sender.selected;
    self.locationSelectTableView.hidden = YES;

    
}
-(void)getConty{
    
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getContyInfoWithCityCode:[DataManager getInstance].cityId andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (arr == nil||arr.count==0) {
                        [weakSelf inputToast:@"没有搜索到当前城市的区县！"];
                        
                    }else{
                        weakSelf.countyArray = [NSMutableArray arrayWithArray:arr];
                        
                        [weakSelf addCountyTableView];
                        
                    }

                }
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
        
    }];
    
    

    
}
-(void)addCountyTableView{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.countyArray) {
        [arr addObject:[dic objectForKey:@"name"]];
    }
    if (self.locationSelectTableView) {
        [self .locationSelectTableView reloadTableView:arr];
    }else{
      self.locationSelectTableView = [[SortSelectTableView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) sourceArray:arr];
    }
    
    self.locationSelectTableView.hidden = NO;

    __weak typeof(self) weakSelf= self;
    [self.locationSelectTableView cellClickAction:^(NSInteger index, BOOL select) {
        weakSelf.LocationButton.selected = NO;
        weakSelf.locationSelectTableView.hidden = YES;
        if (select) {
            NSLog(@"你选择了区----%@",[weakSelf.countyArray objectAtIndex:index]);
            [weakSelf.LocationButton setTitle:[NSString stringWithFormat:@"%@▼",[[weakSelf.countyArray objectAtIndex:index]objectForKey:@"name"]] forState:UIControlStateNormal];
            [weakSelf.LocationButton setTitle:[NSString stringWithFormat:@"%@▲",[[weakSelf.countyArray objectAtIndex:index]objectForKey:@"name"]] forState:UIControlStateSelected];
            if (regionId != [[weakSelf.countyArray objectAtIndex:index]objectForKey:@"id"]) {///如果条件变化了开始刷新
                regionId = [[weakSelf.countyArray objectAtIndex:index]objectForKey:@"id"];

                [weakSelf loadNewData];
            }
        }
        
        
    }];
    [self.view addSubview:self.locationSelectTableView];
}
-(void)addSortTableView{
    __weak typeof(self) weakSelf= self;
    
    self.sortSelectTableView = [[SortSelectTableView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) sourceArray:@[@"按预约量排序",@"按距离排序"]];
    [self.sortSelectTableView cellClickAction:^(NSInteger index, BOOL select) {
        if (select) {
            
            [weakSelf.sortButton setTitle:[NSString stringWithFormat:@"%@▼",index == 0 ? @"按预约量排序":@"按距离排序"] forState:UIControlStateNormal];
            [weakSelf.sortButton setTitle:[NSString stringWithFormat:@"%@▲",index == 0 ? @"按预约量排序":@"按距离排序"] forState:UIControlStateSelected];
            NSLog(@"你选择按----%ld",(long)index);
            if (index != orderBy) {///如果条件变化了开始刷新
                orderBy = index;
                [weakSelf loadNewData];
            }
        }
        weakSelf.sortSelectTableView.hidden = YES;
        weakSelf.sortButton.selected = NO;
        
        
    }];
    [self.view addSubview:self.sortSelectTableView];
    self.sortSelectTableView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
        
    
    self.navigationController.navigationBarHidden = NO;
    showHospitalTview.delegate=self;
    showHospitalTview.dataSource=self;
    hospitals = [NSMutableArray new];
    showHospitalTview.separatorStyle = UITableViewCellSelectionStyleNone;
    //注册单元格
    [showHospitalTview registerNib:[UINib nibWithNibName:@"ChooseHospitalOnlineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ChooseHospitalOnlineCell"];
    [showHospitalTview registerNib:[UINib nibWithNibName:@"ChooseHospitalcell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ChooseHospitalcellID"];
    MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"已加载全部医院，将陆续开通更多医院！" forState:MJRefreshStateNoMoreData];
    showHospitalTview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    showHospitalTview.mj_footer = footer;
    [showHospitalTview.mj_header beginRefreshing];

    ///定位
    [self addSortTableView];
    orderBy = 0;
//    __weak typeof(self) weakSelf= self;

    if ([DataManager getInstance].user.longitude.length < 3) {
        [[GHLocationManager shareLocation]getLocationInfo:^(BOOL success, NSString *_longitude, NSString *_latitude) {
            longitude = _longitude;
            latitude = _latitude;

        }];
        
    }else{
        longitude = [DataManager getInstance].user.longitude;
        latitude = [DataManager getInstance].user.latitude;
//        [showHospitalTview.mj_header beginRefreshing];

    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [self.view endEditing:YES];
            [showHospitalTview.mj_header beginRefreshing];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(void) loadNewData
{
    [self geHospitals:NO content:searchBar.text];
}

-(void) loadMoreData
{
    
    [self geHospitals:YES content:searchBar.text];
}

-(void) geHospitals:(BOOL) isMore content:(NSString*) txt
{
    if (!isMore) {
        [hospitals removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    NSString *serviceType = @"list";
    
    if (self.isAccompany) {
        serviceType = @"list4Pz";
    }

    if (self.isPj) {
        serviceType = @"list4Pj";
    }
    //[self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]getHospitals:txt serviceType:serviceType oppointment:self.isOppointment size:6 page:page longitude:longitude latitude:latitude orderBy:orderBy cityId:regionId andCallback: ^(id data) {
        //[self.view hideToastActivity];
        isMore?[showHospitalTview.mj_footer endRefreshing]:[showHospitalTview.mj_header endRefreshing];
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
                        HospitalVO *hos = [HospitalVO mj_objectWithKeyValues:arr[i]];
                        [hospitals addObject:hos];
                    }
                    [showHospitalTview reloadData];
                    if(arr.count==0){
                        [showHospitalTview.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [showHospitalTview.mj_footer resetNoMoreData];
                    }
                }
                
            }else{
                [self inputToast:msg];
            }
        }
        
    }];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return hospitals.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalVO *vo = nil;
    if (hospitals.count > indexPath.row) {
        vo = hospitals[indexPath.row];
        
    }
    if (vo.isOnlineQueue || self.isPj) {
        ChooseHospitalOnlineCell * orderCell = [tableView dequeueReusableCellWithIdentifier:@"ChooseHospitalOnlineCell"];
        if (hospitals.count>0) {
            HospitalVO *vo = hospitals[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [orderCell clickLocationAction:^(HospitalVO *hosVO) {
                [weakSelf chooseMap:hosVO];
            }];
            [orderCell setCell:vo];
        }
        orderCell.selectionStyle =UITableViewCellSelectionStyleNone;
        return orderCell;
    }else{
        ChooseHospitalcell * orderCell = [tableView dequeueReusableCellWithIdentifier:@"ChooseHospitalcellID"];
        if (hospitals.count>0) {
            HospitalVO *vo = hospitals[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [orderCell clickLocationAction:^(HospitalVO *hosVO) {
                [weakSelf chooseMap:hosVO];
            }];
            [orderCell setCell:vo];
        }
        orderCell.selectionStyle =UITableViewCellSelectionStyleNone;
        return orderCell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (hospitals.count>0) {
        HospitalVO *vo = hospitals[indexPath.row];
        if (_onBlockHospital) {
            _onBlockHospital(vo,nil);
            ChooseDepartmentsVC *view = [GHViewControllerLoader ChooseDepartmentsVC];
            view.isOppointment = self.isOppointment;
            view.hospital = vo;
            view.isChildren = _isChildren;
            view.popBackType = PopBackTwo;
            __weak typeof(self) weakSelf = self;
            view.onBlockDepartment = ^(DepartmentVO * dvo){
                weakSelf.onBlockHospital(vo,dvo);
            };
            if (!self.isCommon) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            [self.navigationController pushViewController:view animated:YES];
            }
        }
            
    }
}

-(void)chooseMap:(HospitalVO *)hosVO{
    MapViewController * view = [[MapViewController alloc]init];
    view.hospitalName = hosVO.name;
    view.hospitalLatitude = hosVO.latitude;
    view.hospitalLongitude = hosVO.longitude;
    view.curLatitude = latitude;
    view.curLongitude= longitude;
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
