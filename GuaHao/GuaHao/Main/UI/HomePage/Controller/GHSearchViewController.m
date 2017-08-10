//
//  GHSearchViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/8.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHSearchViewController.h"
#import "GHSearchBar.h"
#import "DoctorSelectTableViewCell.h"
#import "DoctorVO.h"
#import "ExpertInfomationViewController.h"
#import "GHEmptyView.h"
@interface GHSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
        int hosPage;
        GHEmptyView *_emptyView;
}
@property (nonatomic,strong) GHSearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];
    self.sourceArr = [NSMutableArray array];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.searchBar = [[GHSearchBar alloc]initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 70, 30)  isHome:NO];
    [self.searchBar setCancelButtonTitle:@"搜索医生" setPlaceholder:@"搜索医院、科室、医生"];
    self.searchBar.delegate = self;
    [self.topView addSubview:self.searchBar];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [_searchBar becomeFirstResponder];
    

}
-(void) loadNewData
{
     [self geHospitals:NO content:_searchBar.text];
}

-(void) loadMoreData
{
    [self geHospitals:YES content:_searchBar.text];
}
-(void) geHospitals:(BOOL) isMore content:(NSString*) txt
{
    if (!isMore) {
        hosPage = 1;
    }else{
        hosPage ++;
    }
    if(txt.length == 0){
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        return;
    }
    [[ServerManger getInstance]getExpSearchInHomage:txt size:6 page:hosPage andCallback:^(id data) {
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if ((arr == nil||arr.count==0)&&!isMore) {
                        [self inputToast:@"没有搜索到相关医生！"];
                    }
                    if (!isMore) {
                        [self.sourceArr removeAllObjects];
                    }
                    for (int i = 0; i<arr.count; i++) {
                        DoctorVO*hos = [DoctorVO mj_objectWithKeyValues:arr[i]];
                        [_sourceArr addObject:hos];
                    }
                    [_tableView reloadData];
                }
                
            }else{
                [self inputToast:msg];
            }
        }

    }];
    
}


#pragma mark searchBarDelegate

- (IBAction)cancelAction:(id)sender {
     [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
//    [self.view endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        [_tableView.mj_header beginRefreshing];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:NO];
    
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//        _searchBar.showsCancelButton = YES;       //显示“取消”按钮;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorSelectTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
     DoctorVO * vo = self.sourceArr[indexPath.row];
    [cell setCell:vo];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpertInfomationViewController * view = [GHViewControllerLoader ExpertInfomationViewController];
    DoctorVO * vo = self.sourceArr[indexPath.row];
    view.doctorId = vo.id;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
