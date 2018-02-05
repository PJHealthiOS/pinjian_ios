//
//  HealthCustomOrderViewController.m
//  GuaHao
//
//  Created by PJYL on 2017/4/25.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "HealthCustomOrderViewController.h"
#import "KTActionSheet.h"
#import "AddPersonViewController.h"
#import "CrateOrderSuccessView.h"
@interface HealthCustomOrderViewController ()<AddPatientDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@property (weak, nonatomic) IBOutlet UIView *typeVIew;
@property (weak, nonatomic) IBOutlet UILabel *apply_phone_label;
@property (nonatomic, strong)NSMutableArray *typeArr;
@property (nonatomic, strong)NSMutableArray *patientArr;
@property (nonatomic, strong)PatientVO *selectPatientVO;
@property (nonatomic, strong)NSMutableArray *selectArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewHeight;
@property (nonatomic, strong)CrateOrderSuccessView *successAlter;
@end

@implementation HealthCustomOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建订单";
    self.selectArr = [NSMutableArray array];
    self.imageHeight.constant = SCREEN_WIDTH * 438.0/750.0;
    [self getUserList];
    
    // Do any additional setup after loading the view.
}
///获取用户列表
-(void)getUserList{
    self.patientArr = [NSMutableArray array];
    self.typeArr = [NSMutableArray array];
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance]getHealthOrderPageData:@"2" Callback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    NSArray * arr = data[@"object"][@"patients"];
                    weakSelf.typeArr = data[@"object"][@"packageName"];
                    for (int i = 0; i<arr.count; i++) {
                        PatientVO *vo = [PatientVO mj_objectWithKeyValues:arr[i]];
                        [weakSelf.patientArr addObject:vo];
                        
                    }
                    [weakSelf layoutWithSourceArr:weakSelf.typeArr];
                    if (weakSelf.patientArr.count > 0) {
                        
                        weakSelf.selectPatientVO = weakSelf.patientArr[0];
                        [weakSelf.nameButton setTitle:weakSelf.selectPatientVO.name forState:UIControlStateNormal] ;
                        weakSelf.apply_phone_label.text = weakSelf.selectPatientVO.mobile;
                    }
                    
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}
-(void)layoutWithSourceArr:(NSArray *)sourceArr{
    float originX = 10;
    int row = 0;
    for (int i = 0; i < sourceArr.count; i++) {
        NSString *str = [sourceArr objectAtIndex:i];
        float originX_ = 10;
        originX_ = originX + str.length * 12 + 15 + 40;
        if (originX_ > SCREEN_WIDTH) {
            originX = 10;
            row = row + 1;
        }
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, row * (20 + 10) + 40, str.length * 12 + 20, 20);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x8DCEBD) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 5;
        button.layer.borderColor =  UIColorFromRGB(0x8DCEBD).CGColor;
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = YES;
        button.tag = 3100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeVIew addSubview:button];
        originX = originX + str.length * 12 + 15 + 20;
        
    }
    self.typeViewHeight.constant = row * (20 + 10) + 80;
    
}
-(void)buttonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:UIColorFromRGB(0x8DCEBD) forState:UIControlStateNormal];
    }else{
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = UIColorFromRGB(0x8DCEBD);
    }
    
    NSInteger index = sender.tag - 3100;
    NSString *str = [self.typeArr objectAtIndex:index];
    if ([self.selectArr containsObject:str]) {
        [self.selectArr removeObject:str];
        
    }else{
        [self.selectArr addObject:str];
    }
    NSLog(@"现在选中了几个------%lu",(unsigned long)self.selectArr.count);
}
///选择发起人
- (IBAction)applyPerosnAction:(UIButton *)sender {
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
        [weakSelf.nameButton setTitle:weakSelf.selectPatientVO.name forState:UIControlStateNormal] ;
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
        [self.nameButton setTitle:self.selectPatientVO.name forState:UIControlStateNormal] ;
        self.apply_phone_label.text = self.selectPatientVO.mobile;
    }
}
///输入参团人数
- (IBAction)amountEndAction:(UITextField *)sender {
    
}

///提交
- (IBAction)submitAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.selectPatientVO) {
        [self inputToast:@"请选择申请人！"];
        return;
    }
    if (self.amountText.text.intValue < 5) {
        [self inputToast:@"至少要5个人才能发起预约！"];
        return;

    }
    if (self.selectArr.count < 1) {
        [self inputToast:@"请选择套餐项目！"];
        return;
        
    }
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"patientId"] = self.selectPatientVO.id;
    dic[@"mobile"] = self.selectPatientVO.mobile;
    dic[@"teamNumbers"] = self.amountText.text;
    dic[@"serviceType"] = @"2";
    
    
        NSString *string = [self.selectArr componentsJoinedByString:@","];
        dic[@"packageContent"] = string;
    
    
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
                    HealthManagerReportDetailViewController * reportDetialVC = [GHViewControllerLoader HealthManagerReportDetailViewController];
                    reportDetialVC.orderID =  [[data objectForKey:@"object"]objectForKey:@"id"];;
                    reportDetialVC.popBack = PopBackRoot;
                    [weakSelf.navigationController pushViewController:reportDetialVC animated:YES];
                }];
                [weakSelf.view addSubview:weakSelf.successAlter];
//
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
