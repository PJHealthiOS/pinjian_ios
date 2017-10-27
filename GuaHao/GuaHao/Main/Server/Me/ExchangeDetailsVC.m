//
//  ExchangeDetailsVC.m
//  GuaHao
//
//  Created by 123456 on 16/6/22.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "ExchangeDetailsVC.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "PointVO.h"
#import "DataManager.h"
#import "SignDayesCell.h"
#import "DetailCell.h"
#import "LogsVO.h"

@interface ExchangeDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView * titleTableView;

@end

@implementation ExchangeDetailsVC{
     PointVO  * pointVO;
     LogsVO   * logesVO;
    NSMutableArray * myExchangeMuArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    myExchangeMuArray = [NSMutableArray new];
    [self getOrders];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册单元格
    [_titleTableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DetailCell"];
    [_titleTableView registerNib:[UINib nibWithNibName:@"SignDayesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SignDayesCell"];
    _titleTableView.delegate = self ;
    _titleTableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"ExchangeUpdate" object:nil];
}
-(void) getOrders{
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] getExchangeDetails:30 page:1 andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {

                pointVO = [PointVO mj_objectWithKeyValues:data[@"object"]];
                [myExchangeMuArray addObject:pointVO.logs];
                [_titleTableView reloadData];
            }else{
                [self inputToast:msg];
            }
        }
        
    }];

}

#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    pointVO.point = [DataManager getInstance].user.point;
    [_titleTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 202;
    }
    return 82;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return pointVO.logs.count +1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        DetailCell * RepeatCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        RepeatCell.goldLab.text =pointVO? pointVO.toExpirePoint.stringValue:@"0";
        RepeatCell.titleLab.text = [NSString stringWithFormat:@"个挂号豆将在%@过期",pointVO.expireDate];
        RepeatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return RepeatCell;
    }
    SignDayesCell * RepeatCell = [tableView dequeueReusableCellWithIdentifier:@"SignDayesCell"];
    RepeatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(pointVO.logs.count>0){
        LogsVO * vo = pointVO.logs[indexPath.row -1];
        [RepeatCell setCell:vo ];
    }
    return RepeatCell;
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
