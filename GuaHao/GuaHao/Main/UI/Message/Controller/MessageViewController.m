//
//  MessageViewController.m
//  GuaHao
//
//  Created by qiye on 16/1/19.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MessageViewController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "ImageNewsCell.h"
#import "NormalNewsCell.h"
#import "DataManager.h"
#import "MessageVO.h"
#import "LoginViewController.h"
#import "MessageTakeOrderController.h"
#import "GHViewControllerLoader.h"
#import "GHAcceptDetailViewController.h"
#import "MessageOrderDescController.h"
#import "PurseViewController.h"
#import "SystemMessageExpertSpecialCell.h"
#import "NewOrderVO.h"
#import "AccOrderDetailViewController.h"
#import "UITableView+MJ.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,LoginViewDelegate,MessageTakeOrderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MessageTabV;

@end

@implementation MessageViewController{
    NSMutableArray * messages;
    int page ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"订单消息";
    // Do any additional setup after loading the view from its nib.
    //    隐藏导航栏
    _MessageTabV.delegate=self;
    _MessageTabV.dataSource=self;
    _MessageTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMSGBack:) name:@"UserMSGUpdate" object:nil];
    messages = [NSMutableArray new];
    
    [_MessageTabV registerNib:[UINib nibWithNibName:@"NormalNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NormalNewsCellID"];
    [_MessageTabV registerNib:[UINib nibWithNibName:@"ImageNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderCellID"];
    [_MessageTabV registerNib:[UINib nibWithNibName:@"SystemMessageExpertSpecialCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SpecialCellID"];

    _MessageTabV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _MessageTabV.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    if ([DataManager getInstance].user == nil) {
        LoginViewController * vc = [[LoginViewController alloc] init];
        vc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    [_MessageTabV.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadMSGUpdate" object:nil];
    [MobClick beginLogPageView:@"MessagePage"];//("PageOne"为页面名称，可自定义)

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MessagePage"];
    NSIndexPath *selected = [_MessageTabV indexPathForSelectedRow];
    if(selected) [_MessageTabV selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)updateMSGBack:(NSNotification *)notification{
    [_MessageTabV.mj_header beginRefreshing];
}

-(void) loadNewData
{
    [self geMessages:NO];
}

-(void) loadMoreData
{
    [self geMessages:YES];
}

-(void) geMessages:(BOOL) isMore
{
    if ([DataManager getInstance].user == nil) {
        [self inputToast:@"请先登录！"];
        isMore?[_MessageTabV.mj_footer endRefreshing]:[_MessageTabV.mj_header endRefreshing];
        return;
    }
    if (!isMore) {
        [messages removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    
    [[ServerManger getInstance] getTypeNotices:self.groupID size:6 page:page andCallback:^(id data) {
        isMore?[_MessageTabV.mj_footer endRefreshing]:[_MessageTabV.mj_header endRefreshing];// iphone 5 5s  有问题
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        MessageVO *vo = [MessageVO mj_objectWithKeyValues:arr[i]];
                        [messages addObject:vo];
                    }
                    [_MessageTabV reloadData];
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void) takeOrderComplete:(NewOrderVO*) vo
{
    GHAcceptDetailViewController *accDetailVC = [GHViewControllerLoader GHAcceptDetailViewController];
    AcceptVO *order  = [AcceptVO mj_objectWithKeyValues:@{@"serialNo":vo.serialNo,@"type":@"1"}];
    accDetailVC.order = order;
    

    [self.navigationController pushViewController:accDetailVC animated:YES];
}

-(void) loginComplete
{
    if ([DataManager getInstance].user) {
        [_MessageTabV.mj_header beginRefreshing];
    }
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageVO * vo;
    if (messages.count>0) {
        vo = messages[indexPath.row];
        if (vo.type.intValue == 0&&[self isExpert:vo.extraData]) {
            return 250;
        }else{
            return 191;
        }
    }
    return 191;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageVO * vo;
    NormalNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalNewsCellID"];
    if (messages.count>0) {
        vo = messages[indexPath.row];
        if (vo.type.intValue == 0 &&[self isExpert:vo.extraData]) {
            SystemMessageExpertSpecialCell * cell3 = [tableView dequeueReusableCellWithIdentifier:@"SpecialCellID"];
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell3 setCell:vo];
            return cell3;
        }else{
            
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCell:vo];
            return cell;
        }
    }
    
    return cell;
}

-(BOOL)isExpert:(NSString*)serno
{
    NSArray * arr = [serno componentsSeparatedByString:@";"];
    NSArray * type = [arr[1] componentsSeparatedByString:@":"];
    if (arr.count>1&&arr[1]) {
        if (type&&type.count>1&&[type[0] isEqualToString:@"orderType"]&&[type[1] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}
-(NSString *)getorderSerialNo:(NSString *)extraData{
    NSRange rangeStart;
    rangeStart = [extraData rangeOfString:@":"];
    NSRange rangeEnd;
    rangeEnd = [extraData rangeOfString:@";"];
    NSString * seriousID = [extraData substringWithRange:NSMakeRange(rangeStart.location+1,rangeEnd.location-rangeStart.location)];
    NSLog(@"seriousID = %@",seriousID);
    return seriousID;
}
-(NSString *)getorderType:(NSString *)extraData{
    if (![extraData containsString:@"pzType"]) {
        return @"0";
    }
    NSRange rangeStart;
    rangeStart = [extraData rangeOfString:@"pzType:"];
    NSString * seriousID = [extraData substringWithRange:NSMakeRange(rangeStart.location+7,1)];
    NSLog(@"pzType = %@",seriousID);
    return seriousID;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageVO * vo;
    if (messages.count>0) {
        vo = messages[indexPath.row];
        NSLog(@"vo.type----------%@",vo.type);
       NSString * orderSerialNo = [self getorderSerialNo:vo.extraData];
        vo.readed = YES;
        [_MessageTabV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        if (vo.type.intValue == 1) {
            
        }else if(vo.type.intValue == 0){
            [self setRead:vo.id];
            MessageTakeOrderController * view = [[MessageTakeOrderController alloc]init];
            view.delegate = self;
            view.serialNo = vo.id;
            view.mtitle = vo.title;
            [self.navigationController pushViewController:view animated:YES];
        }else if(vo.type.intValue == 2||vo.type.intValue == 3||vo.type.intValue == 4||vo.type.intValue == 7||vo.type.intValue == 12||vo.type.intValue == 13||vo.type.intValue == 151){
            [self setRead:vo.id];
            
            GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
            view.orderNO = orderSerialNo;
            view.popBack = PopBackDefalt;
            view.orderType = 0;
            [self.navigationController pushViewController:view animated:YES];
            
        }else if(vo.type.intValue == 5){
            [self setRead:vo.id];
            PurseViewController * view = [[PurseViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }else if(vo.type.intValue == 8){
            [self setRead:vo.id];
            GHDisdcountListViewController* view = [GHViewControllerLoader GHDisdcountListViewController];
            [self.navigationController pushViewController:view animated:YES];
        }else if(vo.type.intValue == 10){
            [self setRead:vo.id];

        }else if(vo.type.intValue == 15){
            [self setRead:vo.id];
            GHAcceptDetailViewController* view = [GHViewControllerLoader GHAcceptDetailViewController];
            view.isNormal = YES;
            view.serialNo = orderSerialNo;
            [self.navigationController pushViewController:view animated:YES];
        }else if(vo.type.intValue == 16 || vo.type.intValue == 28){
            [self setRead:vo.id];
            GHAcceptDetailViewController* view = [GHViewControllerLoader GHAcceptDetailViewController];
            view.isNormal = NO;
            view.serialNo = orderSerialNo;
            [self.navigationController pushViewController:view animated:YES];
        }else if(vo.type.intValue == 21||vo.type.intValue == 22||vo.type.intValue == 23||vo.type.intValue == 24||vo.type.intValue == 25||vo.type.intValue == 26||vo.type.intValue == 27||vo.type.intValue == 161){
            [self setRead:vo.id];
            
            GHExpertOrderDetialViewController * view = [GHViewControllerLoader GHExpertOrderDetialViewController];
            view.orderNO = orderSerialNo;
            view.popBack = PopBackDefalt;
            view.orderType = 1;
            [self.navigationController pushViewController:view animated:YES];
            

        }else if(vo.type.intValue == 31){
            [self setRead:vo.id];

            NSString * pzType = [self getorderType:vo.extraData];

            if (pzType.intValue == 0) {
                AccOrderDetailViewController *view = [GHViewControllerLoader AccOrderDetailViewController];
                view.serialNo = orderSerialNo;
                [self.navigationController pushViewController:view animated:YES];
                return;
            }else{
                AccNewOrderDetailViewController *view = [GHViewControllerLoader AccNewOrderDetailViewController];
                view.serialNo = orderSerialNo;
                [self.navigationController pushViewController:view animated:YES];
                return;
            }

        }else{
            [self setRead:vo.id];
        }
    }
}

-(void)setRead:(NSNumber*)_id
{
    [[ServerManger getInstance] getOrderDesc:_id andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    [_MessageTabV reloadData];
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollerViewa.contentSize = CGSizeMake(0, CGRectGetMaxY(_MessageTabV.frame));
}

- (IBAction)onClear:(id)sender {
    if (messages.count == 0) {
        return [self inputToast:@"你当前没有可以清空的消息"];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定清空所有消息？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] clearMessage:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (code.intValue == 0) {
                    [messages removeAllObjects];
                    [_MessageTabV reloadData];
                }else{
                    
                }
            }
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
