//
//  CreateOrderNormalViewController.m
//  GuaHao
//
//  Created by 123456 on 16/7/26.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderNormalViewController.h"
#import "CreateOrderPriceCell.h"
#import "CreateOrderNormalCell.h"
#import "CreateOrderProtocolCell.h"
#import "CreateOrderRemarkCell.h"
#import "Utils.h"
#import "ServerManger.h"
#import "UIViewController+Toast.h"
#import "PatientVO.h"
#import "DataManager.h"
#import "HtmlAllViewController.h"
#import "KTActionSheet.h"
#import "SpecialHTMLViewController.h"
#import "UUDatePicker.h"
#import "CustomUIActionSheet.h"
#import "OrderVO.h"
#import "ConditionRemarksVC.h"
#import "ValueVO.h"
#import "WriteIDcardView.h"
#import "ChooseHospitalVC.h"
#import "ChooseDepartmentsVC.h"
#import "OrderSureView.h"
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"
#import "CreateOrderVO.h"
#import "OrderReviseView.h"
#import "TipSureView.h"
#import "AddPersonViewController.h"
#import "PayViewController.h"
#import "GHOrderTypeChooseController.h"
#import "AppointmentViewController.h"
#import "PonitViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "PatientCertificationVC.h"
#import "GHFixPhoneNumberView.h"
#import "CreateOrderSubmitCell.h"
#import "CreateOrderCardPriceCell.h"
/////////////////////
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define RGB(R, G, B)           [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define RGB_A(R, G, B, A)      [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A/1.0f]


@interface CreateOrderNormalViewController ()<UITableViewDelegate,UITableViewDataSource,ConditionRemarksDelegate,CertificationDelegate,AddPatientDelegate,WriteIDcardViewDelegate,OrderReviseDelegate,TipSureViewDelegate,UIAlertViewDelegate>{

    UIActionSheet          * typeSheet;
    NSNumber                * orderID;
    NSString                * orderNO;
    NSString *socialSecurityCardStr;
    CreateOrderVO          * infoVO;
    NSMutableArray * patients;///家庭成员

    UUDatePicker *datePicker2;
    CustomUIActionSheet * sheet;
    WriteIDcardView * loctationVC;
    NSString *   idStr;
    OrderSureView *       sureView;
    TipSureView * tipSureView;
    NSMutableDictionary * selectDic;
    ConditionRemarksVC *  remarkVC;
    BOOL _certificatResult;
    HospitalVO *_selectHostipal;

    BOOL hasLocatioed;
//    GHFixPhoneNumberView *fixPhoneNumView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonnull) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *LeftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpeace;



@end

@implementation CreateOrderNormalViewController


- (IBAction)ChangeTableViewAction:(UIButton *)sender {
    self.leftSpeace.constant = CGRectGetMinX(sender.frame);
    if (sender.tag == 2101) {
        self.LeftButton.selected = YES;
        self.rightButton.selected = NO;
        _level = @"0";
        _hospital =nil;
        _department = nil;
    }else{
        self.rightButton.selected = YES;
        self.LeftButton.selected = NO;
        _hospital =nil;
        _department = nil;
        _level = @"1";
    }
    [self updateSource];
    [self getInfo:@"" lati:@""];
}



-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    NSLog(@"wdewewewewwewee");
    //这里写要处理的代码
    [self.navigationController popViewControllerAnimated:YES];
    return YES;//返回NO 不会执行
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"OrdinaryRegistrationPage"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrdinaryRegistrationPage"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"普通挂号";
    _level = @"0";
    self.LeftButton.selected = YES;
    [self registerTableView];//设置列表
    [self getInfo:@"" lati:@""];;///获得地理位置
    if (self.isHomeCome) {
        [self ChangeTableViewAction:self.rightButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotify:) name:@"UserMSGUpdate" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}



///设置列表
-(void)registerTableView{
    self.tableView.backgroundColor = RGB(244, 244, 244);
    [self updateSource];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderPriceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderPriceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderSubmitCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderSubmitCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderNormalCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderNormalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderProtocolCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderProtocolCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderRemarkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderRemarkCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderCardPriceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderCardPriceCell"];
}
-(void)updateSource{
    self.dataSource = [NSMutableArray array];
    NSArray *hospitalArr = @[@{@"type":@"order_hospital.png",@"value":@"请选择就诊医院"},@{@"type":@"order_department.png",@"value":@"请选择就诊科室"},@{@"type":@"order_date.png",@"value":@"请选择时间"},@{@"type": @"order_warning.png",@"value":[_level isEqualToString:@"0"] ? @"该时间为品简专员为您挂号的时间段，挂号成功后，请于挂号当日该时间段内联系专员到院取号就诊。" :@"该时间为您预约就诊的时间，预约成功后，在该时间段内到院自行挂号就诊即可"}];
    NSArray *PersonArr = @[@{@"type":@"order_person.png",@"value":@"请选择就诊人"},@{@"type":@"order_phoneNumber.png",@"value":@"手机号"}];
    NSArray *feeArr = @[@{@"type":@"挂号费用",@"value":@"0 元"},@{@"type":@"陪诊服务",@"value":@""}];
    NSArray *payArr = @[@{@"type":@"总计",@"value":@"0 元"},@{@"type":@"支付方式",@"value":[_level isEqualToString:@"0"] ? @"在线支付":@"到院支付"}];
    NSArray *Arr4 = @[@{@"type":@"病情备注",@"value":@""}];
    NSArray *Arr5 = @[@{@"type":@"病情备注",@"value":@""}];
    [self.dataSource addObject:hospitalArr];
    [self.dataSource addObject:PersonArr];
    [self.dataSource addObject:feeArr];
    [self.dataSource addObject:payArr];
    [self.dataSource addObject:Arr4];
    [self.dataSource addObject:Arr5];
}
//返回
- (IBAction)backAction:(id)sender {
    //是否放弃创建订单

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"放弃本次订单" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续编写", nil];
    [alertView show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:YES];
    }else{
}
}

//提交订单
-(void)submitOrder{
    


    if (!_hospital) {
        [self inputToast:@"请选择就诊医院！"];
        return;
    }
    if (!_department) {
        [self inputToast:@"请选择就诊科室！"];
        return;
    }
    if ([[self getLabelValueWithSection:0 row:2] isEqualToString:@"请选择时间"]) {
        [self inputToast:@"请填写挂号时间！"];
        return;
    }
    if ([[self getLabelValueWithSection:1 row:0] isEqualToString:@"请选择就诊人"]) {
        [self inputToast:@"请点击编辑，补全挂号人资料！"];
        return;
    }
    if (self.rightButton.selected == YES) {
        if (_hospital.isNeedSSC) {
            if (_patientVO.socialSecurityCard.length < 3 && socialSecurityCardStr.length < 3) {
                [self addSocialCard];///添加社保卡号
                return;
            }else{
                socialSecurityCardStr = _patientVO.socialSecurityCard;
            }

        }
    }
    
    if ([[self getLabelValueWithSection:1 row:1] isEqualToString:@"手机号"]) {
        [self inputToast:@"请填写手机号！"];
        return;
    }
    
    
    if(!sureView){
        CGRect frame = self.view.frame;
        sureView = [[OrderSureView alloc] initWithFrame:frame];
    }
    [sureView setName:_patientVO.name content:[self getLabelValueWithSection:0 row:2] fromNormal:YES];
    [sureView clickSureAction:^(BOOL result) {
        [self orderSureAction];
    }];
    [self.view addSubview:sureView];

}
-(void)orderPayCompleteDelegate:(BOOL) sucess indexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"click14"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewCellUpdate" object:nil];
}



-(void)orderSureAction
{
    
    [sureView removeFromSuperview];
   
        BOOL alreadycertificate = NO;
        if (!_certificatResult) {
            if (_patientVO.status) {
                if (_patientVO.status.intValue == 2) {
                    alreadycertificate = YES;
                }
            }
        }else{
            alreadycertificate = YES;
        }
        if (_hospital.isNeedRealnameAuth && !alreadycertificate) {
            ///去认证
            PatientCertificationVC * view = [[PatientCertificationVC alloc]init];
            view.delegate = self;
            view.patientVO = _patientVO;
            __weak typeof(self) weakSelf = self;
            [view certificateAction:^(BOOL result) {
                _certificatResult = YES;
                [weakSelf getInfo:@"" lati:@""];
            }];
            [self.navigationController pushViewController:view animated:YES];
            return;
        }

        if (!infoVO.isCheckMedicalCardMatch) {
            [self createOrder];
            return;
        }
        [[ServerManger getInstance] checkMedicalCardIsMatchHospital:_patientVO.id hospitalID:_hospital.id andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (code.intValue == 0) {
                    [self createOrder];
                }else{
                    [self popTipSure];
                }
            }
        }];
    
}
-(void)popTipSure
{
    if (!tipSureView) {
        CGRect frame = self.view.frame;
        tipSureView = [[TipSureView alloc] initWithFrame:frame];
        [tipSureView setNames:_patientVO.name];
        tipSureView.delegate = self;
    }
    tipSureView.patient = _patientVO;
    [self.view addSubview:tipSureView];
}
-(void)tipSureDelegate:(BOOL) isSure
{
    [self createOrder];
}
-(void)createOrder
{
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    if (self.hospital.issuingFee.integerValue > 0) {
        dic[@"issuingFee"] = self.hospital.issuingFee;
    }
    dic[@"socialSecurityCard"] = socialSecurityCardStr;
    dic[@"payType"] = [[self getLabelValueWithSection:3 row:1] isEqualToString:@"在线支付"] ? @"1" : @"2";
    dic[@"patientId"] = _patientVO.id;
    dic[@"hospitalId"] = [NSString stringWithFormat:@"%@",_hospital.id];
    dic[@"departmentId"] = [NSString stringWithFormat:@"%@",_department.id];
    dic[@"registrationFee"] = [[self getLabelValueWithSection:2 row:0]substringToIndex:2];
    dic[@"serviceFee"] = infoVO.serviceFee.stringValue;
    dic[@"visitType"] = _level;
    dic[@"visitDate"] = [self getLabelValueWithSection:0 row:2];
    dic[@"patientComments"] = [self getLabelValueWithSection:4 row:0];
    [[ServerManger getInstance] createOrder:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if(code.intValue == 100018){
                [self getBeanView];
                return ;
            }
            [self inputToast:msg];
            if (code.intValue == 0) {
                orderID = data[@"object"][@"id"];
                orderNO = data[@"object"][@"serialNo"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewCellUpdate" object:nil];
                [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
            }else{
                
            }
        }
    }];
}

-(void)onBack{
    
    if([_level isEqualToString:@"0"] && [[self getLabelValueWithSection:3 row:1]isEqualToString:@"在线支付"]){
        PayViewController * view = [GHViewControllerLoader PayViewController];
        view.orderID = orderID;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        GHNormalOrderDetialViewController * view = [GHViewControllerLoader GHNormalOrderDetialViewController];
        view.orderType = 0;
        view.orderNO = orderNO;
        view.popBack = PopBackRoot;
        [self.navigationController pushViewController:view animated:YES];

        
        
//        AppointmentViewController *view = [GHViewControllerLoader AppointmentViewController];
//        view.orderNO = orderNO;
//        [self.navigationController pushViewController:view animated:YES];
    }
}

-(void)getBeanView{
    UIView * view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.6;
    [self.view addSubview:view];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, SCREEN_HEIGHT*0.2, SCREEN_WIDTH*0.7, SCREEN_WIDTH*0.472)];
    [btn setImage:[UIImage imageNamed:@"bean_not.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(didClickBean) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickBean
{
    PonitViewController * view = [[PonitViewController alloc]init];
    view.popBack = PopBackRoot;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)popLocation
{
    if (!loctationVC) {
        CGRect frame = self.view.frame;
        loctationVC = [[WriteIDcardView alloc] initWithFrame:frame];
        loctationVC.delegate = self;
    }
    [self.view addSubview:loctationVC];
}
-(void) writeIDcardDelegate:(NSString*) content
{
    idStr = content;
    [loctationVC removeFromSuperview];
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArr = [self.dataSource objectAtIndex:section];
    return sectionArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 30;
    }
    if (indexPath.section == 5) {
        return 230;
    }
    return 54;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArr = [self.dataSource objectAtIndex:indexPath.section];
    NSDictionary *dic = [sectionArr objectAtIndex:indexPath.row ];
    NSInteger cellType = 0;
    if (indexPath.section == 0 ) {
        if(indexPath.row == 3){
            cellType = 2;
        }
    }
    if (indexPath.section == 2 ) {
        if (indexPath.row == 0) {
            cellType = 1;///挂号费用
        }else if (indexPath.row == 1){
            cellType = 3;///免费陪诊
        }else if (indexPath.row == 2){///工本费
            cellType = 5;
        }else{
             cellType = 2;
        }
        
    }
    if (indexPath.section == 3 ) {
        if (indexPath.row == 0) {
            cellType = 1;///总计费用
        }else {
            cellType = 3;///支付方式
        }
        
    }
    if (indexPath.section == 4) {
        cellType = 3;
    }
    if (indexPath.section == 5) {
        cellType = 4;
    }
    UITableViewCell *cell = [self returnCellType:cellType andtypeName:[dic objectForKey:@"type"] andvalue:[dic objectForKey:@"value"] andIndexPath:indexPath];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(BOOL)isbottomCell:(NSIndexPath *)indexPath{
    if(indexPath.row  + 1== [self.dataSource[indexPath.section] count] ){
        return YES;
    }
    return NO;
}

-(UITableViewCell *)returnCellType:(NSInteger)cellType andtypeName:(NSString *)typeName andvalue:(NSString *)valueName andIndexPath:(NSIndexPath *)indexPath{
    if (cellType == 0) {
        CreateOrderNormalCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderNormalCell"];
        [CreateOrderNormalCell renderCell:cell typeStr:typeName valueStr:valueName];
        return cell;
        
    }else if (cellType == 1) {
        CreateOrderPriceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderPriceCell"];
        [CreateOrderPriceCell renderCell:cell typeStr:typeName valueStr:valueName];
        return cell;
        
    }else if (cellType == 2) {
        CreateOrderProtocolCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderProtocolCell"];
        cell.content_label.text = valueName;
        
        return cell;
    }else if (cellType == 3){
        CreateOrderRemarkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderRemarkCell"];
        [CreateOrderRemarkCell renderCell:cell typeStr:typeName valueStr:valueName];
        if (indexPath.section == 2 && indexPath.row == 1) {
            cell.valueLabel.attributedText = [self getAttributedStr];
        }
        
        return cell;
    }else if (cellType == 5){
        CreateOrderCardPriceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderCardPriceCell"];
        [CreateOrderCardPriceCell renderCell:cell typeStr:typeName descStr:@"" valueStr:valueName];
        
        return cell;
    }else{
        
        __weak typeof(self) weakSelf = self;
        CreateOrderSubmitCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderSubmitCell"];
        [cell submitAction:^(BOOL isSubmit) {
            if (isSubmit) {
                [weakSelf submitOrder];
            }else{
                HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
                view.mTitle = @"预约规则";
                view.mUrl   =infoVO.ruleDocUrl;
                [weakSelf.navigationController pushViewController:view animated:YES];
 
                
                

            }
        }];
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"section---> %ld,row--->%ld",indexPath.section,indexPath.row);
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:///选择医院
                {
                    [self chooseHospital];
                }
                    break;
                case 1://选择科室
                {
                    [self choseDepartment];
                }
                    break;
                case 2://选择时间
                {
                    [self choseDate];
                }
                    break;
                case 3://门诊类型不可选
                {
//                    if (_isChildren) {
//                        return;
//                    }
//                    
//                    if (!_department) {
//                        [self inputToast:@"请先选择科室！"];
//                        return;
//                    }
//                    __weak typeof(self) weakSelf = self;
//                    GHOrderTypeChooseController *view = [GHViewControllerLoader GHOrderTypeChooseController];
//                    view.openStatus = _department.openStatus;
//                    view.myBlock = ^(BOOL type){
//                        weakSelf.level = type?@"1":@"0";
//                        [weakSelf updateTableViewWithSection:0 row:3 key:@"value" newValue:@"请选择时间"];
//                        [weakSelf updateTableViewWithSection:0 row:2 key:@"value" newValue:type?@"预约":@"挂号"];
//                        [weakSelf choseDate];
//                    };
//                    [self.navigationController pushViewController:view animated:YES];
                }
                    break;
                default:
                    break;
            }
            
            
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0://选人
                {
                    [self chosePerson];

                }
                    break;
                case 1:
                {
                    [self chosePhoneNumber];
                }
                    break;
  
                default:
                    break;
            }
            
            
        }
            break;
        case 2:
        {
            
            ///只有点击陪诊费用才跳转到介绍页
            if (indexPath.row == 1) {
                SpecialHTMLViewController * view = [[SpecialHTMLViewController alloc] init];
                
                view._title = @"陪诊"; view._url = infoVO.pzUrl;
                view.content = [self getAttributedStr];;
                [self.navigationController pushViewController:view animated:YES];
            }else{
                return;
            }

 
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    return;
                }
                    break;
                case 1:
                {
                    if ([_level isEqualToString:@"0"]) {//自费挂号
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        __weak typeof(self) weakSelf = self;
                        [alertController addAction:[UIAlertAction actionWithTitle:@"在线支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSLog(@"在线支付");
                            [weakSelf updateTableViewWithSection:3 row:1 key:@"value" newValue:@"在线支付"];
                        }]];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"到院支付" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            NSLog(@"到院支付");
                            [weakSelf updateTableViewWithSection:3 row:1 key:@"value" newValue:@"到院支付"];
                        }]];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
            break;
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self addPersonRemark];
                }
                    break;
                case 1:
                {
                    
                }
                    break;

                default:
                    break;
            }
            
            
        }
            break;
        default:
            break;
    }
    
}
-(NSAttributedString *)getAttributedStr{
    if (_department.serviceFee.floatValue > 0) {
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元 ",infoVO.orderPzFee] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]}];
        return nameString;
        
        
    }else{
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(原价%@元)",infoVO.orderOriginPzFee] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        
        
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元 ",infoVO.orderPzFee] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]}];
        [nameString appendAttributedString:attrStr];
        return nameString;
        
    }
    
    
}
#pragma mark - 各种选择

-(void)addSocialCard{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"添加社保卡号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertControl) wAlert = alertControl;
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // 点击确定按钮的时候, 会调用这个block
        NSLog(@"社保卡号-----%@",[wAlert.textFields.firstObject text]);
        socialSecurityCardStr = [wAlert.textFields.firstObject text];
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"请输入社保卡号";
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        //监听文字改变的方法
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}



///选择医院
-(void)chooseHospital{
    [MobClick event:@"click9"];

       ChooseHospitalVC* hospitalVC = [[ChooseHospitalVC alloc]init];
        __weak typeof(self) weakSelf = self;
        hospitalVC.isCommon = YES;
    
        hospitalVC.isOppointment = self.LeftButton.selected ? 0:1;
        hospitalVC.onBlockHospital = ^(HospitalVO * vo,DepartmentVO * dvo){
            [weakSelf onBlockHospital:vo department:dvo];
        };
    
    [self.navigationController pushViewController:hospitalVC animated:YES];
}
///选择医院回调
-(void)onBlockHospital:(HospitalVO *)vo department:(DepartmentVO*) dvo{
    _hospital = vo;
    _department = nil;
    if (vo.issuingFee.intValue > 0) {///有工本费
        ///插入一行
        
        NSMutableArray *sectionTwo = [NSMutableArray arrayWithArray: [self.dataSource objectAtIndex:2]];
        if (sectionTwo.count == 2) {
            [sectionTwo addObject:@{@"type":@"工本费用",@"value":vo.issuingFee}];
            [self.dataSource replaceObjectAtIndex:2 withObject:sectionTwo];
        }
        
    }else{
        NSMutableArray *sectionTwo = [NSMutableArray arrayWithArray: [self.dataSource objectAtIndex:2]];
        if (sectionTwo.count > 2) {
            [sectionTwo removeLastObject];
            [self.dataSource replaceObjectAtIndex:2 withObject:sectionTwo];
        }
    }
    [self updateTableViewWithSection:0 row:0 key:@"value" newValue:_hospital.name];
    [self updateTableViewWithSection:4 row:0 key:@"value" newValue:@""];
    if(dvo){
        [self onBlockDepartment:dvo];
    }
    selectDic = nil;
}
//选择部门
-(void)choseDepartment{
    if (!_hospital) {
        [self inputToast:@"请先选择医院！"];
        return;
    }

       ChooseDepartmentsVC *departmentVC = [GHViewControllerLoader ChooseDepartmentsVC];
        departmentVC.hospital = _hospital;
        departmentVC.isOppointment = self.LeftButton.selected ? 0:1;
        departmentVC.popBackType = PopBackDefalt;
        departmentVC.isChildren = _isChildren;
        __weak typeof(self) weakSelf = self;
        departmentVC.onBlockDepartment = ^(DepartmentVO * dvo){
            [weakSelf onBlockDepartment:dvo];
        };

    [self.navigationController pushViewController:departmentVC animated:YES];
}
//选择部门回调
-(void) onBlockDepartment:(DepartmentVO*) vo
{
    selectDic = nil;
    _department = vo;

    [self updateTableViewWithSection:0 row:1 key:@"value" newValue:vo.name];
    [self updateTableViewWithSection:4 row:0 key:@"value" newValue:@""];
    [self choseDate];
}
//选择时间
-(void)choseDate{
    [MobClick event:@"click8"];
    if(datePicker2){
        [datePicker2 removeFromSuperview];
        datePicker2 = nil;
    }
    if(sheet){
        [sheet animationDidStop];
        sheet = nil;
    }
    [self initDatePicker];
    [sheet setActionView:datePicker2];
    [sheet showInView:self.view];

}
-(void) initDatePicker
{
    if (!_department) {
        [self inputToast:@"请先选择科室！"];
        return;
    }
    datePicker2
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)
                             PickerStyle:4
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 NSString * text = [year isEqualToString:@""]?@"请选择时间":[NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,weekDay];
                                 [self updateTableViewWithSection:0 row:2 key:@"value" newValue:text];
                                 
                             }];
    datePicker2.isChildren = _isChildren;
    datePicker2.isUseSocialCard = self.rightButton.selected;
    datePicker2.minLimitDate = [[NSDate date]dateByAddingTimeInterval:0];
    datePicker2.isAdult = (_hospital.type.intValue==0);
    datePicker2.openDays = _department.weekSchedule;
    datePicker2.startByHalfDay = _department.startByHalfDay.intValue;

    sheet = [[CustomUIActionSheet alloc] init];
    datePicker2.sheet = sheet;
}

#pragma mark - Internal
-(void)pushNotify:(NSNotification *)notification
{
    if (notification.userInfo != nil || notification.userInfo[@"extras"][@"type"] != nil ) {
        NSInteger  type = [notification.userInfo[@"extras"][@"type"] integerValue];
        if (type == 14) { //verifyStatus:3;
            NSString * obj = notification.userInfo[@"extras"][@"obj"];
            NSArray *arr1 = [obj componentsSeparatedByString:@";"];
            if(arr1&&arr1.count>1){
                NSArray *brr1 = [arr1[0] componentsSeparatedByString:@":"];
                NSArray *brr2 = [arr1[1] componentsSeparatedByString:@":"];
                if(brr1&&brr2&&brr1.count>1&&brr2.count>1){
                    if([brr1[0] isEqualToString:@"realnameAuthStatus"]&&[brr1[1] isEqualToString:@"2"]){
                        NSString * pid = brr2[1];
                        for (int i=0; i<patients.count; i++) {
                            PatientVO * vo = patients[i];
                            if(vo.id.intValue == pid.intValue){
                                vo.status = [NSNumber numberWithInt:2];
                            }
                        }
                    }else if([brr2[0] isEqualToString:@"realnameAuthStatus"]&&[brr2[1] isEqualToString:@"2"]){
                        NSString * pid = brr1[1];
                        for (int i=0; i<patients.count; i++) {
                            PatientVO * vo = patients[i];
                            if(vo.id.intValue == pid.intValue){
                                vo.status = [NSNumber numberWithInt:2];
                            }
                        }
                    }
                }
                
            }

        }
    }
}

//选人
-(void)chosePerson{
    if (patients.count == 0) {
        [self popRevise];
        return;
    }
    NSMutableArray * bankNames1 = [NSMutableArray new];
    for (int i=0; i<patients.count; i++) {
        PatientVO * vo = patients[i];
        [bankNames1 addObject:vo.name];
    }
    if(bankNames1.count<5){
        [bankNames1 addObject:@"新增就诊人"];
    }
    KTActionSheet *actionSheet = [[KTActionSheet alloc] initWithTitle:@"请选择就诊人" itemTitles:bankNames1];
    actionSheet.delegate = self;
    actionSheet.tag = 50;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        
        NSLog(@"block----%ld----%@", (long)index, title);
        if ([title isEqualToString:@"新增就诊人"]) {
            if (patients.count>=5) {
                [self inputToast:@"您的家庭成员数量到达上限!"];
                return ;
            }
            [self popRevise];
            return ;
        }
        _patientVO = patients[index];
        NSString * text = [NSString stringWithFormat:@"%@", title];
        
        BOOL alreadycertificate = NO;
        if (!_certificatResult) {
            if (_patientVO.status) {
                if (_patientVO.status.intValue == 2) {
                    alreadycertificate = YES;
                }
            }
        }else{
            alreadycertificate = YES;
        }
        
        if (_hospital.isNeedRealnameAuth && !alreadycertificate) {
            ///去认证
            PatientCertificationVC * view = [[PatientCertificationVC alloc]init];
            view.delegate = self;
            view.patientVO = _patientVO;
            [view certificateAction:^(BOOL result) {
                NSLog(@"认证成功");
                _certificatResult = YES;
                [weakSelf getInfo:@"" lati:@""];
                
            }];
            [self.navigationController pushViewController:view animated:YES];
        }

        [weakSelf updateTableViewWithSection:1 row:0 key:@"value" newValue:text];
        [weakSelf updateTableViewWithSection:1 row:1 key:@"value" newValue:_patientVO.mobile];
    }];
}
-(void) delegateConditionRemark:(NSMutableDictionary*) value
{
    if([value objectForKey:@"allText"])[self updateTableViewWithSection:4 row:0 key:@"value" newValue:[value objectForKey:@"allText"]];
    selectDic = value;
}

//修改电话号码
-(void)chosePhoneNumber{
    if(_patientVO==nil){
        [self inputToast:@"请填写或选择挂号人！"];
        return;
    }
    CGRect frame = self.view.frame;
    

        GHFixPhoneNumberView*  fixPhoneNumView = [[GHFixPhoneNumberView alloc]initWithFrame:frame];
        fixPhoneNumView.patientID = [NSString stringWithFormat:@"%@",_patientVO.id];
        fixPhoneNumView.frame = [UIScreen mainScreen].bounds;
        NSLog(@"fixPhoneNumView.patientID--%@",fixPhoneNumView.patientID);
        fixPhoneNumView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        [fixPhoneNumView fixPhoneNumber:^(NSString *phoneNumber) {
             [self updateTableViewWithSection:1 row:1 key:@"value" newValue:phoneNumber];
            if (fixPhoneNumView) {
                [fixPhoneNumView removeFromSuperview];
            }
            
        }];
    
    
    [self.view addSubview:fixPhoneNumView];
    

}

//添加病情备注
-(void)addPersonRemark{
    //判断有没有科室
    
   NSString *departStr = [self getLabelValueWithSection:0 row:1];
    if ([departStr isEqualToString:@"请选择就诊科室"]) {
         [self inputToast:@"请选择科室"];
        return;
    }
    
    if (!remarkVC) {
        remarkVC = [[ConditionRemarksVC alloc] init];
        remarkVC.delegate = self;
        remarkVC.depID = _department.id;
    }else{
        [remarkVC setDepIDs:_department.id];
    }
    remarkVC.type = 1;
    remarkVC.selectDic = selectDic;
    [self.navigationController pushViewController:remarkVC animated:YES];
}
-(void) popRevise
{
    AddPersonViewController *addVC = [[AddPersonViewController alloc]init];
    addVC.delegate = self;
    addVC.openType = 3;
    addVC.isChild = _isChildren;
    [self.navigationController pushViewController:addVC animated:YES];

}

-(void)orderReviseDelegate:(PatientVO*) vo
{
    if (vo) {
        _patientVO = vo;
        [self updateTableViewWithSection:1 row:0 key:@"value" newValue:vo.name];
        [self updateTableViewWithSection:1 row:1 key:@"value" newValue:vo.mobile];
    }
}
-(void) addComplete:(PatientVO*)vo
{
    if (vo) {
        [patients addObject:vo];
        _patientVO = vo;
        [self updateTableViewWithSection:1 row:0 key:@"value" newValue:_patientVO.name];
        [self updateTableViewWithSection:1 row:1 key:@"value" newValue:_patientVO.mobile];
    }
}


-(void)getInfo:(NSString*)lon lati:(NSString*)lati{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getOrderInfo:lon latitude:lati isChildEmergency:self.rightButton.selected andCallback:^(id data)     {
         [weakSelf.view hideToastActivity];
         if (data!=[NSNull class]&&data!=nil) {
             NSNumber * code = data[@"code"];
             if (code.intValue == 0) {
                 if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                     infoVO = [CreateOrderVO mj_objectWithKeyValues:data[@"object"]];
                     if (!infoVO.enabled) {
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您当前所在城市暂未开放，敬请期待"] preferredStyle:UIAlertControllerStyleAlert];
                         
                         [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                             [weakSelf.navigationController popViewControllerAnimated:YES];
                         }]];
                         
                         [self presentViewController:alertController animated:YES completion:nil];

                     }
                     patients = [NSMutableArray arrayWithArray:infoVO.patients];
                     if(patients.count>0){
                         _patientVO = patients[0];
                         ///更改显示的名字，更改数据源刷新列表
                         [weakSelf updateTableViewWithSection:1 row:0 key:@"value" newValue:_patientVO.name];
                         [weakSelf updateTableViewWithSection:1 row:1 key:@"value" newValue:_patientVO.mobile];
                         if(infoVO.isFirstOrder&&(!_patientVO.idcard||_patientVO.idcard.length==0)){
                         }
                     }
                     if (weakSelf.LeftButton.selected) {///如果选中左边
                         [weakSelf updateTableViewWithSection:3 row:1 key:@"value" newValue:infoVO.defPayType.intValue == 1 ? @"在线支付":@"到院支付" ];
                     }
                     NSString *orderPrice = [NSString stringWithFormat:@"%@ 元",infoVO.normalPrice];
                     [weakSelf updateTableViewWithSection:2 row:0 key:@"value" newValue:orderPrice];
                     [weakSelf updateTableViewWithSection:2 row:1 key:@"value" newValue: [NSString stringWithFormat:@"%@ 元",infoVO.orderPzFee]];
                     [weakSelf updateTableViewWithSection:3 row:0 key:@"value" newValue: [NSString stringWithFormat:@"%@ 元",infoVO.totalFee]];
                    

                     if (!_hospital) {//再次挂号 医院 是传过来的，不需要定位的医院
                         _hospital = infoVO.hospital;
                         if(_hospital){
                             [weakSelf updateTableViewWithSection:0 row:0 key:@"value" newValue:_hospital.name];
                         }
                     }
                 }
             }else{
                 
             }
         }
     }];
}


///刷新列表
-(void)updateTableViewWithSection:(NSInteger)section row:(NSInteger)row key:(NSString *)key newValue:(NSString *)newValue{
    NSMutableArray *source = self.dataSource;
    NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:[source objectAtIndex:section]] ;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[sectionArr objectAtIndex:row]];
    if (newValue) {
        [dic setObject:newValue forKey:key];
        [sectionArr replaceObjectAtIndex:row withObject:dic];
        [source replaceObjectAtIndex:section withObject:sectionArr];
        self.dataSource = source;
        [self.tableView reloadData];
    }
}
///获得某个字段
-(NSString *)getLabelValueWithSection:(NSInteger)section row:(NSInteger)row {
    NSDictionary *dic = [[self.dataSource objectAtIndex:section] objectAtIndex:row];
    NSString *value = [dic objectForKey:@"value"];
    return value;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
