//
//  CreateSeriousOrderController.m
//  GuaHao
//
//  Created by PJYLMacBookPro on 2017/2/27.
//  Copyright © 2017年 pinjian. All rights reserved.
//

#import "CreateSeriousOrderController.h"
#import "PackageViewController.h"
#import "PatientVO.h"
#import "KTActionSheet.h"
#import "AddPersonViewController.h"
#import "Validator.h"
#import "UUDatePicker.h"
#import "TZImagePickerController.h"
#import "SeriousExpertSelectVC.h"
#import "DoctorVO.h"
#import "camera.h"
#import "ImageViewController.h"
#import "ExpertView.h"
#import "ImageLookViewController.h"
#import "HtmlAllViewController.h"
#import "OrderSureView.h"
@interface CreateSeriousOrderController ()<AddPatientDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>{
    UUDatePicker *datePicker2;
    CustomUIActionSheet * sheet;
    BOOL isPhoto;
    OrderSureView *       sureView;


}
@property (weak, nonatomic) IBOutlet UILabel *packgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *remarkScrollview;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (weak, nonatomic) IBOutlet UIScrollView *expertScrollView;
@property (weak, nonatomic) IBOutlet UITextView *otherExpertTextView;
@property (weak, nonatomic) IBOutlet UILabel *remarkPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkPlaceLabel2;

@property (weak, nonatomic) IBOutlet UILabel *otherExpertPlaceLabel;
@property (copy, nonatomic) NSString *startDateStr;
@property (copy, nonatomic) NSString *endDateStr;
@property (nonatomic, strong)NSMutableArray *imageArr;
@property (nonatomic, strong)NSMutableArray *patientArr;
@property (nonatomic, strong)NSMutableArray *selectDoctorArr;
@property (nonatomic, strong)PatientVO *selectPatientVO;
@property (nonatomic, strong)PackageVO *selectPackageVO;
@property (copy, nonatomic) NSString *ruleDocUrl;

@end

@implementation CreateSeriousOrderController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.phoneTextField.delegate = self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArr = [NSMutableArray array];
    self.selectDoctorArr =[NSMutableArray array];
    self.title = @"重疾就医服务申请表";
    [self getUserList];
    [self call];
    //        UIBarButtonItem *right = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_more"] highImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(popToRoot) forControlEvents:UIControlEventTouchUpInside];
    //        viewController.navigationItem.rightBarButtonItem = right;
    // Do any additional setup after loading the view.
}
///获取用户列表
-(void)getUserList{
    self.patientArr = [NSMutableArray array];
    [self.view makeToastActivity:CSToastPositionCenter];
    __weak typeof(self) weakSelf = self;
    [[ServerManger getInstance] getPackagePersonListCallback:^(id data) {
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
                    weakSelf.ruleDocUrl = data[@"object"][@"ruleDocUrl"];
                    
                }
                
            }else{
                [self inputToast:msg];
            }
        }
    }];

}
///选套餐
- (IBAction)packgeSelect:(UITapGestureRecognizer *)sender {
    PackageViewController *packgeVC = [GHViewControllerLoader PackageViewController];
     __weak typeof(self) weakSelf = self;
    [packgeVC packgeSelectAction:^(PackageVO *selectVO) {
//        NSLog(@"选的什么套餐------%@",selectVO.name);
        weakSelf.packgeLabel.text = [NSString stringWithFormat:@"%@-%@",selectVO.name,selectVO.title] ;
        weakSelf.selectPackageVO = selectVO;
    }];
    [self.navigationController pushViewController:packgeVC animated:YES];
}
///选专家
- (IBAction)expertSelectAction:(id)sender {
    SeriousExpertSelectVC *vc = [GHViewControllerLoader SeriousExpertSelectVC];
    if (self.selectDoctorArr.count > 0) {
        vc.selectArr = self.selectDoctorArr;
    }
    __weak typeof(self) weakSelf = self;
    [vc selectAction:^(NSArray *selectArr) {
        NSLog(@"selectArr-------------%@",selectArr);
        weakSelf.selectDoctorArr = [NSMutableArray arrayWithArray:selectArr];
        [weakSelf getAllExpertID:selectArr];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
///展示选中的专家
-(void)getAllExpertID:(NSArray *)selectArr{
    [self.expertScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 0;
    int num = SCREEN_WIDTH/105;
    CGFloat width = SCREEN_WIDTH /num;
    for (int i = 0 ; i < selectArr.count;i++) {
        DoctorVO *doctorVO = [selectArr objectAtIndex:i];
        ExpertView *cell = [[[UINib nibWithNibName:@"ExpertView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(originX, 0, width, 140);
        [cell setCell:doctorVO];
        __weak typeof(self) weakSelf = self;
        [cell deleteExpertAction:^(DoctorVO *doctor) {
            if ([weakSelf.selectDoctorArr containsObject:doctor]) {
                [weakSelf.selectDoctorArr removeObject:doctor];
                [weakSelf getAllExpertID:weakSelf.selectDoctorArr];
            }
        }];
        originX = originX + SCREEN_WIDTH/3.0;
        [self.expertScrollView addSubview:cell];
        
    }
    self.expertScrollView.contentSize = CGSizeMake(originX , CGRectGetHeight(self.expertScrollView.frame));
    self.expertScrollView.showsHorizontalScrollIndicator = YES;
}
///选人
- (IBAction)personSelect:(UITapGestureRecognizer *)sender {
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
        weakSelf.nameLabel.text = weakSelf.selectPatientVO.name;
        weakSelf.phoneTextField.text = weakSelf.selectPatientVO.mobile;
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
        self.nameLabel.text = self.selectPatientVO.name;
    }
}
///填写电话号码
- (IBAction)endInputPhoneNumberAction:(UITextField *)sender {
    if (![Validator isValidMobile:sender.text]) {
        [self.view makeToast:@"请填写正确的手机号码！" duration:1.0 position:CSToastPositionCenter style:nil];
        self.phoneTextField.text = @"";
        return;
    }

    NSLog(@"填写的号码-----%@",sender.text);
}
///填写病情备注
-(void)textViewDidChange:(UITextView *)textView{

    if (textView.tag == 70011) {///并请备注
        if (textView.text.length >0) {
            self.remarkPlaceLabel.hidden = YES;
            self.remarkPlaceLabel2.hidden = YES;
        }else{
            self.remarkPlaceLabel.hidden = NO;
            self.remarkPlaceLabel2.hidden = NO;
        }

    }else{//添加其他专家
        if (textView.text.length >0) {
            self.otherExpertPlaceLabel.hidden = YES;
        }else{
            self.otherExpertPlaceLabel.hidden = NO;
        }

    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        NSLog(@"tag---%ld---%@",(long)textView.tag,textView.text);
    }
}
///添加图片
- (IBAction)addRemarkImageAction:(id)sender {
    if (_imageArr.count>=5) {
        [self inputToast:@"最多上传5张图片"];
        return ;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [actionSheet showInView:self.view];
    
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
    [self.remarkScrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 0;
    for (int i = 0; i < self.imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX , 10, 60, 60);
        [button setBackgroundImage:[self.imageArr objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1210+i;
        [self.remarkScrollview addSubview:button];
        originX = originX + 5 + 60;
    }
        self.remarkScrollview.contentSize = CGSizeMake(originX + 80, CGRectGetHeight(self.remarkScrollview.frame));

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
///开始时间
- (IBAction)startDateAction:(UIButton *)sender{
    [self choseDate:YES];
}
///结束时间
- (IBAction)endDateAction:(UIButton *)sender {
    if (self.startDateStr.length < 5) {
        [self.view makeToast:@"请先选择开始时间！" duration:1.0 position:CSToastPositionCenter style:nil];
        return;
    }
    [self choseDate:NO];
}
//选择时间
-(void)choseDate:(BOOL)start{
    [MobClick event:@"click8"];
    if(datePicker2){
        [datePicker2 removeFromSuperview];
        datePicker2 = nil;
    }
    if(sheet){
        [sheet animationDidStop];
        sheet = nil;
    }
    [self initDatePickerWith:start];
    [sheet setActionView:datePicker2];
    [sheet showInView:self.view];
    
}
-(void) initDatePickerWith:(BOOL)start
{
    __weak typeof(self) weakSelf = self;
    datePicker2 = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)
                             PickerStyle:4
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 if ([year isEqualToString:@""] || [month isEqualToString:@""]) {
                                     if (start) {
                                          [weakSelf.startDateButton setTitle:@"请选择时间" forState:UIControlStateNormal];
                                         weakSelf.startDateStr = @"请选择时间";

                                     }else{
                                         [weakSelf.endDateButton setTitle:@"请选择时间" forState:UIControlStateNormal];
                                         weakSelf.endDateStr = @"请选择时间";
                                     }
                                     return ;
                                 }
                                 NSString * text = [year isEqualToString:@""]?@"请选择时间":[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                 NSLog(@"text-------%@",text);
                                 if ([weakSelf isRightDate:text endStr:weakSelf.endDateStr] & start) {
                                     weakSelf.startDateStr = text;
                                     [weakSelf.startDateButton setTitle:text forState:UIControlStateNormal];
                                 }else if ([weakSelf isRightDate:weakSelf.startDateStr endStr:text] & !start) {
                                         weakSelf.endDateStr = text;
                                         [weakSelf.endDateButton setTitle:text forState:UIControlStateNormal];
                                     
                                 }else{
                                     
                                 }
                                 
                                 
                             }];
    datePicker2.minLimitDate = [[NSDate date]dateByAddingTimeInterval:0];
    datePicker2.openDays = @"1111111";
    datePicker2.isSerious = YES;
    sheet = [[CustomUIActionSheet alloc] init];
    datePicker2.sheet = sheet;
}
-(BOOL)isRightDate:(NSString *)startStr endStr:(NSString *)endStr{
    if (endStr.length < 6 || startStr.length < 6) {
        return YES;
    }
    NSString *startYear = [startStr substringWithRange:NSMakeRange(0, 4)];
    NSString *endYear = [endStr substringWithRange:NSMakeRange(0, 4)];
    NSString *startMonth = [startStr substringWithRange:NSMakeRange(5, 2)];
    NSString *endMonth = [endStr substringWithRange:NSMakeRange(5, 2)];
    NSString *startDay = [startStr substringWithRange:NSMakeRange(8, 2)];
    NSString *endDay = [endStr substringWithRange:NSMakeRange(8, 2)];
    if (endYear.intValue > startYear.intValue) {
        return YES;
    }else if(endYear.intValue == startYear.intValue){
        
        if (endMonth.intValue > startMonth.intValue) {
            return YES;
        }else if(endMonth.intValue == startMonth.intValue){
            if (endDay.intValue >= startDay.intValue) {
                return YES;
            }
        }
    }
    [self.view makeToast:@"请选择正确的时间！" duration:1.0 position:CSToastPositionCenter style:nil];

    return NO;
}
///重疾规则
- (IBAction)ruleAction:(UIButton *)sender {
    HtmlAllViewController * view = [[HtmlAllViewController alloc] init];
    view.mTitle = @"重疾预约规则";
    view.mUrl = self.ruleDocUrl;
    [self.navigationController pushViewController:view animated:YES];
}
///提交订单
- (IBAction)submitAction:(id)sender {
    [self.view endEditing:YES];
    
    
    if(!sureView){
        CGRect frame = self.view.frame;
        sureView = [[OrderSureView alloc] initWithFrame:frame];
    }
    [sureView setName:self.selectPackageVO.name content:[NSString stringWithFormat:@"%@,您好!您的申请信息已经提交成功，品简客服人员稍后将电话为您确认详情信息，请保持电话畅通！ ",self.selectPatientVO.name] fromNormal:NO];
    [sureView clickSureAction:^(BOOL result) {
       [self crateOeder];
    }];
    [self.view addSubview:sureView];
    
    
    
    
}
///获取用户列表
-(void)crateOeder{
    [self.view endEditing:YES];
    if (!self.selectPackageVO) {
        [self inputToast:@"请选择服务套餐！"];
        return;
    }
    if (!self.selectPatientVO) {
        [self inputToast:@"请选择就诊人员！"];
        return;
    }
    
    if (![Validator isValidMobile:self.phoneTextField.text]) {
        [self inputToast:@"请输入正确的电话号码！"];
        self.phoneTextField.text = @"";
        return;
    }

    [self.view makeToastActivity:CSToastPositionCenter];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"patientId"] = self.selectPatientVO.id;
    dic[@"mobile"] = self.phoneTextField.text;
    dic[@"packageName"] = [NSString stringWithFormat:@"%@-%@",self.selectPackageVO.name,self.selectPackageVO.title] ;
    if (self.selectDoctorArr.count > 0) {
        NSMutableArray *idArr = [NSMutableArray array];
        for (DoctorVO *doctor in self.selectDoctorArr) {
            [idArr addObject:doctor.id];
        }
        NSString *string = [idArr componentsJoinedByString:@","];
        dic[@"pickDoctorIds"] = string;
    }
    if (self.remarkTextView.text.length >0) {
        dic[@"criticalIllnessDesc"] = self.remarkTextView.text;
    }
    if (self.otherExpertTextView.text.length> 0) {
        dic[@"remarkDoctor"] = self.otherExpertTextView.text;
    }
    if (self.startDateStr.length > 5 && self.endDateStr.length > 5) {
        dic[@"date"] = [NSString stringWithFormat:@"%@,%@",self.startDateStr,self.endDateStr] ;
    }
    __weak typeof(self) weakSelf =self;
    [[ServerManger getInstance] createSeriousOrder:dic  imgs:self.imageArr andCallback:^(id data) {
        [self.view hideToastActivity];
        NSLog(@"创建重疾选择了几张图片---%lu",(unsigned long)self.imageArr.count);
        if (data!=[NSNull class]&&data!=nil) {
            NSNumber * code = data[@"code"];
            NSString * msg = data[@"msg"];
            if (code.intValue == 0) {
                NSLog(@"创建重疾---%@",msg);
                [weakSelf inputToast:msg];
                SeriousOrderDetailViewController *detailVC = [GHViewControllerLoader SeriousOrderDetailViewController];
                detailVC.serialNo = data[@"object"][@"serialNo"];
                detailVC.popBack = PopBackRoot;
;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            }else{
                [weakSelf inputToast:msg];
            }
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textField resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
-(void)call{
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 30, 30);
    [rightItemButton setImage:[UIImage imageNamed:@"common_make_phone_call.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [rightItemButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)callAction:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001150958"];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
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
