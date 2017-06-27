//
//  BankSelectViewController.m
//  GuaHao
//
//  Created by qiye on 16/7/13.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "BankSelectViewController.h"
#import "BankSelectTableCell.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "BankListVO.h"

@interface BankSelectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BankSelectViewController{
    NSMutableArray * datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    datas = [NSMutableArray new];
    [_tableView registerNib:[UINib nibWithNibName:@"BankSelectTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BankSelectTableCell"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self getData];
}

-(void)getData
{
    [[ServerManger getInstance] bankList:^(id data) {
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"];
                    for (int i = 0; i<arr.count; i++) {
                        BankListVO * vo = [BankListVO mj_objectWithKeyValues:arr[i]];
                        [datas addObject:vo];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BankSelectTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BankSelectTableCell"];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if(datas.count>0){
        [cell setCell:datas[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (datas.count>0) {
        BankListVO *vo = datas[indexPath.row];
        if (_delegate) {
            [_delegate bankSelectDelegate:vo];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
