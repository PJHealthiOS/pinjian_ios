//
//  SeriousExpertSelectVC.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SeriousExpertSelectVC.h"
#import "SeriousSelectExpertViewModel.h"
#import "SeriousExpertCell.h"
#import "SelectHospitalView.h"
#import "SelectDepartmentView.h"
#import "SeriousExpertInfoViewController.h"
@interface SeriousExpertSelectVC ()<UITableViewDelegate,UITableViewDataSource,SelectHospitalViewDelegate,SelectDepartmentViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;
@property (weak, nonatomic) IBOutlet UIButton *departmentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SeriousSelectExpertViewModel *viewModel;
//@property (strong, nonatomic) SelectHospitalView * hospitalView;
@property (strong, nonatomic) SelectDepartmentView * departmentView;


@end

@implementation SeriousExpertSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择专家";
    self.viewModel = [[SeriousSelectExpertViewModel alloc]init];
    self.viewModel.depID = nil;self.viewModel.hosID = nil;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_tableView.mj_header beginRefreshing];

    
    
    // Do any additional setup after loading the view.
}
-(void)loadNewData{
    self.viewModel.isMore = NO;
    [self loadData];
}
-(void)loadMoreData{
    self.viewModel.isMore = YES;
    [self loadData];
}
-(void)loadData{
    __weak typeof(self) weakSelf = self;
    [self.viewModel getDataAction:^(NSArray *array, BOOL error) {
        weakSelf.viewModel.isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (array.count > 0) {
            [weakSelf.tableView reloadData];
        }
    }];
}
- (IBAction)hospitalSelectAction:(UIButton *)sender {
    if (_departmentView) {
        [_departmentView removeFromSuperview];
    }
    self.viewModel.depID = nil;
    [self.departmentButton setTitle:@"科室" forState:UIControlStateNormal];
    
    ChooseHospitalVC* hospitalVC = [[ChooseHospitalVC alloc]init];
    __weak typeof(self) weakSelf = self;
    hospitalVC.onBlockHospital = ^(HospitalVO * vo,DepartmentVO * dvo){
        self.viewModel.hosID = vo.id;
        [weakSelf loadNewData];
        //    NSLog(@"选中医院----%@",vo.name);
        [weakSelf.hospitalButton setTitle:vo.name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:hospitalVC animated:YES];
    
    
}



- (IBAction)departmentSelectAction:(UIButton *)sender {
//    if (_hospitalView) {
//        [_hospitalView removeFromSuperview];
//    }
    if(self.viewModel.hosID==nil){
        [self inputToast:@"请先选择医院～"];
        return;
    }
    if(_departmentView == nil) {
        _departmentView =  [[SelectDepartmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.view.height)];
        _departmentView.delegate = self;
    }
    _departmentView.hospitalID = self.viewModel.hosID;
    [_departmentView updateView];
     [self.tableView addSubview:_departmentView];
}
-(void) selectDepartmentViewDelegate:(DepartmentVO*) vo{
    self.viewModel.depID = vo.id;
    [self loadNewData];
//    NSLog(@"选中科室----%@",vo.name);
    [self.departmentButton setTitle:vo.name forState:UIControlStateNormal];
}
#pragma  mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel getHeightForRow]; ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel getNumberRowInSection];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SeriousExpertCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SeriousExpertCell"];
    [cell setCell:[self.viewModel getModelWithIndexPath:indexPath] selectedArr:self.selectArr indexPath:indexPath];
    __weak typeof(self) weakSelf =self;
    [cell selectExpertAction:^(NSArray *selectArr, BOOL full) {
        if (full) {
            [weakSelf inputToast:@"最多可选择5个专家"];
        }
        weakSelf.selectArr = [NSMutableArray arrayWithArray:selectArr];
//        NSLog(@"weakSelf.selectArr----%lu",(unsigned long)weakSelf.selectArr.count);
        [weakSelf.tableView reloadData];
 
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SeriousExpertInfoViewController *vc = [GHViewControllerLoader SeriousExpertInfoViewController];
    vc.doctorVO = [self.viewModel getModelWithIndexPath:indexPath];
    __weak typeof(self) weakSelf =self;
    [vc sureExpert:^(DoctorVO *doctorVO) {
        if (weakSelf.selectArr.count >= 5) {
            [weakSelf inputToast:@"最多选择5个专家"];
            return ;
        }
        if (!weakSelf.selectArr) {
            weakSelf.selectArr = [NSMutableArray array];
        }
        if ([weakSelf.selectArr containsObject:doctorVO]) {
            NSLog(@"已经选过这个人了");
        }else{
            [weakSelf.selectArr addObject:doctorVO];
            [weakSelf.tableView reloadData];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectAction:(SelectExpertAction)action{
    self.myAction = action;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (IBAction)sureAction:(id)sender {
    if (self.selectArr.count>0) {
        self.myAction(self.selectArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
