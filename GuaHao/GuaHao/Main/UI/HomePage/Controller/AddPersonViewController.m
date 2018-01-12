//
//  AddPersonViewController.m
//  GuaHao
//
//  Created by 123456 on 16/8/1.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "AddPersonViewController.h"
#import "AddPersonSelectCell.h"
#import "Utils.h"
#import "AddPersonInputCell.h"
#import "AddPersonFootCell.h"
#import "UUDatePicker.h"
#import "DataManager.h"
#import "UIViewController+Toast.h"
#import "Validator.h"
#import "SetRealNameView.h"
#import "PatientCertificationVC.h"
#import "Validator.h"
@interface AddPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,SetRealNameViewDelegate,CertificationDelegate>{
    NSMutableArray * patients;
    PatientVO * vv ;
    SetRealNameView * setRealNameView;
}

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isChildren;

@property (weak, nonatomic) IBOutlet UIButton *adultBtn;
@property (weak, nonatomic) IBOutlet UIButton *childrenBtn;
@property (strong, nonatomic) NSArray *souceChildArr;
@property (strong, nonatomic) NSArray *souceAdultArr;

@property (strong, nonatomic) NSMutableArray *souceArr;

@end

@implementation AddPersonViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}
-(void)getPatients
{
//    [DataManager getInstance].patients = [NSMutableArray new];
//    [self.view makeToastActivity:CSToastPositionCenter];
//    [[ServerManger getInstance] getPatients:10 page:0 andCallback:^(id data) {
//        [self.view hideToastActivity];
//        if (data!=[NSNull class]&&data!=nil) {
//            NSNumber * code = data[@"code"];
//            NSString * msg = data[@"msg"];
//            if (code.intValue == 0) {
//                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
//                    NSArray * arr = data[@"object"];
//                    for (int i = 0; i<arr.count; i++) {
//                        PatientVO *patient = [PatientVO mj_objectWithKeyValues:arr[i]];
//                        [[DataManager getInstance].patients addObject:patient];
//                    }
//                    patients = [DataManager getInstance].patients;
//                }
//            }else{
//                [self inputToast:msg];
//            }
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBarTintColor:GHDefaultColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    self.title = @"新增就诊人员";
    self.adultBtn.selected = YES;

    [self registerTableView];
//    [self getPatients];

    
    // Do any additional setup after loading the view from its nib.
}
///设置信息注册cell
-(void)registerTableView{
    self.souceArr = [NSMutableArray array];
    self.souceAdultArr = @[@{@"type":@"真实姓名",@"value":@""},@{@"type":@"证件类型",@"value":@"身份证"},@{@"type":@"证件编号",@"value":@""},@{@"type":@"性别",@"value":@""},@{@"type":@"出生年月",@"value":@""},@{@"type":@"电话号码",@"value":@""},@{@"type":@"社保卡号",@"value":@""},@{@"type":@"就诊卡号",@"value":@""},@{@"type":@"就诊人证件号提交后将无法修改，请核实后提交",@"value":@""}];
    self.souceChildArr = @[@{@"type":@"真实姓名",@"value":@""},@{@"type":@"证件类型",@"value":@""},@{@"type":@"证件编号",@"value":@""},@{@"type":@"性别",@"value":@""},@{@"type":@"出生年月",@"value":@""},@{@"type":@"电话号码",@"value":@""},@{@"type":@"就诊卡号",@"value":@""},@{@"type":@"就诊人证件号提交后将无法修改，请核实后提交",@"value":@""}];
//    self.souceAdultArr = @[@"真实姓名",@"证件类型",@"证件编号",@"性别",@"出生年月",@"电话号码",@"社保卡号",@"就诊卡号",@"就诊人信息提交后将无法修改，请核实后提交",@"提交"];
//    self.souceChildArr = @[@"真实姓名",@"监护人证件类型",@"证件编号",@"性别",@"出生年月",@"电话号码",@"就诊卡号",@"就诊人信息提交后将无法修改，请核实后提交",@"提交"];
    
    self.souceArr = [NSMutableArray arrayWithArray: self.souceAdultArr];
    
    self.tableView.backgroundColor = RGB(244, 244, 244);
    [self.tableView registerNib:[UINib nibWithNibName:@"AddPersonSelectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddPersonSelectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddPersonFootCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddPersonFootCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddPersonInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddPersonInputCell"];
}


//返回
- (IBAction)backAction:(UIButton *)sender {
    if (_delegate&&_openType==4) {
        [_delegate addComplete:nil];
    }
    [self.view endEditing:YES];
    NSArray *viewControllers = self.navigationController.viewControllers;
//    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:YES];

//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消添加就诊人员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
//    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:YES];
    }
}
- (IBAction)adultAction:(UIButton *)sender {
    self.isChildren = NO;
    self.childrenBtn.selected = NO;
    self.adultBtn.selected = YES;
    self.souceArr = [NSMutableArray arrayWithArray: self.souceAdultArr];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.lineView.frame;
        frame.origin.x = 0;
        self.lineView.frame = frame;
    }];
}
- (IBAction)childrenAction:(UIButton *)sender {
    self.isChildren = YES;
    self.childrenBtn.selected = YES;
    self.adultBtn.selected = NO;
    self.souceArr = [NSMutableArray arrayWithArray: self.souceChildArr];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.lineView.frame;
        frame.origin.x = SCREEN_WIDTH/2.0;
        self.lineView.frame = frame;
    }];
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.souceArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == self.souceArr.count - 1 ? 200 : 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger cellType = 0;
    switch (indexPath.row) {
        case 0:
        {
            cellType = 1;
        }
            break;
        case 1:
        {
            cellType = 2;
        }
            break;
        case 2:
        {
            cellType = 1;
        }
            break;
        case 3:
        {
            cellType = 2;
        }
            break;
        case 4:
        {
            cellType = 2;
        }
            break;
        case 5:
        {
            cellType = 1;//电话号码
        }
            break;
        case 6:
        {
            cellType = 1;
        }
            break;
        case 7:
        {
            cellType = self.isChildren ? 3:  1;
        }
            break;
        case 8:
        {
            cellType = self.isChildren ? 0:  3;
        }
            break;
        case 9:
        {
            cellType = 0;
        }
            break;

        default:
            break;
    }
    return [self returnCellType:cellType andIndexPath:indexPath];
}

-(UITableViewCell *)returnCellType:(NSInteger)cellType andIndexPath:(NSIndexPath *)indexPath{
    NSString *typeName = [[self.souceArr objectAtIndex:indexPath.row]objectForKey:@"type"] ;
    NSString *valueName =[[self.souceArr objectAtIndex:indexPath.row]objectForKey:@"value"] ;

    if (cellType == 1) {
        AddPersonInputCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPersonInputCell"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        UIKeyboardType keyBoardType;
        if (indexPath.row == 0) {
            keyBoardType = UIKeyboardTypeDefault;
        }else{
            keyBoardType = UIKeyboardTypeNamePhonePad;
        }
        cell.textField.keyboardType = keyBoardType;
        [AddPersonInputCell renderCell:cell typeStr:typeName valueStr:valueName indexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        if (indexPath.row == 2) {
            if ([weakSelf getLabelValueWithRow:1].length < 1) {
                cell.textField.userInteractionEnabled = NO;
            }else{
                cell.textField.userInteractionEnabled = YES;
            }
            
        }
        
        
        [cell returnValue:^(NSString *value, NSIndexPath *indexPath) {
            [weakSelf.view endEditing:YES];
            [weakSelf returnInputResult:value indexPath:indexPath];
        }];
        return cell;
        
    }else if (cellType == 2) {
        AddPersonSelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPersonSelectCell"];
        [AddPersonSelectCell renderCell:cell typeStr:typeName valueStr:valueName indexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (cellType == 3){
        AddPersonFootCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPersonFootCell"];
        [cell buttonSelectAction:^(BOOL result) {
            [self submitOrder];
        }];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
            
    }
    else{
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        UIButton *warningBtn;
//        if ([cell.contentView viewWithTag:1001]) {
//            warningBtn = [cell.contentView viewWithTag:1001];
//        }else{
//            warningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            warningBtn.tag = 1001;
//            [warningBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//            [warningBtn setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
//            warningBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 10, 90, 21);
//            warningBtn.imageEdgeInsets = UIEdgeInsetsMake(5,-5,5,warningBtn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//            [warningBtn setTitle:@"号为必填" forState:UIControlStateNormal];
//        }
//        [cell.contentView addSubview:warningBtn];
//        UIButton *button;
//        if ([cell.contentView viewWithTag:1002]) {
//            button = [cell.contentView viewWithTag:1002];
//        }else{
//            button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.tag = 1002;
//            button.frame = CGRectMake(10, 40, SCREEN_WIDTH - 20, 44);
//            [button setTitle:@"提交" forState:UIControlStateNormal];
//            button.backgroundColor = GHDefaultColor;
//            button.layer.cornerRadius = 5;
//            button.layer.masksToBounds = YES;
//            [button addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
//            cell.contentView.backgroundColor = RGB(244, 244, 422);
//        }
//
//        [cell.contentView addSubview:button];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        [self certificateSelect];
    }else if (indexPath.row == 3){
        [self sexSelect];
    }else if (indexPath.row == 4){
        [self dateSelect];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
 //提交
-(void)submitOrder{
    [self.tableView endEditing:YES];
    [self.view endEditing:YES];

    if ([self getLabelValueWithRow:0].length == 0) {
//        [_nameTexF becomeFirstResponder];
        [self inputToast:@"请填写姓名！"];
        return;
    }

    if([self getLabelValueWithRow:5].length != 11){
        //            [_identityCardTexF becomeFirstResponder];
        [self inputToast:@"请填写手机号码"];
        return;
    }
    if([self getLabelValueWithRow:2].length==0){
//            [_identityCardTexF becomeFirstResponder];
        [self inputToast:@"请填写身份证号"];
        return;
    }
    if([[self getLabelValueWithRow:1] isEqualToString:@"身份证"]&&![Validator isValidIdentityCard:[self getLabelValueWithRow:2]]) {
//            [_identityCardTexF becomeFirstResponder];
        [self inputToast:@"请填写正确的身份证号"];
        return;
    }
    if(![[self getLabelValueWithRow:1] isEqualToString:@"护照"]&&!([self getLabelValueWithRow:2].length >4)) {
        //            [_identityCardTexF becomeFirstResponder];
        [self inputToast:@"请填写正确的护照号码"];
        return;
    }
    
    if ([self getLabelValueWithRow:3].length == 0) {
        [self inputToast:@"请选择性别！"];
        return;
    }
    if ([self getLabelValueWithRow:4] == 0) {
        [self inputToast:@"请填写出生日期！"];
        return;
    }
//    if ([self getLabelValueWithRow:self.souceArr.count - 3].length>0) {
//        if ([self getLabelValueWithRow:self.souceArr.count - 3].length==15) {
//
//        }else{
////            [_MedicalCardNumberTF becomeFirstResponder];
//            [self inputToast:@"请填写正确的就诊卡号"];
//            return;
//        }
//    }

    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([[self getLabelValueWithRow:1] isEqualToString:@"身份证"]) {
//        dic[@"cardType"] = [NSString stringWithFormat:@"%d",self.isChildren ? 3: 1];
        [dic setObject: [NSString stringWithFormat:@"%@",self.isChildren ? @"3": @"1"] forKey:@"cardType"];

    }else{
//        dic[@"cardType"] = [NSString stringWithFormat:@"%d",2];
        [dic setObject:[NSString stringWithFormat:@"%@",@"2"] forKey:@"cardType"];
    }
    [dic setObject:self.isChildren?@"2":@"1" forKey:@"type"];
//    dic[@"type"] = self.isChildren?@"2":@"1";
    [dic setObject:[self getLabelValueWithRow:0] forKey:@"name"];
    [dic setObject:[[self getLabelValueWithRow:3] isEqualToString:@"男"]?@"0":@"1" forKey:@"sex"];
//    dic[@"mobile"] = [self getLabelValueWithRow:5];
    [dic setObject:[self getLabelValueWithRow:5] forKey:@"mobile"];

//    dic[@"idcard"]   = [self getLabelValueWithRow:2];
    [dic setObject:[self getLabelValueWithRow:2] forKey:@"idcard"];

    NSString * medicalCard =[self getLabelValueWithRow:7];
    if(medicalCard&&medicalCard.length>0){
//        dic[@"medicalCard"] = medicalCard;
        [dic setObject:medicalCard forKey:@"medicalCard"];

    }
    NSString * socialSecurityCard =[self getLabelValueWithRow:6];
    if(socialSecurityCard&&socialSecurityCard.length>0){
//        dic[@"socialSecurityCard"] = socialSecurityCard;
        [dic setObject:socialSecurityCard forKey:@"socialSecurityCard"];

    }
    if ([self getLabelValueWithRow:4].length!=0) {
//        dic[@"birthday"] = [NSString stringWithFormat:@"%@ 00:00:00",[self getLabelValueWithRow:4]];
        [dic setObject:[NSString stringWithFormat:@"%@ 00:00:00",[self getLabelValueWithRow:4]] forKey:@"birthday"];

    }
    [self.view makeToastActivity:CSToastPositionCenter];
    [[ServerManger getInstance] createPatient:dic andCallback:^(id data) {
        
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = [data objectForKey:@"code"];
            NSString * msg = [data objectForKey:@"msg"];
            [self inputToast:msg];
            PatientVO * vo = [PatientVO mj_objectWithKeyValues:[data objectForKey:@"object"]];
            vv  = [PatientVO mj_objectWithKeyValues:data[@"object"]];
            if ([code.stringValue isEqualToString:@"0"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePatientInfo" object:nil];
                if (self.delegate) {
                    [self.delegate addComplete:vo];
                }
                [self popRevise];
            }else{
                
            }
        }
    }];

}
-(void) popRevise
{
    [self.view endEditing:YES];
    if (!setRealNameView) {
        CGRect frame = self.view.frame;
        setRealNameView = [[SetRealNameView alloc] initWithFrame:frame];
        setRealNameView.titleLab.text = @"是否去身份认证？";
        setRealNameView.delegate = self;
    }
    [self.view addSubview:setRealNameView];
}
-(void)setRealNameViewDelegate:(int) type{
    if (type == 0) {
        PatientCertificationVC * view = [[PatientCertificationVC alloc]init];
        view.delegate = self;
        view.patientVO = vv;
        view.openType = _openType;
        [setRealNameView removeFromSuperview];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        [setRealNameView removeFromSuperview];
        [self performSelector:@selector(backAction:) withObject:nil afterDelay:1.0];
        
    }
}

///输入回调
-(void)returnInputResult:(NSString *)result indexPath:(NSIndexPath *)indexPath{
    NSLog(@"-----%@-------%ld",result,indexPath.row);
    if (indexPath.row == 2) {
        if ([[self getLabelValueWithRow:1] isEqualToString:@"身份证"]) {
            BOOL isCardNum = [Validator isValidCardNumber:result];
            [self updateTableViewWithRow:2 newValue:result];
            if (!isCardNum) {
                [self inputToast:@"请输入正确的身份证号码"];
                return;
            }else{
                
                [self updateTableViewWithRow:4 newValue:[Validator birthdayStrFromIdentityCard:result]];
                [self updateTableViewWithRow:3 newValue:[Validator getSexWithIDCardNumber:result]? @"男" : @"女"];
            }
        }else if ([[self getLabelValueWithRow:1] isEqualToString:@"护照"]){
            if(result.length < 4){
                [self inputToast:@"请输入正确的护照号码"];
                return;
            }
            
            [self updateTableViewWithRow:indexPath.row newValue:result];
            return;
        }
       
    }else{
            [self updateTableViewWithRow:indexPath.row newValue:result];
    }
    

}

///证件选择
-(void)certificateSelect{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"身份证",@"护照",nil];
    actionSheet.tag = 2000;
    [actionSheet showInView:self.view];

}
///性别选择
-(void)sexSelect{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"男",@"女",nil];
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 2000) {
        //选证件类型
        NSString *str = @"";
        if (buttonIndex == 0) {
            str = @"身份证";
        }else if (buttonIndex == 1){
            str = @"护照";
        }else{
            return;
        }
        [self updateTableViewWithRow:1 newValue: str ];
        [self updateTableViewWithRow:2 newValue:@""];
    }else if (actionSheet.tag == 1000){
        //选性别
        
        NSString *str = @"";
        if (buttonIndex == 0) {
            str = @"男";
        }else if (buttonIndex == 1){
            str = @"女";
        }else{
            return;
        }

        [self updateTableViewWithRow:3 newValue: str ];
    }
}
///时间选择
-(void)dateSelect{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UUDatePicker *datePicker2
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)
                             PickerStyle:1
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 NSString *dateStr = [year isEqualToString:@""]?@"":[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                 [self updateTableViewWithRow:4 newValue:dateStr];
                             }];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:1850];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date2 = [calendar dateFromComponents:comps];
    datePicker2.minLimitDate = date2;
    datePicker2.maxLimitDate = [[NSDate date] dateByAddingTimeInterval:2222];
    CustomUIActionSheet * sheet = [[CustomUIActionSheet alloc] init];
    [sheet setActionView:datePicker2];
    datePicker2.sheet = sheet;
    [sheet showInView:self.view];

}
///刷新列表
-(void)updateTableViewWithRow:(NSInteger )row newValue:(NSString *)newValue{
    NSMutableArray *source =[NSMutableArray array];
    source = self.souceArr;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[source objectAtIndex:row]];
    if (newValue) {
        [dic setObject:newValue forKey:@"value"];
        [source replaceObjectAtIndex:row withObject:dic];
        self.souceArr = source;
        [self.tableView reloadData];
    }
    
    
}
///获得某个字段
-(NSString *)getLabelValueWithRow:(NSInteger)row {
    NSDictionary *dic = [self.souceArr objectAtIndex:row];
    NSString *value = [dic objectForKey:@"value"];
    return value;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void) addComplete:(PatientVO*)vo{
    [self getPatients];
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
