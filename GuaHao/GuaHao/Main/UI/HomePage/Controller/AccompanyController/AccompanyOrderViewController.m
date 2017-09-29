//
//  AccompanyOrderViewController.m
//  GuaHao
//
//  Created by PJYL on 16/10/10.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AccompanyOrderViewController.h"
#import "CreateOrderExpertCell.h"
#import "AccompanyCell.h"
#import "AccompanyServiceCell.h"
#import "AddPersonInputCell.h"
#import "HtmlAllViewController.h"
#import "UUDatePicker.h"
#import "AccompanyOrderVO.h"
#import "PatientCertificationVC.h"
#import "AddPersonViewController.h"
#import "ChooseHospitalVC.h"
#import "KTActionSheet.h"
#import "PayViewController.h"
#import "CreateOrderNormalCell.h"
#import "AccompanySuccessViewController.h"
@interface AccompanyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,CertificationDelegate,AddPatientDelegate>{
    NSMutableArray *_sourceArr;
    ChooseHospitalVC *    hospitalVC;
    UUDatePicker *datePicker2;
    CustomUIActionSheet * sheet;
    NSMutableArray * patients;///家庭成员
    AccompanyOrderVO *_vo;
    NSString *_takeType;
    BOOL _isInsured;
    int _totalPrice;
    
    NSString *order_id;
    NSString *order_serialNo;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccompanyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全程陪诊";
    _takeType = @"1";
    _sourceArr = [NSMutableArray arrayWithObjects:
  @[@{@"type":@"请选择就诊医院",@"value":@"请选择就诊医院",@"image":@"order_hospital.png"},@{@"type":@"请选择时间",@"value":@"请选择时间",@"image":@"order_date.png"},@{@"type":@"选择患者",@"value":@"请选择就诊人",@"image":@"order_person.png"}],
  @[@{@"type":@"保险费用",@"value":@"免费送您一份价值150000平安意外险",@"select":@"0"},@{@"type":@"接送服务",@"value":@"护士上门接送，服务费用不包括就诊人往返医院的交通费用",@"select":@"1"},@{@"type":@"专车接送全程无忧",@"value":@"专员上门，专车接送",@"select":@"0"}],
  @[@{@"type":@"接送地址",@"value":@""}],
  @[@{@"type":@"支付方式",@"value":@"在线支付"},@{@"type":@"总    计",@"value":@""}], nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderNormalCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderNormalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderExpertCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderExpertCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccompanyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AccompanyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddPersonInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddPersonInputCell"];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getAccompanyOrderVCData:0  andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data != [NSNull class] && data != nil) {
            NSNumber *code = data[@"code"];
            NSString *message = data[@"msg"];
            if (code.intValue == 0) {
                NSDictionary *dic = data[@"object"];
                _vo = [AccompanyOrderVO mj_objectWithKeyValues:dic];
                patients = [NSMutableArray arrayWithArray: _vo.patients];
                _totalPrice = _vo.pzFee.intValue +_vo.normalTransferFee.intValue;
                [weakSelf updateTableViewWithSection:3 row:0 key:@"value" newValue:_vo.defPayType.intValue == 1 ? @"在线支付":@"到院支付"];
                NSLog(@"vvvvvvvvv-------%d",_vo.normalTransferFee.intValue);
                [weakSelf updateTableViewWithSection:3 row:1 key:@"value" newValue:[NSString stringWithFormat:@"%d元",_totalPrice]];
                [weakSelf.tableView reloadData];
            }
        }

    }];

}




#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 0;
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 52;
    }
    
    if (indexPath.section == 1 ) {
        return 60;
    }else{
        return 44;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [_sourceArr objectAtIndex:section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [_sourceArr objectAtIndex:indexPath.section];
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];;
    if (indexPath.section == 0) {
        CreateOrderNormalCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderNormalCell"];
        [CreateOrderNormalCell renderCell:cell typeStr:[dic objectForKey:@"image"] valueStr:[dic objectForKey:@"value"]];
        

        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        BOOL hidden = YES;
        NSNumber *price = 0;
        if (_vo) {
            if(indexPath.row == 0)price = _vo.insuranceFee;
            if(indexPath.row == 1)price = _vo.normalTransferFee;
            if(indexPath.row == 2)price = _vo.specialTransferFee;
        }
        if (indexPath.row == 0)hidden = NO;
        AccompanyServiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccompanyServiceCell"];
        [cell layoutSubviewsWithPriceStr:[dic objectForKey:@"type"] price:price description:[dic objectForKey:@"value"] hiddenButton:hidden];
        [cell explainAction:^(BOOL select) {
            HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
            view.mTitle = @"赠送意外险";
            view.mUrl   = _vo.insuranceDocUrl;
            view.isPresent = YES;
            [self.navigationController pushViewController:view animated:YES];
        }];

        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.selectButton.selected = [[dic objectForKey:@"select"]boolValue];
        __weak typeof(self) weakSelf = self;
        [cell clickButtonReturn:^(BOOL select) {
            [weakSelf serviceSelect:indexPath select:select];
        }];
        return cell;
    }else if (indexPath.section == 2){
        AddPersonInputCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPersonInputCell"];
        [AddPersonInputCell renderCell:cell  typeStr:[dic objectForKey:@"type"] valueStr:[dic objectForKey:@"value"] indexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [cell returnValue:^(NSString *value, NSIndexPath *indexPath) {
            [weakSelf updateTableViewWithSection:indexPath.section row:indexPath.row key:@"value" newValue:value];
            [weakSelf.tableView reloadData];
        }];
        cell.mustImage.hidden = YES;
        cell.speatView.hidden = YES;
        cell.nameLable.textColor = [UIColor blackColor];
        cell.nameLable.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            CreateOrderExpertCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderExpertCell"];
            cell.typeLabelLeftSpeace.constant = 20;
            cell.typeLabel.textColor = [UIColor blackColor];
            [CreateOrderExpertCell renderCell:cell typeStr:[dic objectForKey:@"type"] valueStr:[dic objectForKey:@"value"] indexPath:indexPath];
            return cell;
        }
        AccompanyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccompanyCell"];
        [cell layoutSubviews:[dic objectForKey:@"type"] value:[dic objectForKey:@"value"] discounPrice:_vo.firstOrderPrice.intValue isFirst:_vo.firstOrder indexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0)[self chooseHospital];
        if(indexPath.row == 1)[self choseDate];
        if(indexPath.row == 2)[self chosePerson];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self choosePayType];
        }
    }
}
-(void)choosePayType{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        [alertController addAction:[UIAlertAction actionWithTitle:@"在线支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"在线支付");
            [weakSelf updateTableViewWithSection:3 row:0 key:@"value" newValue:@"在线支付"];
            [weakSelf.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"到院支付" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"到院支付");
            [weakSelf updateTableViewWithSection:3 row:0 key:@"value" newValue:@"到院支付"];
            [weakSelf.tableView reloadData];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)serviceSelect:(NSIndexPath *)indexPath select:(BOOL)select{
    if (indexPath.row == 0) {
        if (!select) {
            _isInsured = YES;
            [self updateTableViewWithSection:1 row:0 key:@"select" newValue:@"1"];
        }else{
            _isInsured = NO;
            [self updateTableViewWithSection:1 row:0 key:@"select" newValue:@"0"];
        }
    }
    
    if (indexPath.row == 1) {
        if (!select) {
            _takeType = @"1";
             [self updateTableViewWithSection:1 row:1 key:@"select" newValue:@"1"];
             [self updateTableViewWithSection:1 row:2 key:@"select" newValue:@"0"];
        }else{
            _takeType = @"";
            [self updateTableViewWithSection:1 row:1 key:@"select" newValue:@"0"];
            [self updateTableViewWithSection:1 row:2 key:@"select" newValue:@"0"];
        }
    }
    if (indexPath.row == 2) {
        if (!select) {
            _takeType = @"2";
            [self updateTableViewWithSection:1 row:1 key:@"select" newValue:@"0"];
            [self updateTableViewWithSection:1 row:2 key:@"select" newValue:@"1"];
        }else{
            _takeType = @"";
            [self updateTableViewWithSection:1 row:1 key:@"select" newValue:@"0"];
            [self updateTableViewWithSection:1 row:2 key:@"select" newValue:@"0"];
        }
    }
    
    int takePrice = 0;
    if (_takeType.length > 0) {
        if ([_takeType isEqualToString:@"1"]) {
            takePrice = _vo.normalTransferFee.intValue;
        }else{
            takePrice = _vo.specialTransferFee.intValue;
        }
    }
    _totalPrice = _vo.pzFee.intValue + takePrice + (_isInsured ? _vo.insuranceFee.intValue : 0);
    [self updateTableViewWithSection:3 row:1 key:@"value" newValue:[NSString stringWithFormat:@"%d元",_totalPrice]];
    [self.tableView reloadData];
    NSLog(@"_takeType-----%@------%@",_isInsured ? @"要保险":@"不要",_takeType);
    
}
//接送规则
- (IBAction)takeRuleAction:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"接送服务规则";
    view.mUrl   = _vo.transferDocUrl;
    [self.navigationController pushViewController:view animated:YES];
}
///提交订单
- (IBAction)commitOrder:(id)sender {
    [self.view endEditing:YES];
    if (!_hospital.id) {
        [self inputToast:@"请选择医院"];
        return;
    }
    if ([[self getLabelValueWithSection:0 row:1]isEqualToString:@"请选择时间"]) {
        [self inputToast:@"请选择陪诊时间"];
        return;
    }
    if (!_patientVO) {
        [self inputToast:@"请选择就诊人员"];
        return;
    }

    BOOL take = NO;
    if ([[[[_sourceArr objectAtIndex:1]objectAtIndex:1]objectForKey:@"select"] isEqualToString:@"1" ]) {
        take = YES;
    }
    if ([[[[_sourceArr objectAtIndex:1]objectAtIndex:2]objectForKey:@"select"] isEqualToString:@"1" ]) {
        take = YES;
    }
    if ([self getLabelValueWithSection:2 row:0].length == 0 && take) {
        [self inputToast:@"请输入接送地址"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%d",0] forKey:@"serviceType"];
    [dic setValue:_hospital.id forKey:@"hospitalId"];
    [dic setValue:_patientVO.id forKey:@"patientId"];
    [dic setValue:[self getLabelValueWithSection:0 row:1] forKey:@"serviceDate"];
    if ([[self getLabelValueWithSection:3 row:0]isEqualToString:@"到院支付"]) {
        [dic setValue:@"2" forKey:@"payType"];
    }else{
        [dic setValue:@"1" forKey:@"payType"];
    }
    [dic setValue:@"0" forKey:@"drugFee"];
    [dic setValue:_isInsured ? @"1": @"0" forKey:@"isInsured"];
    [dic setValue:_takeType forKey:@"transferType"];
    [dic setValue:_patientVO.name forKey:@"name"];
    [dic setValue:_patientVO.idcard forKey:@"idcard"];
    [dic setValue:[self getLabelValueWithSection:2 row:0] forKey:@"transferAddr"];
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]createMedicineOrReportOrder:dic imgs:nil andCallback:^(id data){
//    [[ServerManger getInstance] createAccompanyOrder:dic andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            [self inputToast:msg];
            if (code.intValue == 0) {
                order_id = data[@"object"][@"id"];
                order_serialNo = data[@"object"][@"serialNo"];
                [self toPay];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewCellUpdate" object:nil];
//                [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
            }else{
                
            }
        }
    }];
}

-(void)toPay{
    if ([[self getLabelValueWithSection:3 row:0]isEqualToString:@"到院支付"]) {
        AccompanySuccessViewController *view = [[AccompanySuccessViewController alloc]init];;
        view.orderNo = order_serialNo;;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        PayViewController * view = [GHViewControllerLoader PayViewController];
        view.orderID = [NSNumber numberWithDouble:order_id.doubleValue] ;
        view.isAccompany = YES;
        [self.navigationController pushViewController:view animated:YES];

    }

}

///选择医院
-(void)chooseHospital{
    [MobClick event:@"click9"];
    if (!hospitalVC) {
        hospitalVC = [GHViewControllerLoader ChooseHospitalVC];
        hospitalVC.isAccompany = YES;
        __weak typeof(self) weakSelf = self;
        hospitalVC.onBlockHospital = ^(HospitalVO * vo,DepartmentVO * dvo){
            [weakSelf onBlockHospital:vo department:dvo];
        };
    }
    [self.navigationController pushViewController:hospitalVC animated:YES];
}
///选择医院回调
-(void)onBlockHospital:(HospitalVO *)vo department:(DepartmentVO*) dvo{
    _hospital = vo;
    
    [self updateTableViewWithSection:0 row:0 key:@"value" newValue:_hospital.name];
    [self.tableView reloadData];
//    [self updateTableViewWithSection:0 row:1 key:@"value" newValue:@"请选择就诊时间"];
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
                                 [self updateTableViewWithSection:0 row:1 key:@"value" newValue:text];
                                 [self.tableView reloadData];
                                 
                             }];
    datePicker2.minLimitDate = [[NSDate date]dateByAddingTimeInterval:0];
    datePicker2.isAdult = (_hospital.type.intValue==0);
    datePicker2.openDays = @"1111111";
    datePicker2.isAccompany = YES;
    sheet = [[CustomUIActionSheet alloc] init];
    datePicker2.sheet = sheet;
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
        if (_patientVO.status) {
            if (_patientVO.status.intValue == 2) {
                alreadycertificate = YES;
            }
        }
        if (_hospital.isNeedRealnameAuth && !alreadycertificate) {
            ///去认证
            PatientCertificationVC * view = [[PatientCertificationVC alloc]init];
            view.delegate = self;
            view.patientVO = _patientVO;
            [self.navigationController pushViewController:view animated:YES];
        }
        
        [weakSelf updateTableViewWithSection:0 row:2 key:@"value" newValue:text];
        [self.tableView reloadData];
    }];
}
-(void) addComplete:(PatientVO*)vo
{
    if (vo) {
        [patients addObject:vo];
        _patientVO = vo;
//        [self updateTableViewWithSection:1 row:0 key:@"value" newValue:_patientVO.name];
//        [self updateTableViewWithSection:1 row:1 key:@"value" newValue:_patientVO.mobile];
    }
}
-(void) popRevise
{
    AddPersonViewController *addVC = [[AddPersonViewController alloc]init];
    addVC.delegate = self;
    addVC.openType = 3;
    [self.navigationController pushViewController:addVC animated:YES];
    
}
///刷新列表
-(void)updateTableViewWithSection:(NSInteger)section row:(NSInteger)row key:(NSString *)key newValue:(NSString *)newValue {
    NSMutableArray *source = _sourceArr;
    NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:[source objectAtIndex:section]] ;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[sectionArr objectAtIndex:row]];
    if (newValue) {
        [dic setObject:newValue forKey:key];
        [sectionArr replaceObjectAtIndex:row withObject:dic];
        [source replaceObjectAtIndex:section withObject:sectionArr];
        _sourceArr = source;

    }
}

///获得某个字段
-(NSString *)getLabelValueWithSection:(NSInteger)section row:(NSInteger)row {
    NSDictionary *dic = [[_sourceArr objectAtIndex:section] objectAtIndex:row];
    NSString *value = [dic objectForKey:@"value"];
    return value;
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
