//
//  GHAcceptTypeViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/4/12.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GHAcceptTypeViewController.h"
#import "PersonCommonCell.h"
@interface GHAcceptTypeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    HospitalVO *_hospital;
    NSString * isShowAllData;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;
@end

@implementation GHAcceptTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hospital.id = [DataManager getInstance].user.id;
    _hospital.name = [DataManager getInstance].user.hospName;
    [DataManager getInstance].user.hospName = [[[NSUserDefaults standardUserDefaults]objectForKey:@"defaultSelectHospital"]objectForKey:@"hosName"];
    [DataManager getInstance].user.hospId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"defaultSelectHospital"] objectForKey:@"hosId"];
    [self.hospitalButton setTitle:[DataManager getInstance].user.hospName ? [NSString stringWithFormat:@"%@ >",[DataManager getInstance].user.hospName]:@"所有医院>" forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCommonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCommonCell"];
    self.sourceArr = [NSMutableArray arrayWithObjects:@{@"title":@"待接订单",@"icon":@"person_icon_order.png",@"number":@"2"},@{@"title":@"普通订单",@"icon":@"person_icon_order.png"}, @{@"title":@"专家/特需订单",@"icon":@"person_icon_order.png"},@{@"title":@"万家陪诊订单",@"icon":@"person_icon_order.png"},@{@"title":@"已完成订单",@"icon":@"person_icon_order.png"},nil];
    

    // Do any additional setup after loading the view.
}
- (IBAction)changeHospitalAction:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
    GHHospitalChangeViewController *vc = [GHViewControllerLoader GHHospitalChangeViewController];
    [vc hospitalSelect:^(HospitalVO *vo) {
        if(vo==nil){
            isShowAllData = @"1";
            [sender setTitle:[NSString stringWithFormat:@"所有医院>"] forState:UIControlStateNormal];
            return;
        }
        _hospital  = vo;
        isShowAllData = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:@{@"hosName":vo.name,@"hosId":vo.id} forKey:@"defaultSelectHospital"];
        [sender setTitle:[NSString stringWithFormat:@"%@ >", vo.name] forState:UIControlStateNormal];
        [DataManager getInstance].user.hospId = vo.id;
        [DataManager getInstance].user.hospName = vo.name;
        
    }];
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCommonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCommonCell"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [self.sourceArr objectAtIndex:indexPath.row ]];
    cell.isMyOrder = YES;
    [cell setCell:dic indexPth:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[@"waitOrder",@"normalOrder",@"expertOrder",@"wanjiaOrder",@"endOrder"];
    NSString *select = [arr objectAtIndex:indexPath.row];
    [self performSelectorOnMainThread:NSSelectorFromString(select) withObject:nil waitUntilDone:NO];
    
}
///待接单
-(void)waitOrder{
    GHAcceptOrderViewController *order = [GHViewControllerLoader GHAcceptOrderViewController];
    order.contentType = ContentType_order_Wait;
    order.hospital = _hospital;
    order.titleStr = @"待接订单";
    [self.navigationController pushViewController:order animated:YES];
}
///普通
-(void)normalOrder{
    GHAcceptOrderViewController *order = [GHViewControllerLoader GHAcceptOrderViewController];
    order.contentType = ContentType_order_Normal;
    order.hospital = _hospital;
    order.titleStr = @"普通订单";

    [self.navigationController pushViewController:order animated:YES];
    
}
///专家
-(void)expertOrder{
    GHAcceptOrderViewController *order = [GHViewControllerLoader GHAcceptOrderViewController];
    order.contentType = ContentType_order_Expert;
    order.hospital = _hospital;
    order.titleStr = @"专家/特需订单";

    [self.navigationController pushViewController:order animated:YES];
}

///万家订单
-(void)wanjiaOrder{
    GHAcceptOrderViewController *order = [GHViewControllerLoader GHAcceptOrderViewController];
    order.contentType = ContentType_order_Wanjia;
    order.hospital = _hospital;
    order.titleStr = @"万家陪诊订单";

    [self.navigationController pushViewController:order animated:YES];
}
///完成的订单
-(void)endOrder{
    GHAcceptOrderViewController *order = [GHViewControllerLoader GHAcceptOrderViewController];
    order.contentType = ContentType_order_Finish;
    order.hospital = _hospital;
    order.titleStr = @"已完成订单";

    [self.navigationController pushViewController:order animated:YES];
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
