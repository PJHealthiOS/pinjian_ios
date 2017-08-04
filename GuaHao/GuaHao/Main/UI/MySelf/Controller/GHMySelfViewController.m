//
//  GHMySelfViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/2.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHMySelfViewController.h"
#import "PersonCommonCell.h"
#import "HtmlAllViewController.h"
#import "SweepVIewController.h"
#import "InformationVC.h"
#import "PonitViewController.h"
#import "PurseViewController.h"
#import "GHSettingViewController.h"
#import "GHFamilyMemberViewController.h"
#import "PersonalCenterVO.h"
#import "ExpertSweepViewController.h"
#import "GHShareViewController.h"
#import "CollectionViewController.h"
#import "UIView+Shadow.h"

#import "GHAcceptOrderViewController.h"
@interface GHMySelfViewController ()<UITableViewDataSource,UITableViewDelegate,AccountNumberViewDelegate,LoginViewDelegate>{
    PersonalCenterVO * personVO;

}

@property (weak, nonatomic) IBOutlet UIButton *member_image_button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *member_image_height;
@property (weak, nonatomic) IBOutlet UIButton *member_label;///如果不是会员 大小100*30 是会员大小80*17.5



@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *heardView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTacketLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;






@property (strong, nonnull) NSMutableArray *sourceArr;





@end

@implementation GHMySelfViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    [self.member_image_button addSpringAnimation];

    [self loadNewData];
    [MobClick beginLogPageView:@"MePage"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"MePage"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    self.sourceArr = [NSMutableArray arrayWithObjects:@{@"title":@"家庭成员",@"icon":@"person_icon_family.png",@"number":@"2"},@{@"title":@"我的订单",@"icon":@"person_icon_order.png"}, @{@"title":@"应用分享",@"icon":@"person_icon_share.png"},@{@"title":@"挂号豆商城",@"icon":@"person_icon_mall.png"},@{@"title":@"我的关注",@"icon":@"person_icon_attention.png"},@{@"title":@"健康管理个人中心",@"icon":@"person_icon_healthmanager.png"},@{@"title":@"我的接单",@"icon":@"person_icon_takeorder.png"},@{@"title":@"待扫码订单",@"icon":@"person_icon_orders.png"},nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCommonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCommonCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoBack:) name:@"UserInfoUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"UserMSGUpdate" object:nil];
   
    
    ///
    self.member_image_height.constant = GetHeightScale((1.0/3.0), 199.0, 171.0);
    
    

    
    [self loadSubView];
    
    if([DataManager getInstance].user){
        [self loadNewData];
    }else{
        [_tableView reloadData];
    }
    
    
}

-(void)loadSubView{
    if ([DataManager getInstance].user.loginName) {
        self.nameLabel.text = [DataManager getInstance].user.loginName;
    }
    if ([DataManager getInstance].user.memberLevel.intValue > 0) {
        [self.member_label setTitle:@"" forState:UIControlStateNormal];
        [self.member_label setImage:[UIImage imageNamed:[NSString stringWithFormat:@"member_level_%@.png",[DataManager getInstance].user.memberLevel]] forState:UIControlStateNormal];
        [self.member_image_button setImage:[UIImage imageNamed:@"member_up.png"] forState:UIControlStateNormal];
        
    }else {
        [self.member_label setTitle:@"您还不是VIP会员" forState:UIControlStateNormal];
        [self.member_label setImage:nil forState:UIControlStateNormal];
        [self.member_image_button setImage:[UIImage imageNamed:@"member_open.png"] forState:UIControlStateNormal];
        
    }
    
}
-(void) loadNewData{
    [[ServerManger getInstance] getPersonalCenterInfo:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                personVO = [PersonalCenterVO mj_objectWithKeyValues:data[@"object"]];
                [_tableView reloadData];
            }else{
                [self inputToast:msg];
            }
        }
    }];
    [self loadSubView];

}

#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    if (notification.userInfo != nil || notification.userInfo[@"extras"][@"type"] != nil ) {
        NSInteger  type = [notification.userInfo[@"extras"][@"type"] integerValue];
        if (type == 5) {
            [self loadNewData];
        }
        if (type == 9) {
            NSString * obj = notification.userInfo[@"extras"][@"obj"];
            NSString * type = [obj substringWithRange:NSMakeRange(19,1)];
            [DataManager getInstance].user.verifyStatus = [NSNumber numberWithInt:type.intValue];
        }
    }
}

-(void)updateUserInfoBack:(NSNotification *)notification{
    [self loadNewData];
}



#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([DataManager getInstance].user.verifyStatus.intValue ==2) {
            return 8;
        }else{
            return 6;
        }
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    UserVO * user = [DataManager getInstance].user;
    if (user) {
        self.nameLabel.text = user.loginName;
        if (personVO) {
            self.myBeanLabel.text = [NSString stringWithFormat:@"我的挂号豆%d",personVO.pointNum.intValue];
             self.myTacketLabel.text = [NSString stringWithFormat:@"我的优惠券%d",personVO.couponsNum.intValue];
             self.myAccountLabel.text = @"我的钱包";
        }
        if (user.avatar) {
            [self.iconImage sd_setImageWithURL: [NSURL URLWithString:user.avatar]];
        }
    }else{
        self.nameLabel.text = @"未登录";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCommonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCommonCell"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [self.sourceArr objectAtIndex:indexPath.row ]];
    if (indexPath.section == 1){
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"设置",@"icon":@"person_setting"}];
    }
    if (indexPath.row == 0 && personVO) {
        [dic setValue:[NSString stringWithFormat:@"(%@)",personVO.patientNum] forKey:@"content"];
    }
    [cell setCell:dic indexPth:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[@"onFamily",@"onMyOrder",@"onShare",@"onMarket",@"myAttention",@"healthmanager",@"onTakeOrder",@"waitForScan",@"setting"];
    NSString *select = [arr objectAtIndex:indexPath.row];
    if (indexPath.section == 1) {
        select = @"setting";
    }
    [self performSelectorOnMainThread:NSSelectorFromString(select) withObject:nil waitUntilDone:NO];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = self.headerImageView.frame;
        //我们只需要改变图片的y值和高度即可
        rect.origin.y = offset.y;
        rect.size.height = 200 - offset.y;
        self.headerImageView.frame = rect;
    }
}
///挂号豆
- (IBAction)clickBeanAction:(id)sender {
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    [MobClick event:@"click43"];

    PonitViewController * views = [[PonitViewController alloc] init];
    [self.navigationController pushViewController:views animated:YES];
}
//钱包
- (IBAction)clickBagAction:(id)sender {
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    PurseViewController * views = [[PurseViewController alloc] init];
    [self.navigationController pushViewController:views animated:YES];
}
//优惠券
- (IBAction)clickTcketAction:(id)sender {
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    GHDisdcountListViewController* views = [GHViewControllerLoader GHDisdcountListViewController];
    [self.navigationController pushViewController:views animated:YES];
}
///编辑个人信息
- (IBAction)personalInfo:(id)sender {
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
//    InformationVC * views = [[InformationVC alloc] init];
    
    [self.navigationController pushViewController:[GHViewControllerLoader GHFixPersonInfoViewController] animated:YES];
}
///健康管理
-(void)healthmanager{
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    [self.navigationController pushViewController:[GHViewControllerLoader HealthManagerOrderViewController] animated:YES];
}
///家庭成员
-(void)onFamily{
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    GHFamilyMemberViewController * familyVC = [GHViewControllerLoader GHFamilyMemberViewController];
//    FamilyViewController * view = [[FamilyViewController alloc] init];
    [self.navigationController pushViewController:familyVC animated:YES];
}
///应用分享
-(void)onShare{
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    
    GHShareViewController *share = [GHViewControllerLoader GHShareViewController];
//    ShareViewController * view = [[ShareViewController alloc] init];
    [self.navigationController pushViewController:share animated:YES];
}
///我的订单
-(void)onMyOrder{
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    [self.navigationController pushViewController:[GHViewControllerLoader GHOrderTypeViewController] animated:YES];

}
//我的接单
-(void)onTakeOrder{
    
    GHAcceptTypeViewController *acceptTypeVC = [GHViewControllerLoader GHAcceptTypeViewController];
    [self.navigationController pushViewController:acceptTypeVC animated:YES];
}
///我的关注
-(void)myAttention{
        CollectionViewController * view = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}
//扫一扫
-(void)onSweep{
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    SweepViewController * view = [[SweepViewController alloc]init];
    [self.navigationController pushViewController:view animated:NO];
}
///挂号豆商城
-(void)onMarket{
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    HtmlAllViewController *htmlVC = [[HtmlAllViewController alloc]init];
    htmlVC.mTitle = @"挂号豆商城";
    htmlVC.mUrl   = @"https://www.pjhealth.com.cn/wx/ExchangeMall/ExchangeMall.html";
    [self.navigationController pushViewController:htmlVC animated:YES];
    NSLog(@"挂号豆商城");
}
//待扫码订单
-(void)waitForScan{
    NSLog(@"待扫码订单");
    if([DataManager getInstance].user&&([DataManager getInstance].user.verifyStatus.intValue ==2||[DataManager getInstance].user.verifyStatus.intValue ==4)){
        ExpertSweepViewController * view = [[ExpertSweepViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        [self inputToast:@"您尚未认证接单专员，认证通过方可查看！"];
    }
    
}
//设置
- (IBAction)settingAction:(UIButton *)sender {
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    GHSettingViewController *settingVC = [GHViewControllerLoader GHSettingViewController];
    settingVC.delegate = self;
    [self.navigationController pushViewController:settingVC animated:YES];
}
//开通会员
- (IBAction)openMember:(UIButton *)sender {
    if ([DataManager getInstance].user == nil) {
        [self isLogin];
        return ;
    }
    MemberCenterViewController *member = [GHViewControllerLoader MemberCenterViewController];
    [self.navigationController pushViewController:member animated:YES];
}


-(void)accountNumberViewDelegate
{
    [DataManager getInstance].user = nil;
    [DataManager getInstance].loginState = 0;
    [self isLogin];
}
-(void)isLogin
{
    if ([DataManager getInstance].user == nil) {
        LoginViewController * vc = [[LoginViewController alloc] init];
        vc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
-(void) loginComplete{
    [self.tableView reloadData];
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
