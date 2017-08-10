//
//  MessageController.m
//  GuaHao
//
//  Created by qiye on 16/10/11.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MessageController.h"
#import "Masonry.h"
#import "ServerManger.h"
#import "UITableView+MJ.h"
#import "MessageTableCell.h"
#import "Message3VO.h"
#import "MessageViewController.h"

@interface MessageController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataSource = [NSMutableArray new];
    [self.tableView registerClass:[MessageTableCell class] forCellReuseIdentifier:@"MessageTableCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self loadNewData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"UserMSGUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoBack:) name:@"UserInfoUpdate" object:nil];
}

#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    if (notification.userInfo != nil || notification.userInfo[@"extras"][@"type"] != nil ) {
        
        [self loadNewData];
    }
}

-(void)updateUserInfoBack:(NSNotification *)notification{
    [self loadNewData];
}

-(void) loadNewData
{
    [_dataSource removeAllObjects];
    [[ServerManger getInstance] getGroupMsg:^(id data) {
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    _dataSource = [NSMutableArray array];
                    for (int i = 0; i<arr.count; i++) {
                        Message3VO *vo = [Message3VO mj_objectWithKeyValues:arr[i]];
                        [_dataSource addObject:vo];
                    }
                    [_tableView reloadData];
                    
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableCell"];
    if(_dataSource&&_dataSource.count>0){
        [cell setCell:_dataSource[indexPath.row]];
    }
    if(_dataSource&&(_dataSource.count -1)== indexPath.row){
        [cell addFullLine];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Message3VO * vo;
    if (self.dataSource.count>0) {
        vo = self.dataSource[indexPath.row];
        if (vo.unreadNum.intValue > 0) {
            int number = [DataManager getInstance].messageVC.tabBarItem.badgeValue.intValue - vo.unreadNum.intValue;
            if (number > 0) {
                [DataManager getInstance].messageVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",number];
            }else{
                [DataManager getInstance].messageVC.tabBarItem.badgeValue = nil;
            }
            
        }
        vo.unreadNum = [NSNumber numberWithInt:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        MessageViewController * view = [GHViewControllerLoader MessageViewController];
        view.groupID = vo.id;
       
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)updateTabbarItemNumber:(BOOL)isAdd number:(NSString *)number{
    
}
@end
