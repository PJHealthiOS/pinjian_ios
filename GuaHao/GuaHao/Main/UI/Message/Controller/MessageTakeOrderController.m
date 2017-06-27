//
//  MessageTakeOrderController.m
//  GuaHao
//
//  Created by qiye on 16/2/24.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "MessageTakeOrderController.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "NewOrderVO.h"
#import "Utils.h"
#import "DataManager.h"

@interface MessageTakeOrderController ()
@property (weak, nonatomic) IBOutlet UILabel * typeLab;
@property (weak, nonatomic) IBOutlet UILabel * hospitalLab;
@property (weak, nonatomic) IBOutlet UILabel * departmentLab;
@property (weak, nonatomic) IBOutlet UILabel * patientLab;
@property (weak, nonatomic) IBOutlet UILabel * dateLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *btnReceive;
@property (weak, nonatomic) IBOutlet UIImageView *imgNo;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *noLab;
@end

@implementation MessageTakeOrderController{
    NewOrderVO * orderVO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view makeToastActivity:CSToastPositionCenter];
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}

-(void)getData
{
    [[ServerManger getInstance] getMSGNewOrder:_serialNo andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    orderVO = [NewOrderVO mj_objectWithKeyValues:data[@"object"]];
                    [self initView];
                }
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

-(void)initView
{
    _titleLab.text = _mtitle;
    _hospitalLab.text = orderVO.hospitalName;
    _departmentLab.text = orderVO.departmentName;
    _noLab.text = [NSString stringWithFormat:@"-订单编号%@",orderVO.serialNo];
    _dateLab.text = orderVO.visitDate;
    _patientLab.text = [NSString stringWithFormat:@"%@ (%@)",orderVO.patientName,orderVO.patientSex];
    _btnReceive.hidden = !orderVO.canBeAccept;
    _imgNo.hidden = orderVO.canBeAccept;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMore:(id)sender {
    if (_delegate) {
        [_delegate takeOrderComplete:orderVO];
    }
}

- (IBAction)onTake:(id)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] acceptOrder:orderVO.id andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                [self getData];
                [self performSelector:@selector(onOtherBack) withObject:nil afterDelay:1.0];
            }else{
                
            }
        }
    }];
}

-(void) onOtherBack
{
    if (_delegate) {
        [_delegate takeOrderComplete:orderVO];
    }
}

@end
