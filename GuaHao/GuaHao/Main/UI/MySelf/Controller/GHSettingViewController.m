//
//  GHSettingViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/2.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHSettingViewController.h"
#import "FeedbackVC.h"
#import "PersonCommonCell.h"
#import "GHSettingNoticeCell.h"
#import "GHServiceCell.h"
#import "VersionVO.h"
#import "ForgetViewController.h"
#import "FixedPhoneNumber.h"
#import <JPush/JPUSHService.h>
#import "AboutOursVC.h"
#import "DataManager.h"
#import "GHSettingPayPasswordViewController.h"
#import "AppVersionVO.h"
#import "EMClient.h"
#import "HtmlAllViewController.h"
@interface GHSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIView *sectionHeaderView;
@property (strong, nonatomic) NSMutableArray *sourrceArr;
@end

@implementation GHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCommonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCommonCell"];

    
    NSArray * sectionOne = @[@{@"title":@"订单提醒",@"content":@""}, @{@"title":@"手机绑定",@"content":@""},@{@"title":@"登录密码",@"content":@""},@{@"title":@"支付密码",@"content":@""}];
    NSArray * sectionTwo = @[@{@"title":@"关于我们",@"content":@""},@{@"title":@"鼓励我们",@"content":@""}, @{@"title":@"帮助与反馈",@"content":@""}];
    NSArray *sectionThree = @[@{@"title":@"退出登录",@"content":@""}];
    self.sourrceArr =[NSMutableArray arrayWithArray: @[sectionOne,sectionTwo,sectionThree]];
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}



#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number;
    switch (section) {
        case 0:
        {
            NSString *phoneNumber = [DataManager getInstance].user.mobile ;
            if (phoneNumber.length < 2) {
                number = 1;
            }else{
                number = 3;

            }
            
            
        }
            break;
        case 1:
        {
             number = 3;
        }
            break;

        default:{
            number = 1;
        }
            break;
    }

    return number;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.sectionHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, section == 0 ? 20 : 40);
    self.sectionHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return self.sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 20 : 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 3) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            GHSettingNoticeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHSettingNoticeCell"];
            
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"GHfirstStart"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GHfirstStart"];
                NSLog(@"第一次启动");
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"GHacceptOrderPush"];
            }else{
                NSLog(@"不是第一次启动");
            }
            
            NSString *GHacceptOrderPush = [[NSUserDefaults standardUserDefaults]valueForKey:@"GHacceptOrderPush"];
            cell.segement.selectedSegmentIndex = GHacceptOrderPush.integerValue == 1 ?0:1;
            
//            cell.segement.selectedSegmentIndex = [DataManager getInstance].user.acceptOrderPush.integerValue == 1 ?0:1;
            NSLog(@"-----------------acceptOrderPush--------%@",GHacceptOrderPush);
            __weak typeof(self) weakSelf = self;
            [cell pushStatus:^(BOOL open) {
                [[ServerManger getInstance] editPush:open ? @"1" : @"0" andCallback:^(id data) {
                    
                    if (data!=[NSNull class]&&data!=nil) {
                        NSNumber * code = data[@"code"];
                        NSString * msg = data[@"msg"];
                        [weakSelf inputToast:msg];
                        if (code.intValue == 0) {
                            NSDictionary * dict = data[@"object"];
                            UserVO *users = [UserVO mj_objectWithKeyValues:dict];
                            [DataManager getInstance].user = users;
                            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",users.acceptOrderPush] forKey:@"GHacceptOrderPush"];
//                            [weakSelf getUserInf];
                            cell.segement.selectedSegmentIndex = users.acceptOrderPush.integerValue == 1 ?0:1;
                        }else{
                            
                        }
                    }
                }];
                
            }];
            return cell;

        }else{
            PersonCommonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCommonCell"];
            cell.leftSpace.constant = 20;
            NSDictionary *dic = [[self.sourrceArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [cell setCell:dic indexPth:0];
            return cell;
        }
    }else{
        GHServiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHServiceCell"];
        return cell;
    }

    
}
-(void)getUserInf{
    
    [self updateTableViewWithSection:0 row:0 key:@"content" newValue:[DataManager getInstance].user.mobile];
//    _segmentedControl.selectedSegmentIndex = user.isAcceptOrderPush.integerValue == 1 ?0:1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arrOne = @[@"pushNotice",@"changePhoneNumber",@"changePassword",@"payPassword"];
    NSArray *arrTwo = @[@"aboutUs",@"encourageUs",@"helpOrFeedback",@"updateVersion"];
//    NSArray *arr = @[@"changePhoneNumber",@"changePassword",@"helpOrFeedback",@"pushNotice",@"encourageUs",@"aboutUs",@"updateVersion",@"exitAccount"];
//    NSString *select = [arr objectAtIndex:indexPath.row];
    NSString *select = @"";
    if (indexPath.section == 0) {
        select = [arrOne objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        select = [arrTwo objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 2) {
        select = @"exitAccount";
    }
    if (indexPath.section == 3) {
        select = @"callServiceCenter";
    }
    [self performSelectorOnMainThread:NSSelectorFromString(select) withObject:nil waitUntilDone:NO];

}
///支付密码
-(void)payPassword{
    GHSettingPayPasswordViewController *paySetting = (GHSettingPayPasswordViewController *)[GHViewControllerLoader GHSettingPayPasswordViewController];
    [self.navigationController pushViewController:paySetting animated:YES];
}
//绑定手机
-(void)changePhoneNumber{
    FixedPhoneNumber * FPN = [[FixedPhoneNumber alloc]init];
    [self.navigationController pushViewController:FPN animated:YES];

}

//修改密码
-(void)changePassword{
    ForgetViewController * view = [[ForgetViewController alloc]init];
    view.openType = 2;
    [self.navigationController pushViewController:view animated:YES];
}
//帮助反馈
-(void)helpOrFeedback{
    FeedbackVC *HelpView = [[FeedbackVC alloc] init];
    [self.navigationController pushViewController:HelpView animated:YES];
}
//订单提醒
-(void)pushNotice{
    
}
//鼓励我们
-(void)encourageUs{
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1088129186" ];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1088129186"];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//关于我们
-(void)aboutUs{
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"关于我们";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/aboutUs.html",[ServerManger getInstance].serverURL];
    [self.navigationController pushViewController:view animated:YES];
//    AboutOursVC * AboutOu = [[AboutOursVC alloc]init];
//    [self.navigationController pushViewController:AboutOu animated:YES];
}
//版本更新
-(void)updateVersion{
    [[ServerManger getInstance] getAppVersion:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSString *versionURL;
                    AppVersionVO  *version = [AppVersionVO mj_objectWithKeyValues:data[@"object"]];
                    versionURL = version.version.downloadUrl;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionURL]];
                }
                
            }else{
                [ServerManger getInstance].serverURL = @HOST;
            }
        }
    }];
    
    
}
//退出登录
-(void)exitAccount{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要退出账户?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) return;
    if (_delegate) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Password"];
        [[DataManager getInstance] saveToken:nil];
        [JPUSHService setAlias:@""
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        object:nil];
        [[EMClient sharedClient] logout:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearAllCell" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
        [_delegate accountNumberViewDelegate];
    }
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
}
//客服
-(void)callServiceCenter{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001150958"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

///刷新列表
-(void)updateTableViewWithSection:(NSInteger)section row:(NSInteger)row key:(NSString *)key newValue:(NSString *)newValue{
    NSMutableArray *source = self.sourrceArr;
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[source objectAtIndex:row]];
    if (newValue) {
        [dic setObject:newValue forKey:key];
        [source replaceObjectAtIndex:row withObject:dic];
        self.sourrceArr = source;
        [self.tableView reloadData];
    }
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
