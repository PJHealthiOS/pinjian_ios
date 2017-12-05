//
//  PackageViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "PackageViewController.h"
#import "PackageCell.h"
@interface PackageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务套餐选择";
    self.sourceArr = [NSMutableArray array];
    [self loadData];
    [self call];
    // Do any additional setup after loading the view.
}
-(void)call{
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 30, 30);
    [rightItemButton setImage:[UIImage imageNamed:@"common_make_phone_call.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)callAction:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001150958"];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)loadData{
//    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getPackageDataCallback:^(id data) {
//        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        PackageVO *vo = [PackageVO mj_objectWithKeyValues:arr[i]];
                        [weakSelf.sourceArr addObject:vo];
                    }
                    [self.tableView reloadData];
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];

}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageVO *vo = [self.sourceArr objectAtIndex:indexPath.row];
    PackageCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:@"PackageCell"];
    [cell layoutSubviewWithVO:vo];
    __weak typeof(self) weakSelf = self;
    [cell packageSelectAction:^(PackageVO * backVO) {
        [weakSelf backAction:backVO];
    }];
    return cell;
}
///选中套餐返回
-(void)backAction:(PackageVO *)_vo{
    if (self.myBlock) {
        self.myBlock(_vo);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}
-(void)packgeSelectAction:(PackageSelectBlock)block{
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
