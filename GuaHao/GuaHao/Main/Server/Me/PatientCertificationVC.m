//
//  PatientCertificationVC.m
//  GuaHao
//
//  Created by 123456 on 16/6/28.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import "PatientCertificationVC.h"
#import "camera.h"
#import "UIViewController+Toast.h"
#import "ServerManger.h"
#import "Validator.h"
#import "DataManager.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"

@interface PatientCertificationVC ()<UIActionSheetDelegate>{
    int type ;
    BOOL isPhoto;
}
@property (weak, nonatomic) IBOutlet UIScrollView * contScrollView;
@property (weak, nonatomic) IBOutlet UIButton     * btn;
@property (weak, nonatomic) IBOutlet UIImageView  * bgImage;
@property (weak, nonatomic) IBOutlet UILabel      * namel;
@property (weak, nonatomic) IBOutlet UILabel      * idcardl;
@property (weak, nonatomic) IBOutlet UIImageView  * frontImg;
@property (weak, nonatomic) IBOutlet UIImageView  * behindImg;
@property (weak, nonatomic) IBOutlet UIImageView  * bgFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView  * bgBehindImg;
@property (weak, nonatomic) IBOutlet UIImageView  * passportImg1;
@property (weak, nonatomic) IBOutlet UIImageView  * passportImg2;
@property (weak, nonatomic) IBOutlet UILabel      * passportLab3;
@property (weak, nonatomic) IBOutlet UIImageView  * passportImg4;
@property (weak, nonatomic) IBOutlet UIImageView  * smallImg1;
@property (weak, nonatomic) IBOutlet UIImageView  * smallImg2;
@property (weak, nonatomic) IBOutlet UILabel      * titleLab1;
@property (weak, nonatomic) IBOutlet UILabel      * titleLab2;

@end

@implementation PatientCertificationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (_patientVO.idcardFrontImg){
//        [_frontImg sd_setImageWithURL: [NSURL URLWithString:_patientVO.idcardFrontImg]];
//    }
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份证认证申请";
    if (IS_IPHONE_5) {
        _bgFrontImg.frame = CGRectMake(_bgFrontImg.frame.origin.x, _bgFrontImg.frame.origin.y, _bgFrontImg.frame.size.width-15,  _bgFrontImg.frame.size.height);
        _frontImg.frame = CGRectMake(_frontImg.frame.origin.x, _frontImg.frame.origin.y, _frontImg.frame.size.width-15,  _frontImg.frame.size.height);
        _behindImg.frame = CGRectMake(_behindImg.frame.origin.x+15, _behindImg.frame.origin.y, _behindImg.frame.size.width-15,  _behindImg.frame.size.height);
        _bgBehindImg.frame = CGRectMake(_bgBehindImg.frame.origin.x+15, _bgBehindImg.frame.origin.y, _bgBehindImg.frame.size.width-15,  _bgBehindImg.frame.size.height);
        _smallImg1.frame = CGRectMake(_smallImg1.frame.origin.x-7, _smallImg1.frame.origin.y, _smallImg1.frame.size.width,  _smallImg1.frame.size.height);
        _smallImg2.frame = CGRectMake(_smallImg2.frame.origin.x+7, _smallImg2.frame.origin.y, _smallImg2.frame.size.width, _smallImg2.frame.size.height);
        _titleLab1.frame = CGRectMake(_titleLab1.frame.origin.x-7, _titleLab1.frame.origin.y, _titleLab1.frame.size.width, _titleLab1.frame.size.height);
        _titleLab2.frame = CGRectMake(_titleLab2.frame.origin.x+7, _titleLab2.frame.origin.y, _titleLab2.frame.size.width, _titleLab2.frame.size.height);
    }
    if (IS_IPHONE_4_OR_LESS) {
        _bgFrontImg.frame = CGRectMake(_bgFrontImg.frame.origin.x, _bgFrontImg.frame.origin.y, _bgFrontImg.frame.size.width-15,  _bgFrontImg.frame.size.height);
        _frontImg.frame = CGRectMake(_frontImg.frame.origin.x, _frontImg.frame.origin.y, _frontImg.frame.size.width-15,  _frontImg.frame.size.height);
        _behindImg.frame = CGRectMake(_behindImg.frame.origin.x+15, _behindImg.frame.origin.y, _behindImg.frame.size.width-15,  _behindImg.frame.size.height);
        _bgBehindImg.frame = CGRectMake(_bgBehindImg.frame.origin.x+15, _bgBehindImg.frame.origin.y, _bgBehindImg.frame.size.width-15,  _bgBehindImg.frame.size.height);
        _smallImg1.frame = CGRectMake(_smallImg1.frame.origin.x, _smallImg1.frame.origin.y, _smallImg1.frame.size.width,  _smallImg1.frame.size.height);
        _smallImg2.frame = CGRectMake(_smallImg2.frame.origin.x+2, _smallImg2.frame.origin.y, _smallImg2.frame.size.width, _smallImg2.frame.size.height);
        _titleLab1.frame = CGRectMake(_titleLab1.frame.origin.x-5, _titleLab1.frame.origin.y, _titleLab1.frame.size.width, _titleLab1.frame.size.height);
        _titleLab2.frame = CGRectMake(_titleLab2.frame.origin.x+5, _titleLab2.frame.origin.y, _titleLab2.frame.size.width, _titleLab2.frame.size.height);
    }
    [self getInfo];
}
-(void) getInfo{
    _passportImg1.hidden = YES ;
    _passportImg2.hidden = YES ;
    _passportLab3.hidden = YES ;
    _passportImg4.hidden = YES ;
    _bgFrontImg.hidden = NO ;
    _bgBehindImg.hidden = NO ;
    self.namel.text     = _patientVO.name;
    if (_patientVO.cardType.integerValue == 1) {
        if(_patientVO.idcard.length == 0){
            self.idcardl.text   = @"无";
        }else{
            self.idcardl.text   = [NSString stringWithFormat:@"%@(身份证)",[Utils encryptIdcard:_patientVO.idcard]];
        }
        _bgImage.image = [UIImage imageNamed:@"me_family_patient_Certification_bgImage_001.png"];
    }else if (_patientVO.cardType.integerValue == 2){
        _passportImg1.hidden = NO ;
        _passportImg2.hidden = NO ;
        _passportLab3.hidden = NO ;
        _passportImg4.hidden = NO ;
        _smallImg1.hidden = YES ;
        _smallImg2.hidden = YES ;
        _titleLab1.hidden = YES ;
        _titleLab2.hidden = YES ;
        _bgFrontImg.hidden = YES ;
        _bgBehindImg.hidden = YES ;
        
        self.idcardl.text   = [NSString stringWithFormat:@"%@(护照)",_patientVO.idcard];
        _bgImage.image = [UIImage imageNamed:@"me_family_patient_Certification_bgImage_002.png"];
    }else if (_patientVO.cardType.integerValue == 3){
        if(_patientVO.idcard.length==0){
            self.idcardl.text   = @"无";
        }else{
            self.idcardl.text   = [NSString stringWithFormat:@"%@(监护人身份证)",[Utils encryptIdcard:_patientVO.idcard]];
        }
        
        _bgImage.image = [UIImage imageNamed:@"me_family_patient_Certification_bgImage_001.png"];
    }
    
    if (_patientVO.status.integerValue==1) {
//        if (_patientVO.certificationInfo){
//            [_passportImg1 sd_setImageWithURL: [NSURL URLWithString:_patientVO.certificationInfo.passportImg]];
//            [_frontImg sd_setImageWithURL: [NSURL URLWithString:_patientVO.certificationInfo.idcardFrontImg]];
//            [_behindImg sd_setImageWithURL: [NSURL URLWithString:_patientVO.certificationInfo.idcardBackImg]];
//        }
        _bgFrontImg.hidden  = YES;
        _bgBehindImg.hidden = YES;
        _passportImg2.hidden = YES;
        [_btn setTitle:@"(审核中)取消审核" forState:UIControlStateNormal];
    }else if (_patientVO.status.integerValue==2){
        _passportImg2.hidden = YES;
        _bgFrontImg.hidden   = YES;
        _bgBehindImg.hidden  = YES;
        [_btn setTitle:@"认证成功" forState:UIControlStateNormal];
        _btn.enabled = NO;
    }else if (_patientVO.status.integerValue==3){
        if (_patientVO.cardType.integerValue == 2) {
            _passportImg2.hidden = NO;
        }else{
            _bgFrontImg.hidden  = NO;
            _bgBehindImg.hidden = NO;
        }
        [_btn setTitle:@"重新认证" forState:UIControlStateNormal];
    }
    if (_patientVO.status.intValue == 0){
        [_btn setTitle:@"提交审核" forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer * tapGuesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func1:)];
    [_bgFrontImg setUserInteractionEnabled:YES];
    [_bgFrontImg addGestureRecognizer:tapGuesture1];
    
    UITapGestureRecognizer * tapGuesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func2:)];
    [_bgBehindImg setUserInteractionEnabled:YES];
    [_bgBehindImg addGestureRecognizer:tapGuesture2];
    
    UITapGestureRecognizer * tapGuesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func3:)];
    [_passportImg2 setUserInteractionEnabled:YES];
    [_passportImg2 addGestureRecognizer:tapGuesture3];
}
-(void) func1:(UITapGestureRecognizer *) tap{
    type = 0;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 5000;
}

-(void) func2:(UITapGestureRecognizer *) tap{
    type = 1;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 6000;
}
-(void) func3:(UITapGestureRecognizer *) tap{
    type = 2;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 7000;
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 5000) {
        if (buttonIndex==0) {
            //拍照
            PresentPhotoCamera(self, self, YES);
        }else if (buttonIndex==1){
            PresentPhotoLibrary(self, self, YES);
        }
    }else if (actionSheet.tag == 6000){
        if(buttonIndex == 2) return;
        
        if (buttonIndex==0) {
            //拍照
            PresentPhotoCamera(self, self, YES);
        }else if (buttonIndex==1){
            PresentPhotoLibrary(self, self, YES);
        }
    }else{
        if (buttonIndex==0) {
            //拍照
            PresentPhotoCamera(self, self, YES);
        }else if (buttonIndex==1){
            PresentPhotoLibrary(self, self, YES);
        }
    }
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSLog(@"您选择了图片");
    
    NSString * types = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([types isEqualToString:@"public.image"])
    {
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        switch (type) {
            case 0:
                [_frontImg setImage:image];
                break;
            case 1:
                [_behindImg setImage:image];
                break;
            case 2:
                [_passportImg1 setImage:image];
                break;
            default:
                break;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)onCommit:(id)sender {
    if (_patientVO.status.integerValue==1) {
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] cancelRealnameAuth:_patientVO.id andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                if (code.intValue == 0) {
                    [self inputToast:@"取消成功!"];
                     PatientVO *patient = [PatientVO mj_objectWithKeyValues:data[@"object"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePatientInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSelfPatientInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PatientInfoUpdate" object:patient];
                    [self getInfo];
                    [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
                }else{
                    [self inputToast:msg];
                }
            }

        }];
        
    }else if (_patientVO.cardType.integerValue == 2) {
        if (!_passportImg1.image) {
            return[self inputToast:@"请上传证件正面照！"];
        }
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance ] passportPatient:_patientVO.id front:_passportImg1.image andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (code.intValue == 0) {
                    PatientVO *patient = [PatientVO mj_objectWithKeyValues:data[@"object"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePatientInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSelfPatientInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PatientInfoUpdate" object:patient];
                    [self getInfo];
                    [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
                }else{
                }
            }

        }];
    }else{
        if (!_frontImg.image) {
            [self inputToast:@"请上传身份证正面照！"];
            return;
        }
        if (!_behindImg.image) {
            [self inputToast:@"请上传身份证反面照！"];
            return;
        }
        [self.view makeToastActivity:CSToastPositionCenter];
        [[ServerManger getInstance] verificationPatient:_patientVO.id front:_frontImg.image opposite:_behindImg.image andCallback:^(id data) {
            [self.view hideToastActivity];
            if (data!=[NSNull class]&&data!=nil) {
                NSNumber * code = data[@"code"];
                NSString * msg = data[@"msg"];
                [self inputToast:msg];
                if (code.intValue == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePatientInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSelfPatientInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PatientInfoUpdate" object:nil];
                    [self getInfo];
//                    if ([self.delegate respondsToSelector:@selector(addComplete:)]) {
//                        [self.delegate addComplete:_patientVO];
//                    }
                    [self performSelector:@selector(onBack) withObject:nil afterDelay:1.0];
                }else{
                }
            }
        }];
    }
    
}
-(void)certificateAction:(CertificateInfoBlock)block{
    self.myBlock = block;
}
-(void)onBack
{
//    if(_openType==3){
//        NSArray * viewControllers = self.navigationController.viewControllers;
//        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
//        return;
//    }
    if (self.myBlock) {
        self.myBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
    

    if (_delegate) {
//        [_delegate verificationCOmplete];
    }
}
- (IBAction)button:(id)sender {
    if(_openType==3){
        NSArray * viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _contScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_btn.frame)+30);
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
