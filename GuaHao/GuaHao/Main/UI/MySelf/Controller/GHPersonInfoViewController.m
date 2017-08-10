//
//  GHPersonInfoViewController.m
//  GuaHao
//
//  Created by PJYL on 16/9/4.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "GHPersonInfoViewController.h"
#import "AddPersonSelectCell.h"
#import "GHPersonInfoCell.h"
#import "PatientCertificationVC.h"
#import "ServerManger.h"
#import "UUDatePicker.h"

@interface GHPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,CertificationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sourceArr;
@end

@implementation GHPersonInfoViewController{
    PatientVO * patientVO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家庭成员";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePatientInfo:) name:@"UpdateSelfPatientInfo" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddPersonSelectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddPersonSelectCell"];
    self.tableView.tableFooterView=[[UIView alloc]init];//关键语句
    [self getServerData];
    
}

-(void)updatePatientInfo:(NSNotification *)notification{
    [self getServerData];
}

-(void)getServerData{
    [[ServerManger getInstance] getPatient:_patientID andCallback:^(id data) {
        [self.view hideToastActivity];
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    patientVO =[PatientVO mj_objectWithKeyValues: data[@"object"]];
                    NSString *idCardStr = patientVO.idcard.length==0 ? @"无" : [Utils encryptIdcard:patientVO.idcard];
                    NSString *birthdayStr = (patientVO.birthday&&patientVO.birthday.length>0) ? [patientVO.birthday substringWithRange:NSMakeRange(0,10)] : @"无";
                    
                    
                    self.sourceArr = [NSMutableArray arrayWithObjects:@{@"type":@"姓名",@"value":IS_String(patientVO.name)},@{@"type":@"性别",@"value":IS_String(patientVO.sex.intValue == 1?@"女":@"男")},@{@"type":@"出生日期",@"value":IS_String(birthdayStr) },@{@"type":@"身份证号",@"value":IS_String(idCardStr)},@{@"type":@"手机号码",@"value":IS_String(patientVO.mobile)},@{@"type":@"身份认证",@"value":IS_String(patientVO.getStatus)}, nil];
                }
                [self.tableView reloadData];
                
            }else{
                [self inputToast:msg];
            }
        }
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [self.sourceArr objectAtIndex:indexPath.row];
    if (indexPath.row != self.sourceArr.count - 1) {
   
            GHPersonInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GHPersonInfoCell"];
            cell.typeLabel.text = dic[@"type"];
        
        
        if (indexPath.row == 3) {
            ///加密
            NSString *IDCardNo = dic[@"value"];
            if (IDCardNo.length > 7) {
                IDCardNo = [IDCardNo stringByReplacingCharactersInRange:NSMakeRange(3, IDCardNo.length - 6) withString:@" **** **** **** "];
                cell.valueLabel.text = IDCardNo;
            }
        }else{
            cell.valueLabel.text = dic[@"value"];
        }
        
            return cell;
        
    }else{
        AddPersonSelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddPersonSelectCell"];
        cell.nameLabel.text = [dic objectForKey:@"type"];
        cell.valueLabel.text = [dic objectForKey:@"value"];
        cell.hotImage.hidden = YES;

        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        if(patientVO.status.intValue == 2){
            return;
        }
        PatientCertificationVC * view = [[PatientCertificationVC alloc]init];
        view.delegate = self;
        view.patientVO = patientVO;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:{
                [self fixContenWithTitle:@"修改姓名" keyType:UIKeyboardTypeDefault placeHold:@"" index:indexPath.row];
            }
                break;
            case 1:{
                [self fixSex];
            }
                break;
            case 2:{
//                 [self fixContenWithTitle:@"修改出生日期" keyType:UIKeyboardTypeNumbersAndPunctuation placeHold:@"如：1990-12-11" index:indexPath.row];
                [self dateSelect];
            }
                break;

            case 4:{
                [self fixContenWithTitle:@"修改手机号码" keyType:UIKeyboardTypeNumberPad placeHold:@"请输入手机号码" index:indexPath.row];
            }
                break;
            default:
                break;
        }
        
        
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
                                 
                                 if (dateStr.length > 3) {
                                     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                     [dic setObject:dateStr forKey:@"birthday"];
                                     [self fixContenToServer:dic];
                                 }else{
                                     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                     [dic setObject:patientVO.birthday forKey:@"birthday"];
                                     [self fixContenToServer:dic];
                                 }
                                 
                                 
                             }];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:1850];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date2 = [calendar dateFromComponents:comps];
    datePicker2.isFixBirthday = YES;
    datePicker2.minLimitDate = date2;
    datePicker2.maxLimitDate = [[NSDate date] dateByAddingTimeInterval:2222];
    CustomUIActionSheet * sheet = [[CustomUIActionSheet alloc] init];
    [sheet setActionView:datePicker2];
    datePicker2.sheet = sheet;
    [sheet showInView:self.view];
    
}


-(void)fixContenWithTitle:(NSString *)title keyType:(UIKeyboardType )keyboardType placeHold:(NSString *)placeholdStr index:(NSInteger)index{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertControl) wAlert = alertControl;
    __weak typeof(self) weakSelf = self;
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // 点击确定按钮的时候, 会调用这个block
       
        NSString *str = [wAlert.textFields.firstObject text];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (str.length >1) {
            if (index == 0) {
                [dic setObject:str forKey:@"name"];

                [weakSelf fixContenToServer:dic];
            }else if (index == 2){
                [dic setObject:str forKey:@"birthday"];
                [weakSelf fixContenToServer:dic];
            }else if (index == 4){
                 [dic setObject:str forKey:@"mobile"];
                [weakSelf fixContenToServer:dic];
            }
        }
        
//        socialSecurityCardStr = [wAlert.textFields.firstObject text];
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    // 添加文本框(只能添加到UIAlertControllerStyleAlert的样式，如果是preferredStyle:UIAlertControllerStyleActionSheet则会崩溃)
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = placeholdStr;
        textField.keyboardType = keyboardType;
        //监听文字改变的方法
        //        [textField addTarget:self action:@selector(textFieldsValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

-(void)fixSex{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"男");
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"0" forKey:@"sex"];
        [weakSelf fixContenToServer:dic];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"女");
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"sex"];
        [weakSelf fixContenToServer:dic];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)fixContenToServer:(NSMutableDictionary *)parameter {

    NSLog(@"----超超超超超超超超---------%@",parameter);
    __weak typeof(self) weakSelf = self;

    [[ServerManger getInstance] fixPersonInfoWithID:_patientID parameter:parameter andCallback:^(id data) {
        [self.view hideToastActivity];
        
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                
                if (data[@"object"]!=nil&&data[@"object"]!=[NSNull class]) {
                    patientVO =[PatientVO mj_objectWithKeyValues: data[@"object"]];
                    NSString *idCardStr = patientVO.idcard.length==0 ? @"无" : [Utils encryptIdcard:patientVO.idcard];
                    NSString *birthdayStr = (patientVO.birthday&&patientVO.birthday.length>0) ? [patientVO.birthday substringWithRange:NSMakeRange(0,10)] : @"无";
                    
                    
                    weakSelf.sourceArr = [NSMutableArray arrayWithObjects:@{@"type":@"姓名",@"value":IS_String(patientVO.name)},@{@"type":@"性别",@"value":IS_String(patientVO.sex.intValue == 1?@"女":@"男")},@{@"type":@"出生日期",@"value":IS_String(birthdayStr) },@{@"type":@"身份证号",@"value":IS_String(idCardStr)},@{@"type":@"手机号码",@"value":IS_String(patientVO.mobile)},@{@"type":@"身份认证",@"value":IS_String(patientVO.getStatus)}, nil];
                }
                [weakSelf.tableView reloadData];
                
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];

}






///刷新列表
-(void)updateTableViewWithRow:(NSInteger)row key:(NSString *)key newValue:(NSString *)newValue{
    NSMutableArray *source = self.sourceArr;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[source objectAtIndex:row]];
    if (newValue) {
        [dic setObject:newValue forKey:key];
        
        [source replaceObjectAtIndex:row withObject:dic];
        self.sourceArr = source;
        [self.tableView reloadData];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)addComplete:(PatientVO *)vo{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
