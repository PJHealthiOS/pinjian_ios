//
//  HealthManagerOrderDetailViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthManagerOrderDetailViewController.h"
#import "HealthManagerOrderDetailModel.h"
@interface HealthManagerOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLbel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTypeLabel;
@property (strong, nonatomic)HealthManagerOrderDetailModel *orderModel;

@end

@implementation HealthManagerOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情单";
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getHealthOrderDetialOrderID:self.orderID andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                weakSelf.orderModel = [HealthManagerOrderDetailModel mj_objectWithKeyValues:data[@"object"]];
                [weakSelf laySubviews];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];

}
-(void)laySubviews{
    self.nameLabel.text = self.orderModel.patientName;
    self.idCardLabel.text = self.orderModel.idCard;
    self.phoneLabel.text = self.orderModel.patientMobile;
    self.amountLabel.text = [NSString stringWithFormat:@"%@人",self.orderModel.teamNumbers];
    self.projectLbel.text = self.orderModel.packageName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@",self.orderModel.monthNumbers,self.orderModel.packageType.intValue == 1?@"月":@"年"];
    self.timeTypeLabel.text = [NSString stringWithFormat:@"申请%@数",self.orderModel.packageType.intValue == 1?@"月":@"年"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",self.orderModel.amount];

}
-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    //这里写要处理的代码
    NSArray *viewControllers = self.navigationController.viewControllers;
    if(!_popBack||_popBack==0){
        _popBack = PopBackDefalt;
    }
    NSUInteger num = viewControllers.count - _popBack;
    if(_popBack == PopBackRoot){
        num = 2;
    }
    [self.navigationController popToViewController:[viewControllers objectAtIndex:num] animated:YES];
    return YES;//返回NO 不会执行
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
