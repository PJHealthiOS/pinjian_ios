//
//  EditorInformation.m
//  GuaHao
//
//  Created by 123456 on 16/2/14.
//  Copyright © 2016年 pinjian. All rights reserved.
//
#import "ServerManger.h"
#import "EditorInformationVC.h"
#import "UIViewController+Toast.h"
#import "CustomUIActionSheet.h"
#import "Utils.h"
#import "Validator.h"
#import "UUDatePicker.h"
#import "PopAddNumberView.h"
#import "PatientCertificationVC.h"

@interface EditorInformationVC ()<UIActionSheetDelegate,PopAddNumberViewDelegate,CertificationDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView * contView;
@property (weak, nonatomic) IBOutlet UIView       * bottomView;

@property (weak, nonatomic) IBOutlet UITextField  * name2;
@property (weak, nonatomic) IBOutlet UITextField  * sex2;
@property (weak, nonatomic) IBOutlet UITextField  * birthday2;
@property (weak, nonatomic) IBOutlet UILabel      * idcard;
@property (weak, nonatomic) IBOutlet UILabel      * socialSecurityCardLab;
@property (weak, nonatomic) IBOutlet UILabel      * selectName;
@property (weak, nonatomic) IBOutlet UIButton     * sectlBtn;
@property (weak, nonatomic) IBOutlet UIButton     * addNunber;
@property (weak, nonatomic) IBOutlet UIButton     * addNunber2;
@property (weak, nonatomic) IBOutlet UILabel      * medicalCardLable;
@property (weak, nonatomic) IBOutlet UILabel      * stateLab;
@property (weak, nonatomic) IBOutlet UILabel      * typeLab;

@end

@implementation EditorInformationVC{
    __strong UIDatePicker * datePicker;
    int state ;
    PopAddNumberView * popAddNumberView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePatientInfoBack:) name:@"PatientInfoUpdate" object:nil];
    [self initViews];
}

-(void)initViews
{
    if (_patientVO.cardType.intValue == 1) {
        _typeLab.text     = @"身份证号";
    }else if (_patientVO.cardType.intValue == 2){
        _typeLab.text    = @"护 照 号";
    }else if (_patientVO.cardType.intValue == 3){
        _typeLab.text     = @"监护人身份证号";
    }
    if (_patientVO.cardType.intValue == 2) {
        self.idcard.text = _patientVO.idcard;
    }else{
        if (_patientVO.idcard.length==0) {
            self.idcard.text   = @"无";
        }else{
            self.idcard.text   = [Utils encryptIdcard:_patientVO.idcard];
        }
        
    }
    _selectName.text    = _patientVO.name;
    self.name2.text     = _patientVO.name;
    if (_patientVO.status.integerValue==1) {
        _stateLab.text  = @"审核中";
    }else if (_patientVO.status.integerValue==2){
        _stateLab.text  = @"认证成功";//1待认证 2认证成功 3认证失败
    }else if (_patientVO.status.integerValue==3){
        _stateLab.text  = @"认证失败";
    }
    if (_patientVO.status.integerValue == 0){
        _stateLab.text  = @"未认证";
    }
    self.sex2.text      = _patientVO.sex.intValue == 1?@"女":@"男";
    //    NSString *strDate   = [Utils formateDay:_patientVO.birthday];
    //    self.birthday2.text = strDate;
    if (_patientVO.birthday&&_patientVO.birthday.length>0) {
        self.birthday2.text = [_patientVO.birthday substringWithRange:NSMakeRange(0,10)];
    }else{
        self.birthday2.text = @"无";
    }
    
    if(_patientVO.socialSecurityCard.length > 0){
        self.socialSecurityCardLab.text = _patientVO.socialSecurityCard;
        _addNunber.enabled = NO;
        _addNunber.hidden = YES;
    }else{
        self.socialSecurityCardLab.text = @"添加社保卡";
        _addNunber.enabled = YES;
        _addNunber.hidden = NO;
    }
    if(self.patientVO.medicalCard.length > 0){
        self.medicalCardLable.text = _patientVO.medicalCard;
    }else{
        self.medicalCardLable.text = @"添加就诊卡";
    }
    
//    if (_patientVO.isDefault) {
//        [_sectlBtn setImage:[UIImage imageNamed:@"frist_order_tickBtnSelect@2x.png"] forState:UIControlStateSelected];
//    }
}

-(void)updatePatientInfoBack:(NSNotification *)notification{
    PatientVO * patient = (PatientVO*) notification.object;
    if(patient){
        _patientVO = patient;
        [self initViews];
    }
    
}
- (IBAction)addSocialSecurityCardBtn:(id)sender {
    if (!popAddNumberView) {
        CGRect frame = self.view.frame;
        popAddNumberView = [[PopAddNumberView alloc] initWithFrame:frame];
        [popAddNumberView.addNumberF becomeFirstResponder];
//        _patientVO.socialSecurityCard = popAddNumberView.addNumberF.text;
        popAddNumberView.addNumberF.text = @"";
        popAddNumberView.addNumberF.placeholder = @"|输入您的社保卡号";
        popAddNumberView.delegate = self;
    }
    [self.view addSubview:popAddNumberView];
    state = 1;
}
- (IBAction)addMedicalCardBtn:(id)sender {
    if (!popAddNumberView) {
        CGRect frame = self.view.frame;
        popAddNumberView = [[PopAddNumberView alloc] initWithFrame:frame];
        [popAddNumberView.addNumberF becomeFirstResponder];
//        _patientVO.medicalCard = popAddNumberView.addNumberF.text;
        popAddNumberView.addNumberF.text = @"";
        popAddNumberView.addNumberF.placeholder = @"|输入您的就诊卡号";
        popAddNumberView.delegate = self;
    }
    [self.view addSubview:popAddNumberView];
    state = 2;
}

-(void)setPopAddNumberViewDelegate:(int) type
{
    if (type == 0 && state == 1) {
        if (popAddNumberView.addNumberF.text.length == 0) {
            return [self inputToast:@"请填写社保卡号！"];;
        }
        if (popAddNumberView.addNumberF.text.length>0) {
            NSMutableDictionary* dic = [NSMutableDictionary new];
            if(_patientVO.socialSecurityCard.length > 0){
                dic[@"medicalCard"]   = _medicalCardLable.text;
            }
            dic[@"socialSecurityCard"]   = popAddNumberView.addNumberF.text;
            [self.view makeToastActivity:CSToastPositionCenter];
            [[ServerManger getInstance]editPatient:_patientVO.id patient:dic andCallback:^(id data) {
                [self.view hideToastActivity];
                if (data!=[NSNull class]&&data!=nil) {
                    NSNumber * code = data[@"code"];
                    NSString * msg  = data[@"msg"];
                    [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
                    if (code.intValue == 0) {
                        _socialSecurityCardLab.text = popAddNumberView.addNumberF.text;
                        _addNunber.enabled = NO;
                        _addNunber.hidden = YES;
                        popAddNumberView.addNumberF.text = @"";
                        [popAddNumberView removeFromSuperview];
                    }
                }
            }];
        }
        
    }else if (type == 0 && state == 2){
        if (popAddNumberView.addNumberF.text.length == 0) {
            return [self inputToast:@"请填写就诊卡号！"];
        }
        if (popAddNumberView.addNumberF.text.length == 15){
            NSMutableDictionary* dic = [NSMutableDictionary new];
            if(_patientVO.socialSecurityCard.length > 0){
                dic[@"socialSecurityCard"]   = _socialSecurityCardLab.text;
            }
            dic[@"medicalCard"]   = popAddNumberView.addNumberF.text;
            [self.view makeToastActivity:CSToastPositionCenter];
            [[ServerManger getInstance]editPatient:_patientVO.id patient:dic andCallback:^(id data) {
                [self.view hideToastActivity];
                if (data!=[NSNull class]&&data!=nil) {
                    NSNumber * code = data[@"code"];
                    NSString * msg  = data[@"msg"];
                    [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter style:nil];
                    
                    if (code.intValue == 0) {
                        
                        _medicalCardLable.text = popAddNumberView.addNumberF.text;
                        popAddNumberView.addNumberF.text = @"";
                        [popAddNumberView removeFromSuperview];
                        
                    }
                }
                
            }];

        }else if (popAddNumberView.addNumberF.text.length > 15){
           return [self inputToast:@"就诊卡号15位！"];
        }else{
            return [self inputToast:@"就诊卡号15位！"];
        }
    }
}

- (IBAction)gotoID:(id)sender {
    PatientCertificationVC * view = [[PatientCertificationVC alloc]init];
    view.delegate = self;
    view.patientVO = _patientVO;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void) addComplete:(PatientVO*)vo{
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)setChooseBtn:(id)sender {
//       _patientVO.isDefault=1;
    [_sectlBtn setImage:[UIImage imageNamed:@"frist_order_tickBtnSelect@2x.png"] forState:UIControlStateSelected];
    _sectlBtn.selected = !_sectlBtn.selected;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame)+150);
}

- (IBAction)back:(id)sender {
    if(_delegate){
        [_delegate editorInformationDelegate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
