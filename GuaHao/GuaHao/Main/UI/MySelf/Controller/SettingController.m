//
//  SettingController.m
//  GuaHao
//
//  Created by PJYL on 2017/12/11.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "SettingController.h"
#import "FeedbackVC.h"
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
@interface SettingController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchButton;

@end

@implementation SettingController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"GHfirstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GHfirstStart"];
        NSLog(@"第一次启动");
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"GHacceptOrderPush"];
    }else{
        NSLog(@"不是第一次启动");
    }
    
    NSString *GHacceptOrderPush = [[NSUserDefaults standardUserDefaults]valueForKey:@"GHacceptOrderPush"];
    self.switchButton.selectedSegmentIndex = GHacceptOrderPush.integerValue == 1 ?0:1;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (IBAction)switchButtonAction:(UISegmentedControl *)sender {
    BOOL open = YES;
    if (sender.selectedSegmentIndex != 0) {
        open = NO;
    }
    __weak typeof(self) weakSelf = self;

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
                self.switchButton.selectedSegmentIndex = users.acceptOrderPush.integerValue == 1 ?0:1;
            }else{
                
            }
        }
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrOne = @[@"pushNotice",@"changePhoneNumber",@"changePassword",@"payPassword"];
    NSArray *arrTwo = @[@"aboutUs",@"encourageUs",@"helpOrFeedback",@"updateVersion"];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
