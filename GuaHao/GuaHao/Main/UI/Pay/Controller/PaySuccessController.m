//
//  PaySuccessController.m
//  GuaHao
//
//  Created by qiye on 16/8/30.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PaySuccessController.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "SuccessVO.h"

@interface PaySuccessController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UILabel *labNO;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labState;
@property (weak, nonatomic) IBOutlet UILabel *labPay;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@end

@implementation PaySuccessController{
    SuccessVO * successVO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isAccompany) {
        [[ServerManger getInstance] getAccompanyPaySuccessPageData:_orderID andCallback:^(id data) {
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        
                        successVO = [SuccessVO mj_objectWithKeyValues:data[@"object"]];
                        [self initView];
                    }
                    
                }
            }
        }];

    }else{
        [[ServerManger getInstance] getPaySuccessPageData:_orderID isExpert:_isExpert andCallback:^(id data) {
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                if (code.intValue == 0) {
                    if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                        
                        successVO = [SuccessVO mj_objectWithKeyValues:data[@"object"]];
                        [self initView];
                    }
                    
                }
            }
        }];
    }
    
}

-(void)initView{
    _labPrice.text = [NSString stringWithFormat:@"总计:%@",successVO.total_fee];
    _labNO.text = successVO.serialNo;
    _labDate.text = successVO.payDate;
    _labState.text = @"支付成功";
    _labPay.text = successVO.payType;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_btnPay.frame)+47);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)onBack:(id)sender {
    if (self.isAccompany) {
        if (successVO.pzType.intValue == 0) {
            AccOrderDetailViewController *view = [GHViewControllerLoader AccOrderDetailViewController];
            view.serialNo = successVO.serialNo;
            view.popBack = PopBackRoot;
            [self.navigationController pushViewController:view animated:YES];
            return;
        }else{
            AccNewOrderDetailViewController *view = [GHViewControllerLoader AccNewOrderDetailViewController];
            view.serialNo = successVO.serialNo;
            view.popBack = PopBackRoot;
            [self.navigationController pushViewController:view animated:YES];
            return;
        }
        
    }else{
        if (_isExpert) {
            GHExpertOrderDetialViewController * view = [GHViewControllerLoader GHExpertOrderDetialViewController];
            view.orderNO = successVO.serialNo;
            view.popBack = PopBackRoot;
            view.orderType = _isExpert?1:0;
            [self.navigationController pushViewController:view animated:YES];
        }else{
            GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
            view.orderNO = successVO.serialNo;
            view.popBack = PopBackRoot;
            view.orderType = _isExpert?1:0;
            [self.navigationController pushViewController:view animated:YES];
        }

    
    }
    
}

@end
