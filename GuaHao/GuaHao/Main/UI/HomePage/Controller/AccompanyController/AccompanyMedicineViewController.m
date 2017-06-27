//
//  AccompanyMedicineViewController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/3/7.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "AccompanyMedicineViewController.h"
#import "ChooseHospitalVC.h"
#import "AccompanyOrderVO.h"
#import "UUDatePicker.h"
#import "KTActionSheet.h"
#import "PatientCertificationVC.h"
#import "AddPersonViewController.h"
#import "camera.h"
#import "ImageLookViewController.h"
#import "TZImagePickerController.h"
#import "HtmlAllViewController.h"
#import "Validator.h"
#import "PayViewController.h"
@interface AccompanyMedicineViewController ()<CertificationDelegate,AddPatientDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>{
    UUDatePicker *datePicker2;
    CustomUIActionSheet * sheet;
    AccompanyOrderVO *_vo;
    NSMutableArray * patients;///家庭成员
    BOOL isPhoto;
    BOOL isHaveDian;
    
}
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UITextField *acceptTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) HospitalVO *hospital;
@property (strong, nonatomic) PatientVO *patientVO;
@property (nonatomic, strong)NSMutableArray *imageArr;
@property (copy, nonatomic) NSString *ruleDocUrl;

@property (copy, nonatomic) NSString *dateStr;
@property (copy, nonatomic) NSString *acceptStr;
@property (copy, nonatomic) NSString *phoneStr;
@property (copy, nonatomic) NSString *addressStr;
@property (copy, nonatomic) NSString *priceStr;

@property (copy, nonatomic) NSString *orderIDStr;
@property (copy, nonatomic) NSString *orderNoStr;
@end

@implementation AccompanyMedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代取药品";
    self.imageArr = [NSMutableArray array];
    self.priceTextField.delegate = self;
    self.priceTextField.tag = 11111;
    [self getData];

    // Do any additional setup after loading the view.
}
-(void)getData{
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getAccompanyOrderVCData:2  andCallback:^(id data) {
        [weakSelf.view hideToastActivity];
        if (data != [NSNull class] && data != nil) {
            NSNumber *code = data[@"code"];
            NSString *message = data[@"msg"];
            if (code.intValue == 0) {
                NSDictionary *dic = data[@"object"];
                _vo = [AccompanyOrderVO mj_objectWithKeyValues:dic];
                patients = [NSMutableArray arrayWithArray: _vo.patients];
                weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"%@元",_vo.pzFee];
                //                _totalPrice = _vo.pzFee.intValue +_vo.normalTransferFee.intValue;
                //                [weakSelf updateTableViewWithSection:3 row:0 key:@"value" newValue:_vo.defPayType.intValue == 1 ? @"在线支付":@"到院支付"];
                //                NSLog(@"vvvvvvvvv-------%d",_vo.normalTransferFee.intValue);
                //
                //                [weakSelf updateTableViewWithSection:3 row:1 key:@"value" newValue:[NSString stringWithFormat:@"%d元",_totalPrice]];
                //                [weakSelf.tableView reloadData];
            }
        }
        
    }];
    
}


- (IBAction)chooseHospital:(id)sender {
    [self chooseHospital];
}
- (IBAction)chooseDate:(id)sender {
    [self chooseDate];
}
- (IBAction)choosePerson:(id)sender {
    [self chosePerson];
}

- (IBAction)addImageAction:(id)sender {
    [self.view endEditing:YES];
    if (_imageArr.count>=5) {
        [self inputToast:@"最多上传5张图片"];
        return ;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [actionSheet showInView:self.view];
}
- (IBAction)inputAdderssAction:(UITextField *)sender {
    self.addressStr = sender.text;
}
- (IBAction)inputPhoneAction:(UITextField *)sender {
    self.phoneStr = sender.text;
}
- (IBAction)inputAcceptPersonAction:(UITextField *)sender {
    self.acceptStr = sender.text;
}

- (IBAction)inputPriceAction:(UITextField *)sender {
    self.priceStr = sender.text;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",sender.text.doubleValue + _vo.pzFee.intValue];
}

- (IBAction)ruleAction:(id)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"规则";
    view.mUrl = _vo.drugPZUrl;
    [self.navigationController pushViewController:view animated:YES];
}

///选择医院
-(void)chooseHospital{
    [MobClick event:@"click9"];
    ChooseHospitalVC* hospitalVC = [[ChooseHospitalVC alloc]init];
    hospitalVC.isAccompany = YES;
    __weak typeof(self) weakSelf = self;
    hospitalVC.onBlockHospital = ^(HospitalVO * vo,DepartmentVO * dvo){
        _hospital = vo;
        weakSelf.hospitalLabel.text = _hospital.name;
    };
    
    [self.navigationController pushViewController:hospitalVC animated:YES];
}



//选择时间
-(void)chooseDate{
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
    __weak typeof(self) weakSelf = self;
    datePicker2
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)
                             PickerStyle:4
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 if ([year isEqualToString:@""] || [month isEqualToString:@""]) {
                                     weakSelf.dateLabel.text = @"请选择时间";
                                 }else{
                                     NSString * text = [year isEqualToString:@""]?@"请选择时间":[NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,weekDay];
                                     weakSelf.dateLabel.text = text;
                                     weakSelf.dateStr = text;
                                     
                                 }
                                 
                             }];
    datePicker2.minLimitDate = [[NSDate date]dateByAddingTimeInterval:0];
    datePicker2.isAdult = (_hospital.type.intValue==0);
    datePicker2.openDays = @"1111111";
    datePicker2.isAccompany = YES;
    datePicker2.isMedicineOrReport = YES;
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
                [weakSelf inputToast:@"您的家庭成员数量到达上限!"];
                return ;
            }
            [weakSelf popRevise];
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
            view.delegate = weakSelf;
            view.patientVO = _patientVO;
            [weakSelf.navigationController pushViewController:view animated:YES];
        }
        weakSelf.personLabel.text = text;
        
    }];
}
-(void) addComplete:(PatientVO*)vo
{
    if (vo) {
        [patients addObject:vo];
        _patientVO = vo;
        
    }
}
-(void) popRevise
{
    AddPersonViewController *addVC = [[AddPersonViewController alloc]init];
    addVC.delegate = self;
    addVC.openType = 3;
    [self.navigationController pushViewController:addVC animated:YES];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;
    
    if (buttonIndex==0) {
        //拍照
        isPhoto = YES;
        PresentPhotoCamera(self, self, NO);
    }else if (buttonIndex==1){
        isPhoto = NO;
        [self selectImageFromPhotoLibrary];
    }
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    if (_imageArr.count >= 5) {
        [self inputToast:@"最多上传5张图片"];
        return;
    }
    NSLog(@"您选择了图片");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        //UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //image = [Utils reSizeImage:image toSize:CGSizeMake(100, 100)];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [_imageArr addObject:image];
        [self loadSelectImages];
        
    }
}
-(void)selectImageFromPhotoLibrary{
    if (_imageArr.count>=5) {
        [self inputToast:@"最多上传5张图片"];
        return ;
    }
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc]initWithMaxImagesCount:5-self.imageArr.count delegate:self];
    __weak typeof(self) weakSelf = self;
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *imageArr, NSArray *array, BOOL reuslt) {
        [weakSelf.imageArr addObjectsFromArray:imageArr];
        [weakSelf loadSelectImages];
        NSLog(@"%@/n,%@/n,%@",imageArr,array,reuslt?@"1":@"0");
    }];
    [self presentViewController:pickerVC animated:YES completion:nil];//跳转
    
}
-(void)loadSelectImages{
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 0;
    for (int i = 0; i < self.imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX , 20, 60, 60);
        [button setBackgroundImage:[self.imageArr objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1210+i;
        [self.imageScrollView addSubview:button];
        originX = originX + 5 + 60;
    }
    self.imageScrollView.contentSize = CGSizeMake(originX + 80, CGRectGetHeight(self.imageScrollView.frame));
    
}
-(void)lookAction:(UIButton *)sender{
    ImageLookViewController *view = [[ImageLookViewController alloc]init];
    view.image = sender.currentBackgroundImage;
    [view deleteImage:^(BOOL result) {
        if (result) {
            [self.imageArr removeObjectAtIndex:sender.tag - 1210];
            [self loadSelectImages];
        }
    }];
    [self.navigationController pushViewController:view animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




- (IBAction)submitAction:(id)sender {
    [self.view endEditing:YES];
    if (!_hospital.id) {
        [self inputToast:@"请选择医院"];
        return;
    }
    if (self.dateStr.length < 3) {
        [self inputToast:@"请选取药诊时间"];
        return;
    }
    if (!_patientVO) {
        [self inputToast:@"请选择就诊人员"];
        return;
    }
    if (self.acceptStr.length < 1) {
        [self inputToast:@"请填写收件人员"];
        return;
    }
    if (self.addressStr.length < 3) {
        [self inputToast:@"请填写收件地址"];
        return;
    }
    if (![Validator isValidMobile:self.phoneTextField.text]) {
        [self inputToast:@"请填写正确手机号码"];
        return;
    }
    if (self.imageArr.count < 1) {
        [self inputToast:@"请上传取报告凭证"];
        return;
    }
    if (self.priceStr.length < 1) {
        [self inputToast:@"请选输入药品总价格"];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"2" forKey:@"serviceType"];
    [dic setValue:_hospital.id forKey:@"hospitalId"];
    [dic setValue:_patientVO.id forKey:@"patientId"];
    [dic setValue:_patientVO.name forKey:@"name"];
    [dic setValue:@"1" forKey:@"payType"];
    [dic setValue:self.dateStr forKey:@"serviceDate"];
    [dic setValue:self.acceptStr forKey:@"receiverName"];
    [dic setValue:self.addressStr forKey:@"transferAddr"];
    [dic setValue:self.phoneStr forKey:@"receiverMobile"];
    [dic setValue:self.priceStr forKey:@"drugFee"];

    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf =self;
    [[ServerManger getInstance] createMedicineOrReportOrder:dic  imgs:self.imageArr andCallback:^(id data) {
        [self.view hideToastActivity];
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
//                NSLog(@"创建重疾---%@",msg);
                [weakSelf inputToast:msg];
                weakSelf.orderIDStr = data[@"object"][@"id"];
                weakSelf.orderNoStr = data[@"object"][@"serialNo"];
                [weakSelf toPay];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];

}
-(void)toPay{
    PayViewController * view = [GHViewControllerLoader PayViewController];
    view.orderID = [NSNumber numberWithDouble:self.orderIDStr.doubleValue] ;
    view.isAccompany = YES;
    [self.navigationController pushViewController:view animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (textField.tag != 11111) {
        return YES;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                
                if(single == '.')
                {
                    
                    [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
                if (single == '0')
                {
                    
                    [self showMyMessage:@"亲，第一个数字不能为0!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
            }
            
            //输入的字符是否是小数点
            
            if (single == '.')
            {
                
                if(!isHaveDian)//text中还没有小数点
                {
                    
                    isHaveDian = YES;
                    
                    return YES;
                    
                }else{
                    
                    [self showMyMessage:@"亲，您已经输入过小数点了!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
            }else{
                
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (range.location - ran.location <= 2) {
                        
                        return YES;
                        
                    }else{
                        
                        [self showMyMessage:@"亲，您最多输入两位小数!"];
                        
                        return NO;
                        
                    }
                    
                }else{
                    
                    return YES;
                    
                }
                
            }
            
        }else{//输入的数据格式不正确
            
            [self showMyMessage:@"亲，您输入的格式不正确!"];
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
            
        }
        
    }
    
    else
        
    {
        
        return YES;
        
    }
    
}

-(void)showMyMessage:(NSString*)aInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
    
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
