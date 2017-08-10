//
//  MessageTakeOrderController.m
//  GuaHao
//
//  Created by qiye on 16/2/24.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MessageOrderDescController.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "OrderVO.h"
#import "Utils.h"
#import "DataManager.h"
#import "GHNormalOrderDetialViewController.h"
#import "GHExpertOrderDetialViewController.h"
#import "GHViewControllerLoader.h"
@interface MessageOrderDescController ()
@property (weak, nonatomic) IBOutlet UILabel * noLab;
@property (weak, nonatomic) IBOutlet UILabel * typeLab;
@property (weak, nonatomic) IBOutlet UILabel * hospitalLab;
@property (weak, nonatomic) IBOutlet UILabel * departmentLab;
@property (weak, nonatomic) IBOutlet UILabel * patientLab;
@property (weak, nonatomic) IBOutlet UILabel * dateLab;
@property (weak, nonatomic) IBOutlet UITextView *descTV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *boxView;

@end

@implementation MessageOrderDescController{
    OrderVO * orderVO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newCell:) name:@"NewCellUpdate" object:nil];
    [self getServer];
    UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
    [_boxView setUserInteractionEnabled:YES];
    [_boxView addGestureRecognizer:tapGuesture1];
}

-(void)getServer
{
    [self.view makeToastActivity:CSToastPositionCenter];
    if(_isExpert){
        [[ServerManger getInstance] getOrderExpertStatus:_serialNo longitude:@"" latitude:@"" andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    orderVO = [OrderVO mj_objectWithKeyValues:data[@"object"]];
                    [self initView];
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }else{
        [[ServerManger getInstance] getOrderStatus:_serialNo longitude:@"" latitude:@"" andCallback:^(id data) {
            
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        orderVO = [OrderVO mj_objectWithKeyValues:data[@"object"]];
                        [self initView];
                    }
                }else{
                    [self inputToast:msg];
                }
            }
        }];
    }
}

-(void)initView
{
    _titleLab.text = _mtitle;
    _hospitalLab.text = orderVO.hospName;
    _departmentLab.text = orderVO.deptName;
    _typeLab.text = orderVO.outpatientType;
    _noLab.text = [NSString stringWithFormat:@"-预约编号%@",orderVO.serialNo];
    _dateLab.text = orderVO.visitDate;
    _patientLab.text = [NSString stringWithFormat:@"%@ (%@)",orderVO.patientName,orderVO.patientSex];
    
    _descTV.text = _desc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)newCell:(NSNotification *)notification{
    [self getServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) func1:(UITapGestureRecognizer *) tap{
    if (_isExpert) {
        GHExpertOrderDetialViewController * view = [GHViewControllerLoader GHExpertOrderDetialViewController];
        view.orderNO = orderVO.serialNo;
        view.popBack = PopBackRoot;
        view.orderType = _isExpert?1:0;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
        view.orderNO = orderVO.serialNo;
        view.popBack = PopBackRoot;
        view.orderType = _isExpert?1:0;
        [self.navigationController pushViewController:view animated:YES];
    }
    
}
@end
