//
//  PurseViewController.m
//  GuaHao
//
//  Created by 123456 on 16/1/20.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PurseViewController.h"
#import "UIViewController+Toast.h"
#import "ApplyForWithdrawCash.h"
#import "MJRefresh.h"
#import "PurseCell.h"
#import "ServerManger.h"
#import "CrashVO.h"
#import "DataManager.h"
#import "HtmlAllViewController.h"
#import "Utils.h"
#import "UserVO.h"
#import "ShareNoteCell.h"
#import "ShareLogVO.h"
#import "UITableView+MJ.h"

@interface PurseViewController ()<UITableViewDelegate,UITableViewDataSource,ApplyForWithdrawCashDelegate>
@property (weak, nonatomic) IBOutlet UITableView * tableView2;
@property (weak, nonatomic) IBOutlet UILabel     * moneyLab;
@property (weak, nonatomic) IBOutlet UILabel     * IncomeLab;
@property (weak, nonatomic) IBOutlet UIButton    * WithdrawalsBtn;
@property (weak, nonatomic) IBOutlet UILabel * hidLab;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation PurseViewController{
    NSMutableArray * crashes;
    int page ;
    int type;
    NSNumber* incomemoney;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    type = 1;
    self.navigationController.navigationBarHidden = NO;
     self.title = @"我的钱包";
    crashes = [NSMutableArray new];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView2 registerNib:[UINib nibWithNibName:@"PurseCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PurseCellID"];
    [_tableView2 registerNib:[UINib nibWithNibName:@"ShareNoteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ShareNoteCell"];
    [_tableView2 initMJ:self type:MJTypePJGifTaoBao newAction:@selector(loadNewData) moreAction:@selector(loadMoreData)];
    UITapGestureRecognizer *tapLeft=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLeftTap:)];
    tapLeft.cancelsTouchesInView = NO;
    [self.leftView addGestureRecognizer:tapLeft];
    
    UITapGestureRecognizer *rightLeft=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onRightTap:)];
    rightLeft.cancelsTouchesInView = NO;
    [self.rightView addGestureRecognizer:rightLeft];
    [_tableView2.mj_header beginRefreshing];
}

-(void) loadNewData
{
    [self getCrash:NO];
}

-(void) loadMoreData
{
    [self getCrash:YES];
}

-(void) getCrash:(BOOL) isMore
{
    if (!isMore) {
        [crashes removeAllObjects];
        page = 1;
    }else{
        page ++;
    }
    
    if(type == 1){
        NSLog(@"xxxxxx1111");
        [[ServerManger getInstance] getAccount:6 page:page andCallback:^(id data) {
            
            isMore?[_tableView2.mj_footer endRefreshing]:[_tableView2.mj_header endRefreshing];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if(type!=1){
                    return ;
                }
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        NSNumber * money = data[@"object"][@"money"];
                        _moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",money.floatValue];
                        incomemoney = data[@"object"][@"orderIncome"];
                        _IncomeLab.text = [NSString stringWithFormat:@"¥ %.2f",incomemoney.floatValue];
                        NSArray * arr = data[@"object"][@"userCashLogs"];
                        for (int i = 0; i<arr.count; i++) {
                            CrashVO *order = [CrashVO mj_objectWithKeyValues:arr[i]];
                            [crashes addObject:order];
                        }
                        [_tableView2 reloadData];
                    }
                    
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }else{
        NSLog(@"xxxxxx2222");
        [[ServerManger getInstance] shareLogs:8 page:page andCallback:^(id data) {
            
            isMore?[_tableView2.mj_footer endRefreshing]:[_tableView2.mj_header endRefreshing];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if(type!=2){
                    return ;
                }
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        NSArray * arr = data[@"object"];
                        for (int i = 0; i<arr.count; i++) {
                            ShareLogVO * log = [ShareLogVO mj_objectWithKeyValues:arr[i]];
                            [crashes addObject:log];
                        }
                        [_tableView2 reloadData];
                    }
                    
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }

}

-(void) onLeftTap:(UITapGestureRecognizer*)tap{
    type = 1;
    [_tableView2.mj_header beginRefreshing];
}

-(void) onRightTap:(UITapGestureRecognizer*)tap{
    type = 2;
    [_tableView2.mj_header beginRefreshing];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( type == 1 ) return 122;
    return 54;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return crashes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( type == 1 ){
        CrashVO * vo = crashes[indexPath.row];
        PurseCell * PurCell = [tableView dequeueReusableCellWithIdentifier:@"PurseCellID"];
        PurCell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (crashes.count>0&&vo) {
            [PurCell setCell:crashes[indexPath.row]];
        }
        return PurCell;
    }else{
        ShareLogVO * vo = crashes[indexPath.row];
        ShareNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShareNoteCell"];
        if(crashes.count>0&&vo){
            [cell setCell:vo];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(type == 2){
        ShareLogVO * vo = crashes[indexPath.row];
        if(vo.withdrawal){
            GHBankStatementController *view = [GHViewControllerLoader GHBankStatementController];
            view.bankID = vo.id;
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}

- (IBAction)button:(id)sender {
    if(_payStyle == 2){
        NSArray *viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (IBAction)addBunton:(id)sender {
    ApplyForWithdrawCash * view = [[ApplyForWithdrawCash alloc]init];
    view.delegate = self;
    view.hasMoney =incomemoney;
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)topUpBtn:(id)sender {
    GHRechargeViewController *view = [GHViewControllerLoader GHRechargeViewController];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)onRule:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"收益规则";
    view.mUrl   = [NSString stringWithFormat:@"%@htmldoc/incomeRules.html",[ServerManger getInstance].serverURL];
    [self.navigationController pushViewController:view animated:YES];
}


@end
