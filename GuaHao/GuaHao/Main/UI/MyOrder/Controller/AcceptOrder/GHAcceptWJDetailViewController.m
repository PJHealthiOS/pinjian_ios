//
//  GHAcceptWJDetailViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/4/12.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "GHAcceptWJDetailViewController.h"
#import "GHAcceptOrderStatusCell.h"
#import "GHAcceptOrderWJInfoCell.h"
@interface GHAcceptWJDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) AcceptOrderVO *orderVO;
@end

@implementation GHAcceptWJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接单详情";
    
    [self getInfoDesc];
    
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)getInfoDesc
{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    /////万家接单详情页
    [[ServerManger getInstance] getWJOrderDetail:self.order.id.stringValue andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                weakSelf.orderVO = [AcceptOrderVO mj_objectWithKeyValues:data[@"object"]];
//                [weakSelf setAttentionlabelConten];
//                [weakSelf loadFootView];
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 75;
    }else if (indexPath.row == 1) {
        return 300;
    }else{
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"GHAcceptOrderStatusCell";
        
        GHAcceptOrderStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell) {
            cell = [[GHAcceptOrderStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:self.order.type.intValue];
        }
        if (_orderVO.statusLogs.count > 0) {
            [cell layoutSubviewsWithLogs:_orderVO.statusLogs];
        }
        return cell;
    }else {
        GHAcceptOrderWJInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHAcceptOrderWJInfoCell"];

        [cell renderCell:_orderVO];
        return cell;
    }
    
    ;
}

//2.确认接单 5.陪诊开始 6.陪诊结束 7.停诊
- (IBAction)startAction:(id)sender {
    [self operation:5];

}
- (IBAction)endAction:(id)sender {
    [self operation:6];

}
- (IBAction)failAction:(id)sender {
    [self operation:7];
}
- (IBAction)callAction:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://+86%@",_orderVO.patientMobile]];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)operation:(int)opID{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] wjOrderOperation:_orderVO.id operationID:[NSNumber numberWithInt:opID] andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                [self getInfoDesc];
            }
        }
    }];
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
