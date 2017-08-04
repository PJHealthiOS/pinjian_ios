//
//  SpecialDoctorSelectViewController.m
//  GuaHao
//
//  Created by PJYL on 2016/11/15.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "SpecialDoctorSelectViewController.h"
#import "DoctorVO.h"
#import "DoctorSelectTableViewCell.h"
#import "SpecialSelectTableView.h"
#import "UITableView+MJ.h"
#import "SpecialSearchDoctorViewController.h"
#import "GHEmptyView.h"
@interface SpecialDoctorSelectViewController ()<UITableViewDelegate,UITableViewDataSource>{
    GHEmptyView *_emptyView;
}
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UIButton *amountButton;
@property (weak, nonatomic) IBOutlet UIButton *canUseButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *doctorArr;
@property (nonatomic, assign)int pageNo;
@property (nonatomic, assign)int level;
@property (nonatomic, assign)int amount;
@property (nonatomic, strong)NSMutableDictionary *parameter;
@property (nonatomic, strong)SpecialSelectTableView *selectTableView;

@end

@implementation SpecialDoctorSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parameter = [NSMutableDictionary dictionary];
    self.doctorArr = [NSMutableArray array];
    self.title = @"更多名医推荐";
    [self searchDoctor];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"DoctorSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DoctorSelectTableViewCell"];
    [self.tableView initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    [self addSelectTableView];
    [self.tableView.mj_header beginRefreshing];
        // Do any additional setup after loading the view.
}
-(void)searchDoctor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"order_accept_search_image.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)search{
    NSLog(@"搜索特色科室医生");
    SpecialSearchDoctorViewController *searchVC = (SpecialSearchDoctorViewController *)[GHViewControllerLoader SpecialSearchDoctorViewController];
    searchVC._id = self._id;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)addSelectTableView{
    self.selectTableView = [[SpecialSelectTableView alloc]initWithFrame:CGRectMake(0,104, SCREEN_WIDTH, 130)];
//    self.selectTableView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    __weak typeof (self) weakSelf = self;
    [self.selectTableView cellClickAction:^(NSInteger index, int type) {
        weakSelf.selectTableView.hidden = YES;
        //修改那个字典
        if (type == 1) {
            if (index == 0) [weakSelf.parameter removeObjectForKey:@"grade"];
            if (index == 1) [weakSelf.parameter setValue:[NSNumber numberWithInt:3] forKey:@"grade"];
            if (index == 2) [weakSelf.parameter setValue:[NSNumber numberWithInt:2] forKey:@"grade"];
        }else if (type == 2){
            if (index == 0) [weakSelf.parameter removeObjectForKey:@"grade"];
            if (index == 1) [weakSelf.parameter setValue:[NSNumber numberWithInt:1] forKey:@"displayOrder"];
            if (index == 2) [weakSelf.parameter setValue:[NSNumber numberWithInt:2] forKey:@"displayOrder"];
    
        }else{
            if (index == 0) [weakSelf.parameter removeObjectForKey:@"grade"];
            if (index == 1) [weakSelf.parameter setValue:@"1" forKey:@"grade"];
            if (index == 2) [weakSelf.parameter setValue:@"0" forKey:@"grade"];
        }
        [weakSelf loadNewData];
    }];
    [self.view addSubview:self.selectTableView];
    self.selectTableView.hidden = YES;

}
- (IBAction)leveButtonAction:(UIButton *)sender {
    if (sender.selected == YES) {
        self.selectTableView.hidden = YES;
    }else{
        self.selectTableView.hidden = NO;
    }

    sender.selected = !sender.selected;
    self.amountButton.selected = NO;
    self.canUseButton.selected = NO;
    self.selectTableView.tableView.center = CGPointMake(SCREEN_WIDTH / 6.0 + 30, 65);
    [self.selectTableView changTableView:1];
    
}
- (IBAction)amountButtonAction:(UIButton *)sender {
    if (sender.selected == YES) {
        self.selectTableView.hidden = YES;
    }else{
        self.selectTableView.hidden = NO;
    }

    sender.selected = !sender.selected;
    self.levelButton.selected = NO;
    self.canUseButton.selected = NO;
    self.selectTableView.tableView.center = CGPointMake(SCREEN_WIDTH / 6.0 * 3.0 + 30, 65);
    [self.selectTableView changTableView:2];
}
- (IBAction)canUseButtonAction:(UIButton *)sender {
    if (sender.selected == YES) {
        self.selectTableView.hidden = YES;
    }else{
        self.selectTableView.hidden = NO;
    }
    self.amountButton.selected = NO;
    self.levelButton.selected = NO;
    sender.selected = !sender.selected;
    
    self.selectTableView.tableView.center = CGPointMake(SCREEN_WIDTH / 6.0 * 5.0 + 30, 65);
    [self.selectTableView changTableView:3];
}



-(void)loadNewData{
    self.pageNo = 1;
    [self changeTableWithKeyWord:@""];
}

-(void)loadMoreData{
    self.pageNo++;
    [self changeTableWithKeyWord:@""];
    
}



-(void)changeTableWithKeyWord:(NSString *)keyWord {

    
    if (keyWord.length > 0) {
        [self.parameter setValue:keyWord forKey:@"keywords"];
    }
    
    [self.parameter setValue:[NSNumber numberWithInt:6] forKey:@"pageSize"];
    [self.parameter setValue:[NSNumber numberWithInt:self.pageNo] forKey:@"pageNo"];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] specialDepDoctorSelect:@"" size:6 page:self.pageNo _id:self._id parameter:self.parameter  andCallback:^(id data) {
        self.pageNo != 1?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        NSLog(@"11111111");
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    if (weakSelf.pageNo == 1) {
                        weakSelf.doctorArr = [NSMutableArray array];
                    }
                    if (arr&&arr.count>0) {
                        for (int i = 0; i<arr.count; i++) {
                            DoctorVO *vo = [DoctorVO mj_objectWithKeyValues:arr[i]];
                            [weakSelf.doctorArr addObject:vo];
                        }
                    }
                    
                    if (weakSelf.doctorArr.count ==0) {
                        [weakSelf inputToast:@"没有搜索到相关医生！"];
                    }
                    if(weakSelf.doctorArr.count == 0){
                        if (!_emptyView) {
                            _emptyView = [GHEmptyView emptyView];
                        }
                        [weakSelf.tableView addSubview:_emptyView];
                        _emptyView.button.hidden = YES;
                        _emptyView.label.text = @"没有搜索到相关医生!";
                    }else{
                        [_emptyView removeFromSuperview];
                    }
                }
                [_tableView reloadData];
                
            }else{
                [weakSelf inputToast:msg];
            }
        }

    }];
    
    
    
    
}




#pragma mark --- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.doctorArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorVO *vo = [self.doctorArr objectAtIndex:indexPath.row];
    DoctorSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorSelectTableViewCell"];
    [cell setCell:vo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SpecialDoctorInfoViewController *view = [GHViewControllerLoader SpecialDoctorInfoViewController ];
    DoctorVO * vo = self.doctorArr[indexPath.row];
    view.doctorId = vo.id;
    [self.navigationController pushViewController:view animated:YES];
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
