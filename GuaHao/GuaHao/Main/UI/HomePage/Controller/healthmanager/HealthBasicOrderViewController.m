//
//  HealthBasicOrderViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/25.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthBasicOrderViewController.h"
#import "KTActionSheet.h"
#import "AddPersonViewController.h"
#import "CrateOrderSuccessView.h"

@interface HealthBasicOrderViewController ()<AddPatientDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *apply_phone_label;
@property (weak, nonatomic) IBOutlet UIButton *apply_nameButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@property (weak, nonatomic) IBOutlet UITextField *monthText;
@property (weak, nonatomic) IBOutlet UITextField *yearText;
@property (nonatomic, strong)CrateOrderSuccessView *successAlter;
@property (nonatomic, strong)NSMutableArray *patientArr;
@property (nonatomic, strong)PatientVO *selectPatientVO;
@end

@implementation HealthBasicOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建订单";
    self.imageHeight.constant = SCREEN_WIDTH * 438.0/750.0;
    self.yearText.userInteractionEnabled = NO;

    [self getUserList];
    // Do any additional setup after loading the view.
}
///获取用户列表
-(void)getUserList{
    self.patientArr = [NSMutableArray array];
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getHealthOrderPageData:@"1" Callback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"][@"patients"];
                    for (int i = 0; i<arr.count; i++) {
                        PatientVO *vo = [PatientVO mj_objectWithKeyValues:arr[i]];
                        [weakSelf.patientArr addObject:vo];
                        
                    }
                    if (weakSelf.patientArr.count > 0) {
                        
                        weakSelf.selectPatientVO = weakSelf.patientArr[0];
                        [weakSelf.apply_nameButton setTitle:weakSelf.selectPatientVO.name forState:UIControlStateNormal] ;
                        weakSelf.apply_phone_label.text = weakSelf.selectPatientVO.mobile;
                    }
                    
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}

///选择发起人
- (IBAction)applyPerosnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.view endEditing:YES];
    if (self.patientArr.count == 0) {
        [self addPatient];
        return;
    }
    NSMutableArray * nameArray = [NSMutableArray array];
    for (int i=0; i<self.patientArr.count; i++) {
        PatientVO * vo = self.patientArr[i];
        [nameArray addObject:vo.name];
    }
    if (nameArray.count<5) {
        [nameArray addObject:@"新增就诊人"];
    }
    KTActionSheet *actionSheet = [[KTActionSheet alloc] initWithTitle:@"请选择就诊人" itemTitles:nameArray];
    actionSheet.delegate = self;
    actionSheet.tag = 50;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        
        NSLog(@"block----%ld----%@", (long)index, title);
        if ([title isEqualToString:@"新增就诊人"]) {
            if (weakSelf.patientArr.count>=5) {
                [weakSelf inputToast:@"您的家庭成员数量到达上限!"];
                return ;
            }
            [weakSelf addPatient];
            return ;
        }
        weakSelf.selectPatientVO = weakSelf.patientArr[index];
        [weakSelf.apply_nameButton setTitle:weakSelf.selectPatientVO.name forState:UIControlStateNormal] ;
        weakSelf.apply_phone_label.text = weakSelf.selectPatientVO.mobile;
    }];
    
}

-(void)addPatient
{
    AddPersonViewController * vc = [[AddPersonViewController alloc] init];
    vc.delegate = self;
    vc.openType = 3;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addComplete:(PatientVO *)vo{
    if (vo) {
        [self.patientArr addObject:vo];
        self.selectPatientVO = vo;
        [self.apply_nameButton setTitle:self.selectPatientVO.name forState:UIControlStateNormal] ;
        self.apply_phone_label.text = self.selectPatientVO.mobile;
    }
}

///输入参团人数
- (IBAction)amountEndAction:(UITextField *)sender {
    
}
///选择月数
- (IBAction)monthAction:(UITextField *)sender {
    [self.view endEditing:YES];
    
}
///选择年数
- (IBAction)yearAction:(UITextField *)sender {
    [self.view endEditing:YES];
    
    
}
///选择年还是月
- (IBAction)switchAction:(UISwitch *)sender {
    [self.view endEditing:YES];
    if (sender.isOn) {
        self.monthText.text = nil;
        self.monthText.userInteractionEnabled = NO;
        self.yearText.userInteractionEnabled = YES;
    }else{
        self.yearText.text = nil;
        self.yearText.userInteractionEnabled = NO;
        self.monthText.userInteractionEnabled = YES;
    }
}

///提交
- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.view endEditing:YES];
    if (!self.selectPatientVO) {
        [self inputToast:@"请选择申请人！"];
        return;
    }
    if (self.amountText.text.intValue < 5) {
        [self inputToast:@"至少要5个人才能发起预约！"];
        return;
        
    }
    if (self.monthText.text.length < 1 && self.yearText.text.length < 1) {
        [self inputToast:@"请选择年份或月份！"];
        return;
        
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"serviceType"] = @"1";
    dic[@"mobile"] = self.selectPatientVO.mobile;
    dic[@"patientId"] = self.selectPatientVO.id;
    if (self.switchButton.isOn) {
        dic[@"packageType"] = @"2";
        dic[@"monthNumbers"] = self.yearText.text;
    }else{
        dic[@"packageType"] = @"1";
        dic[@"monthNumbers"] = self.monthText.text;
    }
    dic[@"teamNumbers"] = self.amountText.text;
    
    
    __weak typeof(self) weakSelf =self;
    [[ServerManger getInstance]createHealthManagerOrder:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [weakSelf inputToast:msg];
                weakSelf.successAlter = [[CrateOrderSuccessView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, weakSelf.view.height)];
                [weakSelf.successAlter clickShopAction:^(BOOL result) {
                    HealthManagerOrderDetailViewController * orderDetialVC = [GHViewControllerLoader HealthManagerOrderDetailViewController];
                    orderDetialVC.orderID =  [[data objectForKey:@"object"]objectForKey:@"id"];
                    orderDetialVC.popBack = PopBackRoot;
                    [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
                }];
                [weakSelf.view addSubview:weakSelf.successAlter];
                
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
    
    
    
    

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
