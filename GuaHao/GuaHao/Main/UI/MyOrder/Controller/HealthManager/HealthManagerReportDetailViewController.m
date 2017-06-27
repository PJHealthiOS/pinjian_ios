//
//  HealthManagerReportDetailViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/28.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthManagerReportDetailViewController.h"
#import "HealthManagerOrderDetailModel.h"
@interface HealthManagerReportDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (strong, nonatomic)HealthManagerOrderDetailModel *orderModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewHeight;
@property (strong, nonatomic)NSArray *sourceArr;
@end

@implementation HealthManagerReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情单";
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] getHealthOrderDetialOrderID:self.orderID andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                                self.orderModel = [HealthManagerOrderDetailModel mj_objectWithKeyValues:data[@"object"]];
                [self laySubviews];
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}
-(void)laySubviews{
    self.nameLabel.text = self.orderModel.patientName;
    self.idCardLabel.text = self.orderModel.idCard;
    self.phoneLabel.text = self.orderModel.patientMobile;
    self.amountLabel.text = [NSString stringWithFormat:@"%@人",self.orderModel.teamNumbers];
    
    self.sourceArr = self.orderModel.packageContent;
    float originX = 10;
    int row = 0;
    for (int i = 0; i < self.sourceArr.count; i++) {
        NSString *str = [self.sourceArr objectAtIndex:i];
        float originX_ = 10;
        originX_ = originX + str.length * 12 + 15 + 40;
        if (originX_ > SCREEN_WIDTH) {
            originX = 10;
            row = row + 1;
        }
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(originX, row * (20 + 10) + 40, str.length * 12 + 20, 20);
        label.text = str ;
        label.textColor = UIColorFromRGB(0x8DCEBD);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 5;
        label.layer.borderColor =  UIColorFromRGB(0x8DCEBD).CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        
        [self.typeView addSubview:label];
        originX = originX + str.length * 12 + 15 + 20;
        
    }
    self.typeViewHeight.constant = row * (20 + 10) + 80;
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
