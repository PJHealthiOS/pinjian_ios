//
//  CollectionViewController.m
//  GuaHao
//
//  Created by qiye on 16/10/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CollectionViewController.h"
#import "Masonry.h"
#import "ServerManger.h"
#import "UITableView+MJ.h"
#import "DoctorSelectTableViewCell.h"
#import "ExpertInfomationViewController.h"
#import "GHEmptyView.h"
@interface CollectionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CollectionViewController{
    int page;
    GHEmptyView *_emptyView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    page = 1;
    self.dataSource = [NSMutableArray new];
    [_tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [_tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        [_dataSource removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] followList:6 page:page andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
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
                            [_dataSource addObject:vo];
                        }
                    }
                }
                [_tableView reloadData];
                if(_dataSource.count == 0){
                    if (!_emptyView) {
                        _emptyView = [GHEmptyView emptyView];
                    }
                    [weakSelf.tableView addSubview:_emptyView];
                    _emptyView.button.hidden = YES;
                    _emptyView.label.text = @"您还没有任何关注专家~";
                }else{
                    [_emptyView removeFromSuperview];
                }
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
    if(_dataSource&&_dataSource.count>0){
        [cell setCell:_dataSource[indexPath.row]];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count>0) {
        DoctorVO *vo = self.dataSource[indexPath.row];
        ExpertInfomationViewController * view = [GHViewControllerLoader ExpertInfomationViewController];
        view.doctorId = vo.id;
        [self.navigationController pushViewController:view animated:YES];
    }
}
@end
