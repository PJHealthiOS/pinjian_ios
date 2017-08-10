//
//  GHHospitalChangeViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/9.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHHospitalChangeViewController.h"
#import "HospitalTakeTableViewCell.h"
#import "GHLocationManager.h"
@interface GHHospitalChangeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *longitude;
    NSString *latitude;
    int page ;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@end

@implementation GHHospitalChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"HospitalTakeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HospitalTakeTableViewCell"];
    self.sourceArr = [NSMutableArray array];
    self.title = @"选择医院";
    MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"已加载全部医院，将陆续开通更多医院！" forState:MJRefreshStateNoMoreData];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = footer;
    
    
    [[GHLocationManager shareLocation] getLocationInfo:^(BOOL success, NSString *_longitude, NSString *_latitude) {
        longitude = _longitude;latitude = _latitude;
         [_tableView.mj_header beginRefreshing];
    }];
    
    // Do any additional setup after loading the view.
}



-(void) loadNewData
{
    [self getHospitals:NO];
}

-(void) loadMoreData
{
    [self getHospitals:YES];
}

-(void) getHospitals:(BOOL) isMore
{
    if (!isMore) {
//        [_sourceArr removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    [[ServerManger getInstance] getNearByHospitals:20 page:page longitude:longitude latitude:latitude andCallback:^(id data) {
//    [[ServerManger getInstance] getHospitals:@"" size:20 page:page longitude:longitude latitude:latitude andCallback:^(id data) {
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (arr&&arr.count>0) {
                        if (!isMore) {
                            [_sourceArr removeAllObjects];
                        }
                        for (int i = 0; i<arr.count; i++) {
                            HospitalVO *vo = [HospitalVO mj_objectWithKeyValues:arr[i]];
                            [self.sourceArr addObject:vo];
                        }
                    }
                    if(arr.count==0){
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_tableView.mj_footer resetNoMoreData];
                    }
                }
                [_tableView reloadData];
                
            }else{
                //                [self inputToast:msg];
            }
        }
    }];
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalTakeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HospitalTakeTableViewCell"];
    [cell setCell:self.sourceArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalVO *vo = self.sourceArr[indexPath.row];
    if (self.myBlock) {
        self.myBlock(vo);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)hospitalSelect:(HospitalSelectBlock)block{
    self.myBlock = block;
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
