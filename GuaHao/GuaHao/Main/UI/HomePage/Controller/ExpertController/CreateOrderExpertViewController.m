//
//  CreateOrderExpertViewController.m
//  GuaHao
//
//  Created by PJYL on 16/8/31.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "CreateOrderExpertViewController.h"
#import "CreateOrderExpertCell.h"
#import "Utils.h"

#import "SpecialHTMLViewController.h"
#import "PatientVO.h"
#import "DataManager.h"
#import "KTActionSheet.h"
#import "AddPersonViewController.h"
#import "CustomUIActionSheet.h"
#import "OrderVO.h"
#import "ExpInfoVO.h"
#import "ServiceVO.h"
#import "FixPhoneView.h"
#import "PaymentsuccessVC.h"

#import "ExpertAccAddCell.h"
#import "ExpertAccTypeCell.h"
#import "ExpertAccSwitchCell.h"
#import "ExpertAccPriceCell.h"

#import "GHFixPhoneNumberView.h"

@interface CreateOrderExpertViewController ()<UITableViewDelegate,UITableViewDataSource,AddPatientDelegate,FixPhoneDelegate,UIAlertViewDelegate>{
    UIActionSheet          * typeSheet;
    ExpInfoVO              * expInfoVO;
    NSInteger                selectType;
    OrderVO                * orderVO;
    NSMutableArray * patients;
    FixPhoneView           * phoneView;
//    GHFixPhoneNumberView *fixPhoneNumView;
    NSString *_payTypeStr;
    UploadImageViewController *uploadVC;
    NSInteger _price;
//    NSInteger _typeIndex;
//    BOOL _isTake;
    BOOL _isAccompany;
//    NSString *_address;
    NSMutableArray *_imageS;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;

//@property (assign, nonatomic)int accSectionNumber;;

@end

@implementation CreateOrderExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.accSectionNumber = 1;
    _price =self.dayVO.price.integerValue;
    _payTypeStr = @"在线支付";
//    _typeIndex = 1;
    self.title = @"预约详情";
    _imageS = [NSMutableArray array];
//    _address = @"";
    self.sourceArr = [NSMutableArray arrayWithObjects:@{@"type":@"就诊人",@"value":@""},@{@"type":@"身份证号",@"value":@""},@{@"type":@"电话号码",@"value":@""},@{@"type":@"初/复诊",@"value":@""},@{@"type":@"病情备注",@"value":@""}, nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreateOrderExpertCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateOrderExpertCell"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_expertVO.avatar] placeholderImage:[UIImage imageNamed:@"order_expert_desc_icon_bgImage.png"]];
    self.nameLabel.text = _expertVO.name;
    self.positionLabel.text = _expertVO.title;
    self.hospitalLabel.text = _expertVO.hospitalName;
    self.departmentLabel.text = _expertVO.departmentName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",_dayVO.scheduleDate,_dayVO.apm];
    self.orderPriceLabel.text = self.dayVO.price.intValue != 0 ? [NSString stringWithFormat:@"%@ 元",self.dayVO.price] : @"以到院实际费用为准";
    self.typeLabel.text = [NSString stringWithFormat:@"%@门诊",_dayVO.outpatientType.intValue == 1?@"专家":@"特需"];;
    
    ///家庭成员存在就默认第一个人
    if (_patientVO) {
        [self updateOrderListWith:_patientVO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo) name:@"UserInfoUpdate" object:nil];
    [self getInfo];
    // Do any additional setup after loading the view from its nib.
}

///更新订单列表
-(void)updateOrderListWith:(PatientVO *)patientVO{
    [self updateTableViewWithRow:0 newValue:patientVO.name];
    [self updateTableViewWithRow:1 newValue:patientVO.idcard];
    [self updateTableViewWithRow:2 newValue:patientVO.mobile];
    //这个等认证出来 加逻辑
//    [self updateTableViewWithRow:3 newValue:patientVO.firstTimes];
//    [self updateTableViewWithRow:4 newValue:patientVO.patientsInfo];
}

-(void) getInfo
{
    patients = [NSMutableArray new];
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance]getExpNewInfo:_expertVO.id scheduleId:_dayVO.id andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    expInfoVO = [ExpInfoVO mj_objectWithKeyValues:data[@"object"]];
                    if (expInfoVO.needPz) {
                         _price = _price + expInfoVO.pzPrice.intValue;
                    }
                    patients = [NSMutableArray arrayWithArray:expInfoVO.patients];
                    if(!_patientVO || [[self getLabelValueWithRow:0] isEqualToString:@"新增就诊人"]){
                        if(patients.count > 0){
                            _patientVO = patients[0];
                            [self updateOrderListWith:_patientVO];
                        }
                    }
                }
                [self.tableView reloadData];
            }else{
                [self inputToast:msg];
            }
        }
    }];
}





#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section== 0) {
        return 5;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && indexPath.row == 0) {
        return 56;
    }
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.sourceArr objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        CreateOrderExpertCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderExpertCell"];
        [CreateOrderExpertCell renderCell:cell typeStr:[dic objectForKey:@"type"] valueStr:[dic objectForKey:@"value"] indexPath:indexPath];
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            ExpertAccSwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ExpertAccSwitchCell"];
            [cell layoutSubviewsWithTitle:[NSString stringWithFormat:@"%@元",expInfoVO.pzPrice]];
            if (expInfoVO.needPz) {
                cell.switchButton.on = YES;_isAccompany = YES;
                cell.switchButton.userInteractionEnabled = NO;
                cell.switchButton.hidden = YES;
            }else{
                cell.switchButton.hidden = NO;
                cell.switchButton.userInteractionEnabled = YES;
            }
            __weak typeof(self) weakSelf = self;
            [cell pzAction:^(BOOL select) {
                SpecialHTMLViewController * view = [[SpecialHTMLViewController alloc] init];
                
                view._title = @"陪诊";
                view._url = expInfoVO.pzUrl;
                view.content = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",expInfoVO.pzPrice]];;
                [self.navigationController pushViewController:view animated:YES];
            }];
            [cell switchAction:^(BOOL select) {
                if (select) {
                    
                    _price = _price + expInfoVO.pzPrice.intValue;
                    _isAccompany = YES;
                    
                }else{
                    _price = self.dayVO.price.integerValue;
                    _isAccompany = NO;
                   
                }
                [weakSelf.tableView reloadData];
                
            }];
            return cell;
        }
//        else if (indexPath.row == 1) {
//            CreateOrderExpertCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CreateOrderExpertCell"];
//            [CreateOrderExpertCell renderCell:cell typeStr:@"支付方式" valueStr:_payTypeStr indexPath:indexPath];
//            return cell;
//        }
        else{
            ExpertAccPriceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ExpertAccPriceCell"];
            NSString *str = @"";
            if (self.dayVO.price.integerValue == 0) {
                str = @"以到院实际费用为准";
            }else{
                str = [NSString stringWithFormat:@"%ld元",(long)_price];
            }
            cell.priceLabel.text = str;
            return cell;
        }
        
        
    }
    
}

-(void)reloadTableView{
    self.tableViewHeight.constant = 230 + 10 + 3 * 46;
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSArray *arr = [NSMutableArray arrayWithObjects:@"selectPerson",@"changeIDCard",@"changePhoneNumber",@"selectIsFirst",@"patientInfo", nil];
        [self performSelectorOnMainThread:NSSelectorFromString([arr objectAtIndex:indexPath.row]) withObject:nil waitUntilDone:NO];
    }
}

///选择就诊人
-(void)selectPerson{
    NSLog(@"%s",__func__);
    if (patients.count == 0) {
        [self addPatient];
        return;
    }
    NSMutableArray * bankNames1 = [NSMutableArray array];
    for (int i=0; i<patients.count; i++) {
        PatientVO * vo = patients[i];
        [bankNames1 addObject:vo.name];
    }
    if (bankNames1.count<5) {
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
                [weakSelf inputToast:@"您的家庭成员数量到达上限!"];
                return ;
            }
            [weakSelf addPatient];
            return ;
        }
        _patientVO = patients[index];
        [weakSelf updateOrderListWith:_patientVO];
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
        [patients addObject:vo];
        _patientVO = vo;
        [self updateOrderListWith:vo];
    }

}
///填写身份证号
-(void)changeIDCard{
     NSLog(@"%s",__func__);
}

///修改手机号码
-(void)changePhoneNumber{
     NSLog(@"%s",__func__);
    if(_patientVO==nil){
        [self inputToast:@"请填写或选择挂号人！"];
        return;
    }
    CGRect frame = self.view.frame;
    GHFixPhoneNumberView*  fixPhoneNumView = [[GHFixPhoneNumberView alloc]initWithFrame:frame];
    fixPhoneNumView.patientID = [NSString stringWithFormat:@"%@",_patientVO.id];
    NSLog(@"fixPhoneNumView.patientID--%@",fixPhoneNumView.patientID);
    fixPhoneNumView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    fixPhoneNumView.frame = [UIScreen mainScreen].bounds;

        [fixPhoneNumView fixPhoneNumber:^(NSString *phoneNumber) {
            [self updateTableViewWithRow:2 newValue:[NSString stringWithFormat:@"%@",phoneNumber]];
            if (fixPhoneNumView) {
                [fixPhoneNumView removeFromSuperview];
            }
        }];
    
 fixPhoneNumView.patientID = [NSString stringWithFormat:@"%@",_patientVO.id];
    [self.view addSubview:fixPhoneNumView];
    
//    if(!phoneView){
//        phoneView = [[FixPhoneView alloc] initWithFrame:frame];
//        phoneView.delegate = self;
//    }
//    [phoneView setPhone:@""];
//    phoneView.patientID = _patientVO.id;
//    [self.view addSubview:phoneView];

}
-(void)fixPhoneDelegate:(BOOL) isSure phone:(NSString*) phone
{
    [self updateTableViewWithRow:2 newValue:phone];
    [phoneView removeFromSuperview];
}
///是否为初次就诊
-(void)selectIsFirst{
     NSLog(@"%s",__func__);
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择就诊状态" delegate:self cancelButtonTitle:@"初诊" otherButtonTitles:@"复诊", nil];
    [alter show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *value = @"";
    if (buttonIndex == 0) {
        value = @"初诊";
    }else{
        value = @"复诊";
    }
    [self updateTableViewWithRow:3 newValue:value];
}

///病情备注
-(void)patientInfo{
     NSLog(@"%s",__func__);
    if(uploadVC==nil){
        uploadVC = [GHViewControllerLoader UploadImageViewController];
        __weak typeof(self) weakSelf = self;
        [uploadVC returnDataBlock:^(NSArray *images, NSString *remark) {
            [weakSelf updateTableViewWithRow:4 newValue:remark];
            _imageS = [NSMutableArray arrayWithArray:images];
        }];
    }
    [self.navigationController pushViewController:uploadVC animated:YES];
}
-(void) delegateExpertRemarks:(NSString*) value
{
    [self updateTableViewWithRow:4 newValue:value];
}



///提交订单
- (IBAction)commitAction:(UIButton *)sender {
     [self.view endEditing:YES];
    for (int i = 0; i <= 3; i++) {
        if ([self getLabelValueWithRow:i].length == 0) {
            if (i == 0) {
                [self inputToast:@"请填写或选择挂号人！"];
                return;
            }else if (i == 1){
                [self inputToast:@"请填写身份证号！"];
                 return;
            }else if (i == 2){
                [self inputToast:@"请填写手机号码！"];
                 return;
            }
        }
    }
    
//    if (_isTake&&(_address==nil || _address.length==0)){
//        [self inputToast:@"请填写接送详细地址！"];
//        return;
//    }
    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (_isAccompany) [dic setObject:@"1" forKey:@"serviceType"];
//    [dic setValue:_isAccompany? [NSString stringWithFormat:@"%ld",(long)_typeIndex]:@"0" forKey:@"serviceType"];
//    [dic setValue:_isTake?@"1":@"0" forKey:@"isNeedTransfer"];
//    [dic setValue:_address forKey:@"transferAddr"];
//    [dic setValue:[NSString stringWithFormat:@"%@",_isAccompany ? @"0" :@"1" ]forKey:@"serviceType"];
    dic[@"patientId"] = _patientVO.id;
    dic[@"hospitalId"] = _expertVO.hospitalId;
    dic[@"departmentId"] = _expertVO.departmentId;
    dic[@"mobile"] = [self getLabelValueWithRow:2];
    if ([self getLabelValueWithRow:4].length > 0) {
        dic[@"patientComments"] = [self getLabelValueWithRow:4];
    }
    dic[@"doctorId"] = _expertVO.id;
    dic[@"scheduleId"] = _dayVO.id;
    
    [[ServerManger getInstance] createExpertNewOrder:dic  imgs:_imageS andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                [MobClick event:@"click16"];
                orderVO = [OrderVO mj_objectWithKeyValues:data[@"object"]];
                PaymentsuccessVC * view = [[PaymentsuccessVC alloc] init];
                view.serialNo = orderVO.serialNo;
                view.isExpert = YES;
                [self.navigationController pushViewController:view animated:YES];
            }else{
                [self inputToast:msg];
            }
        }
    }];
    
}










///刷新列表
-(void)updateTableViewWithRow:(NSInteger)row newValue:(NSString *)newValue{
    NSMutableArray *source = self.sourceArr;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[source objectAtIndex:row]];
    if (newValue) {
        [dic setObject:newValue forKey:@"value"];
        [source replaceObjectAtIndex:row withObject:dic];
        self.sourceArr = source;
        [self.tableView reloadData];
    }
}
///获得某个字段
-(NSString *)getLabelValueWithRow:(NSInteger)row {
    NSDictionary *dic = [self.sourceArr objectAtIndex:row];
    NSString *value = [dic objectForKey:@"value"];
    return value;
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
