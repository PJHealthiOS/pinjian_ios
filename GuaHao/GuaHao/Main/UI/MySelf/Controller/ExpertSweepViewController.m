
#import "ExpertSweepViewController.h"
#import "ExpertSweepCell.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "SweepVO.h"
#import "MJRefresh.h"

@interface ExpertSweepViewController (){
    
    NSMutableArray * hospitals;
    __weak IBOutlet UITableView *showHospitalTview;
    __weak IBOutlet UISearchBar *searchBar;
    int page ;
}

@end

@implementation ExpertSweepViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"待扫码订单";
    showHospitalTview.delegate=self;
    showHospitalTview.dataSource=self;
    hospitals = [NSMutableArray new];
    showHospitalTview.separatorStyle = UITableViewCellSelectionStyleNone;
    //注册单元格
    [showHospitalTview registerNib:[UINib nibWithNibName:@"ExpertSweepCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ExpertSweepCell"];
    MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"已加载全部医院，将陆续开通更多医院！" forState:MJRefreshStateNoMoreData];
    showHospitalTview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    showHospitalTview.mj_footer = footer;
    [showHospitalTview.mj_header beginRefreshing];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
    
    [[ServerManger getInstance] waiterOrders:txt size:6 page:page andCallback:^(id data) {
        
        isMore?[showHospitalTview.mj_footer endRefreshing]:[showHospitalTview.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (txt&&(arr == nil||arr.count==0)&&!isMore) {
                        [self inputToast:@"没有搜索到相关订单！"];
                    }
                    for (int i = 0; i<arr.count; i++) {
                        SweepVO *hos = [SweepVO mj_objectWithKeyValues:arr[i]];
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
    return 197;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return hospitals.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpertSweepCell * orderCell = [tableView dequeueReusableCellWithIdentifier:@"ExpertSweepCell"];
    if (hospitals.count>0) {
        SweepVO *vo = hospitals[indexPath.row];
        [orderCell setCell:vo];
    }
    orderCell.selectionStyle =UITableViewCellSelectionStyleNone;
    return orderCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (hospitals.count>0) {
        SweepVO *vo = hospitals[indexPath.row];
//        if (_onBlockHospital) {
//            _onBlockHospital(vo,nil);
//            ChooseDepartmentsVC * view = [[ChooseDepartmentsVC alloc]init];
//            view.hospital = vo;
//            [self.navigationController pushViewController:view animated:YES];
//        }
        
    }
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
